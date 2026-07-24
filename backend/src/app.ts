import cors from '@fastify/cors';
import Fastify, { type FastifyInstance } from 'fastify';

import type { AppConfig } from './config';

export interface BuildAppOptions {
  config: AppConfig;
  readinessCheck: () => Promise<boolean>;
}

export async function buildApp(options: BuildAppOptions): Promise<FastifyInstance> {
  const { config, readinessCheck } = options;
  const app = Fastify({
    bodyLimit: 1024 * 1024,
    trustProxy: true,
    logger:
      config.LOG_LEVEL === 'silent'
        ? false
        : {
            level: config.LOG_LEVEL,
            redact: {
              paths: [
                'req.headers.authorization',
                'req.headers.cookie',
                'req.body.password',
                'req.body.refreshToken',
                'res.headers.set-cookie',
              ],
              censor: '[REDACTED]',
            },
          },
  });

  if (config.CORS_ORIGIN.trim().length > 0) {
    const allowedOrigins = new Set(
      config.CORS_ORIGIN.split(',').map((origin) => origin.trim()).filter(Boolean),
    );
    await app.register(cors, {
      origin(origin, callback) {
        if (!origin || allowedOrigins.has(origin)) {
          callback(null, true);
          return;
        }
        callback(new Error('Origin is not allowed'), false);
      },
    });
  }

  app.addHook('onSend', async (_request, reply) => {
    reply.header('X-Content-Type-Options', 'nosniff');
    reply.header('X-Frame-Options', 'DENY');
    reply.header('Referrer-Policy', 'no-referrer');
    reply.header('Cache-Control', 'no-store');
  });

  app.get('/health/live', async () => ({
    status: 'ok',
    service: 'lighter-backend',
    version: config.APP_VERSION,
  }));

  app.get('/health/ready', async (_request, reply) => {
    const ready = await readinessCheck();
    return reply.code(ready ? 200 : 503).send({
      status: ready ? 'ready' : 'not_ready',
      database: ready ? 'reachable' : 'unreachable',
      version: config.APP_VERSION,
    });
  });

  app.get('/v1', async () => ({
    service: 'lighter-backend',
    apiVersion: 'v1',
    version: config.APP_VERSION,
    environment: config.NODE_ENV,
    features: {
      authentication: false,
      synchronization: false,
    },
  }));

  app.setNotFoundHandler(async (request, reply) =>
    reply.code(404).send({
      code: 'route_not_found',
      message: 'The requested API route does not exist.',
      requestId: request.id,
    }),
  );

  app.setErrorHandler(async (error, request, reply) => {
    request.log.error({ err: error }, 'request failed');
    const statusCode = error.statusCode && error.statusCode < 500 ? error.statusCode : 500;
    return reply.code(statusCode).send({
      code: statusCode === 500 ? 'internal_error' : 'request_failed',
      message: statusCode === 500 ? 'The server could not complete the request.' : error.message,
      requestId: request.id,
    });
  });

  return app;
}

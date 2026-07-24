import { afterEach, describe, expect, it } from 'vitest';

import { buildApp } from './app';
import type { AppConfig } from './config';

const config: AppConfig = {
  NODE_ENV: 'test',
  PORT: 8080,
  DATABASE_URL: 'postgresql://unused',
  APP_VERSION: 'test-version',
  LOG_LEVEL: 'silent',
  CORS_ORIGIN: '',
};

const apps: Awaited<ReturnType<typeof buildApp>>[] = [];

afterEach(async () => {
  await Promise.all(apps.splice(0).map((app) => app.close()));
});

describe('health and API status', () => {
  it('reports the process as live without exposing unfinished features', async () => {
    const app = await buildApp({ config, readinessCheck: async () => true });
    apps.push(app);

    const response = await app.inject({ method: 'GET', url: '/v1' });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toMatchObject({
      apiVersion: 'v1',
      features: { authentication: false, synchronization: false },
    });
  });

  it('returns 503 when PostgreSQL is unavailable', async () => {
    const app = await buildApp({ config, readinessCheck: async () => false });
    apps.push(app);

    const response = await app.inject({ method: 'GET', url: '/health/ready' });

    expect(response.statusCode).toBe(503);
    expect(response.json()).toMatchObject({ status: 'not_ready', database: 'unreachable' });
  });
});

import { buildApp } from './app';
import { loadConfig } from './config';
import { databaseIsReady, prisma } from './prisma';

async function main(): Promise<void> {
  const config = loadConfig();
  const app = await buildApp({ config, readinessCheck: databaseIsReady });

  const shutdown = async (signal: string): Promise<void> => {
    app.log.info({ signal }, 'shutting down');
    await app.close();
    await prisma.$disconnect();
  };

  process.once('SIGINT', () => void shutdown('SIGINT'));
  process.once('SIGTERM', () => void shutdown('SIGTERM'));

  await app.listen({ host: '0.0.0.0', port: config.PORT });
  app.log.info({ port: config.PORT, version: config.APP_VERSION }, 'Lighter backend started');
}

main().catch((error: unknown) => {
  console.error(error);
  process.exit(1);
});

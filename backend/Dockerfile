FROM node:22-bookworm-slim AS base
RUN sed -i 's|http://deb.debian.org/debian|http://mirrors.cloud.tencent.com/debian|g' \
      /etc/apt/sources.list.d/debian.sources \
  && apt-get update \
  -o Acquire::Retries=5 \
  -o Acquire::http::Timeout=20 \
  && apt-get install -y --no-install-recommends ca-certificates openssl \
  && rm -rf /var/lib/apt/lists/*

FROM base AS build

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY prisma ./prisma
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

FROM base AS runtime

ENV NODE_ENV=production
WORKDIR /app
RUN groupadd --system --gid 10001 lighter \
  && useradd --system --uid 10001 --gid lighter --create-home lighter
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts \
  && npm cache clean --force
COPY --from=build /app/node_modules/@prisma/engines ./node_modules/@prisma/engines
COPY --from=build /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=build /app/node_modules/@prisma/client ./node_modules/@prisma/client
COPY --from=build /app/dist ./dist
COPY --from=build /app/prisma ./prisma
COPY docker-entrypoint.sh ./docker-entrypoint.sh
RUN chmod 0555 ./docker-entrypoint.sh \
  && chown -R lighter:lighter /app

USER lighter
EXPOSE 8080
ENTRYPOINT ["./docker-entrypoint.sh"]

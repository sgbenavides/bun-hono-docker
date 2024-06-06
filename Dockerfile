# ARG Project VERSION
ARG VERSION=0.0.0

FROM oven/bun:1 as base

# ARG image
ARG VERSION
ENV VERSION=${VERSION}

WORKDIR /usr/src/app

FROM base AS install
WORKDIR /temp/prod

COPY package.json bun.lockb .
RUN bun install --frozen-lockfile --production

# Test
FROM base AS release
ENV NODE_ENV=production

COPY --from=install /temp/prod/node_modules node_modules
COPY . .

RUN bun test

# run the app
USER bun
EXPOSE 3000/tcp
ENTRYPOINT [ "bun", "run", "src/index.ts" ]
FROM node:24-alpine AS base
WORKDIR /app
COPY package.json package-lock.json ./

FROM base AS development
RUN npm ci
COPY . .
CMD ["npm", "run", "start:dev"]

FROM base AS build
RUN npm ci
COPY . .
RUN npm run build && npm prune --omit=dev

FROM node:24-alpine AS production
WORKDIR /app
ENV NODE_ENV=production
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/package.json ./package.json
USER node
CMD ["node", "dist/main.js"]

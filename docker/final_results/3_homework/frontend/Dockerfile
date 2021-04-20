FROM node:14-alpine AS build

WORKDIR /app/

ARG ARG_PROD
ENV NODE_ENV=${ARG_PROD}

COPY package*.json ./
RUN npm ci
COPY ./ ./

RUN npm run build


FROM nginx:alpine

COPY --from=build /app/dist/ /usr/share/nginx/html/
COPY entrypoint.sh /docker-entrypoint.d/

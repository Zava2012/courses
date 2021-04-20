FROM node:14-alpine

WORKDIR /app/

RUN wget https://raw.githubusercontent.com/eficode/wait-for/master/wait-for && \
    chmod +x wait-for

ARG ARG_PROD
ENV NODE_ENV=${ARG_PROD}

COPY --chown=node:node package*.json ./
RUN npm ci
COPY --chown=node:node ./ ./

USER node:

CMD [ "node", "." ]

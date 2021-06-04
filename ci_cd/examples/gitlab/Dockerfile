FROM node:14-alpine

WORKDIR /app/

COPY --chown=node:node package*.json ./
RUN echo "Good"
RUN npm ci
RUN echo "Done"
COPY --chown=node:node ./ ./

USER node

CMD [ "node", "." ]

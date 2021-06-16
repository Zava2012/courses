FROM maven:3.8.1-openjdk-8-slim

WORKDIR /app/

COPY --chown=node:node package*.json ./
RUN echo "Good"
RUN npm ci
COPY --chown=node:node ./ ./

USER node

CMD [ "node", "." ]

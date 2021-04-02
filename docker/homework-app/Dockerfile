FROM node:14-alpine

WORKDIR /app/

COPY --chown=node:node package*.json ./
RUN npm ci
COPY --chown=node:node ./ ./
# RUN chown -R node: ./

USER node

# EXPOSE 5000

CMD [ "node", "." ]
# CMD [ "npm", "start" ]

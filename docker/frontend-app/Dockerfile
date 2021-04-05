FROM node:14-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci
COPY ./ ./

# ARG image_name
# ENV IMAGE=${image_name}

# ENV MYENV=${MYENV:-4000}

RUN npm run build
# CMD [ "npm", "start" ]


FROM nginx:alpine AS app

COPY --from=build /app/build/ /usr/share/nginx/html/
# COPY entrypoint.sh /docker-entrypoint.d/

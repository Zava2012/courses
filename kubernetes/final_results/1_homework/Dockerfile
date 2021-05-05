FROM golang:1.16-alpine AS build

WORKDIR /app/

COPY ./ ./

RUN go build


FROM alpine

COPY --from=build /app/server ./

CMD [ "./server" ]

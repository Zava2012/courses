FROM maven:3-alpine AS build

WORKDIR /app/

COPY ./ ./

RUN mvn package -DskipTests


FROM openjdk:8-alpine

COPY --from=build /app/target/*.jar /app.jar

CMD [ "java", "-jar", "/app.jar" ]

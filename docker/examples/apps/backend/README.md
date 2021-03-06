## Сборка
Для сборки образа необходимо выполнить следующую команду:

`docker build src/ -f Dockerfile -t backend:1.0.0`

Для проверки инструкции в Dockerfile под названием `ONBUILD` необходимо раскомментировать эту инструкцию в файле `Dockerfile` и ещё раз собрать Docker-образ, используя команду выше.

После этого необходимо собрать Docker-образ из файла `Dockerfile-onbuild`, используя следующую команду:

`docker build src/ -f Dockerfile-onbuild -t backend:1.0.0`

## Запуск
Для запуска приложения необходимо в runtime (т.е. при запуске приложения/процесса/контейнера) инициализировать переменную окружения `APP_HOST` (пример значения: 0.0.0.0)

Сам же запуск можно выполнить через одну из следующих команд:

1. `docker run -e APP_HOST=0.0.0.0 -d backend:1.0.0`
2. `docker run --env-file src/.env -d backend:1.0.0`

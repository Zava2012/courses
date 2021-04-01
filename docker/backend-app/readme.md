Для запуска приложения необходимо в runtime инициализировать переменную окружения `APP_HOST`

Для сборки образа необходимо выполнить следующую команду:

`docker build src/ -f Dockerfile -t myimage`

Для проверки инструкции в Dockerfile под названием `ONBUILD` необходимо раскомментировать эту инструкцию в файле `Dockerfile` и ещё раз собрать Docker-образ, используя команду выше.

После этого необходимо собрать Docker-образ из файла `Dockerfile-onbuild`, используя следующую команду:

`docker build src/ -f Dockerfile-onbuild -t myimage`

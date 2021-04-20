Конечная команда для запуска контейнера PostgreSQL с инициализацией базы данных `devops_1` при старте контейнера:

- `docker run -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=devops_1 -d postgres:alpine`

Конечная команда для запуска контейнера MySQL с инициализацией базы данных `devops_1` при старте контейнера:

- `docker run -e MYSQL_ROOT_PASSWORD=mysql -e MYSQL_DATABASE=devops_1 -d mysql`

## Домашнее задание

1. Написать `Dockerfile` для приложения. Постараться максимально оптимизировать Dockerfile как мы это делали на занятиях.
2. Собрать Docker-образ и запустить контейнер на базе этого образа. После запуска контейнер прекратит свою работу, однако в логах этого контейнера вы должны получить фразу `Hello World!`
3. Написать `Helm Chart` и описать в нём следующие абстракции Kubernetes: Deployment, Service и PDB.
4. Создать `.gitlab-ci.yml` файл, который будет делать следующее (не стоит привязываться к списку ниже как к точной последовательности выполнения этапов):
    - Собирать Docker образ
    - Осуществить запуск тестов для приложения
    - Осуществить запуск статического анализа для файла Dockerfile через утилиту `hadolint`
    - И при этом **необходимо запускать тесты и статический анализ параллельно**
    - На базе результата тестов и статического анализв вывести репорты в человекочитаемом виде
    - Сделать так, чтобы тесты и сканирование образа запускались в рамках Merge Request события
    - Сделать возможность деплоить приложение через написанный ранее `Helm Chart` в Kubernetes кластер по кнопке только для `master` ветки, когда в рамках пайплайна доходит до этапа деплоя.
    - Проверить, что задеплоенный в Kubernetes кластер `Helm Chart` успешно применился, а также что в логах задеплоенного пода нет сообщений об ошибке.
    - Проксировать трафик с пода себе на локальную машину через `kubectl` и открыв браузер проверить, что появилась страница с заголовком `Welcome to .NET` и другой дополнительной информацией.
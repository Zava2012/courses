## Подготовка окружения
1. Установить утилиту `kops` из последнего релиза на [GitHub](https://github.com/kubernetes/kops/)
2. Создать пользователя в AWS с `Programmatic access` для генерации ключей, а также добавить этому пользователю следующие политики:
    ```
    AmazonEC2FullAccess
    AmazonRoute53FullAccess
    AmazonS3FullAccess
    IAMFullAccess
    AmazonVPCFullAccess
    ```
3. Разворачивать кластер будем используя Gossip DNS `k8s.local`
4. Установить AWS CLI и выполнить команду `aws configure`, введя свои ключи, которые будут использоваться для развёртывания кластера
5. Экспортировать переменную окружения `KOPS_STATE_STORE`, которая содержит путь к S3 бакету, в котором будет сохраняться состояния кластера, развёрнутого через `kops`:
    - `export KOPS_STATE_STORE=s3://<YOUR_BUCKET>`

    Или же добавить эту строку в `.bashrc` или `.zshrc` файл, в зависимости от оболочки, чтобы при инициализации терминальной сессии автоматически подхватывалась эта переменная окружения
6. **(Опционально)** Экспортировать переменную окружения `AWS_PROFILE`, которая содержит имя профиля в файле `~/.aws/credentials`, если оно у вас не `[default]`, а, например, `[devopsschool]`:
    - `export AWS_PROFILE=devopsschool`

    Или же добавить эту строку в `.bashrc` или `.zshrc` файл, в зависимости от оболочки, чтобы при инициализации терминальной сессии автоматически подхватывалась эта переменная окружения
7. Сгенерируйте SSH-ключи для того, чтобы в последующем через kops развернуть кластер. Сделать это можно командой `ssh-keygen`, просто нажимая Enter при необходимости заполнить какое-либо поле при выполнении этой команды


## Развёртывание кластера
### Вариант 1
1. Через большую консольную команду:
    - `kops create cluster --name=devopsschool.k8s.local --cloud aws --master-count 1 --master-size t3a.small --master-volume-size 20 --node-count 1 --node-size t3a.small --node-volume-size 20 --ssh-public-key="~/.ssh/id_rsa.pub" --networking calico --container-runtime containerd`

### Вариант 2
1. С использование файла `kops.yaml`, выполнив следующую команду:
    - `kops create -f kops.yaml`
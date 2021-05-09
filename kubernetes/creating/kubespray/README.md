## Инструкция для развёртывания кластера на Bare Metal с использованием Multipass
### Подготовка окружения
1. **Важное требование:** ваша машина должна поддерживать аппаратную виртуализацию, а также у вас должно быть свободно как минимум 4 Гб оперативной памяти для данной конфигурации
2. Установить утилиту [multipass](https://multipass.run/)
3. Запустить две виртуальные машины, используя следующие команды:
    - `multipass launch --name primary -c 2 -m 2G -d 10G`
    - `multipass launch --name worker -c 2 -m 2G -d 10G`
4. Если вы используете Windows, то необходимо остановить все виртуальные машины через команду `multipass stop --all` или же вручную их остановить в диспетчере Hyper-V, после чего отключить функцию `динамической памяти` в настройках каждой виртуальной машины, чтобы у вас в один момент виртуальная машина не начала резервировать больше оперативной памяти, чем мы ей указали при старте
5. Запустить обратно все виртуальные машины командой `multipass start --all`
6. Сгенерируйте SSH-ключи для того, чтобы в последующем через Ansible развернуть кластер. Сделать это можно командой `ssh-keygen`, просто нажимая Enter при необходимости заполнить какое-либо поле при выполнении этой команды
7. **(Только для WSL)** Запустить SSH-демон следующими командами, добавить свой ключ и проверить, что он подтянулся:
    - `eval $(ssh-agent -s)`
    - `ssh-add`
    - `ssh-add -l`
8. Выведите свой публичный SSH-ключ командой `cat ~/.ssh/id_rsa.pub` и скопируйте его **на все виртуальные сервера** в файл `authorized_keys` по пути `~/.ssh/`. Зайти на сервера можно по названию созданных через multipass серверов, список которых можно вывести через команду `multipass list`. Примеры того, как зайти на сервер:
    - `multipass shell <node_name>`
    - `multipass shell` (попытается зайти на primary-сервер)
    - `multipass shell worker`
9. **(Только для WSL)** Если вы развернули виртуальные сервера через multipass на Windows, то умолчанию WSL до них никаким образом не может достучаться по причине того, что они находятся в разных виртуальных сетях. Чтобы исправить эту проблему и в перспективе успешно развернуть кластер Kubernetes, запуская его развёртывание через Ansible на WSL, необходимо выполнить следующую команду **в PowerShell от имени администратора**, что может повлечь за собой изменение IP-адресов виртуальных машин, развёрнутых с использованием multipass:
    - `Get-NetIPInterface | where {$_.InterfaceAlias -eq "vEthernet (WSL)" -or $_.InterfaceAlias -eq "vEthernet (Default Switch)" } | Set-NetIPInterface -Forwarding Enabled`

### Развёртывание кластера
1. Склонируйте репиторий `kubespray` с [GitHub](https://github.com/kubernetes-sigs/kubespray) и перейдите в папку с проектом
2. Зайдите в папку `inventory` и сделайте копию папки `sample` через команду `cp -rpf sample/ devopsschool/`
3. По пути `group_vars/k8s-cluster/` измените в файлах `addons.yml` и `k8s-cluster.yml` следующие строки:

    addons.yml:
    - `dashboard_enabled: true`
    - `metrics_server_enabled: true`

    k8s-cluster.yml:
    - `kube_version: v1.21.0`
    - `kube_network_plugin: calico`
    - `container_manager: containerd`
    - `kubernetes_audit: true`
    - `podsecuritypolicy_enabled: true`
    - `event_ttl_duration: "24h0m0s"`
    - `auto_renew_certificates: true`
4. По пути `group_vars/` измените в файле `etcd.yml` строку на следующее:
    - `etcd_deployment_type: host`
5. Перейдите обратно в корневую директорию проекта `kubespray` и по пути `roles/kubespray-defaults/defaults/` измените в файле `main.yaml`следующие строки:
    ```
    kube_feature_gates:
      - EphemeralContainers=true
      - GracefulNodeShutdown=true
      - HPAContainerMetrics=true
      - HPAScaleToZero=true
    ```
6. Настройте `inventory.ini` файл по пути `inventory/devopsschool/`, прописав там необходимые IP-адреса и раскомментировав необходимые поля
7. Разверните кластер Kubernetes, используя следующую команду:
    - `ansible-playbook -i inventory/devopsschool/inventory.ini cluster.yml -u ubuntu -b`

### Дополнительные команды
1. Для обновления кластера необходимо запустить следующую команду:
    - `ansible-playbook -i inventory/devopsschool/inventory.ini upgrade-cluster.yml -u ubuntu -b`
2. Для сброса кластера в исходное состояние (т.е. состояние перед деплоем компонентов Kubernetes) необходимо запустить следующую команду:
    - `ansible-playbook -i inventory/devopsschool/inventory.ini reset.yml -u ubuntu -b`



## Инструкция для развёртывания кластера в AWS
### Подготовка окружения
1. Склонируйте репиторий `kubespray` с [GitHub](https://github.com/kubernetes-sigs/kubespray) и перейдите в папку с проектом
2. Скопируйте папку с inventory для terraform модуля, используя следующую команду:
    - `cp -rpL contrib/terraform/aws/sample-inventory/ inventory/devopsschool/`
3. По пути `сontrib/terraform/aws/modules/iam/` изменить в файле `main.tf` IAM Policy в ресурсе, под названием `resource "aws_iam_role_policy" "kube-worker"`, чтобы в перспективе корректно работал `AWS EBS CSI (Container Storage Interface)` драйвер.

    Заменить надо с этого блока:
    ```
    {
        "Effect": "Allow",
        "Action": "ec2:Describe*",
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": "ec2:AttachVolume",
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": "ec2:DetachVolume",
        "Resource": "*"
    },
    ```
    на этот:
    ```
    {
        "Effect": "Allow",
        "Action": ["ec2:*"],
        "Resource": ["*"]
    },
    ```
4. Перейти в папку `inventory/devopsschool/` и выполнить следующую команду:
    - `terraform init ../../contrib/terraform/aws`
5. Создать пользователя в AWS с `Programmatic access` для генерации ключей, а также добавить этому пользователю следующие политики:
    ```
    AmazonEC2FullAccess
    IAMFullAccess
    AmazonVPCFullAccess
    ```
6. Импортировать свой публичный SSH-ключ в Key Pairs в рамках сервиса EC2.
7. В файл `config` по пути `~/.ssh` добавить следующие строки.
    ```
    Host *
        ForwardAgent yes
    ```

    Если этого файла не существует, то создать его с таким же содержанием.
8. Подготовить через terraform минимально жизнеспособную инфраструктуру с минимальными денежными затратами, изменив в файле `cluster.tfvars` следующие строки:
    ```
    #Global Vars
    aws_cluster_name = "devopsschool"
    aws_bastion_size = "t2.micro"
    aws_kube_master_num = 1
    aws_kube_master_size = "t3a.small"
    aws_kube_master_root_volume_size = 20
    aws_etcd_num = 1
    aws_etcd_size = "t2.micro"
    aws_kube_worker_num = 1
    aws_kube_worker_size = "t3a.small"
    aws_kube_worker_root_volume_size = 20
    inventory_file = "hosts"

    ## Credentials
    #AWS Access Key
    AWS_ACCESS_KEY_ID = "<YOUR_KEY>"
    #AWS Secret Key
    AWS_SECRET_ACCESS_KEY = "<YOUR_SECRET_KEY>"
    #EC2 SSH Key Name
    AWS_SSH_KEY_NAME = "<YOUR_KEY_NAME>"
    #AWS Region
    AWS_DEFAULT_REGION = "eu-central-1"
    ```
8. Развернуть настроенную инфраструктуру, используя следующую команду:
    - `terraform apply -var-file=cluster.tfvars ../../contrib/terraform/aws/`
9. После выполнения этой команды и предпроверки плана terraform необходимо будет ввести слово `yes`. После успешного создания инфраструктуры в папке, где была запущена команда, будет создан файл `hosts`, в котором описаны данные для того, чтобы настраивать на базе созданной инфраструктуры кластер Kubernetes.

### Развёртывание кластера
1. По пути `group_vars/k8s-cluster/` измените в файлах `addons.yml` и `k8s-cluster.yml` следующие строки:

    addons.yml:
    - `dashboard_enabled: true`
    - `metrics_server_enabled: true`

    k8s-cluster.yml:
    - `kube_version: v1.21.0`
    - `kube_network_plugin: calico`
    - `container_manager: containerd`
    - `kubernetes_audit: true`
    - `podsecuritypolicy_enabled: true`
    - `persistent_volumes_enabled: true`
    - `event_ttl_duration: "24h0m0s"`
    - `auto_renew_certificates: true`
2. По пути `group_vars/all/` измените в файлах `all.yml` и `aws.yml` следующие строки для интеграции с облачным провайдером AWS:

    all.yml:
    - `cloud_provider: aws`

    aws.yml:
    - `aws_ebs_csi_enabled: true`
    - `aws_ebs_csi_enable_volume_snapshot: true`
    - `aws_ebs_csi_enable_volume_resizing: true`
3. По пути `group_vars/` измените в файле `etcd.yml` строку на следующее:
    - `etcd_deployment_type: host`
4. Перейдите обратно в корневую директорию проекта `kubespray` и по пути `roles/kubespray-defaults/defaults/` измените в файле `main.yaml`следующие строки:
    ```
    kube_feature_gates:
      - EphemeralContainers=true
      - GracefulNodeShutdown=true
      - HPAContainerMetrics=true
      - HPAScaleToZero=true
    ```
5. Разверните кластер Kubernetes, используя следующую команду:
    - `ansible-playbook -i inventory/devopsschool/hosts cluster.yml -e ansible_user=ubuntu -b`

### Дополнительные команды
1. Для обновления кластера необходимо запустить следующую команду:
    - `ansible-playbook -i inventory/devopsschool/hosts upgrade-cluster.yml -e ansible_user=ubuntu -b`
2. Для сброса кластера в исходное состояние (т.е. состояние перед деплоем компонентов Kubernetes) необходимо запустить следующую команду:
    - `ansible-playbook -i inventory/devopsschool/hosts reset.yml -e ansible_user=ubuntu -b`

## Инструкция для развёртывания кластера на Bare Metal с использованием Multipass
### Подготовка окружения:
1. **Важное требование:** ваша машина должна поддерживать аппаратную виртуализацию, а также у вас должно быть свободно как минимум 4 Гб оперативной памяти для данной конфигурации
2. Установить утилиту [multipass](https://multipass.run/)
3. Запустить две виртуальные машины, используя следующие команды:
    - `multipass launch --name primary -c 2 -m 2G -d 10G`
    - `multipass launch --name worker -c 2 -m 2G -d 10G`
4. Если вы используете Windows, то необходимо остановить все виртуальные машины через команду `multipass stop --all` или же вручную их остановить в диспетчере Hyper-V, после чего отключить функцию `динамической памяти` в настройках каждой виртуальной машины, чтобы у вас в один момент виртуальная машина не начала резервировать больше оперативной памяти, чем мы ей указали при старте
5. Запустить обратно все виртуальные машины командой `multipass start --all`

## Развёртывание кластера
### Подготовка всех виртуальных машин
1. Подготовить операционную систему к требования для CNI плагина, выполнив следующие команды:
    ```
    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
    br_netfilter
    EOF

    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    EOF
    sudo sysctl --system
    ```
2. Установить CRI (Container Runtime Interface) Docker, выполнив следующую команду:
    - `curl -fsSL https://get.docker.com/ | sh`
3. Установить kubelet, kubeadm и kubectl, выполнив следующие команды:
    ```
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg`

    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list`

    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
    ```
4. Настроить Docker Daemon для использования systemd в качестве cgroups для контейнеров, используя следующие команды:
    ```
    sudo mkdir /etc/docker

    cat <<EOF | sudo tee /etc/docker/daemon.json
    {
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2"
    }
    EOF
    ```
5. Перезагрузить Docker, чтобы применить настройки, а также сделать так, чтобы Docker стартовал при запуске системы. Для этого необходимо выполнить следующие команды:
    ```
    sudo systemctl enable docker
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    ```
### Подготовка Control Plane
1. Выполнить следующую команду для инициализации Kubernetes кластера:
    - `sudo kubeadm init --feature-gates 'EphemeralContainers=true,GracefulNodeShutdown=true,HPAContainerMetrics=true,HPAScaleToZero=true'`
2. После успешной инициализации Control Plane на master-нодах необходимо выполнить следующие команды для получения kubeconfig-файла:
    ```
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```
3. Задерлоить CNI (Container Network Interface) плагин в только что созданный Kubernetes кластер. Для примера, возьмём Calico и задеплоим его в кластер следующей командой:
    - `kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml`
4. После успешного деплоя CNI плагина подождать около минуты и выполнить следующую команду, чтобы проверить, что статус ноды `Ready`:
    - `kubectl get node`

### Подготовка Worker Node
1. Выполнить команду, которая появилась после успешной инициализации кластера. Она позволить присоединить узел в кластер Kubernetes. Ниже представлен шаблон этой команды:
    - `sudo kubeadm join <control-plane-host>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>`
2. Перейти на виртуальную машину, где развёрнут Control Plane и ввести следующую команду, которая должна показать, что в кластере уже две ноды со статусом `Ready`:
    - `kubectl get node`

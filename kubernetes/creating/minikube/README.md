## Инструкция для развёртывания кластера на Bare Metal

Установить minikube и выполнить следующую команду для запуска локального кластера:

- `minikube start --addons 'metrics-server,dashboard' --cni calico --container-runtime containerd --nodes 2 --cpus 2 --memory 2g --disk-size 10g --feature-gates 'EphemeralContainers=true,GracefulNodeShutdown=true,HPAContainerMetrics=true,HPAScaleToZero=true'`

Ещё есть специальный флаг `--driver`, который позволяет выбрать драйвер (что использовать для разворачивания кластера), через который будет работать minikube: KVM, Hyper-V, Docker (на данный момент экспериментальная фича), VMware (с определённым установленным драйвером для него), VirtualBox, SSH. По умолчанию же minikube пытается определить драйвер автоматически. Но если он сделал это не так, как вы хотели, вот пример использования флага в команде `minikube start`:
- `--driver hyperv`

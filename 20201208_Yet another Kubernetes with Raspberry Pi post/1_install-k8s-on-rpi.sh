### install Kubernetes on Raspberry Pi

# install Docker
sudo apt install -yqq docker.io
# The following additional packages will be installed:
#   cgroupfs-mount git git-man libcurl3-gnutls liberror-perl libintl-perl libintl-xs-perl libltdl7 libmodule-find-perl
#   libmodule-scandeps-perl libnspr4 libnss3 libproc-processtable-perl libsort-naturally-perl libterm-readkey-perl
#   needrestart runc tini
# ...
# The following NEW packages will be installed:
#   cgroupfs-mount docker.io git git-man libcurl3-gnutls liberror-perl libintl-perl libintl-xs-perl libltdl7
#   libmodule-find-perl libmodule-scandeps-perl libnspr4 libnss3 libproc-processtable-perl libsort-naturally-perl
#   libterm-readkey-perl needrestart runc tini
# 0 upgraded, 19 newly installed, 0 to remove and 0 not upgraded.
# ...
 
# check docker info and change the default cgroups driver for Docker to systemd
sudo docker info
# ...
# Server Version: 18.09.1
# Storage Driver: overlay2
# ...
# Logging Driver: json-file
# Cgroup Driver: cgroupfs
# ...
# Kernel Version: 5.4.79-v7+
# Operating System: Raspbian GNU/Linux 10 (buster)
# OSType: linux
# Architecture: armv7l
# CPUs: 4
# Total Memory: 974.4MiB
# Name: pimaster
# ...
#
# WARNING: No memory limit support
# WARNING: No swap limit support
# WARNING: No kernel memory limit support
# WARNING: No oom kill disable support
 
# create/edit the /etc/docker/daemon.json file (with the following content, uncommented) and restart docker service
sudo nano /etc/docker/daemon.json
# {
#   "exec-opts": ["native.cgroupdriver=systemd"],
#   "log-driver": "json-file",
#   "log-opts": {
#     "max-size": "100m"
#   },
#   "storage-driver": "overlay2"
# }
 
sudo systemctl restart docker
 
# docker info now showing the changed cgroup driver
sudo docker info
# ...
# Cgroup Driver: systemd
# ...
# 
# WARNING: No memory limit support
# WARNING: No swap limit support
# WARNING: No kernel memory limit support
# WARNING: No oom kill disable support
 
# add cgroups limit support and reboot
sudo sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1/' /boot/cmdline.txt
# console=tty1 root=PARTUUID=03f5b65e-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1
 
sudo reboot
 
# recheck docker info (warnings should be gone)
sudo docker info
# ...
# Storage Driver: overlay2
# ...
# Logging Driver: json-file
# Cgroup Driver: systemd
# ...
# Operating System: Raspbian GNU/Linux 10 (buster)
# ...
 
# configure iptables
cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
 
# configure iptables (add lines to the file, uncommented) and apply the configuration
sudo nano /etc/sysctl.d/k8s.conf
# net.bridge.bridge-nf-call-ip6tables = 1
# net.bridge.bridge-nf-call-iptables = 1
 
sudo sysctl --system
* Applying /etc/sysctl.d/98-rpi.conf ...
# kernel.printk = 3 4 1 3
# vm.min_free_kbytes = 16384
# * Applying /etc/sysctl.d/99-sysctl.conf ...
# * Applying /etc/sysctl.d/k8s.conf ...
# net.bridge.bridge-nf-call-ip6tables = 1
# net.bridge.bridge-nf-call-iptables = 1
# * Applying /etc/sysctl.d/protect-links.conf ...
# fs.protected_hardlinks = 1
# fs.protected_symlinks = 1
# * Applying /etc/sysctl.conf ...
 
# disable swap
# check current swap utilization/settings
free -m
#               total        used        free      shared  buff/cache   available
# Mem:            974          82         709           6         182         834
# Swap:            99           0          99
 
sudo cat /etc/fstab
# proc            /proc           proc    defaults          0       0
# PARTUUID=03f5b65e-01  /boot           vfat    defaults          0       2
# PARTUUID=03f5b65e-02  /               ext4    defaults,noatime  0       1
 
# disable swap (note - disabling the service as well!)
sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo update-rc.d dphys-swapfile remove
sudo systemctl disable dphys-swapfile.service
# Synchronizing state of dphys-swapfile.service with SysV service script with /lib/systemd/systemd-sysv-install.
# Executing: /lib/systemd/systemd-sysv-install disable dphys-swapfile
# Removed /etc/systemd/system/multi-user.target.wants/dphys-swapfile.service.
 
# optionally - reboot & recheck
free -m
#               total        used        free      shared  buff/cache   available
# Mem:            974          79         745          12         149         832
# Swap:             0           0           0
 
# prepare for Kubernetes installation (source, keys, kubeadm) and "lock" the kubelet, kubeadm and kubectl versions
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# OK
 
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# deb https://apt.kubernetes.io/ kubernetes-xenial main
 
sudo apt -qq update
# All packages are up to date.
 
sudo apt install -yqq kubeadm
# The following additional packages will be installed:
#   conntrack cri-tools ebtables kubectl kubelet kubernetes-cni socat
# Suggested packages:
#   nftables
# The following NEW packages will be installed:
#   conntrack cri-tools ebtables kubeadm kubectl kubelet kubernetes-cni socat
# 0 upgraded, 8 newly installed, 0 to remove and 0 not upgraded.
# ...
 
sudo apt-mark hold kubelet kubeadm kubectl
# kubelet set on hold.
# kubeadm set on hold.
# kubectl set on hold.
 
# install Kubernetes control plane
# generate token for the installation
TOKEN=$(sudo kubeadm token generate)
echo $TOKEN
# <some_token_info>
 
sudo kubeadm init --token=${TOKEN} --kubernetes-version=v1.19.4 --pod-network-cidr=10.244.0.0/16
# W1208 16:59:02.624049     781 configset.go:348] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
# [init] Using Kubernetes version: v1.19.4
# [preflight] Running pre-flight checks
#         [WARNING SystemVerification]: missing optional cgroups: hugetlb
# [preflight] Pulling images required for setting up a Kubernetes cluster
# [preflight] This might take a minute or two, depending on the speed of your internet connection
# [preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
# [certs] Using certificateDir folder "/etc/kubernetes/pki"
# [certs] Generating "ca" certificate and key
# [certs] Generating "apiserver" certificate and key
# [certs] apiserver serving cert is signed for DNS names [kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local pimaster] and IPs [10.96.0.1 192.168.12.101]
# [certs] Generating "apiserver-kubelet-client" certificate and key
# [certs] Generating "front-proxy-ca" certificate and key
# [certs] Generating "front-proxy-client" certificate and key
# [certs] Generating "etcd/ca" certificate and key
# [certs] Generating "etcd/server" certificate and key
# [certs] etcd/server serving cert is signed for DNS names [localhost pimaster] and IPs [192.168.12.101 127.0.0.1 ::1]
# [certs] Generating "etcd/peer" certificate and key
# [certs] etcd/peer serving cert is signed for DNS names [localhost pimaster] and IPs [192.168.12.101 127.0.0.1 ::1]
# [certs] Generating "etcd/healthcheck-client" certificate and key
# [certs] Generating "apiserver-etcd-client" certificate and key
# [certs] Generating "sa" key and public key
# [kubeconfig] Using kubeconfig folder "/etc/kubernetes"
# [kubeconfig] Writing "admin.conf" kubeconfig file
# [kubeconfig] Writing "kubelet.conf" kubeconfig file
# [kubeconfig] Writing "controller-manager.conf" kubeconfig file
# [kubeconfig] Writing "scheduler.conf" kubeconfig file
# [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
# [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
# [kubelet-start] Starting the kubelet
# [control-plane] Using manifest folder "/etc/kubernetes/manifests"
# [control-plane] Creating static Pod manifest for "kube-apiserver"
# [control-plane] Creating static Pod manifest for "kube-controller-manager"
# [control-plane] Creating static Pod manifest for "kube-scheduler"
# [etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
# [wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
# [kubelet-check] Initial timeout of 40s passed.
# [kubelet-check] It seems like the kubelet isn't running or healthy.
# [kubelet-check] The HTTP call equal to 'curl -sSL http://localhost:10248/healthz' failed with error: Get "http://localhost:10248/healthz": dial tcp [::1]:10248: connect: connection refused.
# [kubelet-check] It seems like the kubelet isn't running or healthy.
# [kubelet-check] The HTTP call equal to 'curl -sSL http://localhost:10248/healthz' failed with error: Get "http://localhost:10248/healthz": dial tcp [::1]:10248: connect: connection refused.
# [kubelet-check] It seems like the kubelet isn't running or healthy.
# [kubelet-check] The HTTP call equal to 'curl -sSL http://localhost:10248/healthz' failed with error: Get "http://localhost:10248/healthz": dial tcp [::1]:10248: connect: connection refused.
# [apiclient] All control plane components are healthy after 212.227971 seconds
# [upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
# [kubelet] Creating a ConfigMap "kubelet-config-1.19" in namespace kube-system with the configuration for the kubelets in the cluster
# [upload-certs] Skipping phase. Please see --upload-certs
# [mark-control-plane] Marking the node pimaster as control-plane by adding the label "node-role.kubernetes.io/master=''"
# [mark-control-plane] Marking the node pimaster as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
# [bootstrap-token] Using token: <some_token_info>
# [bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
# [bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to get nodes
# [bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
# [bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
# [bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
# [bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
# [kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
# [addons] Applied essential addon: CoreDNS
# [addons] Applied essential addon: kube-proxy
#
# Your Kubernetes control-plane has initialized successfully!
# 
# To start using your cluster, you need to run the following as a regular user:
#   mkdir -p $HOME/.kube
#   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#   sudo chown $(id -u):$(id -g) $HOME/.kube/config
#
# You should now deploy a pod network to the cluster.
# Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
#   https://kubernetes.io/docs/concepts/cluster-administration/addons/
#
# Then you can join any number of worker nodes by running the following on each as root:
#
# kubeadm join 192.168.12.101:6443 --token <some_token_info> \
#     --discovery-token-ca-cert-hash sha256:5b04368aaee148fa3eb8c6aed3c3bc8041248590e2055a81617d16d8f796bb77
 
# start using the cluster
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
 
# check node status (something's missing - flannel)
kubectl get nodes
# NAME       STATUS     ROLES    AGE    VERSION
# pimaster   NotReady   master   14m    v1.19.4
 
# install flannel network plugin
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
# podsecuritypolicy.policy/psp.flannel.unprivileged created
# clusterrole.rbac.authorization.k8s.io/flannel created
# clusterrolebinding.rbac.authorization.k8s.io/flannel created
# serviceaccount/flannel created
# configmap/kube-flannel-cfg created
# daemonset.apps/kube-flannel-ds created
 
# and now we're ready (check under STATUS)
kubectl get nodes
# NAME       STATUS     ROLES    AGE     VERSION
# pimaster   Ready      master   17m     v1.19.4
 
# add node to the cluster (pinode, 192.168.12.102)
sudo kubeadm join 192.168.12.101:6443 --token <some_token_info> --discovery-token-ca-cert-hash sha256:5b04368aaee148fa3eb8c6aed3c3bc8041248590e2055a81617d16d8f796bb77
# [preflight] Running pre-flight checks
# [preflight] Reading configuration from the cluster...
# [preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
# [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
# [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
# [kubelet-start] Starting the kubelet
# [kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...
#
# This node has joined the cluster:
# * Certificate signing request was sent to apiserver and a response was received.
# * The Kubelet was informed of the new secure connection details.
#
# Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
 
# check nodes in the cluster (check the details... nice)
kubectl get nodes -o wide
# NAME       STATUS   ROLES    AGE     VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION     CONTAINER-RUNTIME
# pimaster   Ready    master   18m     v1.19.4   192.168.12.101           Raspbian GNU/Linux 10 (buster)   5.4.79-v7+         docker://18.9.1
# pinode     Ready       6m15s   v1.19.4   192.168.12.102           Ubuntu 20.04.1 LTS               5.4.0-56-generic   docker://19.3.8
 
# test with some workload
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml
# deployment.apps/redis-master created
 
kubectl get pods
# NAME                           READY   STATUS    RESTARTS   AGE
# redis-master-f46ff57fd-9m9g9   1/1     Running   0          37s
 
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml
# service/redis-master created
 
kubectl get service
# NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
# kubernetes     ClusterIP   10.96.0.1                443/TCP    22m
# redis-master   ClusterIP   10.100.245.207           6379/TCP   4s
 
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml
# deployment.apps/redis-slave created
 
kubectl get pods
# NAME                           READY   STATUS    RESTARTS   AGE
# redis-master-f46ff57fd-9m9g9   1/1     Running   0          2m30s
# redis-slave-bbc7f655d-dz895    1/1     Running   0          12s
# redis-slave-bbc7f655d-slnhv    1/1     Running   0          12s
 
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml
# service/redis-slave created
 
kubectl get services
# NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
# kubernetes     ClusterIP   10.96.0.1                443/TCP    23m
# redis-master   ClusterIP   10.100.245.207           6379/TCP   91s
# redis-slave    ClusterIP   10.101.165.188           6379/TCP   13s
 
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml
# deployment.apps/frontend created
 
kubectl get pods -l app=guestbook -l tier=frontend
# NAME                        READY   STATUS    RESTARTS   AGE
# frontend-6c6d6dfd4d-945hd   1/1     Running   0          7s
# frontend-6c6d6dfd4d-mm7vm   1/1     Running   0          7s
# frontend-6c6d6dfd4d-wllpx   1/1     Running   0          7s
 
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml
# service/frontend created
 
kubectl get services
# NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
# frontend       NodePort    10.101.140.217           80:31597/TCP   4s
# kubernetes     ClusterIP   10.96.0.1                443/TCP        24m
# redis-master   ClusterIP   10.100.245.207           6379/TCP       2m45s
# redis-slave    ClusterIP   10.101.165.188           6379/TCP       87s

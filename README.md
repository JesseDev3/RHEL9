https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/ \
<br>
** Anyone just getting started with Linux, take a look at the quickstart file and consider ** \
curl -fsSL https://raw.githubusercontent.com/JesseDev3/RHEL9/refs/heads/main/setup.sh -O setup.sh \
sudo bash setup.sh
<br>
# RHEL9
/ , /home , /tmp , /var , /var/tmp , /var/log , /var/log/audit , /boot \
$Creating shared directories on your BM will greatly reduce time spent later!
Always shred or clean drives and motherboards upon disposal if possible, to avoid credential harvesting with openwrt and py dump of partitions or other methods

# Cockpit allows for Ubuntu Focal(20.04)/ROS-Noetic/Gazebo (Gazebo not currently supported on linux9)
https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index \
$ systemctl enable --now cockpit.socket \
$ sudo dnf install -y cockpit-machines

# VPN
https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-a-vpn-connection_configuring-and-managing-networking#configuring-a-vpn-connection_configuring-and-managing-networking 
<br>
Cockpit allows the creation of a Wireguard vpn that inserts an interface and can only be used if FIPS is disabled. While this does add convenience, Wireguard is not recommended for production whereas Libreswan (a fork of Openswan IPsec) is.

# Install virt packages (if not already available) 
$ sudo dnf group install "Virtualization Host" \
$ sudo dnf install qemu-kvm libvirt virt-install virt-viewer \
$ for drv in qemu network nodedev nwfilter secret storage interface; do systemctl start virt${drv}d{,-ro,-admin}.socket; done \
$ virt-host-validate \
$ sudo dnf update -y \
$ sudo dnf install -y pip     

# Install Go 
$ sudo dnf install -y go

# VS Code https://code.visualstudio.com/insiders/#
$ cd Downloads && ls <br>
$ sudo dnf install (code-insiders).rpm && sudo rm (code-insiders).rpm

# Podman Desktop
$ flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo <br> 
$ flatpak install --user flathub io.podman_desktop.PodmanDesktop <br> 
$ flatpak update --user io.podman_desktop.PodmanDesktop <br> 
$ flatpak run io.podman_desktop.PodmanDesktop

# K8 (Kubernetes)
Kubectl, kubeadm, kind, minikube \
$ sudo yum install -y kubelet kubeadm kubectl \
**$ systemctl enable && systemctl start kubelet if necessary** \
$ go install sigs.k8s.io/kind@v0.27.0 \
$ sudo mv ~/go/bin/kind /bin \
$ sudo rmd -r ~/go \
$ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm


# IT Tools :8080
$ podman run -d --name it-tools --restart unless-stopped -p 8080:80 corentinth/it-tools:latest 

# Grafana :3000 (Change port IF running Kali-Linux)
$ sudo systemctl daemon-reload \
$ sudo systemctl start grafana-server \
$ sudo systemctl status grafana-server \
$ sudo systemctl enable grafana-server.service 

# VM Creation 
https://support.broadcom.com/ \
** Using VMM or Cockpit will create a VM in the qemu domain **  \
** RHEL does not support VM qemu domain and is discouraged for production environments ** \
\
VMware Fusion (Mac) \
Oracle Virtual Box VDI (Platform supports both VHDX and VMX) \
Cockpit - localhost:9090 (stored on computer) or HOST-IP:9090 (unsecure/no TLS) \
VMware Workstation Pro (Windows/Linux) - requires vsphere or vcenter esxi for netboot

# Ubuntu 24.04 <br> ROS2 and Gazebo Support 
AMD \
https://ubuntu.com/download/desktop/thank-you?version=24.04.2&architecture=amd64&lts=true \
$ sudo mkdir ~/iso \
$ sudo mv ~/Downloads/ubuntu-24.04.2-desktop-amd64.iso ~/iso

ARM \
https://ubuntu.com/download/server/arm \
Then use terminal to install Desktop (flavour)

# Auto-install
auto-install.yaml
\
<br>
# ROS2(QT)
$ locale  # check for UTF-8 \
$ sudo apt update && sudo apt install locales \
sudo locale-gen en_US en_US.UTF-8 \
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
export LANG=en_US.UTF-8 \
$ locale  # verify settings \
$ sudo apt install software-properties-common \
$ sudo add-apt-repository universe \
$ sudo apt update && sudo apt install curl -y \
$ sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
$ echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null \
$ sudo apt update && sudo apt install ros-dev-tools \
$ sudo apt update -y && sudo apt upgrade -y \
$ sudo apt install ros-jazzy-desktop \
$ source /opt/ros/jazzy/setup.bash
<br>
# Gazebo Harmonic
$ sudo apt-get update && sudo apt-get install lsb-release gnupg \
$ sudo curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null \
$ sudo apt-get update && sudo apt-get install gz-harmonic
<br>



 

  

 

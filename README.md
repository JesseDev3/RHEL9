# RHEL9 
https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/ \
/ , /home , /tmp , /var , /var/tmp , /var/log , /var/log/audit , /boot 

# Cockpit allows for Ubuntu Focal(20.04)/ROS-Noetic/Gazebo (Gazebo not currently supported on linux9)
https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index \
** RHEL does not support VM qemu domain and is discouraged for production environments ** \
<br>
$ systemctl enable --now cockpit.socket \
$ sudo dnf install cockpit-machines

# VPN
https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-a-vpn-connection_configuring-and-managing-networking#configuring-a-vpn-connection_configuring-and-managing-networking 
<br>
Cockpit allows the creation of a Wireguard vpn that inserts an interface and can only be used if FIPS is disabled. While this does add convenience, Wireguard is not recommended for production whereas Libreswan (a fork of Openswan IPsec) is.

# Install virt packages if not already available
$ sudo dnf group install "Virtualization Host" \
$ sudo dnf install qemu-kvm libvirt virt-install virt-viewer \
$ for drv in qemu network nodedev nwfilter secret storage interface; do systemctl start virt${drv}d{,-ro,-admin}.socket; done \
$ virt-host-validate \
$ sudo dnf update -y \
$ sudo dnf install pip -y     

# Install Go https://go.dev/doc/install 
$ https://go.dev/dl/go1.24.2.linux-amd64.tar.gz \
$ rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.2.linux-amd64.tar.gz \ 
$ export PATH=$PATH:/usr/local/go/bin \
$ go version     

# Podman Desktop
$ sudo yum install flatpak <br>
$ flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo <br> 
$ flatpak install --user flathub io.podman_desktop.PodmanDesktop <br> 
$ flatpak update --user io.podman_desktop.PodmanDesktop <br> 
$ flatpak run io.podman_desktop.PodmanDesktop      

# VS Code https://code.visualstudio.com/insiders/#
$ cd Downloads <br>
$ ls <br> 
$ sudo dnf install (code-insiders).rpm <br> 
$ sudo rm (code-insiders).rpm      

# Ubuntu 24.04 <br> ROS2 and Gazebo Support 
AMD \
https://ubuntu.com/download/desktop/thank-you?version=24.04.2&architecture=amd64&lts=true \
$ sudo mkdir ~/iso \
$ sudo mv ~/Downloads/ubuntu-24.04.2-desktop-amd64.iso ~/iso

ARM \
https://ubuntu.com/download/server/arm \
Then use terminal to install Desktop (flavour)

# VM Creation 
VMM \
VMware Fusion (Mac) \
Cockpit - localhost:9090 (stored on computer) or IP:9090 (unsecure/no TLS) \
VMware Workstation Pro (Windows/Linux) - requires vsphere or vcenter esxi for netboot 

# Auto-install
auto-install.yaml
\
<br>
# ROS2(QT) / Gazebo
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
# Kubernetes (For Ubuntu to avoid disabling Selinux)
Kubectl, kind, minikube, kubeadm 




 

  

 

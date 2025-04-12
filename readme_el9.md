# Before we begin
- Tools and Features do not have to be installed on the same server for communication
- Java may not be best suited since RHEL9 seems to be geared more for container and hybrid cloud management 
- Personal preferences: 
- Certain bookmarks for certain browsers
- Setting up shared directories to avoid redundant filepaths (VS Code) and downloads
- e.g.- setting up default directory for saving or accessing vs code files (or similar) in onedrive 
- Organization is key!

## RHEL9 Documentation and Setup Guide
refer to RHEL9 Documentation [Homepage](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/)

## Quickstart
For a quickstart, [link](https://raw.githubusercontent.com/JesseDev3/RHEL9/refs/heads/main/setup.sh). You can copy and paste 
```bash
$ curl -fsSL https://raw.githubusercontent.com/JesseDev3/RHEL9/refs/heads/main/setup.sh -o setup.sh
$ sudo bash setup.sh
```
---

## Important Directories
- `/`, `/home`, `/tmp`, `/var`, `/var/tmp`, `/var/log`, `/var/log/audit`, `/boot`
- Always shred or clean drives and motherboards upon disposal to prevent credential harvesting.

---

## Cockpit
Cockpit supports Ubuntu Focal (20.04), ROS-Noetic, and Gazebo (Gazebo not supported on RHEL9).
- [Cockpit Documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index)
```bash
$ systemctl enable --now cockpit.socket
$ sudo dnf install -y cockpit-machines
```

---

## VPN
- [VPN Configuration Guide](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-a-vpn-connection_configuring-and-managing-networking)
- Cockpit supports WireGuard VPN (requires FIPS disabled). For production, use Libreswan (Openswan IPsec fork). 

---

## Virtualization Setup
Install virtualization packages:
```bash
$ sudo dnf group install "Virtualization Host"
$ sudo dnf install qemu-kvm libvirt virt-install virt-viewer
$ for drv in qemu network nodedev nwfilter secret storage interface; do systemctl start virt${drv}d{,-ro,-admin}.socket; done
$ virt-host-validate
$ sudo dnf update -y
$ sudo dnf install -y pip
```

---

## Install Go 
```bash
$ sudo dnf install -y go
```
AMD/INTEL
```bash
$ curl -LO https://go.dev/dl/go1.24.2.linux-amd64.tar.gz
$ rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.2.linux-amd64.tar.gz
$ export PATH=$PATH:/usr/local/go/bin
```
ARM
```bash
$ curl https://go.dev/dl/go1.24.2.linux-arm64.tar.gz
$ rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.2.linux-arm64.tar.gz
$ export PATH=$PATH:/usr/local/go/bin
```

---

## Visual Studio Code
- [VS Code Insiders](https://code.visualstudio.com/insiders/)
```bash
$ sudo dnf install -y code-insiders
```
or
```bash
$ cd Downloads && ls
$ sudo dnf install (code-insiders).rpm && sudo rm (code-insiders).rpm
```

---

## Podman Desktop
```bash
$ flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
$ flatpak install --user flathub io.podman_desktop.PodmanDesktop
$ flatpak update --user io.podman_desktop.PodmanDesktop
$ flatpak run io.podman_desktop.PodmanDesktop
```

---

## Kubernetes (K8s)
Install Kubernetes tools:
```bash
$ cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
$ sudo yum install -y kubelet kubeadm kubectl cri-tools kubernetes-cni --disableexcludes=kubernetes
$ systemctl enable --now kubelet
$ go install sigs.k8s.io/kind@v0.27.0
$ sudo mv ~/go/bin/kind /bin
$ sudo rm -r ~/go
$ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
$ sudo rpm -Uvh minikube-latest.x86_64.rpm
```

---

## IT Tools
Run IT tools on port 8080:
```bash
$ podman run -d --name it-tools --restart unless-stopped -p 8080:80 corentinth/it-tools:latest
```

---

## Grafana
Run Grafana on port 3000:
```bash
$ sudo systemctl daemon-reload
$ sudo systemctl start grafana-server
$ sudo systemctl status grafana-server
$ sudo systemctl enable grafana-server.service
```

---

## Virtual Machine (VM) Creation
- Use VMM or Cockpit to create VMs in the QEMU domain (not recommended for production).
- Supported platforms:
    - VMware Fusion (Mac)
    - Oracle VirtualBox (supports VHDX and VMX)
    - Cockpit: `localhost:9090` (stored locally) or `HOST-IP:9090` (unsecure - lacks TLS)
    - VMware Workstation Pro (requires vSphere or vCenter ESXi for netboot)

---

## Ubuntu 24.04
### AMD
- [Download Ubuntu Desktop](https://ubuntu.com/download/desktop/thank-you?version=24.04.2&architecture=amd64&lts=true)
```bash
$ sudo mkdir ~/vm/iso
$ sudo mv ~/Downloads/ubuntu-24.04.2-desktop-amd64.iso ~/vm/iso
```

### ARM
- [Download Ubuntu Server for ARM](https://ubuntu.com/download/server/arm)
```bash
$ sudo mkdir ~/vm/iso
$ sudo mv ~/Downloads/ubuntu-24.04.2-desktop-amd64.iso ~/vm/iso
$ install desktop gui ie-kubuntu
```

---

## ROS2 (QT)
Install ROS2:
```bash
$ locale  # check for UTF-8
$ sudo apt update && sudo apt install locales
$ sudo locale-gen en_US en_US.UTF-8
$ sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
$ export LANG=en_US.UTF-8
$ locale  # verify settings
$ sudo apt install software-properties-common
$ sudo add-apt-repository universe
$ sudo apt update && sudo apt install curl -y
$ sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
$ echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
$ sudo apt update && sudo apt install ros-dev-tools
$ sudo apt update -y && sudo apt upgrade -y
$ sudo apt install ros-jazzy-desktop
$ source /opt/ros/jazzy/setup.bash
```

---

## Gazebo Harmonic
Install Gazebo Harmonic:
```bash
$ sudo apt-get update && sudo apt-get install lsb-release gnupg
$ sudo curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
$ echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
$ sudo apt-get update && sudo apt-get install gz-harmonic
```

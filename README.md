# RHEL9
/ , /home , /tmp , /var , /var/tmp , /var/log , /var/log/audit , /boot  

# Cockpit allows for Ubuntu Focal (20.04) vm creation that can pair Ros Noetic with Gazebo
# RHEL does not support VM qemu domain and is discouraged for production environments
$ systemctl enable --now cockpit.socket \
$ sudo dnf install cockpit-machines

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

# Ubuntu 24.04 
# ROS2 and Gazebo (Gazebo not currently supported on linux9)  
https://ubuntu.com/download/desktop/thank-you?version=24.04.2&architecture=amd64&lts=true \
$ sudo mkdir ~/iso \
$ sudo mv ~/Downloads/ubuntu-24.04.2-desktop-amd64.iso ~/iso     
# VM creation here (Start user interface for creation, in case default storage may need to be changed)
# Auto-install
<br>
<br>
# Kubernetes (For Ubuntu to avoid disabling Selinux)
Kubectl, kind, minikube, kubeadm 




 

  

 

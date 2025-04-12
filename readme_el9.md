## RHEL9 [Docs](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/)

## Quickstart
For a quickstart, You can copy and paste 
```bash
$ curl -fsSL https://raw.githubusercontent.com/JesseDev3/RHEL9/refs/heads/main/setup.sh -o setup.sh
$ sudo bash setup.sh
```
---

## Important Directories
- `/`, `/home`, `/tmp`, `/var`, `/var/tmp`, `/var/log`, `/var/log/audit`, `/boot`
- Always shred or clean drives and motherboards upon disposal to prevent credential harvesting.

---

## [Cockpit](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/managing_systems_using_the_rhel_9_web_console/index)
Cockpit supports Ubuntu Focal (20.04), ROS-Noetic, and Gazebo (Gazebo not supported on RHEL9).
```bash
$ systemctl enable --now cockpit.socket
$ sudo dnf install -y cockpit-machines
```

---

## [VPN Configuration Guide](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-a-vpn-connection_configuring-and-managing-networking)
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

## [VS Code - Insiders](https://code.visualstudio.com/insiders/)
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

## Database Connection
[GoldenGate Free](https://docs.oracle.com/en/middleware/goldengate/studio-free/23/uggsf/get-started.html#GUID-42B5358A-A84E-45D2-90CC-D55A474B3678)
```bash
$ podman login container-registry.oracle.com
$ podman pull container-registry.oracle.com/goldengate/goldengate-studio-free:latest
$ docker run -p 80:80 -p 443:443 container-registry.oracle.com/goldengate/goldengate-studio-free:latest
```
Oracle DB 23ai

---

# [RHEL9 Docs](https://docs.oracle.com/en/operating-systems/oracle-linux/9/)

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

## [VPN Config Guide](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-a-vpn-connection_configuring-and-managing-networking)
- Cockpit supports WireGuard VPN (requires FIPS disabled). For production, use Libreswan (Openswan IPsec fork). 

---

## [Virtualization Setup](https://docs.oracle.com/en/operating-systems/oracle-linux/kvm-user/kvm-InstallingVirtualizationPackages.html)
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

## [Install Go](https://go.dev/doc/install) 
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

## [Podman Desktop](https://podman-desktop.io/docs/installation)
```bash
$ flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
$ flatpak install --user flathub io.podman_desktop.PodmanDesktop
$ flatpak update --user io.podman_desktop.PodmanDesktop
$ flatpak run io.podman_desktop.PodmanDesktop
```

---

## [Kubernetes (K8s)](https://kubernetes.io/docs/tasks/tools/)
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

## [Virtual Machine Creation](https://docs.oracle.com/en/operating-systems/oracle-linux/cockpit/cockpit-kvm.html)
- VMware Fusion (Mac)
- Oracle VirtualBox (supports VHDX and VMX)
- Cockpit: `localhost:9090` (stored locally) or `HOST-IP:9090` (unsecure - lacks TLS)
- VMware Workstation Pro (requires vSphere or vCenter ESXi for netboot)

---

## [Setting up HA Clustering](https://docs.oracle.com/en/operating-systems/oracle-linux/9/availability/index.html)

Before continuing, would you like to set up High Availability (HA) Clustering? This setup involves configuring Corosync and Pacemaker.

### Install Required Packages
Enable necessary repositories and install HA packages:
```bash
$ sudo dnf config-manager --enable ol9_appstream ol9_baseos_latest ol9_addons
$ sudo dnf install pcs pacemaker resource-agents fence-agents-all
```

### Configure Firewall
If `firewalld` is running, add the HA service to each node. A script can be used to auto-check `firewalld` status before proceeding.

#### Required Ports
- **TCP Ports**:
    - `2224` (pcs daemon)
    - `3121` (Pacemaker Remote nodes)
    - `21064` (DLM resources)
- **UDP Ports**:
    - `5405` (Corosync clustering)
    - `5404` (Corosync multicast, if configured)

Add the HA service to the firewall:
```bash
$ sudo firewall-cmd --permanent --add-service=high-availability
$ sudo firewall-cmd --add-service=high-availability
```

### Enable and Start Services
Set a password for the `hacluster` user and enable the `pcsd` service:
```bash
$ sudo passwd hacluster
$ sudo systemctl enable --now pcsd.service
```

For more details, refer to the [Create an HA Cluster on OCI](https://docs.oracle.com/en-us/iaas/oracle-linux/ha-clustering/ha-clustering-overview.htm) guide.


## [Database Connection](https://docs.oracle.com/en/operating-systems/oracle-linux/asmlib/asmlib-Preface.html#preface)

### ASMLIB v3
- **ULN Recommended**: Keep the system updated by subscribing to the [Oracle Linux Network (ULN)](https://linux.oracle.com).
- **Steps to Subscribe**:
    1. Sign in or register [here](https://linux.oracle.com).
    2. Navigate to the **Systems** tab > **Registered Systems** > Select the system link.
    3. On the **System Details** page, go to **Manage Subscriptions**.
    4. On the **System Summary** page:
         - Select **ASMLIB** and **Oracle Linux Addons** from the available channels.
         - Click the right arrow to subscribe.
         - Save the subscriptions.

### Manual Patches and Updates
If not subscribed to ULN, download packages manually:
- [ASMLIB v8 Downloads](https://www.oracle.com/linux/downloads/linux-asmlib-v8-downloads.html)
- [ASMLIB v9 Downloads](https://www.oracle.com/linux/downloads/linux-asmlib-v9-downloads.html)

### Installation Commands
Install ASMLIB support:
```bash
$ sudo dnf install oracleasm-support oracleasmlib
```

---

### Driver Requirements
- **UEK R7**: No driver required.
- **OL8 + RHCK**: Install the driver:
    ```bash
    $ sudo dnf install kmod-redhat-oracleasm
    ```
- **OL9 + RHCK**: No driver required, but `io_uring` must be enabled.

### Enable `io_uring`
Add the following line to `/etc/sysctl.conf`:
```bash
kernel.io_uring_disabled = 0
```

Apply the changes:
```bash
$ sudo sysctl -p
$ sudo dnf update -y
```


[GoldenGate Free](https://docs.oracle.com/en/middleware/goldengate/studio-free/23/uggsf/get-started.html#GUID-42B5358A-A84E-45D2-90CC-D55A474B3678)
```bash
$ podman login container-registry.oracle.com
$ podman pull container-registry.oracle.com/goldengate/goldengate-studio-free:latest
$ docker run -p 80:80 -p 443:443 container-registry.oracle.com/goldengate/goldengate-studio-free:latest

```
Oracle DB 23ai

---


sudo yum update -y

sudo yum install -y cockpit-machines qemu-kvm libvirt virt-install virt-viewer
for drv in qemu network nodedev nwfilter secret storage interface; do systemctl start virt${drv}d{,-ro,-admin}.socket; done 
virt-host-validate

sudo yum install -y nodejs
sudo yum module enable -y nodejs:22 && sudo dnf update -y
sudo npm install -g npm@11.3.0 yo generator-hottowel express gulp-cli mocha corepack
curl -fsSL https://rpm.nodesource.com/setup_23.x -o nodesource_setup.sh 
sudo bash nodesource_setup.sh 

systemctl enable --now cockpit.socket
firefox localhost:9090 

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/repodata/repomd.xml.key
EOF
sudo yum install -y kubelet kubeadm kubectl
systemctl enable --now kubelet

ARCH=$(uname -m)
case "$ARCH" in
  x86_64)
    URL="https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-amd64"
    ;;
  aarch64)
    URL="https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-arm64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac
curl -Lo ./kind "$URL"
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

Arch=$(uname -m)
case "$ARCH" in
    x86_64)
        URL="https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm"
        ;;
    aarch64)
        URL="https://storage.googleapis.com/minikube/releases/latest/minikube-latest.aarch64.rpm"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac
curl -LO "$URL"
sudo rpm -Uvh minikube-latest.x86_64.rpm && sudo rm -r minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.aarch64.rpm && sudo rm -r minikube-latest.aarch64.rpm

sudo yum install -y podman podman-docker container-tools
sudo systemctl enable --now podman.socket podman.service
sudo systemctl start podman.socket podman.service
podman pull docker.io/coretinth/it-tools:latest
podman run -d -p 8080:80 --name it-tools -it corentinth/it-tools
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y --user flathub io.podman_desktop.PodmanDesktop
gnome-terminal -- bash -c "flatpak run io.podman_desktop.PodmanDesktop"

go version 
sudo curl -LO https://go.dev/dl/go1.24.2.linux-amd64.tar.gz | tar xz -c /usr/local/go
export PATH=$PATH:/usr/local/go/bin | source $HOME/.profile
go install github.com/pressly/goose/v3/cmd/goose@latest
# go get -u gorm.io/gorm github.com/gin-gonic/gin (go get not supported outside of module)
# go get -u github.com/volatiletech/authboss/v3
sudo mv ~/go/bin/kind /bin

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
sudo yum install -y code-insiders

systemctl enable --now grafana-server.service
firefox localhost:8080 

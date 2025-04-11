# Best Practice
sudo yum update -y

# Java
sudo yum install -y nodejs npm java-17-openjdk java-17-openjdk-devel
# sudo alternatives --config java 
sudo yum module enable -y nodejs:22 && sudo dnf update -y
sudo npm install -g npm@11.3.0 yo generator-hottowel express gulp-cli mocha corepack
curl -fsSL https://rpm.nodesource.com/setup_23.x -o nodesource_setup.sh 
sudo bash nodesource_setup.sh 

# Virtualization 
sudo yum install -y cockpit-machines qemu-kvm libvirt virt-install virt-viewer
for drv in qemu network nodedev nwfilter secret storage interface; do systemctl start virt${drv}d{,-ro,-admin}.socket; done 
virt-host-validate

# Cockpit
systemctl enable --now cockpit.socket
# Create /etc/cockpit/cockpit.conf file first
sudo mk -f /etc/cockpit/cockpit1.conf
# Create /etc/issue.cockpit (personally prefer /etc/cockpit/issue.cockpit so both are in same dir)
cat <<EOF | sudo tee /etc/cockpit/issue1.cockpit
Welcome to Your Server Dashboard!
This is a test server for the IT Tools project.
EOF
# Note: The cockpit.conf file is created by the cockpit package and should not be modified directly.
# Instead, create a new file in the /etc/cockpit directory with the desired configuration.
cat <<EOF | sudo tee /etc/cockpit/cockpit1.conf
[Session]
Banner=/etc/issue.cockpit
EOF
sudo systemctl try-restart cockpit


# Kubernetes
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
# Kind
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
# Minikube
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

# Podman 
sudo yum install -y cockpit-podman container-toolspodman podman-docker 
sudo systemctl enable --now podman.socket podman.service
sudo systemctl start podman.socket podman.service
podman pull docker.io/coretinth/it-tools:latest
podman run -d -p 8080:80 --name it-tools -it corentinth/it-tools
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y --user flathub io.podman_desktop.PodmanDesktop
gnome-terminal -- bash -c "flatpak run io.podman_desktop.PodmanDesktop"

# Go (Arch dependant linux/amd64 or linux/arm64)
if ! command -v go &> /dev/null; then
  echo "Go is not installed. Installing..."
  sudo yum install -y golang
else
  echo "Go is already installed. Version: $(go version)"
fi
# Go install can be used to install other versions of Go.
sudo curl -LO https://go.dev/dl/go1.24.2.linux-amd64.tar.gz | tar xz -c /usr/local/go
export PATH=$PATH:/usr/local/go/bin | source $HOME/.profile
go install github.com/pressly/goose/v3/cmd/goose@latest
# (go get not supported outside of module)
# go get -u gorm.io/gorm github.com/gin-gonic/gin 
# go get -u github.com/volatiletech/authboss/v3

# VS Code 
# Enable the Microsoft repository
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
# Prompt the user to choose between VS Code and VS Code Insiders
echo "Choose the version of Visual Studio Code to install:"
echo "1) Visual Studio Code (Stable)"
echo "2) Visual Studio Code Insiders"
echo "3) Skip Install"
read -p "Enter your choice (1 or 2): " choice

case $choice in
  1)
    echo "Installing Visual Studio Code (Stable)..."
    sudo yum install -y code
    ;;
  2)
    echo "Installing Visual Studio Code Insiders..."
    sudo yum install -y code-insiders
    ;;
  *)
    echo "Skipping."
    exit 1
    ;;
esac

# Launch Browser Portals
systemctl enable --now grafana-server.service
firefox localhost:9090 localhost:8080 

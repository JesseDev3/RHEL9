# Best Practice
###### Using Yum repository for backwards compatability ######
sudo yum update -y

# Tools
sudo yum install -y NetworkManager-tui nm-connection-editor yum-utils goprofng drgn corelens lynx

# Node.js
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"
# Download and install Node.js:
nvm install 22
# Verify the Node.js version:
node -v # Should print "v22.14.0".
nvm current # Should print "v22.14.0".
# Verify npm version:
npm -v # Should print "10.9.2".

# Java/NPM/PHP
sudo yum install -y nodejs npm java-17-openjdk java-17-openjdk-devel php
# sudo alternatives --config java 
sudo yum module enable -y nodejs:22 && sudo yum update -y
npm install -g npm@11.3.0 @angular/cli gulp-cli appcenter-cli yo generator-hottowel express mocha corepack axios
curl -fsSL https://rpm.nodesource.com/setup_23.x -o nodesource_setup.sh 
sudo bash nodesource_setup.sh 
# run following command in new bash window
appcenter login

# Terraform
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

# Virtualization 
# Using the curl cmd approach from the quickstart guide allows you to 
# bypass putting in your password 6x
sudo yum install -y cockpit-machines qemu-kvm libvirt virt-install virt-viewer dotnet-sdk-9.0
for drv in qemu network nodedev nwfilter secret storage interface; do systemctl start virt${drv}d{,-ro,-admin}.socket; done 
virt-host-validate

# Cockpit
systemctl enable --now cockpit.socket

# Check if /etc/cockpit/cockpit.conf exists, create it if not
# Touch only creates a new file if it doesn't already exist and doesn't modify if it does
  sudo touch /etc/cockpit/cockpit.conf

# Create /etc/issue.cockpit (prefer /etc/cockpit/issue.cockpit so both are in the same dir)
cat <<EOF | sudo tee /etc/cockpit/issue.cockpit
Welcome to Your Server Dashboard!
$ sudo nano (or vi) /etc/cockpit/issue.cockpit
for custom display notifications to users
does not compile
EOF

# Edit /etc/cockpit/cockpit.conf to set the banner
cat <<EOF | sudo tee /etc/cockpit/cockpit.conf
[Session]
Banner=/etc/cockpit/issue.cockpit
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
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
sudo yum install -y kubelet kubeadm kubectl cri-tools kubernetes-cni --disableexcludes=kubernetes
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
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        URL="https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm"
        ;;
    aarch64)
        URL="https://storage.googleapis.com/minikube/releases/latest/minikube-latest.aarch64.rpm"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 0
        ;;
esac

# Download and install the appropriate package
curl -LO "$URL"
RPM_FILE=$(basename "$URL")
sudo rpm -Uvh "$RPM_FILE" && rm -f "$RPM_FILE"

# Podman 
sudo yum install -y cockpit-podman container-tools podman podman-docker 
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y --user flathub io.podman_desktop.PodmanDesktop
gnome-terminal -- -c flatpak run io.podman_desktop.PodmanDesktop
xterm -e flatpak run io.podman_desktop.PodmanDesktop || \
echo "Failed to launch Podman Desktop. Please run 'flatpak run io.podman_desktop.PodmanDesktop' manually."

# Go (Arch dependant linux/amd64 or linux/arm64)
# Go install can be used to install other versions of Go.
echo "Proceeding with Go installation..."
sudo yum install -y golang

# Verify Go installation and PATH configuration
if ! command -v go &> /dev/null; then
  echo "Error: Go is not installed or not in PATH. Please check the installation."
fi
echo "Go environment is properly set up."
echo "$(go version)"
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
read -p "Enter your choice (1/2/3): " choice
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
    exit 0
    ;;
esac

# CLIs
# GCLI
sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
sudo yum install -y google-cloud-cli
gcloud init

# Launch Browser Portals
podman pull docker.io/coretinth/it-tools:latest
podman run -d -p 8080:80 --name it-tools -it docker.io/corentinth/it-tools
systemctl enable --now grafana-server.service
echo "Browser: localhost:9090 localhost:8080"

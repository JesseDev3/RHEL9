You can copy and paste 
```bash
$ sudo apt install -y curl
$ curl -fsSL https://raw.githubusercontent.com/JesseDev3/RHEL9/refs/heads/main/ub_setup.sh -o setup.sh
$ sudo bash setup.sh
```
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

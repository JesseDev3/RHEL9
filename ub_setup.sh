#!/bin/bash

# Update and upgrade system
sudo apt update -y && sudo apt upgrade -y

# Ubuntu 24.04 ISO setup for AMD
setup_amd_iso() {
    echo "Setting up Ubuntu 24.04 ISO for AMD..."
    sudo mkdir -p ~/vm/iso
    sudo mv ~/Downloads/ubuntu-24.04.2-desktop-amd64.iso ~/vm/iso
}

# Ubuntu 24.04 ISO setup for ARM
setup_arm_iso() {
    echo "Setting up Ubuntu 24.04 ISO for ARM..."
    sudo mkdir -p ~/vm/iso
    sudo mv ~/Downloads/ubuntu-24.04.2-desktop-amd64.iso ~/vm/iso
    echo "Install desktop GUI (e.g., Kubuntu) manually."
}

# Install ROS2
install_ros2() {
    echo "Installing ROS2..."
    locale  # check for UTF-8
    sudo apt update && sudo apt install -y locales
    sudo locale-gen en_US en_US.UTF-8
    sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8
    locale  # verify settings
    sudo apt install -y software-properties-common
    sudo add-apt-repository universe
    sudo apt update && sudo apt install -y curl
    sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
    sudo apt update && sudo apt install -y ros-dev-tools
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install -y ros-jazzy-desktop
    source /opt/ros/jazzy/setup.bash
}

# Install Gazebo Harmonic
install_gazebo_harmonic() {
    echo "Installing Gazebo Harmonic..."
    sudo apt-get update && sudo apt-get install -y lsb-release gnupg
    sudo curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
    sudo apt-get update && sudo apt-get install -y gz-harmonic
}

# Main menu
echo "Select an option:"
echo "1. Setup Ubuntu 24.04 ISO for AMD"
echo "2. Setup Ubuntu 24.04 ISO for ARM"
echo "3. Install ROS2"
echo "4. Install Gazebo Harmonic"
echo "5. Exit"
read -p "Enter your choice: " choice

case $choice in
    1) setup_amd_iso ;;
    2) setup_arm_iso ;;
    3) install_ros2 ;;
    4) install_gazebo_harmonic ;;
    5) echo "Exiting..."; exit 0 ;;
    *) echo "Invalid choice. Exiting..."; exit 1 ;;
esac

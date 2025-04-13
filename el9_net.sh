# This script is designed to assist with network setup, VPN configuration, and load balancing on EL9 systems.
# It provides options for configuring networking on servers with or without a GUI, setting up VPNs, and enabling load balancing with HAProxy and Keepalived.    
echo "Choose a setup option:"
echo "1) Network Tools Setup"
echo "2) Configure VPN"
echo "3) Load Balancing"
read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        echo "Network Setup selected."
        echo "Would you like to configure networking for:"
        echo "1) Servers Without a GUI"
        echo "2) Servers With a GUI"
        read -p "Enter your choice (1-2): " net_choice
        if [ "$net_choice" -eq 1 ]; then
            echo "Installing NetworkManager-tui..."
            sudo dnf install -y NetworkManager-tui
            sudo nmtui
        elif [ "$net_choice" -eq 2 ]; then
            echo "Installing nm-connection-editor..."
            sudo dnf install -y nm-connection-editor
            sudo nm-connection-editor
        else
            echo "Invalid choice."
        fi
        ;;
    2)
        echo "Configure VPN selected."
        echo "Choose a VPN option:"
        echo "1) WireGuard"
        echo "2) Libreswan"
        read -p "Enter your choice (1-2): " vpn_choice
        if [ "$vpn_choice" -eq 1 ]; then
            echo "Visit https://www.wireguard.com for setup instructions."
        elif [ "$vpn_choice" -eq 2 ]; then
            echo "Visit https://libreswan.org for setup instructions."
        else
            echo "Invalid choice."
        fi
        ;;
    3)
        echo "Load Balancing selected."
        echo "Installing HAProxy and Keepalived..."
        sudo dnf install -y haproxy keepalived
        echo "Configuring HAProxy and Keepalived..."
        echo "Edit the following configuration files as needed:"
        echo "- /etc/haproxy/haproxy.cfg"
        echo "- /etc/keepalived/keepalived.conf"
        echo "1) Edit /etc/haproxy/haproxy.cfg"
        echo "2) Edit /etc/keepalived/keepalived.conf"
        echo "3) Continue"
        read -p "Enter your choice (1-3): " config_choice
        case $config_choice in
            1)
            echo "Opening /etc/haproxy/haproxy.cfg..."
            sudo nano /etc/haproxy/haproxy.cfg
            ;;
            2)
            echo "Opening /etc/keepalived/keepalived.conf..."
            sudo nano /etc/keepalived/keepalived.conf
            ;;
            3*)
            echo "Continuing..."
            ;;
        esac
        echo "Enabling traffic on port 80..."
        sudo firewall-cmd --zone=zone --add-port=80/tcp
        sudo firewall-cmd --permanent --zone=zone --add-port=80/tcp
        echo "Starting and enabling HAProxy..."
        sudo systemctl enable --now haproxy
        echo "Enabling IP forwarding..."
        sudo sed -i '/net.ipv4.ip_forward/s/^#//g' /etc/sysctl.conf
        sudo sysctl -p
        ;;
    *)
        echo "Invalid choice."
        ;;
esac


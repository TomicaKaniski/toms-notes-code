### Raspberry Pi's initial configuration with raspi-config

# raspi-config script is located in /usr/bin/raspi-config
# settings (some of them) are located in /boot/config.txt
 
# update the raspi-config script (or you can use 'sudo raspi-config nonint do_update') and vim... is nice to have
sudo apt update
sudo apt install -y raspi-config vim
 
# set static ip address (configure in '/etc/dhcpcd.conf', can check interfaces with 'ip link' - can be done nicer, but... :))
echo 'interface eth0' | sudo tee -a /etc/dhcpcd.conf
echo 'static ip_address=192.168.12.101/24' | sudo tee -a /etc/dhcpcd.conf
echo 'static routers=192.168.12.1' | sudo tee -a /etc/dhcpcd.conf
echo 'static domain_name_servers=192.168.12.1' | sudo tee -a /etc/dhcpcd.conf
 
# set password (for user 'pi')
echo "pi:MyExtraSecretPass#123" | sudo chpasswd
 
# set boot options to my liking
sudo raspi-config nonint do_boot_behaviour B1
sudo raspi-config nonint do_boot_wait 1
 
# set/disable unnecessary interfaces
sudo raspi-config nonint do_camera 1
sudo raspi-config nonint do_ssh 0
sudo raspi-config nonint do_vnc 1
sudo raspi-config nonint do_spi 1
sudo raspi-config nonint do_i2c 1
sudo raspi-config nonint do_serial 1
sudo raspi-config nonint do_onewire 1
sudo raspi-config nonint do_rgpio 1
sudo raspi-config nonint do_memory_split 16
sudo raspi-config nonint do_expand_rootfs
sudo raspi-config nonint do_wifi_country HR
sudo raspi-config nonint do_change_timezone Europe/Zagreb
 
# upgrade packages and set hostname
sudo apt upgrade -y
sudo raspi-config nonint do_hostname pimaster
sudo reboot
 
# ssh back into your pimaster
ssh pi@192.168.12.101

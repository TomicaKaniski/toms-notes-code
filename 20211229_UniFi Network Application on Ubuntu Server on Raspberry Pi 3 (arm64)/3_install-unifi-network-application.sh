### installs UniFi Network Application

# install prerequisite packages
apt-get update && apt-get install ca-certificates apt-transport-https

# add Ubiquity repo (for ARM)
echo 'deb [arch=armhf] https://www.ui.com/downloads/unifi/debian stable ubiquiti' | tee /etc/apt/sources.list.d/00-ubnt-unifi.list

# download and install GPG keys
wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg

# prevent updating OpenJDK
apt-mark hold openjdk-11-*

# update repos and install UniFi Network Application
apt-get update && apt-get install unifi -y

### install (my) workflow prerequisites on self-runner machine
sudo su -

## install Azure CLI (https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt)
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

## install PowerShell  (https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.2#installation-via-direct-download)
wget -q "https://github.com/PowerShell/PowerShell/releases/download/v7.2.6/powershell-lts_7.2.6-1.deb_amd64.deb" && dpkg -i powershell-lts_7.2.6-1.deb_amd64.deb

## install Bicep
az bicep install

## install other useful things
apt install apt-utils cron vim -y

## install Docker (https://cloudcone.com/docs/article/how-to-install-docker-on-ubuntu-22-04-20-04/)
# install prerequisites
apt install apt-transport-https curl gnupg-agent ca-certificates software-properties-common -y

# add GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# add repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" -y

# install docker
apt install docker-ce docker-ce-cli containerd.io -y

# create docker group
newgrp docker
exit

# add current user (tomica) to docker group
sudo usermod -aG docker $USER

# configure Docker autostart
sudo systemctl enable docker
sudo systemctl restart docker
sudo systemctl status docker

## install Az module for PowerShell (https://learn.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-9.0.0)
pwsh
Install-Module Az -Repository PSGallery -Confirm:$false -Force
exit


### configure ./run.sh (GitHub runner application) to start automatically
crontab -e

# add the following line (uncommented, of course; and check if the path is right!):
# @reboot /home/tomica/actions-runner/run.sh

sudo reboot

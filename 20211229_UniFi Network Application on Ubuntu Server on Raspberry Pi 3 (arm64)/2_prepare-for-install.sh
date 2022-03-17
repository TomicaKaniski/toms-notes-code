### installs MongoDB prerequisite for UniFi Network Application

sudo su -
cd ~
 
wget http://launchpadlibrarian.net/555133932/libssl1.0.0_1.0.2n-1ubuntu5.7_arm64.deb
dpkg -i libssl1.0.0_1.0.2n-1ubuntu5.7_arm64.deb
 
wget https://repo.mongodb.org/apt/ubuntu/dists/xenial/mongodb-org/3.6/multiverse/binary-arm64/mongodb-org-server_3.6.23_arm64.deb
dpkg -i mongodb-org-server_3.6.23_arm64.deb

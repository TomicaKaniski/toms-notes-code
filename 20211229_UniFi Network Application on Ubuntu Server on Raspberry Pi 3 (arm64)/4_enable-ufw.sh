### enables the UFW ("uncomplicated firewall") to solve WARN Unable to load properties from '/usr/lib/unifi/data/system.properties'

# check if UFW is enabled already (probably not)
ufw status

# set exceptions
ufw allow 22/tcp
ufw allow 8080/tcp
ufw allow 8443/tcp

# enable UFW and recheck
ufw enable
ufw status

# restart unifi service
service unifi restart
service unifi status

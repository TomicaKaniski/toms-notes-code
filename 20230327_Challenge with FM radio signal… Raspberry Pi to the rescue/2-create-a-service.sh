### create the service file /etc/systemd/system/runRadio.service:
sudo nano /etc/systemd/system/runRadio.service

### inside the file, insert something like this:
[Unit]
Description=runRadio

[Service]
User=tomica
Environment="DISPLAY=:0"
ExecStartPre=/bin/sleep 30
ExecStart=/usr/bin/vlc -I dummy "https://audio.radio-banovina.hr:9998/stream"
WorkingDirectory=/home/tomica
Restart=always

[Install]
WantedBy=multi-user.target

### to register this service, I'm using standard commands:
sudo systemctl enable runRadio.service
sudo systemctl start runRadio.service
sudo systemctl status runRadio.service

### tips:
### - VLC shouldn't start with 'root', so this is why I'm using a user 'tomica'
### - -I dummy is something I learned during troubleshooting - it doesn't work (as a service) without specifying the correct (I)nterface!
### -  also, I'm using sleep 30 to make sure everything is up before starting a player (could be nicer, but... works!)

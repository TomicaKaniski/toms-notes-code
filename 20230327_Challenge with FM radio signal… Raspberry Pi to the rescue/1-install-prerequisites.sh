### check that you have your radio station's stream address (the right one)!
### i'll use https://audio.radio-banovina.hr:9998/stream, not https://www.radio-banovina.hr/uzivo/
 
# install all updates:
sudo apt update && sudo apt dist-upgrade -y
 
# install VLC (if not already):
sudo apt install vlc -y
 
# when I tried to play the stream, I got an error stating that the TLS certificate is not trusted
# so, I downloaded and copied CA (AlphaSSL CA - SHA256 - G2) and Root CA (GlobalSign Root CA) certificates into the /usr/local/share/ca-certificates/:
sudo cp *.crt /usr/local/share/ca-certificates/*
 
# and updated the certificates in use:
sudo update-ca-certificates
 
# that took care of the TLS error and stream could finally run:
vlc https://audio.radio-banovina.hr:9998/stream

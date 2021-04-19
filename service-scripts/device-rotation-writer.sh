# purpose: started by systemd
# writes latest device rotation updates to file /dev/orientation.txt

monitor-sensor | sudo tee /dev/orientation.txt

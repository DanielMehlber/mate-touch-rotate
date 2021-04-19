# purpose: started by systemd
# listens for changes in orientation file at /dev/orientation.txt and applies them

inotifywait -e write /dev/orientation.txt | while read LINE
do
  echo "it works like this $LINE" | sudo tee -a /dev/orientationslog.txt
done

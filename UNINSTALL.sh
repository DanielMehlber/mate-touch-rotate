source $PWD/env.sh

# stop service
touch-screen-rotator-stop

# disable service
sudo systemctl disable device-orientation-updater
sudo systemctl disable touch-screen-rotator

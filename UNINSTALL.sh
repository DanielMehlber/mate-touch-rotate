source $PWD/env.sh

# stop service
echo "Stopping service..."
touch-screen-rotator-stop

# disable service
echo "Disabling service..."
sudo systemctl disable device-orientation-updater
systemctl --user disable touch-screen-rotator

# remove files
echo "Removing files..."
sudo rm /etc/systemd/system/device-orientation-updater.service
sudo rm /etc/systemd/user/touch-screen-rotator.service

echo "Done."



echo "Installing mate-touch-rotator to /opt/mate-touch-rotate/"
sudo mkdir "/opt/mate-touch-rotate"
# move script file to installation directory
echo "Copying files to installation directory..."
sudo cp $PWD/start-touch-rotator.sh $PWD/stop-touch-rotator.sh $PWD/service-scripts/device-rotation-writer.sh $PWD/service-scripts/device-rotation-listener.sh $PWD/env.sh $PWD/UNINSTALL.sh "/opt/mate-touch-rotate/"

# move service files to systemd directory
echo "Copying files to systemd user directory..."
sudo cp $PWD/services/touch-screen-rotator.service /etc/systemd/user
sudo cp $PWD/services/device-orientation-updater.service /etc/systemd/system

# enable systemd services
echo "Enabling service..."
systemctl --user enable touch-screen-rotator.service
sudo systemctl enable device-orientation-updater.service

# install inotifywait
sudo apt install inotify-tools

source $PWD/env.sh

echo "Starting service..."
touch-screen-rotator-start

echo "Done."


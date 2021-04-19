
echo "Installing mate-touch-rotator to /opt/mate-touch-rotate/"
sudo mkdir "/opt/mate-touch-rotate"
# move script file to installation directory
echo "Copying files to installation directory"
sudo cp $PWD/start-touch-rotator.sh $PWD/stop-touch-rotator.sh $PWD/service-scripts/device-rotation-writer.sh $PWD/service-scripts/device-rotation-listener.sh $PWD/env.sh $PWD/UNINSTALL.sh "/opt/mate-touch-rotate/"

# move service files to systemd directory
echo "Copying files to systemd directory"
sudo cp $PWD/services/touch-screen-rotator.service $PWD/services/device-orientation-updater.service /etc/systemd/system

# enable systemd services
sudo systemctl enable touch-screen-rotator
sudo systemctl enable device-orientation-updater

source $PWD/env.sh

touch-screen-rotator-start


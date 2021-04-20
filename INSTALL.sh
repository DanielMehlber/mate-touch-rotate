

echo "Installing mate-touch-rotator to /opt/mate-touch-rotate/"

echo "Checking input devices..."
devices=$(xinput --list)
# check if touchscreen name ist defined
if [ -z "$1" ]; then
    echo "Error: Please pass the touchscreen's name as an argument"
    echo "Like this: INSTALL.sh [TOUCHSCREEN_NAME] [TOUCHPAD_NAME]"
    echo "Devices are: (according to 'xinput --list')"
    echo "$devices"
    echo "Or just 'None'"
    return
fi

# check if touchpad name is defined
if [ -z "$2" ]; then
    echo "Error: Please also pass the touchpad's name as an argument"
    echo "Like this: INSTALL.sh $1 [TOUCHPAD_NAME]"
    echo "Devices are: (according to 'xinput --list')"
    echo "$devices"
    echo "Or just 'None'"
    return
fi


sudo mkdir "/opt/mate-touch-rotate"
# move script file to installation directory
echo "Copying files to installation directory..."
sudo cp $PWD/start-touch-rotator.sh $PWD/stop-touch-rotator.sh $PWD/service-scripts/device-rotation-writer.sh $PWD/service-scripts/device-rotation-listener.sh $PWD/env.sh $PWD/UNINSTALL.sh "/opt/mate-touch-rotate/"

# configure env.sh
echo "Configurating env.sh..."
echo "TOUCHSCREEN=$1" | sudo tee -a /opt/mate-touch-rotate/env.sh
echo "TOUCHPAD=$2" | sudo tee -a /opt/mate-touch-rotate/env.sh

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


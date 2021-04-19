# mate-touch-rotate
Systemd service to identify orientation of device in order to rotate display, touchpad and touchscreen accordingly. Written for Ubuntu MATE or other distros not supporting this feature natively.

## Install
Just run INSTALL.sh like this:

```
source ./INSTALL.sh [TOUCHSCREEN_NAME] [TOUCHPAD NAME]
```

You can find out the name of your devices by using

```
xinput --list
```

### What is the installation doing
* necessary files will be copies into /opt/mate-touch-rotate (privileges needed)
* set-up of systemd services (privileges needed)
* start of services (privileges needed)

Your screen should rotate after installation.


## Uninstall 
Just run UNINSTALL.sh
* stops systemd services (privileges needed)
* disables systemd services (privileges needed)

Your screen should not rotate after installation.

## Under the hood
2 systemd services will be set up:
* One checking the device's orientation and writing it to /dev/orientation.txt (device-orientation-updater)
* The other waiting for changes in /dev/orientations.txt and then executing the rotation (touch-screen-rotator)

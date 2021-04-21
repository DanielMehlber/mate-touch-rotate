# mate-touch-rotate
Systemd service to identify orientation of device in order to rotate display, touchpad and touchscreen accordingly. Written for Ubuntu MATE or other distros not supporting this feature natively.

## Install
Just run INSTALL.sh like this:

```
source ./INSTALL.sh [DEVICES]
```

You can find out the names or ids of your devices by using

```
xinput --list
```
These could be touchscreens, touchpads, pens, erasers (sometimes addressed by a different device).
Pass their full name or id.

### What the installation is doing
* necessary files will be copies into /opt/mate-touch-rotate (privileges needed)
* set-up of systemd services (privileges needed)
* start of services (privileges needed)

Your screen should rotate after installation.


## Uninstall 
Just run UNINSTALL.sh
* stops systemd services (privileges needed)
* disables systemd services (privileges needed)
* removes files in systemd

Your screen should not rotate after installation.

## Change devices or configure service
To change the device names you need to reinstall.
* uninstall
* install with updated device names

## Under the hood
2 systemd services will be set up:
* One system service checking the device's orientation and writing it to /dev/orientation.txt (device-orientation-updater)
* The other's a user service waiting for changes in /dev/orientations.txt and then executing the rotation (touch-screen-rotator)

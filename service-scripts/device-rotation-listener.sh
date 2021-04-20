# purpose: started by systemd
# listens for changes in orientation file at /dev/orientation.txt and applies them

source ./env.sh # contains TOUCHSCREEN and TOUCHPAD

# wait for modification of the orientation file.
while true
do
    # wait for changes in file storing the current rotation
    inotifywait -e modify /dev/orientation.txt
    
    # get last line of file (must be parsed in order to receive orientation)
    currentorientation=$(tail -1 /dev/orientation.txt)

    
    # clear file
    # echo "" | tee /dev/orientation.txt
    
    # parse orientation
    case "$currentorientation" in
        *"normal"*)
            currentorientation="normal"
        ;;
        *"bottom-up"*)
            currentorientation="inverted"
        ;;
        *"right-up"*)
            currentorientation="right"
        ;;
        *"left-up"*)
            currentorientation="left"
        ;;
        *)
            continue
        ;;
    esac
    
    # set variable currentorientation as $1
    set -- $currentorientation
    
    if [ -z "$1" ]; then
      echo "Missing orientation."
      echo "Usage: $0 [normal|inverted|left|right] [revert_seconds]"
      echo
      exit 1
    fi

    function do_rotate
    {
      xrandr --output $1 --rotate $2

      TRANSFORM='Coordinate Transformation Matrix'

      case "$2" in
        normal)
          [ ! -z "$TOUCHPAD" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" 1 0 0 0 1 0 0 0 1
          [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 1 0 0 0 1 0 0 0 1
          ;;
        inverted)
          [ ! -z "$TOUCHPAD" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" -1 0 1 0 -1 1 0 0 1
          [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" -1 0 1 0 -1 1 0 0 1
          ;;
        left)
          [ ! -z "$TOUCHPAD" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" 0 -1 1 1 0 0 0 0 1
          [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 0 -1 1 1 0 0 0 0 1
          ;;
        right)
          [ ! -z "$TOUCHPAD" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" 0 1 0 -1 0 1 0 0 1
          [ ! -z "$TOUCHSCREEN" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 0 1 0 -1 0 1 0 0 1
          ;;
      esac
    }

    XDISPLAY=`xrandr --current | grep primary | sed -e 's/ .*//g'`
    
    do_rotate $XDISPLAY $1

  
done

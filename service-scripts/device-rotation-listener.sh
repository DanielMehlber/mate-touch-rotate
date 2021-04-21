# purpose: started by systemd
# listens for changes in orientation file at /dev/orientation.txt and applies them

TOUCHSCREEN=$1
TOUCHPAD=$2

echo "Using TOUCHSCREEN=$TOUCHSCREEN and TOUCHPAD=$TOUCHPAD"

# wait for modification of the orientation file.
while true
do
    # wait for changes in file storing the current rotation
    inotifywait -e modify /dev/orientation.txt
    
    # get last line of file (must be parsed in order to receive orientation)
    currentorientation=$(tail -1 /dev/orientation.txt)
    # get display name
    XDISPLAY=`xrandr --current | grep primary | sed -e 's/ .*//g'`
    
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
    

    function do_rotate
    {
      xrandr --output $XDISPLAY --rotate $currentorientation
        echo "DEVICE=$TOUCHSCREEN"
      TRANSFORM='Coordinate Transformation Matrix'
        
      case "$currentorientation" in
        normal)
          echo "rotate to normal"
          [ "$TOUCHPAD" != "None" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" 1 0 0 0 1 0 0 0 1
          [ "$TOUCHSCREEN" != "None" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 1 0 0 0 1 0 0 0 1
          ;;
        inverted)
          echo "rotate to inverted"
          [ "$TOUCHPAD" != "None" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" -1 0 1 0 -1 1 0 0 1
          [ "$TOUCHSCREEN" != "None" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" -1 0 1 0 -1 1 0 0 1
          ;;
        left)
          echo "rotate to left"
          [ "$TOUCHPAD" != "None" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" 0 -1 1 1 0 0 0 0 1
          [ "$TOUCHSCREEN" != "None" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 0 -1 1 1 0 0 0 0 1
          ;;
        right)
          echo "rotate to right"
          [ "$TOUCHPAD" != "None" ]    && xinput set-prop "$TOUCHPAD"    "$TRANSFORM" 0 1 0 -1 0 1 0 0 1
          [ "$TOUCHPAD" != "None" ] && echo "right matrix"
          [ "$TOUCHSCREEN" != "None" ] && xinput set-prop "$TOUCHSCREEN" "$TRANSFORM" 0 1 0 -1 0 1 0 0 1
          ;;
        *)
          echo "Error: orientataion not recognized!"
          ;;
      esac
    }

    
    do_rotate

  
done

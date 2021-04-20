XDISPLAY=$(xrandr --current | grep primary | sed -e 's/ .*//g')

echo "Display name is $XDISPLAY" | tee /home/danielmehlber/Documents/testlog.txt

TOUCHPAD='Synaptics TM3319-001'
TOUCHSCREEN='pointer:04F3224A:00 04F3:24FE'

# purpose: started by systemd
# listens for changes in orientation file at /dev/orientation.txt and applies them

# wait for modification of the orientation file.
while true
do
    # wait for changes in file storing the current rotation
    inotifywait -e modify /dev/orientation.txt
    echo "File change detected" | tee -a /home/danielmehlber/Documents/testlog.txt
    
    # get last line of file (must be parsed in order to receive orientation)
    currentorientation=$(tail -1 /dev/orientation.txt)
    echo "This is the current line: $currentorientation" | tee -a /home/danielmehlber/Documents/testlog.txt
    
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
            echo "Current line is not a orientation - Skipped" | tee -a /home/danielmehlber/Documents/testlog.txt
            continue
        ;;
    esac
    
    echo "This is the orientation: $currentorientation" | tee -a /home/danielmehlber/Documents/testlog.txt
    
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
      echo "rotate $2 on $1"
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
    
    
    echo "do rotate on $XDISPLAY to $1" | tee -a /home/danielmehlber/Documents/testlog.txt
    do_rotate $XDISPLAY $1

  
done

# purpose: started by systemd
# listens for changes in orientation file at /dev/orientation.txt and applies them


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
  
      TRANSFORM='Coordinate Transformation Matrix'
        
      case "$currentorientation" in
        normal)
          echo "rotate to normal"
          for var in "$@"
            do
            [ "$var" != "None" ]    && xinput set-prop "$var"  "$TRANSFORM" 1 0 0 0 1 0 0 0 1
          done 
          ;;
        inverted)
          echo "rotate to inverted"
          for var in "$@"
            do
            [ "$var" != "None" ]    && xinput set-prop "$var"  "$TRANSFORM" -1 0 1 0 -1 1 0 0 1
          done 
          ;;
        left)
          echo "rotate to left"
          for var in "$@"
            do
            [ "$var" != "None" ]    && xinput set-prop "$var"  "$TRANSFORM" 0 -1 1 1 0 0 0 0 1
          done 
          ;;
        right)
          echo "rotate to right"
          for var in "$@"
            do
            [ "$var" != "None" ]    && xinput set-prop "$var"  "$TRANSFORM" 0 1 0 -1 0 1 0 0 1
          done 
          ;;
        *)
          echo "Error: orientataion not recognized!"
          ;;
      esac
    }

    
    do_rotate

  
done

# toggle synaptic touchpad on/off
#untestet http://www.webupd8.org/2009/11/ubuntu-automatically-disable-touchpad.html
# get current state
SYNSTATE=$(synclient -l | grep TouchpadOff | awk '{ print $3 }')

# change to other state
if [ $SYNSTATE = 0 ]; then
synclient touchpadoff=1
elif [ $SYNSTATE = 1 ]; then
synclient touchpadoff=0
else
echo "Couldn't get touchpad status from synclient"
exit 1
fi
exit 0

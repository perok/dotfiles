# Based on:
# https://askubuntu.com/questions/393400/is-it-possible-to-have-two-different-dpi-configurations-for-two-different-screen
xrandr --output HDMI1 --scale 2x2 --mode 1920x1080 --fb 3840x2160 --pos 0x0
xrandr --output eDP1 --scale 1x1 --pos 3840x0

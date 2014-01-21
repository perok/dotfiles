#!/bin/bash

# PLay a vlc movie, then run clialarm.sh

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] ; then
    echo "Begone you twat."
else
    if [ date +%s -d now > date +%s -d "$2 $3" ] ; then
        echo "Trying to time travel, eh?"
        echo "Watch Primer. Think twice, or trice about it."
        echo "Then come ask me again (yeah, I know how to do it)."
        exit 1
    fi

    sudo uptime > /dev/null
    vlc $1 VLC://quit && sh ./clialarm.sh $2 $3 $4
fi

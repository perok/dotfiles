#!/bin/bash

# Script for waking the computer up and playing music.
# Spotify
# - mdbus2 org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2
# - Pause example: dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause
# dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Openuri string:spotify:user:peroyvin
#
# TODO list:
# - Shuffle (not supported by spotify)
# - PLay a playlist
# - Start spotify for you.
# - Check for pid lock instead of ps grep

#Song or playlist to play.
spotifyLink=string:spotify:track:6gTQubOSdry0ievEXvhzxd

# Suspend pc to memory and wake at that time
function sleepAndWake {
    sudo rtcwake -l -m mem -t $time && \
        amixer -c 0 set Master 100% > /dev/null

    # mpv 'path to some folder with songs.'

    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify \
        /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.OpenUri \
        $spotifyLink > /dev/null

    echo "Good morning!"
    echo "FYI: Stay awake you time slut."
}

# Take in time to active: torrow 09:00
if [ -z "$1" ] || [ -z "$2" ] ; then
    echo "Add time parameters."
    echo "Ex: tomorrow 09:00"
    exit 1
else
    time=$(date +%s -d "$1 $2")
fi

#If user has another link he whises to play
if [ -n "$3" ]; then
    spotifyLink=$3
fi

# Make sure that spotify is running, then start an awesome song.
if ps aux | grep "[s]potify" > /dev/null
then
    echo "Sleeping computer. Waking you up at: $time"
    sleepAndWake
else
    echo "Spotify is not running. Start it you nimwit."
    echo "Make sure shuffle is on and run the script again."
    #spotify & > /dev/null
    exit 1
fi

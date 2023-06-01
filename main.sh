#!/bin/bash

# Author           : Bartosz Kopania 193169
# Created On       : 2023.05.23
# Last Modified By : Bartosz Kopania 193169
# Last Modified On : 2023.06.04 
# Version          : wersja
#
# Description      :
# Aplication made with usage of zenity and ffmppeg.
# It uses ffmpeg in order to play music and zenity to visaulize that
# User is allowed to save playlists to play it in futher
# depsite playlist it is possible to play exact file or files
# It is possible to play or pause the ffplay
# after creating the playlist or adding new songs, it shows the time, size etc
# Opis
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)

. zenityHandler.rc
. variables.rc
. timeStat.rc

getStats()
{
  SUM_DURATION=0
  SUM_SIZE=0

  for element in "${SONGS[@]}"; do
    echo "$element"
    DURATION=$(ffmppeg -i testowy.mp3 2>&1 | grep "Duration" | cut -d ' ' -f 4)
    echo $DURATION
    SIZE=$(stat -c "%s" $element)
    SUM_SIZE=$(($SUM_SIZE+SIZE))
    
    DURATION=$(time_to_ms  $DURATION)
    SUM_DURATION=$(($SUM_DURATION+$DURATION))
  done
}

mp3Player()
{
  PLAYING="true"
  ZENITY_PID=0
  ITERATOR=0

  # ffplay -v 0 -nodisp -autoexit testowy.mp3 &
  # ffplay_pid=$!

  while [ "$PLAYING" == "true" ]; do
      ffplay -v 0 -nodisp -autoexit ${SONGS[$ITERATOR]} &
      ffplay_pid=$!
    while ps -p $ffplay_pid > /dev/null
    do
      if [ $ZENITY_PID -eq 0 ]; then
        playingView &
        ZENITY_PID=$!
      fi
    done
    ZENITY_PID=0
    PLAYING="false"
  done
  startView
}

#start the program

ffplay_pid="null"
PLAYING="false"
SONGS=(testowy.mp3 ../testowy2.mp3)

DURATION=$(ffmppeg -i testowy.mp3 2>&1 | grep "Duration")
    echo $DURATION

#getStats

while getopts "vhD" arg; do
  case $arg in
    v)
      echo -e "version 1.0, by Bartosz Kopania 193169\nMade for SO as big script"
      exit
      ;;
    h)
      echo "run the application without any options, then pick whatever you want. Zamknij means back to startingView and there Zamknij means close application"
      exit;
      ;;
    D)
      echo "USUWANIE USTAWIEN"
      read -p "Czy na pewno chcesz usunac zapisane ustawienia(TAK/n) " ODP
      if [ "$ODP" == "TAK" ]; then
        OLD="$(echo "$CONFIG_FILE_PATH" | tr -d '\r')"
        while read WIERSZ; do
            CLEANED_WIERSZ="$(echo "$WIERSZ" | tr -d '\r')"
            rm $CLEANED_WIERSZ".playlist"
        done < "$CONFIG_FILE_PATH"
        rm $OLD
        echo "usunieto dane"
      fi
      exit;
      ;;
  esac
done

# Open startView
startView

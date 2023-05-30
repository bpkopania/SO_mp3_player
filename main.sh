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

#start the program, open startView

ffplay_pid="null"
PLAYING="false"
SONGS=()
ITERATOR=0

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

startView

ZENITY_PID=0

ffplay -v 0 -nodisp -autoexit testowy.mp3 &
ffplay_pid=$!

while [ "$PLAYING" == "true" ]; do
  
  #ffplay_pid=$!
  #ps
  echo $ffplay
  while ps -p $ffplay_pid > /dev/null
  do
    if [ $ZENITY_PID -eq 0 ]; then
      playingView &
      ZENITY_PID=$!
    fi
  done
  kill $ZENITY_PID
  ZENITY_PID="null"
  echo "zmiana statusu"
  PLAYING="false"
  ZENITY_PID=0;
  playingView
done

handleExit

# test

# zenity --question \
#     --text "Do you want to proceed?" \
#     --ok-label "OK" \
#     --cancel-label "Cancel" \
#     --extra-button "Extra" \
#     --extra-button "superExtra"

# RESPONSE=$?
# echo $RESPONSE
# if [ $RESPONSE -eq 0 ]; then
#     echo "OK button clicked"
#     # Continue with further actions for OK button
# elif [ $RESPONSE -eq 1 ]; then
#     echo "Cancel button clicked"
#     # Continue with further actions for Cancel button
# elif [ $RESPONSE -eq 2 ]; then
#     echo "Extra button clicked"
#     # Continue with further actions for Extra button
# else
#     echo "Dialog closed or an error occurred"
#     # Handle other scenarios if needed
# fi


# if [ $RESPONSE -eq 1 ]; then
#     echo "OK button clicked"
#     ffplay -v 0 -nodisp -autoexit testowy.mp3 &
#     ffplay_pid=$!

#     # Wyświetlenie okna Zenity z przyciskiem "Stop"
#     zenity --question --text="Czy chcesz zatrzymać odtwarzanie?" --title="Odtwarzanie" --ok-label="Tak" --cancel-label="Nie"

#     # Sprawdzenie, czy użytkownik kliknął przycisk "Tak"
#     if [ $? -eq 0 ]; then
#         # Wysłanie sygnału przerwania (SIGINT) do procesu ffplay
#         kill -SIGINT $ffplay_pid
#     fi
# fi

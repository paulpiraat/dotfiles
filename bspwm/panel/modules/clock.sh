#!/bin/sh

# Define the clock
DATETIME=$(date "+%a %d %b %T")

while true; do
    printf "%s\n" "C$DATETIME"
    #printf "%s\n" "C$DATETIME" > "$PANEL_FIFO"
    #echo "C$DATETIME"
    sleep 1
done

# Print the clock

# This is already done in panel_bar
# while true; do
#     echo "%{c}%{F#FFFF00}%{B#0000FF} $(Clock) %{F-}%{B-}"
#     sleep 1
# done

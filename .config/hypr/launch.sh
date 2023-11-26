#!/bin/bash

while getopts "pc" opt; do
    case $opt in 
        p)
            hyprctl hyprpaper unload all
            for file in $(find "$HOME/Wallpapers/" -type f); do
                hyprctl hyprpaper preload $file
            done
            ;;
        c)
            CONFIG="$HOME/.config"
            MONITOR=$(hyprctl monitors | awk '{print $2}' | head -n 1)
            WALLPAPER=$(find "$HOME/Wallpapers/" -type f | shuf -n 1)
            wal -nq -i $WALLPAPER
            hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER"
            echo "preload = $WALLPAPER" > "$CONFIG/hypr/hyprpaper.conf"
	    echo "wallpaper = ,$WALLPAPER" >> "$CONFIG/hypr/hyprpaper.conf"
            if ps aux | grep -v grep | grep "waybar" > /dev/null; then
                killall waybar
            fi
            waybar 
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            ;;
    esac
done

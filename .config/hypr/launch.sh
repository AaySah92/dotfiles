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
            echo "preload = $WALLPAPER" > "$CONFIG/hypr/hyprpaper.conf"
            for monitor in $(hyprctl monitors | grep Monitor | awk '{print $2}'); do
                hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER"
	        echo "wallpaper = $monitor,$WALLPAPER" >> "$CONFIG/hypr/hyprpaper.conf"
            done
            echo "splash = false" >> "$CONFIG/hypr/hyprpaper.conf"
            echo "ipc = off" >> "$CONFIG/hypr/hyprpaper.conf"
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

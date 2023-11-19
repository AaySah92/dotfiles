!/bin/bash

CONFIG="$HOME/.config"
MONITOR=$(hyprctl monitors | awk '{print $2}' | head -n 1)
#WALLPAPER="$HOME/Downloads/wall9.jpg"
WALLPAPER="$HOME/Downloads/wall.png"

while getopts ":w" opt; do
    case $opt in
        w)
	    wal -nq -i $WALLPAPER
	    echo "preload = $WALLPAPER" > "$CONFIG/hypr/hyprpaper.conf"
	    # echo "wallpaper = $MONITOR,$WALLPAPER" >> "$CONFIG/hypr/hyprpaper.conf"
	    echo "wallpaper = ,$WALLPAPER" >> "$CONFIG/hypr/hyprpaper.conf"
	    killall hyprpaper & killall waybar
	    # hyprctl hyprpaper unload all
	    ;;
    esac
done

hyprpaper & waybar

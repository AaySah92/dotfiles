#!/bin/bash

exit_with_error_message() {
	echo $1
	exit 1
}

if [ $# -eq 0 ]; then
	exit_with_error_message "No image provided"
elif [ $# -gt 1 ]; then
	exit_with_error_message "This program takes only 1 argument"
fi

readonly image_path=$1
readonly hyprpaper_config=$HOME/.config/hypr/hyprpaper.conf

if [ ! -e $image_path ]; then
	exit_with_error_message "Image does not exist"
fi

# Use pywal to generate colors
wal -nq -i $image_path
# wal --theme github -nq 

# Use IPC (hyprctl) to preload the image and persist the changes for reboot
hyprctl hyprpaper unload all
hyprctl hyprpaper preload $image_path
echo "preload = $image_path" > $hyprpaper_config

# Loop through all the monitors
for monitor in $(hyprctl monitors | grep Monitor | awk '{print $2}'); do
	# Use IPC (hyprctl) to set image as wallpaper and persist the changes for reboot
	hyprctl hyprpaper wallpaper "$monitor,$image_path"
	echo "wallpaper = $monitor,$image_path" >> $hyprpaper_config
done

echo "splash = false" >> $hyprpaper_config

# Kill waybar if running and restart it
if ps aux | grep -v grep | grep "waybar" > /dev/null; then
	killall waybar
fi
waybar 

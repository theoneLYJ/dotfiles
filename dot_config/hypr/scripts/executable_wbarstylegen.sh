#!/usr/bin/env sh


# detect hypr theme and initialize variables

ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
waybar_dir="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
in_file="$waybar_dir/style.css"
out_file="$waybar_dir/style.css"
src_file="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/themes/theme.conf"

ln -fs $waybar_dir/Wall-Dcol.css $waybar_dir/theme.css
reload_flag=1

if [ "$reload_flag" == "1" ] ; then
    killall waybar
    waybar > /dev/null 2>&1 &
    # killall -SIGUSR2 waybar
fi

#!/usr/bin/env sh

# define functions

Wall_Update()
{
    if [ ! -d "${cacheDir}" ] ; then
        mkdir -p "${cacheDir}"}
    fi

    local x_wall="$1"
    local x_update="${x_wall/$HOME/"~"}"
    cacheImg=$(basename "$x_wall")
		$ScrDir/swwwallbash.sh "$x_wall" &

    if [ ! -f "${cacheDir}/${cacheImg}" ] ; then
        convert -strip "$x_wall" -thumbnail 500x500^ -gravity center -extent 500x500 "${cacheDir}${cacheImg}" &
    fi

    if [ ! -f "${cacheDir}/${cacheImg}.rofi" ] ; then
        convert -strip -resize 2000 -gravity center -extent 2000 -quality 90 "$x_wall" "${cacheDir}/${cacheImg}.rofi" &
    fi

    if [ ! -f "${cacheDir}/${cacheImg}.blur" ] ; then
        convert -strip -scale 10% -blur 0x3 -resize 100% "$x_wall" "${cacheDir}/${cacheImg}.blur" &
    fi

    wait
    ln -fs "${x_wall}" "${wallSet}"
    ln -fs "${cacheDir}/${cacheImg}.rofi" "${wallRfi}"
    ln -fs "${cacheDir}/${cacheImg}.blur" "${wallBlr}"
}

Wall_Change()
{
    local x_switch=$1

    for (( i=0 ; i<${#Wallist[@]} ; i++ ))
    do
        if [ "${Wallist[i]}" == "${fullPath}" ] ; then

            if [ $x_switch == 'n' ] ; then
                nextIndex=$(( (i + 1) % ${#Wallist[@]} ))
            elif [ $x_switch == 'p' ] ; then
                nextIndex=$(( i - 1 ))
            fi

            Wall_Update "${Wallist[nextIndex]}"
            break
        fi
    done
}

Wall_Set()
{
    if [ -z $xtrans ] ; then
        xtrans="grow"
    fi

    swww img "$wallSet" \
    --transition-bezier .43,1.19,1,.4 \
    --transition-type "$xtrans" \
    --transition-duration 0.7 \
    --transition-fps 60 \
    --invert-y \
    --transition-pos "$( hyprctl cursorpos )"
}


# set variables

ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
wallSet="${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.set"
wallBlr="${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.blur"
wallRfi="${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.rofi"

fullPath=$(echo "$ctlLine" | awk -F '|' '{print $NF}' | sed "s+~+$HOME+")
wallName=$(basename "$fullPath")
wallPath="$HOME/.config/swww/wallpaper"
mapfile -d '' Wallist < <(find ${wallPath} -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | sort -z)

# evaluate options
while getopts "nps" option ; do
    case $option in
    n ) # set next wallpaper
        xtrans="grow"
        Wall_Change n ;;
    p ) # set previous wallpaper
        xtrans="outer"
        Wall_Change p ;;
    s ) # set input wallpaper
        shift $((OPTIND -1))
        if [ -f "$1" ] ; then
            Wall_Update "$1"
        fi ;;
    * ) # invalid option
        echo "n : set next wall"
        echo "p : set previous wall"
        echo "s : set input wallpaper"
        exit 1 ;;
    esac
done

# check swww daemon and set wall
swww query
if [ $? -eq 1 ] ; then
    swww init
fi

Wall_Set


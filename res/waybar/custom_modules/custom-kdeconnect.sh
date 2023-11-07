#
# Shamefully massacred from haideralipunjabi's polybar-kdeconnect 
# (https://github.com/haideralipunjabi/polybar-kdeconnect/)
#
# ...
# And then stolen from https://github.com/Pipshag/dotfiles_gruvbox/blob/master/.config/waybar/custom_modules/custom-kdeconnect.sh


get_status() {
    for device in $(qdbus --literal org.kde.kdeconnect /modules/kdeconnect org.kde.kdeconnect.daemon.devices); do
        deviceid=$(echo "$device" | awk -F'["|"]' '{print $2}')
        isreach="$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.isReachable)"
    if [ "$isreach" = "true" ]
        then
            battery="$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid/battery" org.kde.kdeconnect.device.battery.charge)󰏰"
            icon="󰄜"
            devices+="$icon $battery"
            conn+=connected
    else
        devices+="󰥍"
        conn+=disconnected
        fi
    done
    echo -e "$devices\nKDE Connect\n$conn"
}

option="${1}"
    case "${option}" in
        battery) get_status
            ;;
        *) echo "Use with ./custom-kdeconnect.sh battery"
            ;;
    esac

exit 0
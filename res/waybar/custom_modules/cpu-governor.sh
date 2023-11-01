#!/bin/bash

GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

if [ $GOVERNOR = performance ]; then
	echo '{"text": "perf", "alt": "perf", "class": "performance", "tooltip": "<b>Governor</b> Performance"}'
	if [[ $1 = switch ]]; then
		sudo cpupower frequency-set -g powersave;pkill -RTMIN+8 waybar;
	fi
elif [ $GOVERNOR = powersave ]; then
    echo '{"text": "powersave", "alt": "powersave", "class": "powersave", "tooltip": "<b>Governor</b> Powersave"}'
    if [[ $1 = switch ]]; then
        sudo cpupower frequency-set -g performance;pkill -RTMIN+8 waybar;
    fi
fi
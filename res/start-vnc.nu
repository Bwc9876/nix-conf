#!/usr/bin/env nu

$env.WLR_BACKENDS = "headless"
$env.WLR_LIBINPUT_NO_DEVICES = 1

mprocs "Hyprland" "sleep 3; WAYLAND_DISPLAY=wayland-1 wayvnc"


#!/usr/bin/env nu

# Provided a given address and assuming that address is setup
# with my config / ssh keys, this script will start a vnc session
# on the remote machine with Hyprland, and then start a NoVNC 
# webserver on the local machine to connect to the remote machine.

def main [address: string, user: string = "bean", port: number = 8069] {
    let hyprland = $'ssh -p ($port) ($user)@($address) "bash -c \"source /etc/set-environment; WLR_LIBINPUT_NO_DEVICES=1 WLR_BACKENDS=headless Hyprland\""'
    let wayvnc = $'sleep 3; ssh -p ($port) ($user)@($address) "WAYLAND_DISPLAY=\"wayland-1\" wayvnc -k us"'
    let novnc = $"novnc --listen 127.0.0.1:6080 --vnc localhost:5900"
    let tunnel = $"ssh -N -T -L 5900:localhost:5900 ($user)@($address) -p ($port)"
    
    mprocs $hyprland $wayvnc $novnc $tunnel --names "Hyprland (Remote),WayVNC (Remote),NoVNC (Local),Tunnel (Local)"
}


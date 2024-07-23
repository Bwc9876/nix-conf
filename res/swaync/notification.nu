#!/usr/bin/env nu

const SILENCED_APP_NAMES = [
    "vesktop",
    "thunderbird"
]

let name = $env.SWAYNC_APP_NAME? | default "" | str downcase

if ($name not-in $SILENCED_APP_NAMES) {
    aplay ~/.config/swaync/notif.wav
}

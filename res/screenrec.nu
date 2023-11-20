#!/usr/bin/env nu

let captures_folder = $"($env.HOME)/Videos/Captures"

if not ($captures_folder | path exists) {
    mkdir $captures_folder
}

let file_name = date now | format date $"($captures_folder)/%Y-%m-%d_%H-%M-%S.gif" 

wf-recorder -g (slurp) -F fps=30 -c gif -f $file_name

open $file_name | wl-copy --type image/gif

let action = notify-send --action=open=Open --action=folder="Show In Folder" "Recording finished" $"File saved to ($file_name) and copied to clipboard"

match $action {
    "open" => {
        xdg-open $file_name
    }
    "folder" => {
        xdg-open $captures_folder
    }
}

#!/usr/bin/env nu

let captures_folder = $"($env.HOME)/Videos/Captures"

if not ($captures_folder | path exists) {
    mkdir $captures_folder
}

let file_name = date now | format date $"($captures_folder)/%Y-%m-%d_%H-%M-%S.gif" 

let workspaces = hyprctl monitors -j | from json | get activeWorkspace.id
let windows = hyprctl clients -j | from json | where workspace.id in $workspaces
let geom = $windows | each { |w| $"($w.at.0),($w.at.1) ($w.size.0)x($w.size.1)" } | str join "\n"

let stat = do { echo $geom | slurp -d } | complete

if $stat.exit_code == 1 {
    echo "No selection made"
    exit
}

wf-recorder -g ($stat.stdout) -F fps=30 -c gif -f $file_name

open $file_name | wl-copy --type image/gif

let action = notify-send -i $file_name -t 7500 --action=open=Open --action=folder="Show In Folder" "Recording finished" $"File saved to ($file_name) and copied to clipboard"

match $action {
    "open" => {
        xdg-open $file_name
    }
    "folder" => {
        xdg-open $captures_folder
    }
}

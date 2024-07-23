#!/usr/bin/env nu

def main [contents: string] {

    let body = $contents | str replace "Newsboat: finished reload, " "";

    # Reload waybar to update the newsboat module
    pkill -SIGRTMIN+6 waybar

    let action = notify-send --action=open=Open --app-name=newsboat --icon=newsboat --urgency=low "Newsboat Refresh" $body;

    if ($action == "open") {
        let active = (do { pidof -q newsboat } | complete | get exit_code) == 0;
        if ($active) {
            hyprctl dispatch focuswindow newsboat
        } else {
            foot --title="Newsboat" --app-id="newsboat" newsboat
        }
    }
}

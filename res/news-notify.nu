#!/usr/bin/env nu

def main [contents: string] {
    let body = $contents | str replace "Newsboat: finished reload, " "";
    notify-send --urgency=low "Newsboat Refresh" $body
}

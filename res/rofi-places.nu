#!/usr/bin/env nu

let places = cat ~/.local/share/user-places.xbel | from xml | get content | where tag == "bookmark" | where attributes.href != "" | each {|it| {loc: $it.attributes.href, name: ($it.content | where tag == "title" | get content.0.content.0), icon: ($it.content | where tag == "info" | get content.0.content.0 | where tag == "icon" | get attributes.name.0 )} }

let disp_loc = {|it| (if ($it | str starts-with "file://") { $it | str substring 7.. } else { $it } | str replace $"/home/($env.USER)" "~")}

let disp = $places | each {|it| 
    $"($it.name) <span color=\"#A2A2A2\"><i><small>\(($it.loc | each $disp_loc | str trim)\)</small></i></span> \u{0}icon\u{1f}($it.icon)"
} | str join "\n"

let res = ($disp | rofi -dmenu -markup-rows -show-icons -p "Dolphin" | complete) 

if $res.exit_code == 1 {
    echo "Cancelled"
} else {
    let name = $res.stdout | split row " <span color=\"#A2A2A2\">" | get 0
    let loc = $places | where name == $name | get 0.loc
    echo "Opening $loc"
    dolphin --new-window $loc
}

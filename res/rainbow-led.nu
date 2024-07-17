#!/usr/bin/env nu

let colors = ["red", "green", "blue", "yellow", "amber", "white"];

mut i = 0;
let l = $colors | length;

let leds = ["right", "left"];

loop {
    let ii = $i mod $l;
    let color = $colors | get $ii;
    for led in $leds {
        ectool led $led $color;
    }
    $i += 1;
    sleep 0.3sec;
}

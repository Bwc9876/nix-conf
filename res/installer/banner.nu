#!/usr/bin/env nu

let has_cowsay = try { 
    cowsay -e ^^ Welcome to the Installer! | lolcat -F 0.5
    true
} catch { 
    print "Failed to render the cow :(" ;
    false
}

def checklist_item [name: string, checked: bool, hint = ""] {
    print $"- (if $checked {$"(ansi green)󰗠(ansi reset)"} else {$"(ansi red)󰀨(ansi reset)"}) ($name) (if $checked {""} else {$"\(($hint)\)"})";
}

def check_network [] {
    try { 
        ping google.com -c 1 | null;
        true
    } catch {
        false
    }
}

def check_mountpoint [path: string] {
    let points = mount | lines | where {|it| $"on ($path) " in $it}
    if ($points | length) == 0 {
        null    
    } else {
        $points | get 0 | split row " on " | get 0
    }
}

let mnt = check_mountpoint /mnt
let mnt_boot = check_mountpoint /mnt/boot


let connected = check_network
let has_mnt = $mnt != null
let has_mnt_boot = $mnt_boot != null


let sep = "======================================================================================="

print "_____________________________";
print "Checklist for install";
print $sep;
checklist_item "Cowsay" $has_cowsay "FIX IT Ņ̵͓̣͕̭̼͊̈̒̌̂Ò̴̡̧̜̠̱̜̯̯̻͚̳͔̅̈́̄̈́͗̿̋̉̿̕͠W̶̯̤̘̰̺͖̤͎̺͐͊̆͗̅͌̍́̏!!!!"
checklist_item "Network Connection" $connected "Run nmtui!"
checklist_item $"Mountpoint (if $has_mnt {$"($mnt)"} else {""})" $has_mnt "Run `installer-disks` for help" 
checklist_item $"Bootpoint (if $has_mnt_boot {$"($mnt_boot)"} else {""})" $has_mnt_boot "Run `installer-disks` for help"
print $sep;
print "Once everything's checked off, run `sudo installer-go` to start the install";
print "You can check this list again by running `installer-check`. gl!";
print $sep;

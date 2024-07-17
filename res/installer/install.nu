#!/usr/bin/env nu

let a = input "Are you running with sudo and did you run `installer-check` and make sure everything is working? (y/N)"

if ($a == "y" or $a == "Y") {
    clear
    print "Awesome! Let's do this!"
    print "\n"
    if (not ("/mnt/nix-conf" | path exists)) {
        print "First and foremost I'll copy the flake to /mnt/conf-temp"
        print "This is so I can make changes to it and you'll have it once everything is done"    
        mkdir /mnt/nix-conf
        bash -c "cp -Lr /home/nixos/nix-conf /mnt"
        print "Copying done!"
    }

    cd /mnt/nix-conf

    let name = if (".host" | path exists) {
        open .host | str trim
    } else {
        print "Now we need to generate a new hardware-configuration.nix";
        let name = input "Enter the name of this system in kebab-case: " | str trim;
        just setup $name;
        $name
    }
    mkdir $"/mnt/nix-conf/computers/($name)"

    let hw_config = $"/mnt/nix-conf/computers/($name)/hardware-configuration.nix"

    if (not ($hw_config | path exists)) {
        print "Generating hardware-configuration.nix"
        nixos-generate-config --root /mnt --show-hardware-config | save -f $"/mnt/nix-conf/computers/($name)/hardware-configuration.nix"
        input "Generated the hardware-configuration.nix, press enter to review / make changes"
        vim $"/mnt/nix-conf/computers/($name)/hardware-configuration.nix"
        clear    
        print "Done making the hardware-configuration.nix"
    }

    input "Now you need to edit flake.nix to include the new system. I will launch vim for you to edit it. Press enter to continue"
    vim /mnt/nix-conf/flake.nix
    clear

    input "Alright, now we're ready to install, press enter to continue"
    nixos-install --no-channel-copy --no-bootloader --root /mnt --flake $".#($name)" --option extra-experimental-features "auto-allocate-uids cgroups" -v --show-trace --keep-going
} else {
    print "Gotcha"
    exit 1
}

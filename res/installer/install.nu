
let a = input "Are you running with sudo and did you run `installer-check` and make sure everything is working? (y/N)"

if (a == "y" or a == "Y") {
    echo "Awesome! Let's do this!"
    echo "\n"
    echo "First and foremost I'll copy the flake to /mnt/conf-temp"
    echo "This is so I can make changes to it and you'll have it once everything is done"
    bash -c "cp -Lr /home/nixos/nix-conf /mnt"
    echo "Copying done!"
    cd /mnt/nix-conf
    echo "Now we need to generate a new hardware-configuration.nix"
    let name = input "Enter the name of this system in kebab-case: "
    just setup $name
    mkdir $"/mnt/nix-conf/computers/($name)"
    nixos-generate-config --root /mnt --show-hardware-config | write $"/mnt/nix-conf/computers/($name)/hardware-configuration.nix"
    echo "Done making the hardware-configuration.nix"
    input "Now you need to edit flake.nix to include the new system. I will launch vim for you to edit it. Press enter to continue"
    vim /mnt/nix-conf/flake.nix
    input "Alright, now we're ready to install, press enter to continue"
    nixos-install --no-channel-copy --root /mnt --flake $".#($name)" --option extra-experimental-features "auto-allocate-uids cgroups"
} else {
    echo "Gotcha"
    exit 1
}

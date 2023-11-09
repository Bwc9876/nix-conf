{
  pkgs,
  lib,
}:
with lib; {
  enable = true;
  configFile.text = ''
    let fish_completer = {|spans|
        ${pkgs.fish}/bin/fish --command $'complete "--do-complete=($spans | str join " ")"'
        | $"value(char tab)description(char newline)" + $in
        | from tsv --flexible --no-infer
    }
    let command_not_found = ${fileContents ../res/command_not_found.nu}
    $env.config = {
        show_banner: false
        completions: {
            external: {
                enable: true
                completer: $fish_completer
            }
        }
        hooks: {
            command_not_found: $command_not_found
        }
    }
  '';
  envFile.text = ''
    alias py = python
    alias cat = bat
    alias neofetch = hyfetch
    alias screensaver = pipes-rs -k curved -p 10 --fps 30
    alias hyperctl = hyprctl
    alias hyprland = Hyprland
    alias hyperland = hyprland
  '';
}

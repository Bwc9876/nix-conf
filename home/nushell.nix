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
    let multiple_completers = {|spans|
        # if the current command is an alias, get it's expansion
        let expanded_alias = (scope aliases | where name == $spans.0 | get -i 0 | get -i expansion)

        # overwrite
        let spans = (if $expanded_alias != null  {
            # put the first word of the expanded alias first in the span
            $spans | skip 1 | prepend ($expanded_alias | split row " ")
        } else { $spans })

        match $spans.0 {
            _ => $fish_completer
        } | do $in $spans
    }
    let command_not_found = ${fileContents ../res/command_not_found.nu}
    $env.config = {
        show_banner: false
        completions: {
            external: {
                enable: true
                completer: $multiple_completers
            }
        }
        hooks: {
            command_not_found: $command_not_found
        }
    }
  '';
  envFile.text = ''
    alias py = python
    alias z = zoxide
    alias cat = bat
    alias neofetch = hyfetch
    alias screensaver = pipes-rs -k curved -p 10 --fps 30
    alias hyperctl = hyprctl
    alias hyprland = Hyprland
    alias hyperland = hyprland
  '';
}

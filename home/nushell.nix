{
  pkgs,
  lib,
  ...
}:
with lib; {
  programs.nushell = {
    enable = true;
    shellAliases = {
      cd = "z";
      sw = "zi";
      py = "python";
      cat = "bat";
      pcat = "prettybat";
      pbat = "prettybat";
      man = "__batman";
      bgrep = "batgrep";
      neofetch = "hyfetch";
      screensaver = "pipes-rs -k curved -p 10 --fps 30";
    };
    configFile.text = ''
      let fish_completer = {|spans|
          ${pkgs.fish}/bin/fish --command $'complete "--do-complete=($spans | str join " ")"'
          | $"value(char tab)description(char newline)" + $in
          | from tsv --flexible --no-infer
      }
      let zoxide_completer = {|spans|
          $spans | skip 1 | zoxide query -l $in | lines | where {|x| $x != $env.PWD}
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
              z => $zoxide_completer
              zi => $zoxide_completer
              __zoxide_z => $zoxide_completer
              __zoxide_zi => $zoxide_completer
              _ => $fish_completer
          } | do $in $spans
      }

      let command_not_found = ${fileContents ../res/command_not_found.nu}

      def --env __batman [...rest:string] {
        BAT_THEME="Monokai Extended" batman $rest
      }

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
  };
}

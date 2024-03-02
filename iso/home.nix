{
  inputs,
  lib,
  ...
}:
with lib; rec {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ../home/nushell.nix
    ../home/shell.nix
    ../home/foot.nix
  ];

  programs.nushell.loginFile.source = ../res/installer/banner.nu;

  xdg.configFile = {
    "hyfetch.json".source = ../res/hyfetch.json;
  };

}

{
  rustPlatform,
  dbus,
  nushell,
  pkg-config,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_dbus";
  version =
    if nushell.version == nu_version
    then "0.10.0"
    else abort "Nushell Version mismatch\nPlugin: ${nu_version}\tnixpkgs: ${nushell.version}";
  nu_version = "0.97.1";

  src = fetchFromGitHub {
    owner = "devyn";
    repo = "nu_plugin_dbus";
    rev = version;
    sha256 = "sha256-XVLX0tCgpf5Vfr00kbQZPWMolzHpkMVYKoBHYylpz48=";
  };

  cargoHash = "sha256-aza+vLCkepDwKGnJeyHSnQmAKrBFIUzn2pZuzoWGhp4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  meta = with lib; {
    description = "A nushell plugin for interacting with dbus";
    license = licenses.mit;
    homepage = "https://github.com/devyn/nu_plugin_dbus";
  };
}

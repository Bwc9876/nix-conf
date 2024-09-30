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
    then "0.11.0"
    else abort "Nushell Version mismatch\nPlugin: ${nu_version}\tnixpkgs: ${nushell.version}";
  nu_version = "0.98.0";

  src = fetchFromGitHub {
    owner = "Canvis-Me";
    repo = "nu_plugin_dbus";
    rev = "main"; # version;
    sha256 = "sha256-CrTVLbD7Q/swDCxiWcqoxkB8X6ydfxhTAZjoT0SoB4I=";
  };

  cargoHash = "sha256-zXcDNvhJPBj18MiKyW+fNmGiHM9Odt90vGa1L0WQ2sE=";

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

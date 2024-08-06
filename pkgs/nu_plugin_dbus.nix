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
  version = assert nushell.version == nu_version || abort "Nushell Version mismatch\nPlugin: ${nu_version}\tnixpkgs: ${nushell.version}"; "0.9.0";
  nu_version = "0.96.1";

  src = fetchFromGitHub {
    owner = "devyn";
    repo = "nu_plugin_dbus";
    rev = version;
    sha256 = "sha256-Bb55IO/qkQRVkPPyS0iYxYUw6qxhWMuaLj9oxK+I1fk=";
  };

  cargoHash = "sha256-JY5mjKx1m9hFWnXo+ej6C0aKuEvSKttHczybHUQIWWs=";

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

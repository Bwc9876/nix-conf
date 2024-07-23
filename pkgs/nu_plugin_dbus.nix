{
  rustPlatform,
  dbus,
  pkg-config,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_dbus";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "devyn";
    repo = "nu_plugin_dbus";
    rev = "c1217b933a4ac7bfaac8d3fd30dbf75fd9a04966";
    sha256 = "sha256-iTZanNEKuNZ+IVV8h3SixktJGg15iG9MIZyeZe7Gpjw=";
  };

  cargoHash = "sha256-Qi5TGaUugH3AjaJsCS0r6g4ebn43HLKc+/mv8ICKH4Q=";

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

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
    then "0.12.0"
    else abort "Nushell Version mismatch\nPlugin: ${nu_version}\tnixpkgs: ${nushell.version}";
  nu_version = "0.99.1";

  src = fetchFromGitHub {
    owner = "devyn";
    repo = "nu_plugin_dbus";
    rev = version;
    sha256 = "sha256-I6FB2Hu/uyA6lBGRlC6Vwxad7jrl2OtlngpmiyhblKs=";
  };

  cargoHash = "sha256-WwdeDiFVyk8ixxKS1v3P274E1wp+v70qCk+rNEpoce4=";

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

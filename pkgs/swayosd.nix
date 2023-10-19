{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook,
  gtk-layer-shell,
  libpulseaudio,
  systemd,
  libevdev,
  libinput,
}:
rustPlatform.buildRustPackage {
  pname = "swayosd";
  version = "unstable-2023-05-09";

  src = fetchFromGitHub {
    owner = "Syndelis";
    repo = "SwayOSD";
    rev = "feat/brightnessctl-backend";
    hash = "sha256-5xb5mGGRQVCWrp3jVtBH12UhY1OVT8nsJaXmhh/C8MU=";
  };

  cargoHash = "sha256-uWV1t8aPrN28NZMehNyOfHQNFftrn3skWhSZQUDaIQ0=";

  nativeBuildInputs = [
    wrapGAppsHook
    pkg-config
  ];

  buildInputs = [
    gtk-layer-shell
    libpulseaudio
    systemd
    libevdev
    libinput
  ];

  meta = with lib; {
    description = "A GTK based on screen display for keyboard shortcuts";
    homepage = "https://github.com/Syndelis/SwayOSD";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [aleksana];
    platforms = platforms.linux;
  };
}

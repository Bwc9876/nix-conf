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
    owner = "ErikReider";
    repo = "SwayOSD";
    rev = "main";
    hash = "sha256-3NJHZv4Ed7haUUmE9JV9Yl4rRnJlPqQFv53Xuw0q+IY=";
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

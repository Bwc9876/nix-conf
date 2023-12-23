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
  version = "unstable-2023-12-22";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayOSD";
    rev = "a0709bcd89d6ca19889486972bac35e69f1fa8e4";
    hash = "sha256-3NJHZv4Ed7haUUmE9JV9Yl4rRnJlPqQFv53Xuw0q+IY=";
  };

  cargoHash = "sha256-2C72FhXhs2wEsqe1P7rhSqa7lbgm2Mih2BBCYuxqrto=";

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

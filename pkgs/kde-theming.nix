{
  runCommand,
  fetchFromGitHub,
}: let
  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "Sweet";
    rev = "Ambar-Blue-Dark";
    hash = "sha256-lWnyIW2BTE3TEGVCeTkfHtZm5kfpbvAQvWm2IEGHB3I=";
  };
  icons-src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "candy-icons";
    rev = "master";
    hash = "sha256-lWnyIW2BTE3TEGVCeTkfHtZm5kfpbvAQvWm2IEGHB3I=";
  };
  bg-src = ../res/pictures/background.jpg;
  pfp-src = ../res/pictures/cow.png;
in
  runCommand "sweet-ambar-blue" {} ''

    # SDDM Theme
    mkdir -p $out/share/sddm/themes/Sweet-Ambar-Blue
    echo $'[General]\nbackground=${bg-src}' > $out/share/sddm/themes/Sweet-Ambar-Blue/theme.conf.user
    cp -r ${src}/kde/sddm/Sweet-Ambar-Blue/* $out/share/sddm/themes/Sweet-Ambar-Blue
    chmod 755 $out/share/sddm/themes/Sweet-Ambar-Blue

    # SDDM PFP
    mkdir -p $out/share/sddm/faces
    cp ${pfp-src} $out/share/sddm/faces/bean.face.icon

    # Plasma Look and Feel
    mkdir -p $out/share/plasma/look-and-feel
    cp -r ${src}/kde/plasma/look-and-feel/Sweet-Ambar-Blue $out/share/plasma/look-and-feel

    # Candy Icons
    mkdir -p $out/share/icons/candy-icons
    cp -r ${icons-src} $out/share/icons/candy-icons

    # Kvantum
    mkdir -p $out/share/Kvantum
    cp -r ${src}/kde/kvantum/Sweet-Ambar-Blue $out/share/Kvantum

    # GTK Themes

    mkdir -p $out/share/themes/Sweet-Ambar-Blue
    cp -r ${src}/gtk-2.0 $out/share/themes/Sweet-Ambar-Blue
    cp -r ${src}/gtk-3.0 $out/share/themes/Sweet-Ambar-Blue
    cp -r ${src}/gtk-4.0 $out/share/themes/Sweet-Ambar-Blue
    cp -r ${src}/assets $out/share/themes/Sweet-Ambar-Blue
    cp -r ${src}/index.theme $out/share/themes/Sweet-Ambar-Blue

    # Konsole Color Scheme
    mkdir -p $out/share/konsole
    cp ${src}/kde/konsole/Sweet-Ambar-Blue.colorscheme $out/share/konsole
  ''

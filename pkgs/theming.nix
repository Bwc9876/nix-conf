{
  gtk3,
  runCommand,
  fetchFromGitHub,
}: let
  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "Sweet";
    rev = "Ambar-Blue";
    hash = "sha256-7hNQ+TocetezMpt4GleHx3L4enOOIC0i8LJV8SDlFM4=";
  };
  icons-src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "candy-icons";
    rev = "master";
    hash = "sha256-yXjhztUWmXMD+40pw0vnUMslxPiog3ZLrSkxcJgpxsU=";
  };
  cursor-src = ../res/Sweet-cursors.tar.xz;
  bg-src = ../res/pictures/background.jpg;
  pfp-src = ../res/pictures/cow.png;
in
  runCommand "sweet-ambar-blue" {} ''

    # Candy Icons
    mkdir -p $out/share/icons/candy-icons
    cp -r ${icons-src}/* $out/share/icons/candy-icons


    # Cursor Theme
    tar -xf ${cursor-src} -C $out/share/icons

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

    ${gtk3}/bin/gtk-update-icon-cache -f -t $out/share/icons/candy-icons
    ${gtk3}/bin/gtk-update-icon-cache -f -t $out/share/icons/Sweet-cursors
  ''

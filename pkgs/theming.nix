{
  gtk3,
  runCommand,
  fetchFromGitHub,
}: let
  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "Sweet";
    rev = "dd2dca053b437dcbcbbce082298d28e07dfb384d";
    hash = "sha256-BbAsnnGZ+qGNW7WdjezqsDIYTlQbg3tTv1CwdkBV9Es=";
  };
  icons-src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "candy-icons";
    rev = "3b36e89485daab8845f5793f9cbd2bc2ae2e303d";
    hash = "sha256-49cegx2moKY8INjSm2AcNo7kKC0vy+Iai3R3k/afywI=";
  };
  cursor-src = ../res/cursors/Sweet-cursors.tar.xz;
  hypr-cursor-src = ../res/cursors/Sweet-cursors-hypr.tar.xz;
in
  runCommand "sweet-ambar-blue" {} ''

    # Candy Icons
    mkdir -p $out/share/icons/candy-icons
    cp -r ${icons-src}/* $out/share/icons/candy-icons
    chmod +w $out/share/icons/candy-icons/apps/scalable
    ln -s -T $out/share/icons/candy-icons/apps/scalable/firefox-developer.svg $out/share/icons/candy-icons/apps/scalable/firefox-devedition.svg

    # Cursor Theme
    tar -xf ${cursor-src} -C $out/share/icons
    tar -xf ${hypr-cursor-src} -C $out/share/icons

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

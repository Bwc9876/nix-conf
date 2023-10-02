{ runCommand, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "Sweet";
    rev = "Ambar-Blue";
    hash = "sha256-uLthKtrC5nQd+jfPH636wVN82q+kEa08QoMprc1gaNs=";
  };
  bg-src = ../background.jpg;
  pfp-src = ../cow.png;
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

  # Konsole Color Scheme
  mkdir -p $out/share/konsole
  cp ${src}/kde/konsole/Sweet-Ambar-Blue.colorscheme $out/share/konsole
''


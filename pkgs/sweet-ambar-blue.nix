{ runCommand, fetchFromGitHub }:

let
  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "Sweet";
    rev = "Ambar-Blue";
    hash = "sha256-uLthKtrC5nQd+jfPH636wVN82q+kEa08QoMprc1gaNs=";
  };
in 
runCommand "sweet-ambar-blue" {} ''
  mkdir -p $out/share/sddm/themes

  cp -r ${src}/kde/sddm/Sweet-Ambar-Blue $out/share/sddm/themes
''

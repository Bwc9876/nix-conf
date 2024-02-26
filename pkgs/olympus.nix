{
  stdenv,
  fetchurl,
  steam-run,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  lib,
  love,
  unzip,
}:
stdenv.mkDerivation rec {
  name = "olympus";
  version = "3958";
  src = fetchurl {
    url = "https://dev.azure.com/EverestAPI/Olympus/_apis/build/builds/${version}/artifacts?artifactName=linux.main&$format=zip";
    sha256 = "sha256-6LCxQ3TScbtyam+Oy2us0oxUETXtZIsfu9IurlPEshw=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    unzip
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "olympus";
      exec = "olympus %u";
      icon = "olympus";
      desktopName = "Olympus";
      categories = ["Game"];
      comment = "Celeste/Evereste Mod Manager";
      mimeTypes = ["x-scheme-handler/everest"];
    })
  ];

  unpackPhase = ''
    unzip $src -d .
    unzip ./linux.main/dist.zip -d ./olympus
  '';

  installPhase = ''
    mkdir -p $out

    copyDesktopItems

    mkdir -p $out/share/icons/hicolor/128x128/apps/
    cp ./olympus/olympus.png $out/share/icons/hicolor/128x128/apps

    mkdir -p $out/share/games/lovegames/
    cp -r olympus $out/share/games/lovegames/

    mkdir -p $out/bin
    makeWrapper ${steam-run}/bin/steam-run $out/bin/olympus \
      --add-flags "${love}/bin/love $out/share/games/lovegames/olympus/olympus.love" \
      --suffix LUA_PATH ";" "$out/share/games/lovegames/?.lua" \
      --suffix LUA_PATH ";" "$out/share/games/lovegames/?.so" \
  '';

  meta = with lib; {
    description = "Cross-platform Celeste Mod Manager";
    homepage = "https://github.com/EverestAPI/Olympus";
    downloadPage = "https://everestapi.github.io/";
    mainProgram = "olympus";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [bwc9876];
  };
}

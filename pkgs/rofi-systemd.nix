{ stdenv, fetchFromGitHub, jq }:

stdenv.mkDerivation {
    name = "rofi-systemd";
    src = fetchFromGitHub {
        owner = "colonelpanic8";
        repo = "rofi-systemd";
        rev = "master";
        sha256 = "sha256-TO9O+4OJMeb+VbQsNwvzKa1UNuP95n36FOiQeIrzUPc=";
    };
    buildInputs = [
        jq
    ];
    installPhase = ''
        mkdir -p $out/bin
        cp $src/rofi-systemd $out/bin
    '';
}

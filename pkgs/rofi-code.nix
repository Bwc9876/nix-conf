{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  go,
  gnumake,
}:
buildGoModule {
  name = "rofi-code";
  src = fetchFromGitHub {
    owner = "Coffelius";
    repo = "rofi-code";
    rev = "master";
    sha256 = "sha256-mfMiraadJRqtMB+4yzeDozDApPAUHnLiTgEgRjPXJqs=";
  };
  vendorHash = "sha256-Yp2tBZWHc/xjp1rpJEAfz8nNo4Wtu66rdwCEkfeLq3I=";
}

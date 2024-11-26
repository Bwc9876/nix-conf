{hostName, ...}: let
  fontSize = "18";
in {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        title = "Terminal (Foot)";
        term = "xterm-256color";
        font = "monospace:size=${fontSize}";
      };
      bell = {
        visual = true;
      };
      cursor = {
        style = "beam";
        blink = true;
      };
    };
  };
}

{pkgs, ...}: let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
  lock-empty-string = {
    Value = "";
    Status = "locked";
  };
in {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    wrapperConfig = {
      pipeWireSupport = true;
    };
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisableSetDesktopBackground = true;
      DontCheckDefaultBrowser = true;
      AppAutoUpdate = false;
      DNSOverHTTPS.Enabled = true;
      ShowHomeButton = true;
      DisplayBookmarksToolbar = "always";
      DisablePocket = true;
      OfferToSaveLoginsDefault = false;
      OverrideFirstRunPage = "";
      NoDefaultBookmarks = true;
      PasswordManagerEnabled = false;
      SearchBar = "unified";

      EnableTrackingProtection = {
        Value= true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      Preferences = {
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
      };
    };
  };
}

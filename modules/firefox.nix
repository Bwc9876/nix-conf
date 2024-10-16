{
  pkgs,
  lib,
  ...
}: {
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
      DisableProfileImport = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      OfferToSaveLoginsDefault = false;
      OverrideFirstRunPage = "";
      NoDefaultBookmarks = true;
      PasswordManagerEnabled = false;
      SearchBar = "unified";
      EncryptedMediaExtensions = true;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };

      Preferences = let
        lock = val: {
          Value = val;
          Status = "locked";
        };
      in {
        # General
        "browser.aboutConfig.showWarning" = lock false;
        "media.eme.enabled" = lock true; # Encrypted Media Extensions (DRM)
        "layout.css.prefers-color-scheme.content-override" = lock 0;
        "browser.startup.page" = 3; # Restore previous session
        "toolkit.telemetry.server" = lock "";

        # New Tab
        "browser.newtabpage.activity-stream.showSponsored" = lock false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock false;
        "browser.newtabpage.activity-stream.feeds.topsites" = lock false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock false;
        "browser.newtabpage.activity-stream.showWeather" = lock false;
        "browser.newtabpage.activity-stream.system.showWeather" = lock false;
        "browser.newtabpage.activity-stream.feeds.weatherfeed" = lock false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = lock false;
        "browser.newtabpage.activity-stream.telemetry" = lock false;
        "browser.newtabpage.activity-stream.telemetry.structuredIngestion.endpoint" = lock "";
        "browser.newtabpage.pinned" = lock [];
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = lock "";
        "browser.urlbar.suggest.weather" = lock false;
        "browser.urlbar.quicksuggest.scenario" = lock "offline";
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = lock false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = lock false;

        # Devtools
        "devtools.theme" = lock "dark";
        "devtools.dom.enabled" = lock true;
        "devtools.command-button-rulers.enabled" = lock true;
        "devtools.command-button-measure.enabled" = lock true;
        "devtools.command-button-screenshot.enabled" = lock true;
        "devtools.toolbox.host" = lock "right";
        "devtools.webconsole.persistlog" = lock true;
        "devtools.webconsole.timestampMessages" = lock true;

        # Privacy
        "dom.private-attribution.submission.enabled" = lock false;
        "privacy.globalprivacycontrol.enabled" = lock true;
      };

      Containers = {
        Testing = {
          name = "Testing 1";
          icon = "pet";
          color = "purple";
        };
        Testing2 = {
          name = "Testing 2";
          icon = "pet";
          color = "green";
        };
      };

      Extensions.Install = map (x: "https://addons.mozilla.org/firefox/downloads/latest/${x}/latest.xpi") [
        # Appearance
        "nicothin-space"
        "darkreader"
        "material-icons-for-github"
        "refined-github-"

        # Security / Privacy
        "privacy-badger17"
        "decentraleyes"
        "canvasblocker"
        "facebook-container"

        ## Ads / Youtube
        "adnauseam"
        "sponsorblock"
        "youtube-shorts-block"
        "dearrow"

        # Information
        "flagfox"
        "awesome-rss"

        # Devtools
        "react-devtools"
        "open-graph-preview-and-debug"
        "wave-accessibility-tool"
        "styl-us"

        # Misc
        "plasma-integration" # integration with MPRIS & KDE Connect
        "keepassxc-browser" # integration with KeepassXC
      ];

      ExtensionSettings."*" = {
        default_area = "menupanel";
      };
    };
  };
}

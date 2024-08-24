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
        "layout.css.prefers-color-scheme.content-override" = 0;
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
        "devtools.dom.enabled" = true;
        "devtools.command-button-rulers.enabled" = true;
        "devtools.command-button-measure.enabled" = true;
        "devtools.command-button-screenshot.enabled" = true;
        "devtools.toolbox.host" = "right";
        "devtools.webconsole.persistlog" = true;
        "devtools.webconsole.timestampMessages" = true;

        # Privacy
        "dom.private-attribution.submission.enabled" = lock false;
        "privacy.globalprivacycontrol.enabled" = lock true;

        # UI Customization
        ## TODO: Derive this from extensions?
        "browser.uiCustomizationState" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["jid1-mnnxcxisbpnsxq_jetpack-browser-action","sponsorblocker_ajay_app-browser-action","dearrow_ajay_app-browser-action","adnauseam_rednoise_org-browser-action","_contain-facebook-browser-action","_34daeb50-c2d2-4f14-886a-7160b24d66a4_-browser-action","_a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad_-browser-action","_eac6e624-97fa-4f28-9d24-c06c9b8aa713_-browser-action","canvasblocker_kkapsner_de-browser-action","plasma-browser-integration_kde_org-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","home-button","urlbar-container","save-to-pocket-button","downloads-button","developer-button","keepassxc-browser_keepassxc_org-browser-action","addon_darkreader_org-browser-action","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["firefox-view-button","tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["personal-bookmarks","_react-devtools-browser-action","_6e262423-d612-4f29-be6e-e83aa641645d_-browser-action","screenshot-button"]},"seen":["developer-button","profiler-button","_6e262423-d612-4f29-be6e-e83aa641645d_-browser-action","_contain-facebook-browser-action","_34daeb50-c2d2-4f14-886a-7160b24d66a4_-browser-action","_a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad_-browser-action","_eac6e624-97fa-4f28-9d24-c06c9b8aa713_-browser-action","canvasblocker_kkapsner_de-browser-action","plasma-browser-integration_kde_org-browser-action","addon_darkreader_org-browser-action","keepassxc-browser_keepassxc_org-browser-action","_react-devtools-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action","sponsorblocker_ajay_app-browser-action","dearrow_ajay_app-browser-action","adnauseam_rednoise_org-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","unified-extensions-area","toolbar-menubar","TabsToolbar"],"currentVersion":20,"newElementCount":6}'';
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

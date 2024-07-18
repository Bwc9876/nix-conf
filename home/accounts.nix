{...}: {
  programs.thunderbird = {
    enable = true;
    profiles.bean.isDefault = true;
    settings = {
      "privacy.donottrackheader.enabled" = true;
      "mail.shell.checkDefaultClient" = false;
      "messenger.options.messagesStyle.variant" = "Dark";
      "mailnews.message_display.disable_remote_image" = false;
      "browser.aboutConfig.showWarning" = false;
      "browser.newtabpage.enabled" = false;
      "extensions.getAddons.showPane" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "datareporting.policy.dataSubmissionPolicyBypassNotification" = true;
      "datareporting.healthreport.uploadEnabled" = false;
      "toolkit.telemetry.unified" = true;
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.coverage.opt-out" = true;
      "toolkit.coverage.opt-out" = true;
      "toolkit.coverage.endpoint.base" = "";
      "browser.ping-centre.telemetry" = false;
      "app.shield.optoutstudies.enabled" = false;
      "app.normandy.enabled" = false;
      "mail.rights.override" = true;
      "app.donation.eoy.version.viewed" = 999;
      "browser.formfill.enable" = false;
      "signon.autofillForms" = false;
      "privacy.sanitize.sanitizeOnShutdown" = true;
      "privacy.resistFingerprinting" = true;
    };
  };

  accounts.email = {
    maildirBasePath = ".mail";

    accounts.personal = rec {
      primary = true;
      flavor = "gmail.com";
      address = "bwc9876@gmail.com";
      userName = address;
      realName = "Ben C";
      aliases = [
        "bwc9876@outerwildsmods.com"
      ];
      signature = {
        text = ''
          ${realName}
          https://bwc9876.dev
        '';
        showSignature = "append";
      };
      thunderbird = {
        enable = true;
        # OAuth2
        settings = id: {
          "mail.smtpserver.smtp_${id}.authMethod" = 10;
          "mail.server.server_${id}.authMethod" = 10;
        };
      };
    };
  };
}

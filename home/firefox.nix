{
  pkgs,
  lib,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    profiles.dev-edition-default.search = {
      force = true;
      default = "DuckDuckGo";
      engines = let
        mkEngineForceFavicon = aliases: queryUrl: iconUrl: {
          definedAliases = aliases;
          iconUpdateURL = iconUrl;
          urls = [{template = queryUrl;}];
        };
        mkEngine = aliases: queryUrl: iconExt: (
          mkEngineForceFavicon aliases queryUrl (let
            noPath =
              lib.strings.concatStrings
              (
                lib.strings.intersperse "/"
                (
                  lib.lists.take 3
                  (lib.strings.splitString "/" queryUrl)
                )
              );
          in "${noPath}/favicon.${iconExt}")
        );
      in {
        # Dev
        "GitHub Repos" = mkEngineForceFavicon ["@gh" "@github"] "https://github.com/search?type=repositories&q={searchTerms}" "https://github.githubassets.com/favicons/favicon-dark.svg";
        "SourceGraph" = mkEngine ["@sg" "@sourcegraph"] "https://sourcegraph.com/search?q={searchTerms}" "png";

        ## Web
        "MDN Web Docs" = mkEngine ["@mdn"] "https://developer.mozilla.org/en-US/search?q={searchTerms}" "ico";
        "Web.Dev" = mkEngineForceFavicon ["@webdev" "@lighthouse"] "https://web.dev/s/results?q={searchTerms}" "https://www.gstatic.com/devrel-devsite/prod/vc7080045e84cd2ce1faf7f7a3876037748d52d088e5100df2e949d051a784791/web/images/favicon.png";
        "Can I Use" = mkEngineForceFavicon ["@ciu" "@baseline"] "https://caniuse.com/?search={searchTerms}" "https://caniuse.com/img/favicon-128.png";
        "NPM" = mkEngineForceFavicon ["@npm"] "https://www.npmjs.com/search?q={searchTerms}" "https://static-production.npmjs.com/3dc95981de4241b35cd55fe126ab6b2c.png";
        "Iconify" = mkEngine ["@iconify" "@icons"] "https://icon-sets.iconify.design/?query={searchTerms}" "ico";
        "Astro" = mkEngineForceFavicon ["@astro"] "https://a.stro.cc/{searchTerms}" "https://docs.astro.build/favicon.svg";
        "Porkbun" = mkEngine ["@porkbun"] "https://porkbun.com/checkout/search?q={searchTerms}" "ico";
        "Http.Cat" = mkEngine ["@cat" "@hcat" "@httpcat"] "https://http.cat/{searchTerms}" "ico";

        ## Rust
        "Crates.io" = mkEngine ["@crates" "@cratesio" "@cargo"] "https://crates.io/search?q={searchTerms}" "ico";
        "Rust Docs" = mkEngineForceFavicon ["@rust" "@rustdocs" "@ruststd"] "https://doc.rust-lang.org/std/index.html?search={searchTerms}" "https://doc.rust-lang.org/static.files/favicon-2c020d218678b618.svg";
        "Docsrs" = mkEngine ["@docsrs"] "https://docs.rs/releases/search?query={searchTerms}" "ico";

        ## Python
        "PyPI" = mkEngineForceFavicon ["@pypi" "@pip"] "https://pypi.org/search/?q={searchTerms}" "https://pypi.org/static/images/favicon.35549fe8.ico";

        ## .NET
        "NuGet" = mkEngine ["@nuget"] "https://www.nuget.org/packages?q={searchTerms}" "ico";

        ## Linux Stuff
        "Kernel Docs" = mkEngine ["@lnx" "@linux" "@kernel"] "https://www.kernel.org/doc/html/latest/search.html?q={searchTerms}" "ico";
        "Arch Wiki" = mkEngine ["@aw" "@arch"] "https://wiki.archlinux.org/index.php?title=Special%3ASearch&search={searchTerms}" "ico";
        "Nerd Fonts" = mkEngineForceFavicon ["@nf" "@nerdfonts"] "https://www.nerdfonts.com/cheat-sheet?q={searchTerms}" "https://www.nerdfonts.com/assets/img/favicon.ico";

        ### Nix
        "Nix Packages" = mkEngine ["@nixpkgs"] "https://search.nixos.org/packages?channel=unstable&size=500&query={searchTerms}" "png";
        "NixOS Options" = mkEngine ["@nixos"] "https://search.nixos.org/options?channel=unstable&size=500&query={searchTerms}" "png";
        "NixOS Wiki" = mkEngine ["@nixwiki"] "https://nixos.wiki/index.php?search={searchTerms}" "png";
        "Home Manager Options" = mkEngineForceFavicon ["@hm"] "https://home-manager-options.extranix.com/?release=master&query={searchTerms}" "https://home-manager-options.extranix.com/images/favicon.png";
        "Noogle" = mkEngine ["@noogle" "@nixlib"] "https://noogle.dev/q?limit=100&term={searchTerms}" "png";
        "SourceGraph Nix" = mkEngine ["@sgn" "@yoink"] "https://sourcegraph.com/search?q=lang:Nix+-repo:NixOS/*+-repo:nix-community/*+{searchTerms}" "png";
        "Nixpkgs Issues" = mkEngineForceFavicon ["@nixissues"] "https://github.com/NixOS/nixpkgs/issues?q=sort%3Aupdated-desc+is%3Aissue+is%3Aopen+{searchTerms}" "https://github.githubassets.com/favicons/favicon-dark.svg";

        # Media
        "YouTube" = mkEngine ["@yt"] "https://www.youtube.com/results?search_query={searchTerms}" "ico";
        "Spotify" = mkEngineForceFavicon ["@sp" "@spotify"] "https://open.spotify.com/search/{searchTerms}" "https://open.spotifycdn.com/cdn/images/favicon16.1c487bff.png";
        "Netflix" = mkEngine ["@nfx"] "https://www.netflix.com/search?q={searchTerms}" "ico";
        "IMDb" = mkEngine ["@imdb"] "https://www.imdb.com/find?q={searchTerms}" "ico";

        # Misc
        "Firefox Add-ons" = mkEngine ["@addons"] "https://addons.mozilla.org/en-US/firefox/search/?q={searchTerms}" "ico";
        "Urban Dictionary" = mkEngine ["@ud" "@urban"] "https://www.urbandictionary.com/define.php?term={searchTerms}" "ico";

        # Overrides
        "History".metaData.alias = "@h";
        "Bookmarks".metaData.alias = "@b";
        "Tabs".metaData.alias = "@t";
        "Bing".metaData.hidden = true;
        "Amazon.com".metaData.alias = "@amz";
        "Google".metaData.alias = "@g";
        "Wikipedia (en)".metaData.alias = "@w";
      };
    };
  };
}

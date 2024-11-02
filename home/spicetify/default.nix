{ inputs, pkgs, config, ... }:
let
  colors = config.lib.stylix.colors;
in
{

  imports = [ inputs.spicetify-nix.homeManagerModules.default ];
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        betterGenres
        fullAlbumDate
        songStats
        copyToClipboard
        copyLyrics
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        ncsVisualizer
      ];
      enabledSnippets = with spicePkgs.snippets; [
        pointer
      ];

      # colorScheme = "custom";
      # customColorScheme = with colors; {
      #   "text"               = "${base05}";
      #   "subtext"            = "${base04}";
      #   "nav-active-text"    = "${bright-orange}";
      #   "main"               = "${base00}";
      #   "sidebar"            = "${base01}";
      #   "player"             = "${base02}";
      #   "card"               = "${base00}";
      #   "shadow"             = "${base02}";
      #   "main-secondary"     = "${base01}";
      #   "button"             = "${brown}";
      #   "button-secondary"   = "${bright-cyan}";
      #   "button-active"      = "${orange}";
      #   "button-disabled"    = "${base0D}";
      #   "nav-active"         = "${bright-magenta}";
      #   "play-button"        = "${bright-green}";
      #   "tab-active"         = "${yellow}";
      #   "notification"       = "${blue}";
      #   "notification-error" = "${red}";
      #   "playback-bar"       = "${bright-red}";
      #   "misc"               = "${bright-magenta}";
      # };
      
    };

}

{ config, pkgs, settings, ... }:
let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  programs.rofi = {
    enable = true;
    package = if settings.wm == "bspwm"
              then pkgs.rofi else pkgs.rofi-wayland;
  };

  home.file = {
    "./.config/rofi/config.rasi".source = ./config.rasi;
    "./.config/rofi/applauncher.rasi".source = ./applauncher.rasi;
  };

  xdg.configFile."rofi/colors.rasi".text = ''
      * {
          background:                 ${colors.base00};
          background-alt:             ${colors.base01};
          border:                     ${colors.base0E};
          foreground:                 ${colors.base05};
          accent:                     ${colors.base0D};

          text-color:                 @fg;
          javacafe-blue:              ${colors.base0A};

          font:                       "${settings.font} Nerd Font 12";
      }
  '';

}

{ config, pkgs, settings, ... }:
{
  programs.rofi = {
    enable = true;
    package = if settings.wm == "bspwm"
              then pkgs.rofi else pkgs.rofi-wayland;
  };
  home.file = {
    "./.config/rofi/config.rasi".source = ./config.rasi;
    "./.config/rofi/applauncher.rasi".source = ./applauncher.rasi;
    "./.config/rofi/colors.rasi".source = ./colors.rasi;
  };

}

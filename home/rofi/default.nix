{ config, pkgs, ... }:
{

  home.file = {
    "./config/rofi/config.rasi".source = ./config.rasi;
    "./config/rofi/applauncher.rasi".source = ./applauncher.rasi;
    "./config/rofi/colors.rasi".source = ./colors.rasi;
  };

}

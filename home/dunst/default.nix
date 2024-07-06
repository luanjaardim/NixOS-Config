{ config, pkgs, ... }:
{

  home.file = {
    "./.config/dunst/dunstrc".source = ./dunstrc;
    "./.config/dunst/imgs" = {
      source = ./imgs;
      recursive = true;
    };
  };

}

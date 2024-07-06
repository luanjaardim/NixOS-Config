{ config, pkgs, ... }:
{

  home.file = {
    "./.config/eww/eww.yuck".source = ./eww.yuck;
    "./.config/eww/eww.scss".source = ./eww.scss;
    "./.config/eww/scripts" = {
      source = ./scripts;

      # import every script in the folder
      recursive = true;
      # make them executable
      executable = true;
    };
    "./.config/eww/scss" = {
      source = ./scss;
      recursive = true;
    };
    "./.config/eww/src" = {
       source = ./src;
       recursive = true;
    };
    "./.config/eww/bar" = {
       source = ./bar;
       recursive = true;
    };
    "./.config/eww/panel" = {
       source = ./panel;
       recursive = true;
    };
  };

}

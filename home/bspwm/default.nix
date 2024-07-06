{ config, pkgs, ... }:
{

  home.file = {
    "./config/bspwm/bspwmrc".source = ./bspwmrc;
    "./config/bspwm/scripts" = {
      source = ./scripts;
      recursive = true;
      executable = true;
    };
  };

}

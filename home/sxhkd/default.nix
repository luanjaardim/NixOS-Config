{ config, pkgs, ... }:
{

  home.file = {
    "./.config/sxhkd/sxhkdrc".source = ./sxhkdrc;
    "./.config/sxhkd/scripts" = {
      source = ./scripts;
      recursive = true;
      executable = true;
    };
  };

}

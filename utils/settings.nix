{ pkgs, ... }:

{
  user = "jaardim";
  hostname = "nixos";
  system = "x86_64-linux";
  wm = "hypr";         # bspwm or hypr
  prompt = "pure.toml"; # look at ../home/starship/presets/
  shell = pkgs.nushell;
  cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };
}

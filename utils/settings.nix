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
  font = "FiraCode";
  theme = "catppuccin-mocha";
  wallpaper = ./../home/wallpaper.jpg;
  image = pkgs.runCommand "dimmed-background.png" { } ''
      ${pkgs.imagemagick}/bin/convert "${wallpaper}" -brightness-contrast -30,0 -fill "black" $out
  '';
}

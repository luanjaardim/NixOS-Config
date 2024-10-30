{ pkgs, config, settings, ... }:

let
  res = import ../../utils/apply-theme-to-wallpaper.nix { inherit pkgs config settings; };
in
{
  stylix = {
    enable = true;
    image = res.image;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${settings.theme}.yaml";
    cursor = { inherit (settings.cursor) name package size; };
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "${settings.font}" ]; };
        name = "${settings.font} Nerd Font Mono";
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
  };
}

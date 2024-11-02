{ pkgs, config, settings, ... }:

let
  res = import ../../utils/apply-theme-to-wallpaper.nix { inherit pkgs config settings; };
in
{
  stylix = {
    enable = true;
    polarity = "dark";
    image = res.image;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${settings.theme}.yaml";
    cursor = { inherit (settings.cursor) name package size; };
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "${settings.font}" ]; };
        name = "${settings.font} Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.nerdfonts.override { fonts = [ "${settings.font}" ]; };
        name = "${settings.font} Nerd Font Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      emoji = config.stylix.fonts.monospace;
    };
    targets = {
      fzf.enable = true;
      btop.enable = true;
      firefox.enable = true;
      gtk.enable = true;
      kitty.enable = true;
      nixvim.enable = true;
      nixvim.plugin = "base16-nvim";
      nixvim.transparentBackground.main = true;
      nixvim.transparentBackground.signColumn = true;
      nushell.enable = true;
      spicetify.enable = true;
      yazi.enable = true;
      zathura.enable = true;
      # hyprland.enable = true;
    };
  };
}

{ pkgs, config, settings }:

let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  image = pkgs.runCommand "apply-theme-to-wallpaper" { } ''
    ${pkgs.imagemagick}/bin/magick -size 16x1 \
    xc:'${colors.base00}' \
    xc:'${colors.base01}' \
    xc:'${colors.base02}' \
    xc:'${colors.base03}' \
    xc:'${colors.base04}' \
    xc:'${colors.base05}' \
    xc:'${colors.base06}' \
    xc:'${colors.base07}' \
    xc:'${colors.base08}' \
    xc:'${colors.base09}' \
    xc:'${colors.base0A}' \
    xc:'${colors.base0B}' \
    xc:'${colors.base0C}' \
    xc:'${colors.base0D}' \
    xc:'${colors.base0E}' \
    xc:'${colors.base0F}' \
    +append miff:- | ${pkgs.imagemagick}/bin/magick ${settings.wallpaper} -remap miff:- $out
  '';
}


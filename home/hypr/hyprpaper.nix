{ pkgs, config, settings, ... }:

let
    res = import ../../utils/apply-theme-to-wallpaper.nix { inherit pkgs config settings; };
in
{
    services.hyprpaper = {
        enable = true;
        settings = {
            splash = false;

            preload = [ res.image ];

            wallpaper = [
              "eDP-1,${res.image}"
              "HDMI-A-1,${res.image}"
            ];
        };
    };
}

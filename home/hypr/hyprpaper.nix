{ settings, ... }:

{
    services.hyprpaper = {
        enable = true;
        settings = {
            splash = false;

            preload = [ settings.image ];

            wallpaper = [
              "eDP-1,${settings.image}"
              "HDMI-A-1,${settings.image}"
            ];
        };
    };
}

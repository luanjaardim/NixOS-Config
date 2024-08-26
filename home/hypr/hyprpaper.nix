{ ... }:

{
    services.hyprpaper = {
        enable = true;
        settings = {
            splash = false;

            preload =
              [ "/home/jaardim/pictures/wallpaper.png" ];

            wallpaper = [
              "eDP-1,/home/jaardim/pictures/wallpaper.png"
              "HDMI-A-1,/home/jaardim/pictures/wallpaper.png"
            ];
        };
    };
}

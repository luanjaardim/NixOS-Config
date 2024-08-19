{ ... }:

{
    services.hyprpaper = {
        enable = true;
        settings = {
            splash = false;

            preload =
              [ "/home/jaardim/pictures/wallpaper.png" ];

            wallpaper = [
              "DP-3,/home/jaardim/pictures/wallpaper.png"
              "DP-1,/home/jaardim/pictures/wallpaper.png"
            ];
        };
    };
}

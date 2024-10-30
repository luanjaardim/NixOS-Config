{ config, pkgs, settings, ... }:

{

  imports = [
    ./hyprpaper.nix
  ];

  home.packages = with pkgs; [

    # Hyprland programs
    hyprpaper
    wl-clipboard
    wayland-utils
    wayland-protocols
    wlroots
    meson
    # Screenshot
    grim
    slurp
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
        exec-once = [
            "hyprpaper &"
            # "eww daemon ; eww open bar ; sleep 1sec ; eww open workspace"
            "ags"
        ];

        general = {
            "$mod" = "SUPER";
            "$terminal" = "kitty";
            "$file-manager" = "yazi";
            "$sys_monitor" = "btop";
            # "$menu" = "rofi -show drun";
            "$menu" = "ags -t applauncher";
            "$actions" = "ags -t utilities_btns";
            gaps_in = 3;
            gaps_out = 5;
            no_focus_fallback = true;
            resize_on_border = true;
            layout = "master";
            no_border_on_floating = true;
        };

        input = {
            kb_layout = "us,br";
            kb_options="grp:toggle";
            follow_mouse = 1;
            touchpad = {
                natural_scroll = "no";
                # right click with two fingers press
                clickfinger_behavior = true;
            };
        };

        cursor = {
            no_warps = true;
        };

        decoration = {
            rounding = 5;
            blur = {
                enabled = true;
                size = 10;
                passes = 2;
            };
            active_opacity = 0.92;
            inactive_opacity = 0.87;

            drop_shadow = false;
        };

        animations = {
            enabled = true;
            # ...
        };

        misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
        };

        # Bindings for keyboard
        bind = [
            "$mod, RETURN, exec, $terminal"
            "$mod, Y, exec, kitty $file-manager"
            "$mod, B, exec, kitty $sys_monitor"
            "$mod, SPACE, exec, $menu"
            "$mod SHIFT, SPACE, exec, $actions"
            "$mod, Q, killactive"
            "$mod, M, exit"
            "$mod, S, togglefloating"
            "$mod, F, fullscreen"

            # Move focus to neighbour window
            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, k, movefocus, u"
            "$mod, j, movefocus, d"

            # Switch windows positions
            "$mod SHIFT, h, swapwindow, l"
            "$mod SHIFT, l, swapwindow, r"
            "$mod SHIFT, k, swapwindow, u"
            "$mod SHIFT, j, swapwindow, d"

            # Increase window size
            "$mod ALT, h, resizeactive, -10 0"
            "$mod ALT, l, resizeactive, 10 0"
            "$mod ALT, k, resizeactive, 0 -10 "
            "$mod ALT, j, resizeactive, 0 10"

            # Decrease window size
            "$mod ALT SHIFT, h, resizeactive, 10 0"
            "$mod ALT SHIFT, l, resizeactive, -10 0"
            "$mod ALT SHIFT, k, resizeactive, 0 10 "
            "$mod ALT SHIFT, j, resizeactive, 0 -10"

            ] ++
            # Generating move to workspace and send window to workspace
            (builtins.concatLists (
                builtins.genList (x:
                   let
                    ws = builtins.toString (x+1);
                   in
                   [ "$mod, ${ws}, workspace, ${ws}"
                   "$mod SHIFT, ${ws}, movetoworkspace, ${ws}" ])
                5)) ++ [

            #Brigthness
            ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
            ",XF86MonBrightnessUp,exec,brightnessctl set +5%"

            #Audio
            ",XF86AudioRaiseVolume,exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume,exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"

            #Screenshot
            ''
            $mod, Print, exec, grim -g "$(slurp)" "$HOME/pictures/screenshots/$(date '+%y%m%d_%H-%M-%S').png"
            ''
            '', Print, exec, grim -g "$(slurp)" - | wl-copy''
        ];

        # Bindings for mouse
        bindm = [
            # Move window with left button
            "$mod, mouse:272, movewindow"
            # Resize window with right button
            "SUPER_CTRL, mouse:272, resizewindow"
        ];

    };

    extraConfig = ''
      monitor=eDP-1,preferred,auto,1.2
      monitor=HDMI-A-1,preferred,-1360x0,auto

      # Some default env vars.
      env = XCURSOR_SIZE,${builtins.toString settings.cursor.size}
      env = QT_QPA_PLATFORMTHEME,qt5ct # change to qt6ct if you have that
      gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = on
          workspace_swipe_forever = true
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device {
          name = epic-mouse-v1
          sensitivity = -0.5
      }

      # Blur windows of eww that has the namespace 'eww'
      layerrule = blur, eww
      layerrule = ignorezero, eww

      windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.
      windowrule = opacity 0.8 0.7, ^("$terminal")$
      windowrule = opacity 0.8 0.7, ^("$terminal")$

      xwayland {
        force_zero_scaling = true
      }
    '';

  };
}

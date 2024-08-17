{ config, pkgs, settings, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
        exec-once = [
            #"set wallpaper here..."
        ];

        general = {
            "$mod" = "SUPER";
            "$terminal" = "kitty";
            "$file-manager" = "yazi";
            "$sys_monitor" = "btop";
            "$menu" = "rofi -show drun";
            gaps_in = 3;
            gaps_out = 5;
            no_focus_fallback = true;
            resize_on_border = true;
            layout = "master";
            no_border_on_floating = true;
            "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = "rgba(595959aa)";
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

        decoration = {
            rounding = 5;
            blur = {
                enabled = true;
                size = 7;
                passes = 1;
            };
            active_opacity = 0.97;
            inactive_opacity = 0.90;

            drop_shadow = true;

            shadow_ignore_window = true;
            shadow_offset = "0 2";
            shadow_range = 20;
            shadow_render_power = 3;
            "col.shadow" = "rgba(00000055)";
        };

        animations = {
            enabled = true;
            # ...
        };

        # Bindings for keyboard
        bind = [
            "$mod, RETURN, exec, $terminal"
            "$mod, Y, exec, $file-manager"
            "$mod, B, exec, $sys_monitor"
            "$mod, SPACE, exec, $menu"
            "$mod, Q, killactive"
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
                9)) ++ [

            #Brigthness
            ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
            ",XF86MonBrightnessUp,exec,brightnessctl set +5%"

            #Audio
            ",XF86AudioRaiseVolume,exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume,exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"

            #Screenshot
            ''
            $mod, Print, exec, grim -g "$(slurp -d)" "$HOME/pictures/screenshots/$(date '+%y%m%d_%H-%M-%S').png"
            ''
            '', Print, exec, grim -g "$(slurp -d)" - | wl-copy''
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
      monitor=,preferred,auto,auto

      # Some default env vars.
      env = XCURSOR_SIZE,24
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

      windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.

      xwayland {
        force_zero_scaling = true
      }
    '';

  };
}

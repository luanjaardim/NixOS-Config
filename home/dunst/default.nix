{ config, pkgs, settings, ... }:

{
  home.file = {
    "./.config/dunst/imgs" = {
      source = ./imgs;
      recursive = true;
    };
  };

  xdg.configFile."dunst/dunstrc".text = ''
  [global]
      monitor = 0
      follow = keyboard
      # width = (0, 300)
      width = (200, 500)
      height = 300
      origin = top-right
      offset = 10x50
      scale = 0
      notification_limit = 5
      progress_bar = true
      progress_bar_height = 10
      progress_bar_frame_width = 1
      progress_bar_min_width = 150
      progress_bar_max_width = 300
      progress_bar_corner_radius = 0
      progress_bar_corners = all
      icon_corner_radius = 0
      icon_corners = all
      indicate_hidden = yes
      transparency = 10
      separator_height = 2
      padding = 8
      horizontal_padding = 8
      text_icon_padding = 0
      frame_width = 3
      frame_color = "#aaaaaa"
      gap_size = 5
      separator_color = frame
      sort = yes
      font = ${settings.font} Nerd Font 15
      line_height = 0
      markup = full
      format = "<b>%s</b>\n%b"
      alignment = left
      vertical_alignment = center
      show_age_threshold = 60
      ellipsize = middle
      ignore_newline = no
      stack_duplicates = false
      hide_duplicate_count = false
      show_indicators = yes
      enable_recursive_icon_lookup = true
      icon_theme = Adwaita
      icon_position = left
      min_icon_size = 32
      max_icon_size = 80
      icon_path = /usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/
      sticky_history = yes
      history_length = 20
      dmenu = /usr/bin/dmenu -p dunst:
      browser = /usr/bin/xdg-open
      always_run_script = true
      title = Dunst
      class = Dunst
      corner_radius = 5
      corners = all
      ignore_dbusclose = false
      force_xwayland = false
      force_xinerama = false
      mouse_left_click = close_current
      mouse_middle_click = do_action, close_current
      mouse_right_click = close_all
      per_monitor_dpi = false

  [urgency_low]
      # IMPORTANT: colors have to be defined in quotation marks.
      # Otherwise the "#" and following would be interpreted as a comment.
      background = "#101419"
      foreground = "#888888"
      timeout = 3
      # Icon for notifications with low urgency, uncomment to enable
      #default_icon = /path/to/icon

  [urgency_normal]
      background = "#101419"
      foreground = "#ffffff"
      timeout = 3
      override_pause_level = 30
      # Icon for notifications with normal urgency, uncomment to enable
      #default_icon = /path/to/icon

  [urgency_critical]
      background = "#101419"
      foreground = "#ffffff"
      frame_color = "#ED333B"
      timeout = 0
      override_pause_level = 60
      # Icon for notifications with critical urgency, uncomment to enable
      #default_icon = /path/to/icon
      '';

}

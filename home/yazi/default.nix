{ ... }:

{
  programs.yazi = {
    enable = true;
    keymap.manager.append_keymap = [
      { on = [ "<C-t>" ]; run = "shell fish --block --confirm"; desc = "Drop into a shell, quit it to go back to yazi"; }
    ];
    settings = {
       log = {
         enabled = false;
       };
       manager = {
         sort_by = "natural";
         sort_reverse = false;
         show_hidden = true;
         show_symlink = true;
         sort_dir_first = false;
         linemode = "size";
         mouse_events = [ "click" "scroll" "drag" ];
       };
       opener = {
         edit = [
           { run = "nvim \"$@\""; desc = "$EDITOR"; block = true; for = "unix"; }
         ];
         open = [
           { run = "xdg-open \"$@\""; desc = "Open"; for = "linux"; }
         ];
         play = [
           { run = "vlc \"$@\""; orphan = true; for = "unix"; }
         ];
       };
       open.append_rules = [
         { name = "*/"; use = [ "edit" "open" "reveal" ]; }
         { mime = "text/*";          use = [ "edit" "reveal" ]; }
         { mime = "image/*";         use = [ "open" "reveal" ]; }
         { mime = "{audio,video}/*"; use = [ "play" "reveal" ]; }
       ];
     };

  };
}

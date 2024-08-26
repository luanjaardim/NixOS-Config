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
         sort_by = "alphabetically";
         sort_reverse = false;
         show_hidden = true;
         show_symlink = true;
         sort_dir_first = false;
       };
     };

  };
}

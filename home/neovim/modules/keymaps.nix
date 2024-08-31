{ ... }:

{
  programs.nixvim = {
    keymaps = [
      { # Ctrl + c to exit insert mode
        mode = "n";
        key = "<C-c>";
        action = "<Esc>";
      }
      { # Ctrl + s to save
        mode = "n";
        key = "<C-s>";
        action = "<cmd>w<CR>";
      }
      { # Ctrl + q to quit
        mode = "n";
        key = "<C-q>";
        action = "<cmd>q<CR>";
      }
    ];
  };
}

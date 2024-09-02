{ ... }:

{
  programs.nixvim = {
    keymaps = [
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
      { # Ctrl + j move to the window below
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
      }
      { # Ctrl + h move to the left window
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
      }
      { # Ctrl + k move to the window above
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
      }
      { # Ctrl + l move to the window at right
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
      }
      { # Ctrl + t to open a new tab
        mode = "n";
        key = "<C-t>";
        action = "<cmd>tabe<CR>";
      }
      { # Esc to go to Normal mode when in the terminal
        mode = "t";
        key = "<Esc>";
        action = "<C-\\><C-n><C-\\><C-n>";
      }
      { # Toggle NetRW (file explorer)
        mode = "n";
        key = "<M-e>";
        action = "<cmd>ToggleNetRW<CR>"; # This command was overwritten in config
      }
      { # Open Noegit
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>Neogit<CR>";
      }

    ] ++ (builtins.concatLists (
      builtins.genList (x:
         let
          ws = builtins.toString (x+1);
         in
         [ {
            mode = "n";
            key = "<M-${ws}>";
            action = "${ws}gt<CR>";
         } ])
      9));
  };
}

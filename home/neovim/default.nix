{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim 

    ./modules/lsp.nix
    ./modules/telescope.nix
    ./modules/cmp.nix
    ./modules/keymaps.nix
    ./modules/mini.nix

  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorschemes = {
      # https://nix-community.github.io/nixvim/colorschemes/tokyonight/index.html
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#globals
    globals = {
      # Set <space> as the leader key
      # See `:help mapleader`
      mapleader = " ";
      maplocalleader = " ";

      # Set to true if you have a Nerd Font installed and selected in the terminal
      have_nerd_font = true;
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#opts
    opts = {
      # Show line numbers
      number = true;
      # You can also add relative line numbers, to help with jumping.
      #  Experiment for yourself to see if you like it!
      relativenumber = true;

      # Enable mouse mode, can be useful for resizing splits for example!
      mouse = "a";

      # Don't show the mode, since it's already in the statusline
      showmode = false;

      # Sync clipboard between OS and Neovim
      #  Remove this option if you want your OS clipboard to remain independent.
      #  See `:help 'clipboard'`
      clipboard = "unnamedplus";

      # Enable break indent
      breakindent = true;

      # Save undo history
      undofile = true;

      # Case-insensitive searching UNLESS \C or one or more capital letters in search term
      ignorecase = true;
      smartcase = true;

      # Keep signcolumn on by default
      signcolumn = "yes";

      # Decrease update time
      updatetime = 250;

      # Decrease mapped sequence wait time
      # Displays which-key popup sooner
      timeoutlen = 300;

      # Configure how new splits should be opened
      splitright = true;
      splitbelow = true;

      # Sets how neovim will display certain whitespace characters in the editor
      #  See `:help 'list'`
      #  See `:help 'listchars'`
      list = true;
      # NOTE: .__raw here means that this field is raw lua code
      listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

      # Preview subsitutions live, as you type!
      inccommand = "split";

      # Show which line your cursor is on
      cursorline = true;

      # Minimal number of screen lines to keep above and below the cursor
      scrolloff = 10;

      # Set highlight on search, but clear on pressing <Esc> in normal mode
      hlsearch = true;
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
    autoGroups = {
      kickstart-highlight-yank = {
        clear = true;
      };
    };

    # [[ Basic Autocommands ]]
    #  See `:help lua-guide-autocommands`
    # https://nix-community.github.io/nixvim/NeovimOptions/autoCmd/index.html
    autoCmd = [
      # Highlight when yanking (copying) text
      #  Try it with `yap` in normal mode
      #  See `:help vim.highlight.on_yank()`
      {
        event = ["TextYankPost"];
        desc = "Highlight when yanking (copying) text";
        group = "kickstart-highlight-yank";
        callback.__raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      }
    ];

    plugins = {
      # Detect tabstop and shiftwidth automatically
      # https://nix-community.github.io/nixvim/plugins/sleuth/index.html
      sleuth.enable = true;

      # "gc" to comment visual regions/lines
      # https://nix-community.github.io/nixvim/plugins/comment/index.html
      comment.enable = true;

      nvim-autopairs.enable = true;
      indent-blankline.enable = true;
      treesitter.enable = true;
      nvim-ufo.enable = true;
      nvim-colorizer.enable = true;
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = {text = "+";};
            change = {text = "~";};
            delete = {text = "_";};
            topdelete = {text = "‾";};
            changedelete = {text = "~";};
          };
        };
      };
      neogit.enable = true;
      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          float_opts = {
            border = "curved";
          };
          open_mapping = "[[<M-t>]]";
        };
      };
      # TODO: Add neo-tree: https://github.com/JMartJonesy/kickstart.nixvim/blob/main/plugins/kickstart/plugins/neo-tree.nix
      lint = {
        enable = true;
        lintersByFt = {
          nix = ["nix"];
          # ...
        };
      };


      # Highlight todo, notes, etc in comments
      # https://nix-community.github.io/nixvim/plugins/todo-comments/index.html
      todo-comments = {
        enable = true;
        signs = true;
      };

    };

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraplugins
    extraPlugins = with pkgs.vimPlugins; [
      # Useful for getting pretty icons, but requires a Nerd Font.
      nvim-web-devicons
    ];

    # TODO: Figure out where to move this
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapre
    extraConfigLuaPre = ''
      vim.opt.foldlevelstart = 99;
      vim.wo.foldlevel = 99;

      if vim.g.have_nerd_font then
        require('nvim-web-devicons').setup {}
      end
      vim.keymap.set("n", "<leader>/", function()
        require('telescope.builtin').current_buffer_fuzzy_find(
          require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false
          }
        )
      end, { desc="[/] Fuzzily search in current buffer" })
    '';

    # The line beneath this is called `modeline`. See `:help modeline`
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapost
    extraConfigLuaPost = ''
      -- netrw config
      function ToggleNetRW()
        if vim.bo.filetype == 'netrw' then
          vim.api.nvim_command('Rex')
          if vim.bo.filetype == 'netrw' then
            vim.api.nvim_command('bdel')
          end
        else
          vim.api.nvim_command('Ex')
        end
      end
      vim.api.nvim_command('command! ToggleNetRW lua ToggleNetRW()')

      vim.g.netrw_banner = 0
      vim.g.netrw_liststyle = 0
      vim.g.netrw_bufsettings = 'nonu nornu noma ro nobl'
      vim.g.netrw_browse_split = 0 -- (4 to open in other window)
      vim.g.netrw_altfile = 0 -- (4 to open in other window)
      vim.g.netrw_list_hide = '^\\.\\.\\?/$,\\(^\\|\\s\\s\\)\\zs\\.\\S\\+'
      vim.g.netrw_localcopydircmd = 'cp -r' -- enable recursive copy

      vim.api.nvim_create_autocmd('filetype', {
        pattern = 'netrw',
        desc = 'Better mappings for netrw',
        callback = function()
          local bind = function(lhs, rhs)
            vim.keymap.set('n', lhs, rhs, {remap = true, buffer = true})
          end 

          -- edit new file
          bind('a', '%')

          -- rename file
          bind('r', 'R')

          -- go up one directory
          bind('h', '-')

          -- enters the dir
          bind('l', '<CR>')

          -- toggles hidden files
          bind('.', 'gh')
        end
      })

    '';

  };
}

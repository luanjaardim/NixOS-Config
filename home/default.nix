{ config, pkgs, ... }:

let 
 lib = pkgs.lib;
in
{
  # TODO please change the username & home directory to your own
  home.username = "lan";
  home.homeDirectory = "/home/lan";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';
  imports = [
    ./eww
    ./rofi
    ./sxhkd
    ./bspwm
    ./dunst
  ];

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    fd # Find files with fd
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    brightnessctl # brightness controller
    playerctl # music player

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    gnupg

    # productivity
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    # Other programs
    eww
    rofi
    dunst
  ];

  programs = {
    # basic configuration of git
    git = {
      enable = true;
      userName = "luanjaardim";
      userEmail = "luang.ajardim@gmail.com";
    };
    # starship - an customizable prompt for any shell
    starship = {
      enable = true;
      # custom settings
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;

	character = {
	  success_symbol = "➜";
	  error_symbol = "➜";
	};
        format = lib.concatStrings [
          " [󰘧](bold bright-white) " "\\[ $directory\\] " "$all"
        ];
      };
    };
    fish = {
      enable = true;
      shellAbbrs = {
        l = "ls -la";
	c = "cd ..";
	gits = "git status";
	gitl = "git log --oneline --graph --all";
	gitc = "git commit -m";
      };
    };
    kitty = {
      enable = true;
      font = {
  	name = "JetBrainsMono";
	size = 12;
      };
    };
    # alacritty - a cross-platform, GPU-accelerated terminal emulator
    alacritty = {
      enable = true;
      # custom settings
      settings = {
        env.TERM = "xterm-256color";
        font = {
	  normal = {
	    family = "JetBrainsMono";
	    style = "Regular";
	  };
          size = 12;
        };
        scrolling.multiplier = 5;
        selection.save_to_clipboard = true;
      };
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}

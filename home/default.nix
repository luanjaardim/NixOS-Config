{ config, pkgs, outputs, ... }:

let 
  lib = pkgs.lib;
  user = outputs.vars.user;
in
{
  # TODO please change the username & home directory to your own
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  imports = [
    ./rofi
    ./sxhkd
    ./bspwm
    ./dunst
    ./neovim
  ];

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };
  services.picom = {
    enable = true;
    activeOpacity = 0.95;
    inactiveOpacity = 0.85;
    settings = {
      animations = true;
      corner-radius = 10;
      blur = {
        method = "dual-kawase";
	size = 9;
	background = true;
      };
    };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    neofetch

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
    killall

    # Other programs
    rofi
    dunst
    yazi    # terminal file manager
  ];

  programs = {
    eww = {
      enable = true;
      configDir = ./eww;
    };
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
        nv = "nvim";
	gits = "git status";
	gitl = "git log --oneline --graph --all";
	gitc = "git commit -m";
      };
      shellInit = "set fish_greeting";
    };
    kitty = {
      enable = true;
      font = {
          name = "JetBrainsMono";
          size = 12;
      };
      shellIntegration.enableFishIntegration = true;
      theme = "Tokyo Night Moon";
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

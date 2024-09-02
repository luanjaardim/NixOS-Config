{ config, pkgs, settings, ... }:

let
  lib = pkgs.lib;
  user = settings.user;
in
{
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./rofi
    ./dunst
    ./neovim
    ./starship
    ./yazi
    ./firefox
  ] ++
  (if settings.wm == "bspwm" then
    [ ./bspwm ./sxhkd ]
  else
    [ ./hypr ]);

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    # For hyprland running Electron apps
    NIXOS_OZONE_WL = "1";
  };
  services.mpris-proxy.enable = true;

  # Enable copy from pdf to clipoard in zathura
  xdg.configFile."zathura/zathurarc".text = "set selection-clipboard clipboard";

  services.picom = {
    package = pkgs.picom-next;
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
    pulseaudio # audio control
    acpi # battery control
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

    # Utility programs
    dmenu     # Simpler App launcher
    dunst     # Notification app
    zathura   # pdf viewer
    bluetuith # tui for blueooth management

    # Other programs
    anydesk
    spotify
    discord
    vlc
    obs-studio
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
    # Starship - an customizable prompt for any shell
    starship = {
      enable = true;
    };

    fish = {
      enable = true;
      shellAbbrs = {
        l = "ls -la";
	c = "cd ..";
        nv = "nvim";
        y = "yazi .";
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
          size = 11;
      };
      shellIntegration.enableFishIntegration = true;
      theme = "Tokyo Night Moon";
      extraConfig = "confirm_os_window_close 0";
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

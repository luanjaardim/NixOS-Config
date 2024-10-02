{ config, pkgs, settings, ... }:

let
  lib = pkgs.lib;
  user = settings.user;
  aliases = {
    l = "ls -la";
    c = "cd ..";
    nv = "nvim";
    dev = "nix develop";
    y = "yazi .";
    gits = "git status";
    gitl = "git log --oneline --graph --all";
    gitc = "git commit -m";
  };
in
{
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    sessionVariables = {
      EDITOR = "nvim";
      # For hyprland running Electron apps
      NIXOS_OZONE_WL = "1";
    };
  };

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./stylix
    ./rofi
    ./dunst
    ./neovim
    ./starship
    ./yazi
    ./firefox
    ./bspwm
    ./sxhkd
    ./hypr
    ./ags
    ./../scripts
  ];
  # imports = [
  #   ./rofi
  #   ./dunst
  #   ./neovim
  #   ./starship
  #   ./firefox
  # ] ++
  # (if settings.wm == "bspwm" then
  #   [ ./bspwm ./sxhkd ]
  # else
  #   [ ./hypr ]);

  # Bluetooth buttons
  services.mpris-proxy.enable = true;

  # Enable copy from pdf to clipoard in zathura
  xdg.configFile."zathura/zathurarc".text = "set selection-clipboard clipboard";

  xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "nvim.desktop";
        "application/pdf" = "zathura.desktop";
        "application/png" = "feh.desktop";
        "application/jpeg" = "feh.desktop";
      };
    };

 #  services.picom = {
 #    package = pkgs.picom-next;
 #    enable = true;
 #    activeOpacity = 0.95;
 #    inactiveOpacity = 0.85;
 #    settings = {
 #      animations = true;
 #      corner-radius = 10;
 #      blur = {
 #        method = "dual-kawase";
	# size = 9;
	# background = true;
 #      };
 #    };
 #  };

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
      userName = settings.gitUserName;
      userEmail = settings.gitUserEmail;
    };

    carapace.enable = true;
    nushell = {
      enable = true;
      shellAliases = aliases;
      configFile.text = ''
        $env.config = {
          # remove the welcome message
          show_banner : false,
        }
      '';
    };
    fish = {
      enable = true;
      shellAbbrs = aliases;
      shellInit = "set fish_greeting";
    };

    kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;
      extraConfig = ''
        confirm_os_window_close 0
        map ctrl+shift+q no_op
      '';
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

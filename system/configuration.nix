{ config, lib, pkgs, settings, ... }:

let
  user = settings.user;
  hostname = settings.hostname;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix # TODO: Copy your hardware-configuration.nix to this directory
    ];

  boot.loader = (if settings.is_vm then {
    grub.enable = true;
    grub.device = "/dev/sda"; # or "nodev" for efi only
  } else {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  });
  virtualisation.virtualbox = if settings.is_vm then { guest.enable = true; } else { host.enable = true; };

  networking.hostName = "${hostname}"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Recife";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "intel" ]; # TODO: enable nvidia driver
    windowManager.bspwm.enable = true;
    displayManager.lightdm = {
      enable = true;
      greeters.gtk.enable = true;
    };
  };
  programs.hyprland.enable = true;

  services.upower.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Bluetooth actions with headphone
  systemd.user.services.mpris-proxy = {
      description = "Mpris proxy";
      after = [ "network.target" "sound.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.fish.enable = true;

  users = {
    extraGroups.vboxusers.members = [ user ];
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users."${user}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ]; # Adding user to groups
      initialPassword = "nixos"; # TODO: change this.
      shell = settings.shell;
    };
  };

  # List packages installed in system profile. For every user.
  environment.systemPackages = with pkgs; [
    # Shells
    bash
    fish
    nushell

    # Standard apps
    firefox
    tree
    feh
    kitty
    neovim
    wget
    git
    tldr
    comma # install and test packages easily with comma: ', cowsay'
    # Command to install the nix-index DB, TODO: make this declarative to know worry in running this
    # mkdir -p "$HOME/.cache/nix-index" && wget https://github.com/Mic92/nix-index-database/releases/latest/download/index-x86_64-linux -O "$HOME/.cache/nix-index/files"

    # notification lib packages
    libnotify
    glib

    # clipboard
    xclip
  ];

  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.05"; # Did you read the comment?

}


{ pkgs, inputs, ...}:

{

  # add the home manager module
  imports = [ inputs.ags.homeManagerModules.default ];

  xdg.configFile."ags/config.js".source = config.lib.file.mkOutOfStoreSymlink ~/.dots/home/ags/config.js;
  xdg.configFile."ags/style.scss".source = config.lib.file.mkOutOfStoreSymlink ~/.dots/home/ags/style.scss;

  # Package to compile scss into css
  home.packages = [ pkgs.sass ];

  programs.ags = {
    enable = true;

    # null or path, leave as null if you don't want hm to manage the config
    # configDir = ../ags;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };

}


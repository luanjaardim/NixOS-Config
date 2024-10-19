{ pkgs, config, inputs, ...}:
let
  colors = config.lib.stylix.colors.withHashtag;
in
{

  # add the home manager module
  imports = [ inputs.ags.homeManagerModules.default ];

  xdg.configFile."ags/config.js".source = ./config.js;
  xdg.configFile."ags/applauncher.js".source = ./applauncher.js;
  xdg.configFile."ags/utilities_btns.js".source = ./utilities_btns.js;
  xdg.configFile."ags/notifications.js".source = ./notifications.js;
  xdg.configFile."ags/style.scss".text = ''
     $bg: ${colors.base00};
     $bg_alt: ${colors.base01};
     $bg_sel: ${colors.base02};
     $comments: ${colors.base03};
     $fg_alt: ${colors.base04};
     $fg: ${colors.base05};
     $c0: ${colors.base06};
     $c1: ${colors.base07};
     $c2: ${colors.base08};
     $c3: ${colors.base09};
     $c4: ${colors.base10};
     $c5: ${colors.base11};
     $c6: ${colors.base12};
     $c7: ${colors.base13};
     $c8: ${colors.base14};
     $c9: ${colors.base15};

     ${builtins.readFile ./style.scss}
  '';

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


{ config, pkgs, inputs, outputs, ... }:
let
  user = outputs.vars.user;
  sys = outputs.vars.system;
in
{
  programs.firefox = {
    enable = true;
    profiles."${user}" = {
      id = 0;

      # TODO: Customize preferences...

      extensions = with inputs.firefox-addons.packages."${sys}"; [
        bitwarden
        ublock-origin
        sponsorblock
        darkreader
        tridactyl
        youtube-shorts-block
      ];
    };
  };
}


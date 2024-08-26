{ pkgs, ... }:
# let volumeCmd = pkgs.runCommand "volume" 
#   {
#     nativeBuildInputs = with pkgs; [ libnotify ];
#     # Here we have some enviroment variables for the script
#   }
#   ''
#
#   '';
# in
{

  home.packages = with pkgs; [ 
    (writeShellScriptBin "audio" (builtins.readFile ./audio.sh))
  ];

}

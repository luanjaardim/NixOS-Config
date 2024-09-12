# Starship - an customizable prompt for any shell
{ settings, ... }:
let
  default_prompt = settings.prompt;
in
{
  # Starship - an customizable prompt for any shell
  programs.starship.enable = true;
  home.file."./.config/starship.toml".source = ./presets/${default_prompt};
}

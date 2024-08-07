# Starship - an customizable prompt for any shell
{ settings, ... }:
let
  default_prompt = settings.prompt;
in
{
  home.file."./.config/starship.toml".source = ./presets/${default_prompt};
}

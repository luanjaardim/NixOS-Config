# Starship - an customizable prompt for any shell
{ outputs, ... }:
let
  default_prompt = outputs.vars.prompt;
in
{
  home.file."./.config/starship.toml".source = ./presets/${default_prompt};
}

{ ... }:
{
  programs.neovim.defaultEditor = true;

	home.file."./.config/nvim" = {
    source = ./nvim;
    recursive = true;
  };
}

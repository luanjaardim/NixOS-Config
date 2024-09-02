{ ... }:

{
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      modules = {
        surround = {};
        statusline.use_icons.__raw = "vim.g.have_nerd_font";
        starter = {
          header = ''
          ╭╮╭┬─╮╭─╮┬  ┬┬╭┬╮
          │││├┤ │ │╰┐┌╯││││
          ╯╰╯╰─╯╰─╯ ╰╯ ┴┴ ┴
          '';
        };
        sessions = {};
      };
    };

    extraConfigLua = ''
      require('mini.statusline').section_location = function()
        return '%2l:%-2v'
      end
    '';
  };
}

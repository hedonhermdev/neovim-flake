{ config, lib, pkgs, ... }:

with builtins;
with lib;

{
  vim.startPlugins = with pkgs.neovimPlugins; [
    nvim-tree
  ];
  vim.luaConfigRC = ''
    vim.g.loaded = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      sort_by = "case_sensitive",
      view = {
        side = "right",
        adaptive_size = true,
        mappings = {
          list = {
            { key = "u", action = "dir_up" },
          },
        },
      },
      renderer = {
        group_empty = true,
      },
    })
  '';

  vim.nnoremap = {
    "<leader>n" = "<cmd>NvimTreeToggle<CR>";
  };
}

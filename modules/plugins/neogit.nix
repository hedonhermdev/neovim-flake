{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.neogit
  ];

  vim.lazy = [
    {
      name = "neogit";
      cmd = [ "Neogit" ];
      keys = [ "<leader>gn" ];
      after = ''
        require('neogit').setup({})
      '';
    }
  ];

  vim.luaConfigRC = ''
    vim.keymap.set("n", "<leader>gn", "<cmd>Neogit<cr>",
      { silent = true, desc = "Neogit" })
  '';
}

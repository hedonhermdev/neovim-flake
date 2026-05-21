{ config, pkgs, lib, ... }:

{
  vim.luaConfigRC = ''
    vim.api.nvim_create_user_command('Format', function(args)
      vim.lsp.buf.format()
    end,
    {})
  '';
}

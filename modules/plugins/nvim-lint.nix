{ config, lib, pkgs, ... }:

{
  vim.optPlugins = [
    pkgs.vimPlugins.nvim-lint
  ];

  vim.lazy = [
    {
      name = "nvim-lint";
      event = [ "BufReadPre" "BufNewFile" ];
      cmd = [ "LintTrigger" ];
      after = builtins.readFile ./nvim-lint.lua;
    }
  ];
}

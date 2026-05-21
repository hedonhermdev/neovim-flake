{ config, lib, pkgs, ... }:

{
  vim.optPlugins = with pkgs.neovimPlugins; [
    telescope
  ];

  # Lazy-load via lz.n on the :Telescope command. The spec name must
  # match the directory under pack/*/opt/, which now equals the flake
  # input attribute name ("telescope") since lib/buildPlugin.nix sets
  # `pname` instead of `name` (avoiding the `vimplugin-` prefix that
  # vimUtils.buildVimPlugin would otherwise add).
  vim.lazyPlugins = [
    ''
      {
        "telescope",
        cmd = "Telescope",
        after = function()
          pcall(function()
            require("telescope").setup {
              defaults = {
                vimgrep_arguments = {
                  "${pkgs.ripgrep}/bin/rg",
                  "--color=never",
                  "--no-heading",
                  "--with-filename",
                  "--line-number",
                  "--column",
                  "--smart-case",
                },
              },
              pickers = {
                find_files = {
                  find_command = {
                    "${pkgs.fd}/bin/fd",
                    "--type",
                    "f",
                  },
                },
              },
            }
          end)
        end,
      }
    ''
  ];

  vim.nnoremap = {
     "<leader>ff" = "<cmd>Telescope find_files<CR>";
     "<leader>fg" = "<cmd>Telescope live_grep<CR>";
     "<leader>fb" = "<cmd>Telescope buffers<CR>";
  };
}

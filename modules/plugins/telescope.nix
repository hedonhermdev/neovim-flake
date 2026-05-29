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
            -- rg/fd are provided on nvim's PATH by lib/neovimBuilder.nix
            -- (corePackages), which is the single source for these binaries
            -- (FIXME #20). Reference them by bare name rather than
            -- re-interpolating their nix-store paths here.
            require("telescope").setup {
              defaults = {
                vimgrep_arguments = {
                  "rg",
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
                    "fd",
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

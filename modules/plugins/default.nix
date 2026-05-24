{ config, lib, pkgs, ... }:
{
  # plugins that don't require extra config go here
  vim.startPlugins = with pkgs.neovimPlugins; [
    devicons
    plenary
    nui
  ];

  vim.optPlugins = with pkgs.neovimPlugins; [
    vim-nix
    move
    fugitive
  ];

  # Register lz.n triggers for the optPlugins listed above. (move has
  # its own dedicated module, so its trigger lives there.)
  vim.lazyPlugins = [
    ''
      {
        "vim-nix",
        ft = "nix",
      }
    ''
    ''
      {
        "fugitive",
        cmd = { "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Gedit", "Gblame", "Glog" },
      }
    ''
  ];

  imports = [
    ./treesitter.nix
    ./catppuccin.nix
    ./indent-blankline.nix
    ./telescope.nix
    ./cokeline.nix
    ./treesitter-context.nix
    ./nvim-tree.nix
    ./git.nix
    ./numb.nix
    ./lsp.nix
    ./snacks.nix
    ./lualine.nix
    ./zen-mode.nix
    ./scnvim.nix
    ./avante.nix
    ./render-markdown.nix
    ./nvim-surround.nix
    ./which-key.nix
    ./fidget.nix
    ./trouble.nix
    ./inc-rename.nix
    ./lsp-lines.nix
    ./conform.nix
    ./nvim-lint.nix
    ./flash.nix
    ./nvim-spider.nix
    ./treesitter-textobjects.nix
    ./nvim-neoclip.nix
    ./neogit.nix
    ./diffview.nix
    ./dap.nix
    ./neotest.nix
    ./nvim-bqf.nix
    ./persistence.nix
    ./codecompanion.nix
    ./oil.nix
    ./move.nix
    ./lz-n.nix
    ./copilot.nix
  ];
}

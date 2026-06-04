{ config, lib, pkgs, ... }:

{
  # nvchad-ui is already placed on the runtimepath by base46.nix (base46 needs
  # its `nvconfig` module at mkOrder 100). This module ACTIVATES the UI:
  # `require "nvchad"` wires the statusline, tabufline, the Nvdash/NvCheatsheet
  # commands, and schedules `nvchad.au` (nvdash-on-startup, colorify, lsp
  # signature, MasonInstallAll, the reload autocmd).
  #
  # Activated at DeferredUIEnter — the same slot lualine/cokeline/snacks used,
  # so timing (incl. nvdash's empty-buffer detection) matches the dashboard it
  # replaces. base46 highlights are already compiled by the time this runs.
  #
  # No optPlugins entry here: the plugin dir is a startPlugin (via base46.nix),
  # and lz.n only needs the require call, not a managed load of a pack/opt dir.
  vim.lazy = [
    {
      name = "nvchad-ui";
      event = [ "DeferredUIEnter" ];
      after = ''
        require "nvchad"
      '';
    }
  ];

  # Keybinds for nvchad UI features that replace retired plugins. These call
  # into nvchad modules that the plugin (already on the rtp via base46.nix)
  # exposes; guarded require so a key press can't error if the module moved.
  vim.luaConfigRC = ''
    -- LSP rename -> nvchad renamer (replaces inc-rename). Floating prompt
    -- prefilled with the symbol under the cursor.
    vim.keymap.set("n", "<leader>rn", function()
      require("nvchad.lsp.renamer")()
    end, { silent = true, desc = "LSP rename (nvchad)" })

    -- Terminal toggle -> nvchad term (replaces snacks.terminal). A single
    -- horizontal toggle term, persistent by id.
    vim.keymap.set({ "n", "t" }, "<leader>ft", function()
      require("nvchad.term").toggle({ pos = "sp", id = "htoggleTerm" })
    end, { silent = true, desc = "Toggle terminal (nvchad)" })

    -- :Floatterm -> toggle a floating nvchad terminal (separate id from the
    -- split toggle above, so the two don't share a buffer/window).
    vim.api.nvim_create_user_command("Floatterm", function()
      require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
    end, { desc = "Toggle floating terminal (nvchad)" })

    -- <Esc> in any nvchad terminal hides it (closes the window; the shell job
    -- stays alive and is restored on the next toggle, exactly like nvchad's own
    -- toggle which does nvim_win_close(win, true)). nvchad tags every terminal
    -- buffer with filetype "NvTerm_<pos>" (float/sp/vsp), so one FileType
    -- pattern covers the floatterm and the split toggle term alike. Mapping is
    -- buffer-local so <Esc> keeps its normal meaning everywhere else.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("NvTermEscClose", { clear = true }),
      pattern = "NvTerm_*",
      callback = function(args)
        vim.keymap.set("t", "<Esc>", function()
          vim.api.nvim_win_close(0, false)
        end, { buffer = args.buf, silent = true, desc = "Hide terminal" })
      end,
    })

    -- Theme picker (volt-backed). Live-switches and recompiles base46's cache.
    vim.keymap.set("n", "<leader>th", function()
      require("nvchad.themes").open()
    end, { silent = true, desc = "Theme picker" })

    -- Mappings cheatsheet (replaces which-key's discovery role; static grid).
    vim.keymap.set("n", "<leader>ch", "<cmd>NvCheatsheet<CR>",
      { silent = true, desc = "Cheatsheet" })
  '';
}

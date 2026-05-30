{ pkgs, ... }:

{
  # opencode.nvim drives the `opencode` CLI from inside Neovim (replacing
  # avante.nvim). It ships from nixpkgs as `opencode-nvim` (pname
  # "opencode.nvim"), and the package propagates the `opencode` binary onto
  # PATH. snacks.nvim is an optional-but-recommended integration that upgrades
  # ask()/select() to snacks.input/snacks.picker; it is already provided by
  # ./snacks.nix, so the require('snacks') calls resolve at runtime.
  vim.optPlugins = [
    pkgs.vimPlugins.opencode-nvim
  ];

  # opencode.nvim has no setup() — it reads `vim.g.opencode_opts` (an
  # `opencode.Opts`). Set the global + autoread at startup (cheap, no require).
  vim.luaConfigRC = ''
    -- Drive opencode's window via `snacks.terminal` instead of the plugin's
    -- built-in terminal, reusing the snacks instance configured in ./snacks.nix
    -- (terminal = { enabled = true }). `opencode.terminal.setup` is still called
    -- on the snacks window so the in-terminal navigation keymaps + process
    -- cleanup keep working. (Pattern from opencode.nvim's README.)
    local opencode_cmd = "opencode --port"
    ---@type snacks.terminal.Opts
    local snacks_terminal_opts = {
      win = {
        position = "left",
        enter = false,
        on_win = function(win)
          require("opencode.terminal").setup(win.win)
        end,
      },
    }

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      lsp = { enabled = true },
      server = {
        start = function()
          require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
        end,
        stop = function()
          local term = require("snacks.terminal").get(opencode_cmd, snacks_terminal_opts)
          if term then term:close() end
        end,
        toggle = function()
          require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
        end,
      },
    }

    -- Required for opts.events.reload to pick up files opencode edits on disk.
    vim.o.autoread = true
  '';

  # Lazy-load via lz.n: the plain-string `keys` list installs stub mappings that
  # load the plugin on first press. The real keymaps MUST be (re)created in the
  # `after` block — lz.n deletes its stub on trigger and then re-feeds the key,
  # so the mapping that actually runs opencode has to exist post-load. (Defining
  # them in luaConfigRC instead leaves the key dead after the stub self-deletes;
  # this mirrors the flash.nix pattern.)
  vim.lazyPlugins = [
    ''
      {
        "opencode.nvim",
        keys = {
          { "<leader>oa", mode = { "n", "x" } },
          { "<leader>oA", mode = "n" },
          { "<leader>os", mode = { "n", "x" } },
          { "<leader>oo", mode = { "n", "t" } },
        },
        after = function()
          pcall(function()
            local opencode = require("opencode")
            vim.keymap.set({ "n", "x" }, "<leader>oa", function() opencode.ask("@this: ", { submit = true }) end,
              { silent = true, desc = "opencode: ask about this" })
            vim.keymap.set("n", "<leader>oA", function() opencode.ask() end,
              { silent = true, desc = "opencode: ask" })
            vim.keymap.set({ "n", "x" }, "<leader>os", function() opencode.select() end,
              { silent = true, desc = "opencode: select prompt" })
            vim.keymap.set({ "n", "t" }, "<leader>oo", function() opencode.toggle() end,
              { silent = true, desc = "opencode: toggle window" })
          end)
        end,
      }
    ''
  ];
}

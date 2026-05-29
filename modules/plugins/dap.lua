-- WARNING: keep "${port}" / "${workspaceFolder}" out of any Nix interpolation.
-- This file is read verbatim by dap.nix via `builtins.readFile`, which returns
-- the content as a plain string, so the DAP placeholder literals below
-- (expanded by nvim-dap at debug time) are safe today. Do NOT inline this
-- content directly into a Nix `''...''` string — Nix would treat "${...}" as
-- antiquotation and either error or substitute the wrong value. Keep it .lua.
local dap = require("dap")
local dapui = require("dapui")

dapui.setup({})
require("nvim-dap-virtual-text").setup({})

-- Open/close UI automatically
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Signs
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual", numhl = "" })

-- Python adapter (FIXME #21). Prefer the active virtualenv's interpreter so
-- debugpy resolves the project's own environment; fall back to PATH python3
-- (provided when vim.languages.python.enable is set). Using a bare "python3"
-- unconditionally picked the wrong interpreter inside venv projects.
-- nvim-dap-python is an opt plugin that lz.n does not load (only nvim-dap is
-- triggered), so packadd it before requiring its module.
pcall(function()
  vim.cmd("packadd nvim-dap-python")
  local function dap_python_path()
    local venv = os.getenv("VIRTUAL_ENV")
    if venv and venv ~= "" then
      return venv .. "/bin/python"
    end
    local p = vim.fn.exepath("python3")
    if p ~= "" then return p end
    return "python3"
  end
  require("dap-python").setup(dap_python_path())
end)

-- Rust adapter via codelldb if available; rustaceanvim wires up its own DAP automatically.
if vim.fn.executable("codelldb") == 1 then
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = "codelldb",
      args = { "--port", "${port}" },
    },
  }
  dap.configurations.rust = {
    {
      name = "Launch",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }
end

-- Keymaps
local map = vim.keymap.set
map("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "DAP toggle breakpoint" })
map("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "DAP conditional breakpoint" })
map("n", "<leader>dc", function() dap.continue() end, { desc = "DAP continue" })
map("n", "<leader>di", function() dap.step_into() end, { desc = "DAP step into" })
map("n", "<leader>do", function() dap.step_over() end, { desc = "DAP step over" })
map("n", "<leader>dO", function() dap.step_out() end, { desc = "DAP step out" })
map("n", "<leader>dr", function() dap.repl.toggle() end, { desc = "DAP REPL toggle" })
map("n", "<leader>dl", function() dap.run_last() end, { desc = "DAP run last" })
map("n", "<leader>dt", function() dap.terminate() end, { desc = "DAP terminate" })
map("n", "<leader>du", function() dapui.toggle() end, { desc = "DAP UI toggle" })

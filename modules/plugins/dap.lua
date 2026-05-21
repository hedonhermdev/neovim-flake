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

-- Python adapter (uses debugpy from PATH)
pcall(function()
  require("dap-python").setup("python3")
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

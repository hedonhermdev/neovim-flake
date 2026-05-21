local ok, neotest = pcall(require, "neotest")
if not ok then return end

local adapters = {}

pcall(function()
  table.insert(adapters, require("neotest-python")({
    dap = { justMyCode = false },
  }))
end)

pcall(function()
  table.insert(adapters, require("neotest-rust")({}))
end)

neotest.setup({
  adapters = adapters,
})

local map = vim.keymap.set
map("n", "<leader>tt", function() neotest.run.run() end, { desc = "Neotest run nearest" })
map("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Neotest run file" })
map("n", "<leader>tA", function() neotest.run.run(vim.uv.cwd()) end, { desc = "Neotest run all" })
map("n", "<leader>td", function() neotest.run.run({ strategy = "dap" }) end, { desc = "Neotest debug nearest" })
map("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Neotest summary" })
map("n", "<leader>to", function() neotest.output.open({ enter = true }) end, { desc = "Neotest output" })
map("n", "<leader>tO", function() neotest.output_panel.toggle() end, { desc = "Neotest output panel" })
map("n", "<leader>tx", function() neotest.run.stop() end, { desc = "Neotest stop" })

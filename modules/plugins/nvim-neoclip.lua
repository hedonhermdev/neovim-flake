require("neoclip").setup({})

pcall(function()
  require("telescope").load_extension("neoclip")
end)

vim.keymap.set("n", "<leader>fy", "<cmd>Telescope neoclip<CR>", { desc = "Clipboard history" })

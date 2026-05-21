require("oil").setup({
  default_file_explorer = false,
  view_options = {
    show_hidden = true,
  },
})

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory (oil)" })
vim.keymap.set("n", "<leader>o", "<cmd>Oil<cr>", { desc = "Open oil file explorer" })

require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true,
  },
})

local select = require("nvim-treesitter-textobjects.select")

vim.keymap.set({ "x", "o" }, "af", function()
  select.select_textobject("@function.outer", "textobjects")
end, { desc = "Select around function" })
vim.keymap.set({ "x", "o" }, "if", function()
  select.select_textobject("@function.inner", "textobjects")
end, { desc = "Select inside function" })
vim.keymap.set({ "x", "o" }, "ac", function()
  select.select_textobject("@class.outer", "textobjects")
end, { desc = "Select around class" })
vim.keymap.set({ "x", "o" }, "ic", function()
  select.select_textobject("@class.inner", "textobjects")
end, { desc = "Select inside class" })

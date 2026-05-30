{ config, lib, pkgs, ... }:

{
  vim.luaConfigRC = ''
    -- KEYBINDINGS

    -- I hate <ESC>
    vim.keymap.set("i", "jk", "<esc>")
    -- ...and in terminal mode too (<C-\><C-n> leaves terminal mode)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]])

    -- Save your pinky
    vim.keymap.set("n", ";", ":")

    -- Move through wrapped lines
    vim.keymap.set("n", "j", "gj")
    vim.keymap.set("n", "k", "gk")

    -- Better window navigation
    vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
    vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
    vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
    vim.keymap.set("n", "<C-H>", "<C-W><C-H>")

    -- Use alt + hjkl to resize windows
    vim.keymap.set("n", "<M-j>", ":resize -2<CR>")
    vim.keymap.set("n", "<M-k>", ":resize +2<CR>")
    vim.keymap.set("n", "<M-h>", ":vertical resize -2<CR>")
    vim.keymap.set("n", "<M-l>", ":vertical resize +2<CR>")
  '';
}

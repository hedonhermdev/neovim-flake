{ config, pkgs, lib, ... }:

with lib;
with builtins;

{
  vim.startPlugins = with pkgs.neovimPlugins; [
    alpha
  ];

  vim.luaConfigRC = ''
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣄⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀          ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡄⠲⡖⣶⠷⣬⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀      ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠤⠢⠙⠈⡁⠀⡀⣿⠸⠀⠁⠋⠶⣠⠀⠀⠀⠀⠀⠀⠀      ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠻⠈⠀⠀⠀⠀⢧⠬⠣⠉⠀⠀⠀⠀⠀⠁⠞⢠⠀⠀⠀⠀⠀      ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⠿⠘⠀⠀⠀⠀⠀⠀⠋⠐⠀⠀⠀⡿⣿⣴⢠⠀⠀⠃⡴⢀⠀⠀⠀      ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⣀⢄⠶⠶⠓⠛⠓⠒⠒⠙⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠈⠀⠀⠀⠀⠋⡴⢀⠀      ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⣀⠦⠙⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠎⢠   ACK",
      "⠀⠀⠀⠀⠀⠀⡄⢷⠸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⡞  /   ",
      "⠀⠀⠀⠀⡀⢦⠙⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣹⣇⢻ /    ",
      "⠀⠀⠀⣄⠻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠋⣟⠻⠀      ",
      "⠀⠀⣆⠘⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⡙⢸⠉⠉⠊⠒⠓⠉⠀⠀⠀      ",
      "⠀⡄⢻⠀⠀⠀⠀⠀⣿⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⣱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀      ",
      "⠀⢣⠀⠀⠀⠀⠀⠀⠇⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡄⢀⠀⠀⡀⣧⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀      ",
      "⡆⠘⠀⠀⠀⠀⠀⠀⠀⡇⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⠀⠀⡆⢻⠿⠚⡀⢿⡧⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀      ",
      "⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠾⠀⠀⠀⠀⠀⠀⠀⠀⡆⣾⠀⠀⠀⠀⡀⢹⠈⠀⠀⣿⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀      ",
      "⡇⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⢀⠀⠀⠀⠂⡿⠘⠀⠀⠀⡷⠸⠀⣾⢷⠨⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀      ",
      "⠃⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡞⠀⠀⠀⠦⡼⢶⠀⠀⡀⣧⢼⠳⡄⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀      ",
      "⠀⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⠀⠀⠀⠒⠿⣷⣽⣦⠿⣽⡎⠀⡇⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀      ",
      "⠀⠇⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣄⢧⠈⠀⠀⠀⡀⠢⠆⢠⠀⠀⡿⠃⣴⠁⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀      ",
      "⠀⠀⠁⡰⠀⠀⠀⠀⠀⠀⠀⠀⡀⢧⠙⢀⠀⣀⣀⢦⠘⠀⠀⠏⢠⠀⡇⢰⣸⠀⠏⣠⣠⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀      ",
      "⠀⠀⠀⠀⠊⡤⢀⠀⣀⠀⠀⡇⠟⠚⠛⠛⠿⠭⣉⠀⠀⠀⠀⠀⢸⠀⠀⠼⣯⣤⣆⣤⢯⠿⠾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀      ",
      "⠀⠀⠀⠀⠀⠀⠁⠉⠛⠚⠐⠁⠖⠤⠤⣀⣀⡀⠇⣯⣴⠀⠀⠀⡼⣦⣤⣶⣷⢸⠀⠉⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀      ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠋⣛⣛⠀⠀⠀⠀⡀⢋⠁⣛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀      ",
    }

    local function button(sc, txt, keybind)
        local sc_ = sc:gsub("%s", ""):gsub("LDR", "<leader>")

        local opts = {
            position = "left",
            text = txt,
            shortcut = sc,
            cursor = 0,
            width = 44,
            align_shortcut = "right",
            hl_shortcut = "AlphaShortcuts",
            hl = "AlphaHeader",
        }
        if keybind then
            opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
        end

        return {
            type = "button",
            val = txt,
            on_press = function()
                local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
                vim.api.nvim_feedkeys(key, "normal", false)
            end,
            opts = opts,
        }
    end

    local buttons = {
        type = "group",
        val = {
            button("LDR f", " >fuzzy search", ":Telescope find_files<CR>"),
            button("LDR y", " >browse files" , ":Telescope file_browser<CR>"),
            button("LDR /", " >regex search", ":Telescope live_grep<CR>"),
        },
        opts = {
            spacing = 0,
        },
    }

    dashboard.section.buttons = buttons

    alpha.setup(dashboard.opts)
  '';
}

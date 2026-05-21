local lint = require("lint")

lint.linters_by_ft = {
  python = { "ruff" },
  sh = { "shellcheck" },
  bash = { "shellcheck" },
  nix = { "nix" },
  markdown = { "markdownlint" },
  dockerfile = { "hadolint" },
}

local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    pcall(function()
      lint.try_lint()
    end)
  end,
})

vim.api.nvim_create_user_command("LintTrigger", function()
  lint.try_lint()
end, { desc = "Trigger nvim-lint manually" })

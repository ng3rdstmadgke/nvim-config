return {
  "stevearc/conform.nvim",
  cmd = "ConformInfo",
  keys = {
    { "<Leader>cf", function() require("conform").format({ async = true }) end, mode = { "n", "v" }, desc = "整形" },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_organize_imports", "ruff_format" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      vue = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },
    -- 上記に無い言語 (rust, go, terraform など) は LSP の整形を使う
    default_format_opts = { lsp_format = "fallback" },
  },
}

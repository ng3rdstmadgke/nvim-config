-- シンタックスハイライトは Neovim 組み込みの treesitter を使い、
-- nvim-treesitter (main ブランチ) はパーサーのインストールとクエリの提供に使う。
-- パーサーのビルドには tree-sitter-cli と C コンパイラが必要。
local languages = {
  "python", "typescript", "tsx", "javascript", "bash", "markdown", "markdown_inline",
  "html", "css", "make", "terraform", "hcl", "rust", "go", "gomod", "yaml", "json",
  "vue", "toml", "dockerfile", "lua", "vim", "vimdoc", "query", "regex", "diff",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false, -- 遅延ロード非対応
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(languages)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          -- パーサーが無いファイルタイプでは何もしない
          if not pcall(vim.treesitter.start, args.buf) then
            return
          end
          vim.wo[0][0].foldmethod = "expr"
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end,
      })
    end,
  },
  {
    -- html / tsx / jsx / vue の閉じタグを自動補完する
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}

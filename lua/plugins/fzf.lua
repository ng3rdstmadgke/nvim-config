return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "FzfLua",
  opts = {
    defaults = { file_icons = false }, -- Nerd Font が無い環境なのでアイコンを使わない
    files = { hidden = true },
    grep = { hidden = true },
  },
  -- <Leader>ff は .gitignore を適用する。ファイル一覧の中では <C-t> でタブ, <C-v> で縦分割, <C-s> で横分割に開ける
  keys = {
    { "<Leader>ff", function() require("fzf-lua").files() end, desc = "ファイル検索" },
    { "<Leader>fg", function() require("fzf-lua").live_grep() end, desc = "内容検索 (rg, .gitignore適用)" },
    -- .gitignore を無視して検索する (.git/ の中身だけは除く)
    {
      "<Leader>fG",
      function()
        require("fzf-lua").live_grep({
          no_ignore = true,
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --glob=!.git/ -e",
        })
      end,
      desc = "内容検索 (rg, .gitignore無視)",
    },
    { "<Leader>fw", function() require("fzf-lua").grep_cword() end, desc = "カーソル下の単語を検索" },
    { "<Leader>fw", function() require("fzf-lua").grep_visual() end, mode = "v", desc = "選択範囲を検索" },
    { "<Leader>fb", function() require("fzf-lua").buffers() end, desc = "バッファ" },
    { "<Leader>fo", function() require("fzf-lua").oldfiles() end, desc = "最近開いたファイル" },
    { "<Leader>fT", function() require("fzf-lua").tabs() end, desc = "タブ" },
    { "<Leader>fr", function() require("fzf-lua").resume() end, desc = "直前の検索を再開" },
    { "<Leader>fd", function() require("fzf-lua").diagnostics_document() end, desc = "診断 (このファイル)" },
    { "<Leader>fD", function() require("fzf-lua").diagnostics_workspace() end, desc = "診断 (プロジェクト)" },
    { "<Leader>fs", function() require("fzf-lua").lsp_document_symbols() end, desc = "シンボル" },
    { "<Leader>fh", function() require("fzf-lua").helptags() end, desc = "ヘルプ" },
    { "<Leader>fk", function() require("fzf-lua").keymaps() end, desc = "キーマップ" },
  },
}

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<Leader>e", "<Cmd>NvimTreeFocus<CR>", desc = "エクスプローラを開く/フォーカス" },
    { "<Leader>m", "<Cmd>NvimTreeClose<CR>", desc = "エクスプローラを閉じる" },
    { "<Leader>E", "<Cmd>NvimTreeFindFile<CR>", desc = "エクスプローラで現在のファイルを表示" },
  },
  -- ツリー内: <CR> で開く, <C-t> 新しいタブ, <C-v> 縦分割, <C-x> 横分割, a 作成, d 削除, r 名前変更, g? ヘルプ
  opts = {
    view = { width = 35 },
    -- Nerd Font が無い環境なのでアイコンを使わない
    renderer = {
      icons = {
        show = { file = false, folder = false, folder_arrow = true, git = true, modified = true, diagnostics = false, bookmarks = false },
        glyphs = { folder = { arrow_closed = ">", arrow_open = "v" } },
      },
    },
    update_focused_file = { enable = true },
    filters = { dotfiles = false },
    git = { ignore = false },
  },
}

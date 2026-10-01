return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    -- ツリーはフォーカス中のウィンドウにそのまま開く。<CR> で開いたファイルも同じウィンドウに入る
    { "<Leader>e", function() require("nvim-tree.api").tree.open({ current_window = true }) end, desc = "エクスプローラを開く" },
    {
      "<Leader>m",
      function()
        -- ツリーを表示しているウィンドウでは、ウィンドウを閉じずに直前のファイルへ戻す
        if vim.bo.filetype == "NvimTree" and vim.fn.bufexists(0) == 1 and vim.fn.buflisted(vim.fn.bufnr("#")) == 1 then
          -- nvim-tree が「ツリーはまだ開いている」と誤認しないよう、replace_tree_buffer と同じく状態を破棄する
          require("nvim-tree.view").abandon_current_window()
          vim.cmd("buffer #")
        else
          require("nvim-tree.api").tree.close()
        end
      end,
      desc = "エクスプローラを閉じる",
    },
    { "<Leader>E", function() require("nvim-tree.api").tree.find_file({ open = true, focus = true, current_window = true }) end, desc = "エクスプローラで現在のファイルを表示" },
  },
  -- ツリー内: <CR> そのウィンドウで開く (フォルダは展開), <C-t> 新しいタブ, <C-v> 縦分割, <C-x> 横分割, a 作成, d 削除, r 名前変更, g? ヘルプ
  opts = {
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")
      api.config.mappings.default_on_attach(bufnr)
      -- ファイルはツリーを表示しているウィンドウにそのまま開く。フォルダは展開/折りたたみ
      vim.keymap.set("n", "<CR>", function()
        local node = api.tree.get_node_under_cursor()
        if node and node.type == "file" then
          api.node.open.replace_tree_buffer()
        else
          api.node.open.edit()
        end
      end, { buffer = bufnr, desc = "その場で開く / フォルダを展開" })
    end,
    view = { width = 35 },
    -- Nerd Font が無い環境なのでアイコンを使わない
    renderer = {
      icons = {
        show = { file = false, folder = false, folder_arrow = true, git = true, modified = true, diagnostics = false, bookmarks = false },
        glyphs = { folder = { arrow_closed = ">", arrow_open = "v" } },
      },
    },
    -- `nvim .` で全ペインがツリーに置き換わらないよう、ディレクトリの乗っ取りは無効にする
    hijack_directories = { enable = false },
    update_focused_file = { enable = true },
    filters = { dotfiles = false },
    git = { ignore = false },
  },
}

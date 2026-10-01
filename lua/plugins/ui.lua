return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        always_show_tabline = false, -- タブが1つのときはタブラインを隠す
        globalstatus = true,
      },
      sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
        lualine_z = { "location" },
      },
      -- 複数タブの管理: タブ番号とファイル名を表示する
      tabline = {
        lualine_a = { { "tabs", mode = 2, max_length = vim.o.columns } },
      },
    },
  },
  {
    -- キーマップのヒントを表示する (<Leader> を押して少し待つ)
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<Leader>f", group = "検索 (fzf)" },
        { "<Leader>c", group = "コード" },
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
}

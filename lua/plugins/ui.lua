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
        icons_enabled = false,     -- Nerd Font が無い環境なのでアイコンを使わない
        component_separators = "|",
        section_separators = "",
        always_show_tabline = false, -- タブが1つのときはタブラインを隠す
        globalstatus = false, -- 分割した各ウィンドウにファイル名を表示する
      },
      sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
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
      icons = {
        mappings = false,
        keys = {
          Up = "Up", Down = "Down", Left = "Left", Right = "Right",
          C = "C-", M = "M-", D = "D-", S = "S-",
          CR = "CR", Esc = "Esc", NL = "NL", BS = "BS", Space = "Space", Tab = "Tab",
          ScrollWheelDown = "WheelDown", ScrollWheelUp = "WheelUp",
          F1 = "F1", F2 = "F2", F3 = "F3", F4 = "F4", F5 = "F5", F6 = "F6",
          F7 = "F7", F8 = "F8", F9 = "F9", F10 = "F10", F11 = "F11", F12 = "F12",
        },
      },
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

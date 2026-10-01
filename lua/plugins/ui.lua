-- netrw のバッファ名は "NetrwTreeListing" 固定なので、ディレクトリのパスで表示する
local function netrw_dir(bufnr)
  return vim.fn.getbufvar(bufnr, "netrw_curdir")
end

local function winbar_filename(str)
  if vim.bo.filetype ~= "netrw" then
    return str
  end
  return vim.fn.fnamemodify(netrw_dir(vim.api.nvim_get_current_buf()), ":~")
end

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
        globalstatus = true, -- ステータスラインは画面全体で1本にする
      },
      sections = {
        lualine_c = {},
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_z = { "location" },
      },
      -- ファイル名は各ウィンドウの上端 (winbar) に表示する
      winbar = {
        lualine_c = { { "filename", path = 1, fmt = winbar_filename } },
      },
      inactive_winbar = {
        lualine_c = { { "filename", path = 1, fmt = winbar_filename } },
      },
      -- 複数タブの管理: タブ番号とファイル名を表示する
      tabline = {
        lualine_a = { {
          "tabs",
          mode = 2,
          max_length = vim.o.columns,
          fmt = function(name, tab)
            if tab.filetype == "netrw" then
              local buf = vim.fn.tabpagebuflist(tab.tabnr)[vim.fn.tabpagewinnr(tab.tabnr)]
              return vim.fn.fnamemodify(netrw_dir(buf), ":t") .. "/"
            end
            return name
          end,
        } },
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

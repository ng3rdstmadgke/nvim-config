local M = {}

-- プロジェクトルート: 現在のファイルが属する Git リポジトリのルート。無ければ cwd のリポジトリ、それも無ければ cwd
function M.root()
  local start = vim.api.nvim_buf_get_name(0)
  if vim.bo.filetype == "netrw" or start == "" or vim.fn.filereadable(start) == 0 then
    start = vim.fn.getcwd()
  end
  return vim.fs.root(start, ".git") or vim.fn.getcwd()
end

-- netrw を今のウィンドウに、プロジェクトルートで開く
function M.open()
  vim.cmd("Explore " .. vim.fn.fnameescape(M.root()))
end

-- netrw を今のウィンドウに、現在のファイルのディレクトリで開く
function M.open_file_dir()
  vim.cmd("Explore")
end

-- netrw のツリー上で path までフォルダを展開し、その行にカーソルを置いてハイライトする
local group = vim.api.nvim_create_augroup("user_explorer", { clear = true })
-- ハイライトはウィンドウ単位なので、netrw からファイルを開いたら消す
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = group,
  callback = function()
    if vim.w.explorer_match and vim.bo.filetype ~= "netrw" then
      pcall(vim.fn.matchdelete, vim.w.explorer_match)
      vim.w.explorer_match = nil
    end
  end,
})

function M.reveal(path)
  local top = vim.w.netrw_treetop
  if not top or path == "" then
    return
  end
  local rel = vim.fs.relpath(top, path)
  if not rel or rel == "." then
    return
  end
  -- カラースキームを切り替えると定義が消えるので、毎回設定する
  vim.api.nvim_set_hl(0, "ExplorerCurrentFile", { link = "Visual", default = true })
  local parts = vim.split(rel, "/", { plain = true })
  local lnum = 1
  for i, name in ipairs(parts) do
    local is_dir = i < #parts
    -- ツリーの行は深さの数だけ "| " が付く (例: "| | init.lua")。実行ファイルなどは末尾に記号が付く
    local pat = "\\V\\^" .. string.rep("| ", i) .. vim.fn.escape(name, "\\") .. (is_dir and "/" or "\\[*@=|]\\?") .. "\\$"
    vim.api.nvim_win_set_cursor(0, { lnum, 0 })
    local found = vim.fn.search(pat, "cW")
    if found == 0 then
      return
    end
    lnum = found
    -- 閉じているフォルダだけ <CR> で開く (開いていれば次の行が一段深い)
    local next_line = vim.fn.getline(lnum + 1)
    if is_dir and not vim.startswith(next_line, string.rep("| ", i + 1)) then
      vim.cmd("normal \r")
      vim.api.nvim_win_set_cursor(0, { lnum, 0 })
    end
    if not is_dir then
      if vim.w.explorer_match then
        pcall(vim.fn.matchdelete, vim.w.explorer_match)
      end
      vim.w.explorer_match = vim.fn.matchadd("ExplorerCurrentFile", pat)
    end
  end
end

return M

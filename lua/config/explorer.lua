local M = {}

-- プロジェクトルート: 現在のファイルが属する Git リポジトリのルート。無ければ cwd のリポジトリ、それも無ければ cwd
function M.root()
  local start = vim.api.nvim_buf_get_name(0)
  if vim.bo.filetype == "netrw" or start == "" or vim.fn.filereadable(start) == 0 then
    start = vim.fn.getcwd()
  end
  return vim.fs.root(start, ".git") or vim.fn.getcwd()
end

-- netrw を今のウィンドウに、プロジェクトルートで開く。直前まで開いていたファイルの行にカーソルを置く
function M.open()
  local file = vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) or ""
  vim.cmd("Explore " .. vim.fn.fnameescape(M.root()))
  M.reveal(file)
end

-- netrw を今のウィンドウに、現在のファイルのディレクトリで開く
function M.open_file_dir()
  vim.cmd("Explore")
end

-- netrw のツリー上で path までフォルダを展開し、その行にカーソルを置く
function M.reveal(path)
  local top = vim.w.netrw_treetop
  if not top or path == "" then
    return
  end
  local rel = vim.fs.relpath(top, path)
  if not rel or rel == "." then
    return
  end
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
  end
end

return M

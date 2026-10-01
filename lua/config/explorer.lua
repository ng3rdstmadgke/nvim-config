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

return M

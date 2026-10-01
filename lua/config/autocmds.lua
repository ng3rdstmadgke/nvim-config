local augroup = vim.api.nvim_create_augroup("user_config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function() vim.hl.on_yank() end,
})

-- .tsv はタブ区切りなので expandtab しない
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup,
  pattern = "*.tsv",
  callback = function() vim.bo.expandtab = false end,
})

-- w の移動で「-」も1単語に含める (CSS のクラス名など)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "css", "scss", "html", "vue", "yaml" },
  callback = function() vim.opt_local.iskeyword:append("-") end,
})

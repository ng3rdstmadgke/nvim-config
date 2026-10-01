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

-- 引数なしで起動したときは、エクスプローラを初期画面にする
-- (ディレクトリを指定した場合は netrw が自動で開くので、cwd だけ合わせる)
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  nested = true,
  callback = function()
    if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" and vim.bo.buftype == "" then
      require("config.explorer").open()
    elseif vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      vim.cmd.cd(vim.fn.fnameescape(vim.fn.fnamemodify(vim.fn.argv(0), ":p:h"))) -- fzf / rg の検索対象も合わせる
    end
  end,
})

-- netrw は <C-l> (再読み込み) をバッファ内で上書きするので、境界を動かすキーに戻す
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "netrw",
  callback = function(args)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        vim.keymap.set("n", "<C-l>", function() require("config.window").move_border("l") end, { buffer = args.buf, desc = "ペインの境界を右へ動かす" })
      end
    end)
  end,
})

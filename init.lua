vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- netrw は nvim-tree に置き換えるため無効化する
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.loader.enable()

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

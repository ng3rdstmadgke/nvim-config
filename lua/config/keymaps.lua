local map = vim.keymap.set

-- === カーソル移動 ===
-- 表示行で移動する
map("n", "j", "gj")
map("n", "k", "gk")
map("n", "gj", "j")
map("n", "gk", "k")
-- インサートモード時の移動
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")
map("i", "<C-l>", "<Right>")
map("i", "<C-h>", "<Left>")

-- === ウィンドウ ===
map("n", "<Leader>j", "<C-w>j")
map("n", "<Leader>k", "<C-w>k")
map("n", "<Leader>l", "<C-w>l")
map("n", "<Leader>h", "<C-w>h")
-- ウィンドウを移動
map("n", "<Leader>J", "<C-w>J")
map("n", "<Leader>K", "<C-w>K")
map("n", "<Leader>L", "<C-w>L")
map("n", "<Leader>H", "<C-w>H")
-- ペインの境界を動かす (> < + - は本来の操作を壊すので Ctrl+hjkl にしている)
map("n", "<C-l>", function() require("config.window").move_border("l") end, { desc = "ペインの境界を右へ動かす" })
map("n", "<C-h>", function() require("config.window").move_border("h") end, { desc = "ペインの境界を左へ動かす" })
map("n", "<C-k>", function() require("config.window").move_border("k") end, { desc = "ペインの境界を上へ動かす" })
map("n", "<C-j>", function() require("config.window").move_border("j") end, { desc = "ペインの境界を下へ動かす" })
map("n", "<Leader>=", "<C-w>=")
-- === エクスプローラ (netrw) ===
map("n", "<Leader>e", function() require("config.explorer").open() end, { desc = "エクスプローラ (プロジェクトルート)" })
map("n", "<Leader>E", function() require("config.explorer").open_file_dir() end, { desc = "エクスプローラ (現在のファイルのディレクトリ)" })
map("n", "<Leader>m", function()
  -- エクスプローラを閉じて、直前のバッファへ戻る
  if vim.bo.filetype == "netrw" and vim.fn.buflisted(vim.fn.bufnr("#")) == 1 then
    vim.cmd("buffer #")
  end
end, { desc = "エクスプローラを閉じて元のバッファへ戻る" })

-- 新しいウィンドウ/タブは、エクスプローラで開く
local function new_window(cmd)
  vim.cmd(cmd)
  require("config.explorer").open()
end
-- 分割したときは、元のペインで開いていたファイルの行にエクスプローラのカーソルを置く
local function split_window(cmd)
  local file = vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) or ""
  new_window(cmd)
  require("config.explorer").reveal(file)
end
map("n", "<Leader>s", function() split_window("split") end, { desc = "横に分割" })
map("n", "<Leader>d", function() split_window("vsplit") end, { desc = "縦に分割" })

-- === タブ ===
map("n", "<Leader>t", function() new_window("tabnew") end, { desc = "新しいタブ" })
map("n", "<Leader>n", "gt", { desc = "次のタブ" })
map("n", "<Leader>p", "gT", { desc = "前のタブ" })
map("n", "<Leader>>", "<Cmd>tabmove +1<CR>", { desc = "タブを右へ移動" })
map("n", "<Leader><", "<Cmd>tabmove -1<CR>", { desc = "タブを左へ移動" })
map("n", "<Leader>a", "<C-w>T", { desc = "現在のウィンドウをタブに移動" })
map("n", "<Leader>x", "<Cmd>tabclose<CR>", { desc = "タブを閉じる" })
for i = 1, 9 do
  map("n", "<Leader>" .. i, i .. "gt", { desc = "タブ" .. i .. "へ移動" })
end

-- === その他 ===
map("n", "*", "*N")
-- s を接頭辞にするため無効化する
map("n", "s", "<Nop>")
map("n", "sy", "yiw", { desc = "単語をヤンク" })
map("n", "sp", 'viw"0p', { desc = "単語をヤンクレジスタの内容に置換" })
map("n", "<Leader>w", function()
  -- 右端での折り返しの切替 (単語の切れ目は考慮せず、右端でそのまま折り返す)
  vim.wo.wrap = not vim.wo.wrap
  vim.notify("wrap: " .. (vim.wo.wrap and "on" or "off"))
end, { desc = "折り返し表示の切替" })
map("n", "<Leader>W", "<Cmd>w<CR>", { desc = "保存" })
map("n", "<Leader>q", "<Cmd>q<CR>", { desc = "閉じる" })
map("n", "<Leader>o", "<Cmd>qa!<CR>", { desc = "保存せずに全て終了" })
map("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "検索ハイライトを消す" })
-- 端末モードから Normal モードへ戻る
map("t", "<Esc>", "<C-\\><C-n>", { desc = "端末モードを抜ける" })
-- <C-{> を区別して送れる端末向け (送れない端末では <C-{> が <Esc> と同じ信号になるので上のマップで戻れる)
map("t", "<C-{>", "<C-\\><C-n>", { desc = "端末モードを抜ける" })
-- 画面下部に端末を開いて、そのまま入力できる状態にする
map("n", "<Leader>i", function()
  vim.cmd("botright 15split | terminal")
  vim.wo.number = false
  vim.cmd("startinsert")
end, { desc = "ターミナルを開く" })

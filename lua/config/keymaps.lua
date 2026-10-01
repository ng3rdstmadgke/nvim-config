local map = vim.keymap.set

-- === カーソル移動 ===
-- 表示行で移動する
map("n", "j", "gj")
map("n", "k", "gk")
map("n", "gj", "j")
map("n", "gk", "k")
map("n", "<C-j>", "5j")
map("n", "<C-k>", "5k")
map("n", "<C-l>", "5l")
map("n", "<C-h>", "5h")
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
-- サイズ調整 (> < + - は本来の操作を壊すので Ctrl+矢印にしている)
map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Left>", "<C-w><")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")
map("n", "<Leader>=", "<C-w>=")
map("n", "<Leader>s", "<Cmd>split<CR>", { desc = "横に分割" })
map("n", "<Leader>d", "<Cmd>vsplit<CR>", { desc = "縦に分割" })

-- === タブ ===
map("n", "<Leader>t", "<Cmd>tabnew<CR>", { desc = "新しいタブ" })
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
map("n", "<Leader>w", "<Cmd>w<CR>", { desc = "保存" })
map("n", "<Leader>q", "<Cmd>q<CR>", { desc = "閉じる" })
map("n", "<Leader>o", "<Cmd>qa!<CR>", { desc = "保存せずに全て終了" })
map("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "検索ハイライトを消す" })

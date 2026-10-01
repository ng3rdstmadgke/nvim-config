local opt = vim.opt

-- === 表示 ===
opt.number = true                      -- 行数表示
opt.cursorline = true                  -- カーソルラインを表示する
opt.showmatch = true                   -- 対応括弧をハイライト表示
opt.list = true                        -- 不可視文字を表示する
opt.listchars = { tab = "»_", trail = "-" } -- tab=タブ, trail=行末スペース
opt.wrap = false                       -- 画面端で行を折り返さない
opt.scrolloff = 8                      -- 上下8行の視界を確保
opt.sidescroll = 1                     -- 左右スクロールは一文字づつ行う
opt.signcolumn = "yes"                 -- 診断表示でガタつかないよう常に表示
opt.termguicolors = true
opt.background = "dark"
opt.splitright = true                  -- vsplitしたときに右側に開く
opt.splitbelow = true                  -- splitしたときに下側に開く
opt.showtabline = 1                    -- タブが2つ以上のときだけタブラインを表示

-- === インデント ===
opt.expandtab = true                   -- タブ文字をスペースに変換
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.smartindent = true

-- === 検索 ===
opt.ignorecase = true
opt.smartcase = true                   -- 大文字が入っているときは区別する
opt.inccommand = "split"               -- :%s の結果をリアルタイムに表示する

-- === エクスプローラ (netrw) ===
vim.g.netrw_liststyle = 3              -- ツリー表示
vim.g.netrw_banner = 0                 -- 上部のバナーを消す

-- === 折りたたみ (treesitter) ===
opt.foldlevelstart = 99                -- 開いた時点では折りたたまない

-- === その他 ===
opt.swapfile = false
opt.updatetime = 250
opt.undofile = true                    -- undo履歴を永続化する

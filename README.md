# Neovim 設定

Neovim 0.12 以降向けの設定です。プラグイン管理は lazy.nvim、構文ハイライトは treesitter、静的解析は組み込み LSP + mason.nvim を使っています。

## 構成

```
init.lua                 エントリポイント
lazy-lock.json           プラグインのバージョン固定
lua/config/              基本設定 (options / keymaps / autocmds / lazy / explorer)
lua/plugins/             プラグイン別の設定
  ui.lua                 テーマ, lualine (タブ表示), which-key, autopairs
  treesitter.lua         シンタックスハイライト, 折りたたみ, 閉じタグ補完
  lsp.lua                LSP (mason で自動インストール), 診断表示
  completion.lua         補完 (blink.cmp)
  format.lua             整形 (conform.nvim)
  git.lua                Git の差分表示 (gitsigns.nvim)
  fzf.lua                ファイル検索 / rg による内容検索 (fzf-lua)
```

## セットアップ手順 (Linux x86_64 / Ubuntu)

### 1. 依存コマンドを入れる

```bash
sudo apt install -y git curl tar unzip gcc make ripgrep fzf python3-venv
```

Node.js も必要です (pyright, vtsls, prettier など多くのツールが mason から npm 経由で入ります)。nvm で入れて、default に設定します。

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash
source ~/.bashrc
nvm install 24
nvm alias default 24
```

`default` が無効になっていると、新しいシェルに `npm` が入らず、mason のインストールが失敗します。`nvm current` が `none` 以外になっていることを確認してください。

### 2. Neovim を入れる

apt の版は古いので、公式バイナリを `~/.local` に入れます。

```bash
mkdir -p ~/.local/bin ~/.local/share
curl -sLO https://github.com/neovim/neovim/releases/download/v0.12.5/nvim-linux-x86_64.tar.gz
tar xzf nvim-linux-x86_64.tar.gz -C ~/.local/share
ln -sf ~/.local/share/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
rm nvim-linux-x86_64.tar.gz
```

### 3. tree-sitter-cli を入れる

treesitter のパーサーのビルドに必要です。0.26.1 以降が必要です (npm 版は非対応)。次のどちらかで入れてください。

#### A. 公式バイナリを入れる (Ubuntu 24.04 以降)

公式バイナリは glibc 2.39 以降を要求します。Ubuntu 22.04 では `GLIBC_2.39' not found` で起動しないので、B を使ってください。

```bash
curl -sL https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz | gunzip > ~/.local/bin/tree-sitter
chmod +x ~/.local/bin/tree-sitter
```

`~/.local/bin` が `PATH` に入っていることを確認してください。

#### B. Rust でソースからビルドする (Ubuntu 22.04 など glibc が古い環境)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
cargo install --locked tree-sitter-cli
```

`~/.cargo/bin/tree-sitter` に入ります。A で入れた `~/.local/bin/tree-sitter` が残っていると、そちらが優先されることがあるので削除してください。


#### 確認

```bash
nvim --version | head -1
tree-sitter --version
```

### 4. 設定を適用する

```bash
git clone https://github.com/ng3rdstmadgke/nvim-config.git ~/.config/nvim
nvim
```

既に `~/.config/nvim` がある場合は、退避してから clone してください。

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

初回起動時に、次のものが自動で入ります。完了まで数分かかります。

- プラグイン (lazy.nvim)
- treesitter のパーサー (ビルド)
- LSP サーバー、整形ツール (mason)

途中で `-- More --` と出て入力待ちになったら、`q` か `<Enter>` を押して進めてください。Lazy の画面が出たら `q` で閉じられます (裏でインストールは続きます)。

### 5. インストール状況を確認する

LSP サーバーと整形ツールは、手順 4 の初回起動で mason が自動で入れます。`:Mason` で導入状況を確認してください。入っていないものがある場合 (ネットワーク断などで失敗した場合) は、次を実行します。

```vim
:LspInstall
:MasonToolsInstall
```

導入対象は `lua/plugins/lsp.lua` の `servers` で定義しています。

### 6. 動作確認

```vim
:checkhealth vim.lsp
:checkhealth nvim-treesitter
:Lazy
```

## 補足

- **アイコン:** Nerd Font が無い環境でも表示が崩れないよう、アイコンは無効にしています (lualine, fzf-lua, which-key, blink.cmp, Lazy)。Nerd Font を使う場合は、各設定の `icons` 関連オプションを戻してください。
- **Rust / Go:** rust_analyzer と gopls が動くには `cargo` / `go` が必要です。`go` が無い環境では gopls を自動で除外します。
- **Makefile:** ハイライトのみで、静的解析は対応していません。
- **ripgrep:** `rg` は実行ファイルとして `PATH` に必要です (シェルの関数や alias では Neovim から見えません)。無い場合、fzf-lua は `find` / `grep` で動き、`.gitignore` が効きません。apt に無い環境では、[公式リリース](https://github.com/BurntSushi/ripgrep/releases) のバイナリを `~/.local/bin` に置いてください。
- **macOS:** `brew install neovim tree-sitter-cli ripgrep fzf` で、手順 2 と 3 の代わりになります。
- **更新:** プラグインの更新は `:Lazy update` です。更新後は `lazy-lock.json` をコミットしてください。

## 主なキー操作

リーダーキーは `<Space>` です。`<Space>` を押して待つと which-key がキー一覧を表示します。

| キー | 動作 |
|---|---|
| `<Leader>ff` | ファイル名で検索 (.gitignore の対象は除外) |
| `<Leader>fg` | rg で内容検索 (.gitignore の対象と `.git/` の中は除外) |
| `<Leader>fG` | rg で内容検索 (.gitignore を無視。`.git/` の中は除く) |
| `<Leader>fw` | カーソル下の単語を検索 |
| `<Leader>fb` / `fo` | バッファ / 最近開いたファイル |
| `<Leader>fd` | 診断一覧 |
| `<Leader>s` / `d` | 横 / 縦に分割 (新しいペインはエクスプローラで開き、元のファイルの行にカーソルを置く) |
| `<Leader>h` / `j` / `k` / `l` | ペイン間の移動 |
| `<Leader>e` | エクスプローラを開く (プロジェクトルート。直前のファイルの行にカーソルを置く) |
| `<Leader>m` | エクスプローラを閉じて、直前のバッファへ戻る |
| `<Leader>t` | 新しいタブ |
| `<Leader><C-n>` / `<C-p>` | 次 / 前のタブ |
| `<Leader>x` | タブを閉じる |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | ペインの境界を左 / 下 / 上 / 右へ動かす |
| `<Leader>a` | 現在のウィンドウをタブに移動 |
| `<Leader>2` | 定義へ移動 |
| `<Leader>3` | 定義元を縦分割で表示 |
| `<Leader>4` | 定義元を横分割で表示 |
| `<C-/>` | ホバー |
| `grn` / `gra` | 名前変更 / コードアクション |
| `]d` / `[d` | 次 / 前の診断 |
| `<Leader>cf` | 整形 |
| `]c` / `[c` | 次 / 前の変更箇所 (Git) |
| `<Leader>gi` | 変更箇所の差分をファイル内に表示 |
| `<Leader>gp` | 変更箇所の差分をポップアップで表示 |
| `<Leader>gd` | 最後のコミットとの差分を左右に並べて表示 |
| `<Leader>gb` | カーソル行の blame |
| `<Leader>W` / `q` | 保存 / 閉じる |
| (マウス) ドラッグして離す | 選択範囲を手元の PC のクリップボードへコピー |
| `<Leader>w` | 折り返し表示の切替 |
| `<Leader>i` | 画面下部にターミナルを開く |
| (端末モード) `<Esc>` / `<C-{>` | 端末モードを抜けて Normal モードへ戻る (`i` で再び入力) |

ファイルピッカー (fzf-lua) の中では `<C-t>` でタブ、`<C-v>` で縦分割、`<C-s>` で横分割に開けます。
エクスプローラは Neovim 標準の netrw をツリー表示で使っています。今のウィンドウにそのまま開き (プロジェクトルート = Git のルート。無ければカレントディレクトリ)、複数のウィンドウで同時に開けます (同じバッファを表示するため、フォルダの展開状態は共有されます)。`nvim` の起動時と、`<Leader>s`/`<Leader>d`/`<Leader>t` で作る新しいウィンドウ・タブでも開きます。

- `<CR>` ファイルを今のウィンドウで開く / フォルダを展開、`-` 親ディレクトリ
- `v` 縦分割、`o` 横分割、`t` 新しいタブで開く
- `%` ファイル作成、`d` フォルダ作成、`R` 名前変更、`D` 削除、`<F1>` ヘルプ

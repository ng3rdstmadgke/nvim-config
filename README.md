# Neovim 設定

Neovim 0.12 以降向けの設定です。プラグイン管理は lazy.nvim、構文ハイライトは treesitter、静的解析は組み込み LSP + mason.nvim を使っています。

## 構成

```
init.lua                 エントリポイント
lazy-lock.json           プラグインのバージョン固定
lua/config/              基本設定 (options / keymaps / autocmds / lazy)
lua/plugins/             プラグイン別の設定
  ui.lua                 テーマ, lualine (タブ表示), which-key, autopairs
  treesitter.lua         シンタックスハイライト, 折りたたみ, 閉じタグ補完
  lsp.lua                LSP (mason で自動インストール), 診断表示
  completion.lua         補完 (blink.cmp)
  format.lua             整形 (conform.nvim)
  fzf.lua                ファイル検索 / rg による内容検索 (fzf-lua)
  explorer.lua           ファイルツリー (nvim-tree)
```

## セットアップ手順 (Linux x86_64 / Ubuntu)

### 1. 依存コマンドを入れる

```bash
sudo apt install -y git curl tar unzip gcc make ripgrep fzf python3-venv
```

Node.js も必要です (pyright, vtsls など多くの LSP が npm 経由で入ります)。nvm などで入れてください。

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

treesitter のパーサーのビルドに必要です (npm 版は非対応)。

```bash
curl -sL https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz | gunzip > ~/.local/bin/tree-sitter
chmod +x ~/.local/bin/tree-sitter
```

`~/.local/bin` が `PATH` に入っていることを確認してください。

```bash
nvim --version | head -1
tree-sitter --version
```

### 4. 設定を適用する

```bash
git clone <このリポジトリのURL> ~/.config/nvim
nvim
```

既に `~/.config/nvim` がある場合は、退避してから clone してください。

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

初回起動時に lazy.nvim が自動でプラグインを取得し、treesitter のパーサーをビルドします。完了するまで数分かかります。

### 5. LSP を入れる

LSP サーバーは mason が入れます。初回起動後、`:Mason` で導入状況を確認してください。入っていない場合は、次を実行します。

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

- **アイコン:** Nerd Font が無い環境でも表示が崩れないよう、アイコンは無効にしています (nvim-tree, lualine, fzf-lua, which-key, blink.cmp, Lazy)。Nerd Font を使う場合は、各設定の `icons` 関連オプションを戻してください。
- **Rust / Go:** rust_analyzer と gopls が動くには `cargo` / `go` が必要です。`go` が無い環境では gopls を自動で除外します。
- **Makefile:** ハイライトのみで、静的解析は対応していません。
- **macOS:** `brew install neovim tree-sitter-cli ripgrep fzf` で、手順 2 と 3 の代わりになります。
- **更新:** プラグインの更新は `:Lazy update` です。更新後は `lazy-lock.json` をコミットしてください。

## 主なキー操作

リーダーキーは `<Space>` です。`<Space>` を押して待つと which-key がキー一覧を表示します。

| キー | 動作 |
|---|---|
| `<Leader>ff` | ファイル名で検索 |
| `<Leader>fg` | rg で内容検索 |
| `<Leader>fG` | rg で内容検索 (.gitignore を無視) |
| `<Leader>fw` | カーソル下の単語を検索 |
| `<Leader>fb` / `fo` | バッファ / 最近開いたファイル |
| `<Leader>fd` | 診断一覧 |
| `<Leader>e` | ファイルツリーを開く (開いていればフォーカス) |
| `<Leader>E` | ファイルツリーで現在のファイルを表示 |
| `<Leader>m` | ファイルツリーを閉じる |
| `<Leader>t` | 新しいタブ |
| `<Leader>n` / `p` | 次 / 前のタブ |
| `<Leader>1`〜`9` | 番号でタブへ移動 |
| `<Leader>x` | タブを閉じる |
| `<Leader>a` | 現在のウィンドウをタブに移動 |
| `gd` | 定義へ移動 |
| `K` | ホバー |
| `grn` / `gra` | 名前変更 / コードアクション |
| `]d` / `[d` | 次 / 前の診断 |
| `<Leader>cf` | 整形 |
| `<Leader>w` / `q` | 保存 / 閉じる |

ファイルピッカー (fzf-lua) の中では `<C-t>` でタブ、`<C-v>` で縦分割、`<C-s>` で横分割に開けます。
ファイルツリー内では `<CR>` で開く、`<C-t>` で新しいタブ、`a` で作成、`d` で削除、`r` で名前変更、`g?` でヘルプです。

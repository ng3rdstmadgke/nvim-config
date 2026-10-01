-- 静的解析は LSP で行う。サーバーは mason が自動インストール・自動有効化する。
local servers = {
  "pyright", "ruff",                          -- Python
  "vtsls", "vue_ls", "eslint",                -- TS / JS / TSX / JSX / Vue
  "html", "cssls",                            -- HTML / CSS
  "bashls",                                   -- Shell (shellcheck を内部で使う)
  "marksman",                                 -- Markdown
  "terraformls", "tflint",                    -- Terraform
  "rust_analyzer",                            -- Rust
  "yamlls", "jsonls", "taplo",                -- YAML / JSON / TOML
  "lua_ls",                                   -- この設定ファイル用
}
-- gopls は Go ツールチェインが無いと mason でビルドできない
if vim.fn.executable("go") == 1 then
  table.insert(servers, "gopls")
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      { "mason-org/mason-lspconfig.nvim", opts = { ensure_installed = servers } },
      {
        -- LSP 以外のツール (linter 本体 / formatter)
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = { ensure_installed = { "shellcheck", "shfmt", "prettier", "stylua" } },
      },
      "b0o/SchemaStore.nvim",
    },
    config = function()
      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = { spacing = 2, source = "if_many" },
        float = { border = "rounded", source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.HINT] = "H",
          },
        },
      })

      -- vue_ls (hybrid mode) は vtsls に @vue/typescript-plugin を読み込ませて動く
      local vue_plugin = {
        name = "@vue/typescript-plugin",
        location = vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server"),
        languages = { "vue" },
        configNamespace = "typescript",
      }
      vim.lsp.config("vtsls", {
        settings = { vtsls = { tsserver = { globalPlugins = { vue_plugin } } } },
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      })

      vim.lsp.config("jsonls", {
        settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } },
      })
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" }, -- SchemaStore.nvim 側で管理する
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      -- Neovim 0.11+ のデフォルト: grn 名前変更, gra コードアクション, grr 参照, gri 実装, K ホバー, [d ]d 診断移動
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
        callback = function(args)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
          end
          map('<Leader>"', vim.lsp.buf.definition, "定義へ移動")
          map("<Leader>#", function()
            -- 定義元を縦分割で開く。定義が無いときは分割しない
            vim.lsp.buf.definition({
              on_list = function(res)
                local items = res.items
                if #items == 0 then
                  return
                end
                vim.cmd("vsplit " .. vim.fn.fnameescape(items[1].filename))
                vim.api.nvim_win_set_cursor(0, { items[1].lnum, items[1].col - 1 })
                if #items > 1 then
                  vim.fn.setqflist({}, " ", res)
                  vim.cmd("copen")
                end
              end,
            })
          end, "定義元を縦分割で表示")
          map("gD", vim.lsp.buf.declaration, "宣言へ移動")
          map("<Leader>cd", vim.diagnostic.open_float, "診断の詳細")
          map("<Leader>cr", vim.lsp.buf.rename, "名前変更")
          map("<Leader>ca", vim.lsp.buf.code_action, "コードアクション")
        end,
      })
    end,
  },
}

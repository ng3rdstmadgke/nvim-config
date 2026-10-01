return {
  "saghen/blink.cmp",
  version = "1.*", -- v2 は破壊的変更の開発中なので v1 に固定する
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    -- default: <C-y> 確定, <C-n>/<C-p> 選択, <C-e> 閉じる, <C-Space> 呼び出し
    keymap = {
      preset = "default",
      ["<C-k>"] = { "fallback" }, -- インサートモードの <C-k> (上移動) を優先する
    },
    completion = { documentation = { auto_show = true } },
    cmdline = { enabled = true },
  },
}

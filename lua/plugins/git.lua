-- 編集中のファイルと最後のコミットとの差分を表示する。
-- 左端に変更行の記号 (追加 / 変更 / 削除) が出る。ステージや reset は :Gitsigns stage_hunk / reset_hunk で行える。
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- 変更箇所 (hunk) の移動。diff モード (:diffthis) では標準の ]c / [c を使う
      map("]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, "次の変更箇所")
      map("[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, "前の変更箇所")

      map("<Leader>gi", gitsigns.preview_hunk_inline, "変更箇所の差分をファイル内に表示")
      map("<Leader>gp", gitsigns.preview_hunk, "変更箇所の差分をポップアップで表示")
      map("<Leader>gb", function() gitsigns.blame_line({ full = true }) end, "この行の blame")
      map("<Leader>gd", gitsigns.diffthis, "最後のコミットとの差分を左右に並べて表示")
    end,
  },
}

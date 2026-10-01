local M = {}

local STEP = 3

-- 押した方向 → 動かす境界。far: その方向の隣 / near: 反対側の隣 / cmd: リサイズコマンド
local DIRS = {
  l = { far = "l", near = "h", cmd = "vertical resize" },
  h = { far = "h", near = "l", cmd = "vertical resize" },
  j = { far = "j", near = "k", cmd = "resize" },
  k = { far = "k", near = "j", cmd = "resize" },
}

-- ペインの境界を dir (h/j/k/l) の方向に動かす。
-- その方向に隣のペインがあれば、その側の境界を動かす (今のペインが広がる)。
-- 無ければ反対側の境界を動かす (今のペインが狭まる)。
function M.move_border(dir)
  local d = DIRS[dir]
  local function has_neighbor(w)
    return vim.fn.winnr() ~= vim.fn.winnr(w)
  end
  local sign
  if has_neighbor(d.far) then
    sign = "+"
  elseif has_neighbor(d.near) then
    sign = "-"
  else
    return
  end
  vim.cmd(d.cmd .. " " .. sign .. STEP)
end

return M

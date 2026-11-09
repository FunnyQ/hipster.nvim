local c = require("hipster.palette")

local function tint(hex, t)
  local out = "#"
  for i = 2, 6, 2 do
    local v = tonumber(hex:sub(i, i + 1), 16)
    out = out .. ("%02x"):format(math.floor(v + (255 - v) * t + 0.5))
  end
  return out
end

local function mode(color)
  return {
    a = { fg = c.statusline_mode_fg or c.punct, bg = color, gui = "bold" },
    b = { fg = c.statusline_fg or c.bg, bg = c.statusline_section_bg or tint(color, 0.5) },
    c = { fg = c.statusline_fg or c.bg, bg = c.statusline_bg or "#ffffff" },
  }
end

return {
  normal = mode(c.teal),
  insert = mode(c.coral),
  visual = mode(c.purple),
  replace = mode(c.git_delete),
  command = mode(c.warn),
  terminal = mode(c.info),
  inactive = {
    a = { fg = c.statusline_inactive_fg or c.muted, bg = c.statusline_inactive_bg or c.status, gui = "bold" },
    b = { fg = c.statusline_inactive_fg or c.muted, bg = c.statusline_inactive_bg or c.status },
    c = { fg = c.statusline_inactive_fg or c.muted, bg = c.statusline_inactive_bg or c.status },
  },
}

return function(defaults)
  local c = require("hipster.palette")
  local tab_bg = c.tab_bg or c.teal
  local tab_fg = c.tab_fg or c.punct
  local hl = {}
  for name, attrs in pairs(defaults.highlights) do
    local selected = name:match("_selected$") ~= nil
    hl[name] = vim.tbl_extend("force", attrs, {
      bg = selected and c.bg or tab_bg,
      fg = selected and attrs.fg or tab_fg,
    })
    if name:match("^separator") then hl[name].fg = tab_bg end
  end
  hl.fill = { bg = tab_bg }
  hl.buffer_selected = { fg = c.fg, bg = c.bg, bold = true, italic = false }
  hl.indicator_selected = { fg = c.tab_indicator or c.coral, bg = c.bg }
  return hl
end

return function(defaults)
  local c = require("hipster.palette")
  local hl = {}
  for name, attrs in pairs(defaults.highlights) do
    local selected = name:match("_selected$") ~= nil
    hl[name] = vim.tbl_extend("force", attrs, {
      bg = selected and c.bg or c.teal,
      fg = selected and attrs.fg or c.punct,
    })
    if name:match("^separator") then hl[name].fg = c.teal end
  end
  hl.fill = { bg = c.teal }
  hl.buffer_selected = { fg = c.fg, bg = c.bg, bold = true, italic = false }
  hl.indicator_selected = { fg = c.coral, bg = c.bg }
  return hl
end

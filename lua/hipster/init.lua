local M = {}

local options = {
  overrides = function(_) return {} end,
}

function M.setup(opts)
  options = vim.tbl_extend("force", options, opts or {})
end

function M.load()
  local c = require("hipster.palette")

  if vim.g.colors_name then vim.cmd("highlight clear") end
  vim.o.background = "dark"
  vim.g.colors_name = "hipster"

  local groups = vim.tbl_extend("force", require("hipster.highlights")(c), options.overrides(c))
  for group, hl in pairs(groups) do
    vim.api.nvim_set_hl(0, group, hl)
  end

  local terminal = {
    c.bg_dark, c.coral, c.git_add, c.warn, c.blue, c.purple, c.teal, c.fg,
    c.muted, c.red, c.green, c.gold, c.cyan, c.lavender, c.info, "#ffffff",
  }
  for i, color in ipairs(terminal) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
end

return M

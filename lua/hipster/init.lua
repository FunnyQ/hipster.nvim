local M = {}

local options = {
  palette = "hipster",
  overrides = function(_) return {} end,
}

function M.setup(opts)
  local next_options = vim.tbl_extend("force", options, opts or {})
  local selected = next_options.palette
  assert(type(selected) == "string" or type(selected) == "table", "hipster: palette must be a name or color table")
  local colors = type(selected) == "table" and selected or require("hipster.palettes." .. selected)
  colors = vim.tbl_extend("force", require("hipster.palettes.hipster"), colors)
  local current = require("hipster.palette")
  for key in pairs(current) do current[key] = nil end
  for key, color in pairs(colors) do current[key] = color end
  options = next_options
  package.loaded["lualine.themes.hipster"] = nil
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
    c.bg_dark, c.terminal_red or c.coral, c.git_add, c.warn, c.blue, c.purple, c.teal, c.fg,
    c.muted, c.red, c.green, c.gold, c.cyan, c.lavender, c.info, "#ffffff",
  }
  for i, color in ipairs(terminal) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
end

return M

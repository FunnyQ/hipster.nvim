vim.opt.rtp:prepend(vim.fn.getcwd())

local failures = 0
local function eq(name, got, want)
  if vim.deep_equal(got, want) then
    print("ok   " .. name)
  else
    failures = failures + 1
    print(("FAIL %s\n  got:  %s\n  want: %s"):format(name, vim.inspect(got), vim.inspect(want)))
  end
end

local function hex(group, attr)
  local v = vim.api.nvim_get_hl(0, { name = group, link = false })[attr]
  return v and ("#%06x"):format(v)
end

vim.cmd.colorscheme("hipster")
eq("colors_name", vim.g.colors_name, "hipster")
eq("background", vim.o.background, "dark")
eq("Normal bg", hex("Normal", "bg"), "#2c3e50")
eq("LineNr gutter is coral", hex("LineNr", "bg"), "#d45649")
eq("LineNr is bold", vim.api.nvim_get_hl(0, { name = "LineNr" }).bold, true)
eq("CursorColumn stands out from the editor", hex("CursorColumn", "bg"), "#3f5469")
eq("git add sign is teal", hex("GitSignsAdd", "fg"), "#1abc9c")
eq("git change sign is a deeper yellow", hex("GitSignsChange", "fg"), "#f5cc5a")
eq("git delete sign is bright red", hex("GitSignsDelete", "fg"), "#ff1a2d")
for _, group in ipairs({ "DiagnosticSignError", "DiagnosticSignWarn", "DiagnosticSignInfo", "DiagnosticSignHint",
  "GitSignsAdd", "GitSignsChange", "GitSignsDelete" }) do
  eq(group .. " takes its bg from SignColumn", hex(group, "bg"), nil)
end
eq("noice cmdline border is teal", hex("NoiceCmdlinePopupBorder", "fg"), "#1abc9c")
eq("noice cmdline border has no gutter bg", hex("NoiceCmdlinePopupBorder", "bg"), nil)
eq("noice search border is gold", hex("NoiceCmdlinePopupBorderSearch", "fg"), "#ffcb6b")
eq("String", hex("String", "fg"), "#f78794")
eq("@variable.member is teal", hex("@variable.member", "fg"), "#1abc9c")
vim.api.nvim_set_hl(0, "SnacksPickerTree", { link = "LineNr", default = true })
eq("snacks tree lines have no gutter bg", hex("SnacksPickerTree", "bg"), nil)
eq("minimap git delete sign shows on the editor bg", hex("NeominimapGitDeleteSign", "fg"), "#eb2525")
eq("minimap cursor line sign follows CursorLine", hex("NeominimapCursorLineSign", "bg"), "#34495e")
eq("lualine diff delete reads on a light segment", hex("LuaLineDiffDelete", "fg"), "#a93226")
eq("terminal color 1", vim.g.terminal_color_1, "#d45649")

require("hipster").setup({
  overrides = function(c)
    return { Comment = { fg = c.teal }, MyGroup = { bg = c.coral } }
  end,
})
vim.cmd.colorscheme("hipster")
eq("override replaces a group", hex("Comment", "fg"), "#1abc9c")
eq("override drops replaced attrs", vim.api.nvim_get_hl(0, { name = "Comment" }).italic, nil)
eq("override adds a group", hex("MyGroup", "bg"), "#d45649")

local theme = require("lualine.themes.hipster")
eq("lualine normal a", theme.normal.a.bg, "#1abc9c")
eq("lualine insert a", theme.insert.a.bg, "#d45649")
eq("lualine normal b is a light teal", theme.normal.b.bg, "#8ddece")
eq("lualine insert b is a light coral", theme.insert.b.bg, "#eaaba4")
eq("lualine c is white", theme.normal.c, { fg = "#2c3e50", bg = "#ffffff" })

local bl = require("hipster.bufferline")({
  highlights = {
    fill = { bg = "#000000" },
    background = { fg = "#111111", bg = "#000000" },
    buffer_selected = { fg = "#111111", bg = "#000000", italic = true },
    error_visible = { fg = "#ff0000", bg = "#000000" },
    separator = { fg = "#000000", bg = "#000000" },
    separator_selected = { fg = "#000000", bg = "#000000" },
    indicator_selected = { fg = "#000000", bg = "#000000" },
  },
})
eq("bufferline fill is teal", bl.fill.bg, "#1abc9c")
eq("bufferline inactive tab", bl.background, { fg = "#eeeeee", bg = "#1abc9c" })
eq("bufferline selected tab joins the editor", bl.buffer_selected, { fg = "#ecf0f1", bg = "#2c3e50", bold = true, italic = false })
eq("bufferline inactive diagnostics stay readable", bl.error_visible.fg, "#eeeeee")
eq("bufferline slope separator", bl.separator, { fg = "#1abc9c", bg = "#1abc9c" })
eq("bufferline selected slope separator", bl.separator_selected, { fg = "#1abc9c", bg = "#2c3e50" })
eq("bufferline indicator is coral", bl.indicator_selected.fg, "#d45649")

if failures > 0 then os.exit(1) end

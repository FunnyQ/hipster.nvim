# hipster.nvim

A dark Neovim colorscheme with selectable palettes. Keep the original [Hipster](https://github.com/lalevac/vscode-hipster-theme) colors or use AWACS for a CRT phosphor-green tactical interface.

## Requirements

- Neovim 0.10 or later
- `termguicolors` on

## Install

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "FunnyQ/hipster.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("hipster")
  end,
}
```

## Options

Call `setup` before `:colorscheme hipster`. Select a built-in palette with `palette`:

| Palette | Editor | Gutter, tabs and status line |
| --- | --- | --- |
| `"hipster"` (default) | Slate blue, teal and coral | Coral gutter, teal tabs, white status line |
| `"awacs"` | Black-green CRT, phosphor green, amber and red | Blue gutter, muted green buffer bar and status line |

```lua
require("hipster").setup({ palette = "awacs" })
vim.cmd.colorscheme("hipster")
```

Run both lines again to switch palettes in the current session. Keep the `hipster` colorscheme name for both palettes. Omit `palette` in later `setup` calls to keep the selected palette.

Pass a color table to create a custom palette. Unspecified colors inherit from the original Hipster palette. Extend AWACS explicitly when using it as a base:

```lua
require("hipster").setup({
  palette = vim.tbl_extend("force", require("hipster.palettes.awacs"), {
    bg = "#081522",
    blue = "#abc9e5",
  }),
})
vim.cmd.colorscheme("hipster")
```

Use `overrides` for highlight attributes or transparency. It receives the selected palette and returns highlight groups. Each group replaces the built-in one whole.

```lua
require("hipster").setup({
  palette = "awacs",
  overrides = function(c)
    return {
      Comment = { fg = c.muted, italic = true },
      CursorLine = { bg = c.bg_dark },
      Normal = { fg = c.fg, bg = "NONE" },
    }
  end,
})
```

Find built-in palettes in `lua/hipster/palettes/`. Read the active colors through `require("hipster.palette")`; cached references follow palette changes. Use the optional `gutter_*`, `tab_*`, `statusline_*` and `accent_fg` fields in the AWACS palette to style UI surfaces separately from syntax colors. Set `terminal_red` to choose the normal terminal red independently of the coral accent.

## Lualine

```lua
require("lualine").setup({ options = { theme = "hipster" } })
```

Use the same lualine theme name for both palettes. Hipster uses a white bar with tinted mode sections; AWACS uses a muted green bar with a darker green section. Reload the colorscheme after switching palettes to refresh lualine.

Use the palette's `on_light_*` fields for diagnostics. These retain their original names and follow the selected status line colors:

```lua
local p = require("hipster.palette")
lualine_b = {
  "branch",
  "diff",
  {
    "diagnostics",
    diagnostics_color = {
      error = { fg = p.on_light_delete },
      warn = { fg = p.on_light_change },
      info = { fg = p.on_light_info },
      hint = { fg = p.on_light_hint },
    },
  },
}
```

## Bufferline

Pass the Hipster highlights callback to bufferline.nvim. Hipster uses a teal bar; AWACS uses a muted green bar matching its status line. The current buffer joins the editor in both palettes.

```lua
require("bufferline").setup({
  options = { separator_style = "slant" },
  highlights = require("hipster.bufferline"),
})
```

## Neominimap

The coral gutter is `SignColumn`, and neominimap.nvim keeps it in the minimap window. Map it to the minimap background:

```lua
vim.g.neominimap = {
  winopt = function(opt)
    opt.winhighlight = opt.winhighlight .. ",SignColumn:NeominimapBackground"
  end,
}
```

## Supported plugins

Treesitter, LSP semantic tokens, diagnostics, gitsigns, blink.cmp, snacks.nvim, flash.nvim, virt-column.nvim, and neominimap.nvim. Other plugins fall back to the standard groups they link to.

## Development

```sh
nvim --clean -l tests/run.lua
```

## Credits

Colors from [vscode-hipster-theme](https://github.com/lalevac/vscode-hipster-theme) by lalevac, MIT licensed.

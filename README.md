# hipster.nvim

A dark Neovim colorscheme ported from [Hipster](https://github.com/lalevac/vscode-hipster-theme): a slate-blue editor, a coral gutter, and teal accents.

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

Call `setup` before `:colorscheme hipster`. `overrides` receives the palette and returns highlight groups. Each group replaces the built-in one whole.

```lua
require("hipster").setup({
  overrides = function(c)
    return {
      Comment = { fg = c.muted, italic = true },
      CursorLine = { bg = c.bg_dark },
    }
  end,
})
```

The palette lives in `lua/hipster/palette.lua`.

## Lualine

```lua
require("lualine").setup({ options = { theme = "hipster" } })
```

Each mode paints section `a` in its color and section `b` in a light tint of it, on a white bar. The diff counts already read on the light sections. Diagnostics take their colors from the dark editor, so give them the `on_light_*` palette:

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

bufferline.nvim derives its colors from `Normal`, so pass the Hipster highlights to it. Tabs sit on a teal bar and the current buffer joins the editor.

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

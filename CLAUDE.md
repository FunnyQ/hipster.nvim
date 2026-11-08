# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

hipster.nvim is a dark Neovim colorscheme (Neovim 0.10+, `termguicolors`) ported from vscode-hipster-theme: a slate-blue editor (`#2c3e50`), a coral gutter, and teal accents. It is pure Lua with no dependencies.

## Commands

Run the test suite (headless, no user config):

```sh
nvim --clean -l tests/run.lua
```

`tests/run.lua` is one flat script with an `eq(name, got, want)` helper; it prints `ok`/`FAIL` per check and exits 1 on any failure. There is no per-test runner. To run a single check, comment out the others or run a one-off with `nvim --clean -l` using the same `rtp:prepend` + `hex()` helper. There is no build or lint step.

## Architecture

- `colors/hipster.lua` calls `require("hipster").load()`.
- `lua/hipster/init.lua`: `setup({ overrides })` stores options; `load()` clears highlights, merges `highlights(c)` with `overrides(c)` via `vim.tbl_extend("force")`, applies them with `nvim_set_hl`, and sets the 16 `terminal_color_*` globals. An override replaces a group whole; it does not merge attributes.
- `lua/hipster/palette.lua` is the single source of colors. Every other module reads from it. It also holds `on_light_*` colors for text drawn on the white/tinted lualine sections.
- `lua/hipster/highlights.lua` returns `function(c) -> { group = attrs }` covering editor, Treesitter, LSP, diagnostics, and supported plugins (gitsigns, blink.cmp, snacks, flash, virt-column, neominimap, noice).
- `lua/lualine/themes/hipster.lua`: section `a` is the mode color, `b` is a 50% white `tint()` of it, `c` is white.
- `lua/hipster/bufferline.lua` returns a function that takes bufferline's `defaults` and rewrites every group: `*_selected` groups get the editor bg, the rest sit on teal. Users pass it as `highlights = require("hipster.bufferline")`.

## Gotchas

- The gutter is coral (`SignColumn`/`LineNr` bg). Sign groups (`DiagnosticSign*`, `GitSigns*`) must not set `bg`, so they inherit the gutter; otherwise they paint coral into floats and popups (see commit 64644e5, noice borders). Tests assert these `bg` values are `nil`.
- Plugins that link to `LineNr` (e.g. `SnacksPickerTree`) would inherit the coral bg; the tests cover this case.
- Tests assert exact hex values, so a palette change usually needs a matching test update.
- When adding plugin support, update the "Supported plugins" list in `README.md`.

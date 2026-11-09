# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

hipster.nvim is a dark Neovim colorscheme (Neovim 0.10+, `termguicolors`) with selectable palettes. The default Hipster palette is ported from vscode-hipster-theme; AWACS provides a navy tactical briefing palette. It is pure Lua with no dependencies.

## Commands

Run the test suite (headless, no user config):

```sh
nvim --clean -l tests/run.lua
```

`tests/run.lua` is one flat script with an `eq(name, got, want)` helper; it prints `ok`/`FAIL` per check and exits 1 on any failure. There is no per-test runner. To run a single check, comment out the others or run a one-off with `nvim --clean -l` using the same `rtp:prepend` + `hex()` helper. There is no build or lint step.

## Architecture

- `colors/hipster.lua` calls `require("hipster").load()`.
- `lua/hipster/init.lua`: `setup({ palette, overrides })` selects a named or custom palette, updates the active table in place, and invalidates the cached lualine theme. `load()` clears highlights, merges `highlights(c)` with `overrides(c)`, applies them with `nvim_set_hl`, and sets the 16 terminal colors. An override replaces a group whole.
- `lua/hipster/palettes/` holds built-in color tables. Custom tables inherit unspecified fields from `hipster.lua`. `lua/hipster/palette.lua` is the stable active table; cached references must keep following palette switches. Optional gutter, tab and status line fields separate UI surfaces from syntax accents. `on_light_*` fields retain their names but match each palette's status line.
- `lua/hipster/highlights.lua` returns `function(c) -> { group = attrs }` covering editor, Treesitter, LSP, diagnostics, and supported plugins (gitsigns, blink.cmp, snacks, flash, virt-column, neominimap, noice).
- `lua/lualine/themes/hipster.lua`: Hipster uses tinted sections and a white bar; AWACS uses dark sections and a colored mode label.
- `lua/hipster/bufferline.lua` returns a highlights callback. Selected buffers use the editor background; inactive buffers follow `tab_bg` or the original teal fallback.

## Gotchas

- Hipster uses a coral gutter; AWACS uses a dark gutter. Sign groups (`DiagnosticSign*`, `GitSigns*`) must not set `bg`, so they inherit the gutter instead of painting it into floats and popups (see commit 64644e5, noice borders). Tests assert these `bg` values are `nil`.
- Plugins that link to `LineNr` (e.g. `SnacksPickerTree`) would inherit the coral bg; the tests cover this case.
- Tests assert exact hex values, so a palette change usually needs a matching test update.
- When adding plugin support, update the "Supported plugins" list in `README.md`.

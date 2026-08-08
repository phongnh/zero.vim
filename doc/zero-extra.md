# zero/extra.lua

Extra textobject specifications for [mini.ai](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md).

## `M.gen_ai_spec.comment`

A port of [vim-textobj-comment](https://github.com/glts/vim-textobj-comment) to the `mini.ai` textobject specification.

### Usage

```lua
require('mini.ai').setup({
  custom_textobjects = {
    c = require('zero.extra').gen_ai_spec.comment(),
  },
})
```

### Textobjects

| Key | Description |
|-----|-------------|
| `ac` | **around** comment — selects the full comment including delimiters |
| `ic` | **inner** comment — selects only the comment content, stripping delimiters and surrounding whitespace |
| `anc` / `inc` | next comment |
| `alc` / `ilc` | last (previous) comment |

### Comment types detected

Comment leaders are read from `'comments'` (`&comments`) with a fallback to `'commentstring'` (`&commentstring`), so it automatically adapts to any filetype.

#### Simple line comments

Lines whose content starts with the comment leader (e.g. `//`, `#`, `--`).
Contiguous runs of comment lines are treated as a single block.

```lua
-- this is one block
-- spanning two lines

# another block
```

- `ac` — selects the whole block, linewise (`V` mode)
- `ic` — selects the content after stripping leaders and surrounding whitespace, charwise

#### Paired block comments

Open/close delimiter pairs (e.g. `/* ... */`, `--[[ ... ]]`).

```lua
/* single-line block */

/*
 * multi-line block
 */
```

- `ac` on multi-line — selects the whole block, linewise (`V` mode)
- `ac` on single-line — selects the whole block, charwise
- `ic` — selects content between delimiters, trimming whitespace, charwise

#### Inline / end-of-line comments

Comments that appear after code on the same line.

```lua
local x = 1  -- end-of-line comment
local y = f(/* inline */ 2)
```

- `ac` — selects from the comment leader to end of comment, charwise
- `ic` — selects comment content only, charwise

### Visual mode behaviour

| Selection | `vis_mode` | Result |
|-----------|-----------|--------|
| `ac` on multi-line block | `V` | Linewise — whole lines selected |
| `ac` on single-line paired | charwise | Only the `/* ... */` span |
| `ac` on inline comment | `v` | Charwise — prevents inheriting `V` from a prior `ac` |
| `ic` (all types) | `v` | Always charwise — prevents inheriting `V` from `ac` |

### next / last variants

Because the spec function returns **all** comment regions in the buffer as an array, `mini.ai` can apply its full `cover / next / prev / nearest` search logic. This enables:

- `anc` / `inc` — jump to and select the **next** comment
- `alc` / `ilc` — jump to and select the **last** (previous) comment
- Repeated `ac` increments through all comments in order

### Implementation notes

- All buffer lines are loaded once with `vim.api.nvim_buf_get_lines` at invocation time; no per-line `vim.fn.getline` calls.
- `vim.pesc` is used for all pattern escaping.
- Simple leader flag check uses `^[bnOf]*$` (strict — excludes middle-of-block `m`, start `s`, end `e` markers).
- Regions are sorted by `(from.line, from.col)` before being returned so `mini.ai` search works correctly.

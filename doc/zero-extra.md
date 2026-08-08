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

## Known differences from vim-textobj-comment

### Consecutive single-line `/* */` blocks are not merged

The original `vim-textobj-comment` merges adjacent single-line paired comments into one block:

```c
/* line one */
/* line two */   ← treated as one big comment by vim-textobj-comment
/* line three */
```

With `vim-textobj-comment`, `ac` on any of these lines selects all three. In this implementation each `/* ... */` is returned as a **separate region**. This was a deliberate choice — separate regions are more flexible with `mini.ai`'s next/last navigation (`anc`/`alc` can target each block individually).

If you want to implement merging later, the algorithm from `vim-textobj-comment`'s `s:FindNearestPair()` is:

```vim
" After finding a single-line paired block at [start, end] where start == end:
" Walk upward from start, merging consecutive single-line blocks
let ln = start[0] - 1
while ln > 0
  let col = match(getline(ln), startre)   " startre matches /^...*end..$/
  if col < 0 | break | endif
  let [start[0], start[1]] = [ln, col+1]
  let ln -= 1
endwhile
" Walk downward from end, merging consecutive single-line blocks
let ln = end[0] + 1
while ln <= line("$")
  let col = match(getline(ln), endre)
  if col < 0 | break | endif
  let [end[0], end[1]] = [ln, col+1]
  let ln += 1
endwhile
```

In Lua, replace `find_all_paired_comment_blocks` with this version that merges adjacent single-line blocks:

```lua
local function find_all_paired_comment_blocks(lines, open, close)
  local blocks = {}
  local total = #lines
  local open_re = '^%s*' .. vim.pesc(open)
  local close_re = vim.pesc(close) .. '%s*$'
  local single_re = '^%s*' .. vim.pesc(open) .. '.-' .. vim.pesc(close) .. '%s*$'
  local ln = 1
  while ln <= total do
    if lines[ln]:match(open_re) then
      local start_line = ln
      local found = false
      for el = ln, total do
        if lines[el]:match(close_re) then
          local sl, end_line = start_line, el
          -- Merge consecutive single-line /* */ blocks
          if sl == end_line then
            local up = sl - 1
            while up >= 1 and lines[up]:match(single_re) do
              sl = up
              up = up - 1
            end
            local down = end_line + 1
            while down <= total and lines[down]:match(single_re) do
              end_line = down
              down = down + 1
            end
          end
          table.insert(blocks, { start_line = sl, end_line = end_line })
          ln = end_line
          found = true
          break
        end
      end
      if not found then break end
    end
    ln = ln + 1
  end
  return blocks
end
```

Note: with merging enabled, `anc`/`alc` will treat the merged group as one unit, losing the ability to target individual `/* */` lines.

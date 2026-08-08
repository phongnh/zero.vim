local M = {}

M.gen_ai_spec = {}

-- Parse 'comments' option into {flags, leader} pairs, with 'commentstring' as fallback.
-- Returns two lists: simple leaders (e.g. "//", "#") and paired leaders (e.g. {open="/*", close="*/"}).
local function get_comment_leaders()
  local comments = vim.bo.comments
  local leaders = {}

  if comments ~= '' then
    for entry in vim.gsplit(comments, ',') do
      local colon = entry:find(':')
      if colon then
        local flags = entry:sub(1, colon - 1)
        local leader = entry:sub(colon + 1)
        table.insert(leaders, { flags = flags, leader = leader })
      end
    end
  end

  -- Fallback to commentstring if no leaders found
  if #leaders == 0 then
    local cms = vim.bo.commentstring
    if cms:find('%%s') then
      local before, after = cms:match('^(.-)%s*%%s(.-)%s*$')
      if before and before ~= '' and after and after ~= '' then
        table.insert(leaders, { flags = 's', leader = before })
        table.insert(leaders, { flags = 'e', leader = after })
      elseif before and before ~= '' then
        table.insert(leaders, { flags = '', leader = before })
      end
    end
  end

  local simple = {}
  local paired = {} -- list of {open, close}

  local se_leaders = vim.tbl_filter(function(l)
    return l.flags:match('[se]')
  end, leaders)

  for i = 1, #se_leaders - 1 do
    local s, e = se_leaders[i], se_leaders[i + 1]
    if s.flags:match('s') and e.flags:match('e') then
      table.insert(paired, { open = s.leader, close = e.leader })
    end
  end

  for _, l in ipairs(leaders) do
    -- Simple leaders have flags that are empty or contain only b, n, O, f characters
    if l.flags:match('^[bnOf]*$') then
      table.insert(simple, l.leader)
    end
  end

  return simple, paired
end

-- Returns the simple leader that matches at the start of the given line, or nil.
local function match_simple_leader(line, simple_leaders)
  for _, leader in ipairs(simple_leaders) do
    if line:match('^%s*' .. vim.pesc(leader)) then
      return leader
    end
  end
  return nil
end

-- Scan the whole buffer and return all contiguous simple comment blocks as
-- a list of {start_line, end_line, leader}.
local function find_all_simple_comment_blocks(lines, simple_leaders)
  local blocks = {}
  local total = #lines
  local ln = 1
  while ln <= total do
    local leader = match_simple_leader(lines[ln], simple_leaders)
    if leader then
      local leader_re = '^%s*' .. vim.pesc(leader)
      local start_line = ln
      while ln < total and lines[ln + 1]:match(leader_re) do
        ln = ln + 1
      end
      table.insert(blocks, { start_line = start_line, end_line = ln, leader = leader })
    end
    ln = ln + 1
  end
  return blocks
end

-- Scan the whole buffer and return all paired comment blocks (/* ... */) as
-- a list of {start_line, end_line}.
local function find_all_paired_comment_blocks(lines, open, close)
  local blocks = {}
  local total = #lines
  local open_re = '^%s*' .. vim.pesc(open)
  local close_re = vim.pesc(close) .. '%s*$'
  local ln = 1
  while ln <= total do
    if lines[ln]:match(open_re) then
      local start_line = ln
      local found = false
      for el = ln, total do
        if lines[el]:match(close_re) then
          table.insert(blocks, { start_line = start_line, end_line = el })
          ln = el
          found = true
          break
        end
      end
      if not found then
        break
      end
    end
    ln = ln + 1
  end
  return blocks
end

-- Scan each line for inline/end-of-line simple comments (leader not at line start).
-- e.g. "code  // trailing comment" or "code  # remark"
-- Returns a list of {line, col_start, col_end, leader}.
local function find_all_inline_simple_comments(lines, simple_leaders)
  local results = {}
  for ln, line in ipairs(lines) do
    -- Skip pure comment lines (already handled by find_all_simple_comment_blocks)
    if not match_simple_leader(line, simple_leaders) then
      for _, leader in ipairs(simple_leaders) do
        local col = line:find(vim.pesc(leader))
        if col and col > 1 then
          table.insert(results, { line = ln, col_start = col, col_end = #line, leader = leader })
          break -- take the first matching leader per line
        end
      end
    end
  end
  return results
end

-- Scan each line for inline paired comments (/* ... */ not at line start).
-- Returns a list of {line, col_start, col_end, open, close}.
local function find_all_inline_paired_comments(lines, open, close)
  local results = {}
  local esc_open = vim.pesc(open)
  local esc_close = vim.pesc(close)
  local open_re = '^%s*' .. esc_open
  for ln, line in ipairs(lines) do
    -- Skip lines where the open is at line start (handled by paired block scanner)
    if not line:match(open_re) then
      local pos = 1
      while true do
        local s = line:find(esc_open, pos)
        if not s then break end
        local e = line:find(esc_close, s + #open)
        if not e then break end
        local col_end = e + #close - 1
        table.insert(results, { line = ln, col_start = s, col_end = col_end, open = open, close = close })
        pos = col_end + 1
      end
    end
  end
  return results
end

-- Build the inner region for a simple comment block: strip leader and trailing whitespace.
local function simple_comment_inner(lines, start_line, end_line, leader)
  local leader_re = '^%s*' .. vim.pesc(leader)
  local first_content_col = nil
  for ln = start_line, end_line do
    local line = lines[ln]
    local _, e = line:find(leader_re)
    if e then
      local rest = line:sub(e + 1)
      local trimmed_start = rest:find('%S')
      if trimmed_start and not first_content_col then
        first_content_col = e + trimmed_start
      end
    end
  end
  local last_line = lines[end_line]
  local last_col = #last_line:match('(.-)%s*$')
  return {
    from = { line = start_line, col = first_content_col or 1 },
    to = { line = end_line, col = math.max(last_col, 1) },
    vis_mode = 'v',
  }
end

-- Build the inner region for a paired comment block: skip open/close delimiters.
local function paired_comment_inner(lines, start_line, end_line, open, close)
  local open_line = lines[start_line]
  local _, oe = open_line:find(vim.pesc(open))
  local rest_after_open = open_line:sub((oe or 0) + 1)
  local nonws = rest_after_open:find('%S')

  local from_line, from_col, to_line, to_col

  if nonws and start_line == end_line then
    -- Single-line: /* content */
    local close_line = lines[end_line]
    local cs = close_line:find('%s*' .. vim.pesc(close) .. '%s*$')
    from_line = start_line
    from_col = (oe or 0) + nonws
    to_line = end_line
    to_col = (cs or #close_line + 1) - 1
    if to_col < from_col then
      return nil
    end
    return {
      from = { line = from_line, col = from_col },
      to = { line = to_line, col = to_col },
      vis_mode = 'v',
    }
  else
    -- Multi-line: first non-blank char after open, last non-blank char before close
    from_line = start_line
    from_col = (oe or 0) + (nonws or #rest_after_open + 1)
    if not nonws then
      -- open delimiter is alone on its line; content starts on the next line
      from_line = start_line + 1
      local next_line = lines[from_line]
      from_col = next_line:find('%S') or 1
    end
    local close_line_str = lines[end_line]
    local cs = close_line_str:find('%s*' .. vim.pesc(close) .. '%s*$')
    local content_before_close = close_line_str:sub(1, (cs or #close_line_str + 1) - 1)
    local last_nonws = #content_before_close:match('(.-)%s*$')
    to_line = end_line
    to_col = last_nonws
    if last_nonws == 0 then
      to_line = end_line - 1
      local prev = lines[to_line]
      to_col = #prev:match('(.-)%s*$')
    end
  end

  return {
    from = { line = from_line, col = from_col },
    to = { line = to_line, col = math.max(to_col, 1) },
    vis_mode = 'v',
  }
end

-- Port of vim-textobj-comment to mini.ai textobject specification.
-- Supports both simple (// ...) and paired (/* ... */) comment delimiters.
-- Uses the 'comments' and 'commentstring' options to determine comment leaders.
-- Returns all comment regions in the buffer so mini.ai can apply its
-- cover/next/prev/nearest search methods (enabling next/last variants).
M.gen_ai_spec.comment = function()
  return function(ai_type)
    local simple_leaders, paired_leaders = get_comment_leaders()
    if #simple_leaders == 0 and #paired_leaders == 0 then
      return nil
    end

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local regions = {}

    for _, block in ipairs(find_all_simple_comment_blocks(lines, simple_leaders)) do
      if ai_type == 'i' then
        local region = simple_comment_inner(lines, block.start_line, block.end_line, block.leader)
        if region then
          table.insert(regions, region)
        end
      else
        local end_col = #lines[block.end_line]
        table.insert(regions, {
          from = { line = block.start_line, col = 1 },
          to = { line = block.end_line, col = math.max(end_col, 1) },
          vis_mode = 'V',
        })
      end
    end

    for _, pair in ipairs(paired_leaders) do
      for _, block in ipairs(find_all_paired_comment_blocks(lines, pair.open, pair.close)) do
        if ai_type == 'i' then
          local region = paired_comment_inner(lines, block.start_line, block.end_line, pair.open, pair.close)
          if region then
            table.insert(regions, region)
          end
        else
          local end_col = #lines[block.end_line]
          table.insert(regions, {
            from = { line = block.start_line, col = 1 },
            to = { line = block.end_line, col = math.max(end_col, 1) },
            vis_mode = block.start_line ~= block.end_line and 'V' or nil,
          })
        end
      end
    end

    -- Inline/end-of-line simple comments: "code  // remark"
    for _, c in ipairs(find_all_inline_simple_comments(lines, simple_leaders)) do
      if ai_type == 'i' then
        local _, e = lines[c.line]:find('^%s*' .. vim.pesc(c.leader), c.col_start)
        local rest = lines[c.line]:sub((e or c.col_start) + 1)
        local trimmed = rest:find('%S')
        local from_col = trimmed and (e or c.col_start) + trimmed or c.col_start
        local to_col = #lines[c.line]:match('(.-)%s*$')
        if from_col <= to_col then
          table.insert(regions, { from = { line = c.line, col = from_col }, to = { line = c.line, col = to_col }, vis_mode = 'v' })
        end
      else
        table.insert(regions, { from = { line = c.line, col = c.col_start }, to = { line = c.line, col = c.col_end } })
      end
    end

    -- Inline paired comments: "code /* remark */ more"
    for _, pair in ipairs(paired_leaders) do
      for _, c in ipairs(find_all_inline_paired_comments(lines, pair.open, pair.close)) do
        if ai_type == 'i' then
          local from_col = c.col_start + #pair.open
          local to_col = c.col_end - #pair.close
          local inner = lines[c.line]:sub(from_col, to_col)
          local lt = inner:match('^%s*')
          local rt = inner:match('%s*$')
          from_col = from_col + #lt
          to_col = to_col - #rt
          if from_col <= to_col then
            table.insert(regions, { from = { line = c.line, col = from_col }, to = { line = c.line, col = to_col }, vis_mode = 'v' })
          end
        else
          table.insert(regions, { from = { line = c.line, col = c.col_start }, to = { line = c.line, col = c.col_end } })
        end
      end
    end

    -- Sort regions by start position so mini.ai search works correctly
    table.sort(regions, function(a, b)
      if a.from.line ~= b.from.line then
        return a.from.line < b.from.line
      end
      return a.from.col < b.from.col
    end)

    return regions
  end
end

return M

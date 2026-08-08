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

  local i = 1
  while i <= #se_leaders do
    local s = se_leaders[i]
    local e = se_leaders[i + 1]
    if s and e and s.flags:match('s') and e.flags:match('e') then
      table.insert(paired, { open = s.leader, close = e.leader })
      i = i + 2
    else
      i = i + 1
    end
  end

  for _, l in ipairs(leaders) do
    -- Simple leaders have flags that contain only b, n, O or are empty (no s/e/m)
    if not l.flags:match('[sem]') then
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

-- Find a contiguous block of simple comment lines that includes lnum.
-- Returns start_line, end_line, matched_leader or nil.
local function find_simple_comment_block(lnum, simple_leaders)
  local line = vim.fn.getline(lnum)
  local leader = match_simple_leader(line, simple_leaders)
  if not leader then
    return nil
  end

  local leader_re = '^%s*' .. vim.pesc(leader)
  local start_line = lnum
  while start_line > 1 and vim.fn.getline(start_line - 1):match(leader_re) do
    start_line = start_line - 1
  end
  local end_line = lnum
  while end_line < vim.fn.line('$') and vim.fn.getline(end_line + 1):match(leader_re) do
    end_line = end_line + 1
  end
  return start_line, end_line, leader
end

-- Find a paired comment block (/* ... */) that contains lnum, or the nearest one above
-- when upwards=true.
local function find_paired_comment_block(lnum, open, close, upwards)
  local open_re = '^%s*' .. vim.pesc(open)
  local close_re = vim.pesc(close) .. '%s*$'
  local total = vim.fn.line('$')

  if upwards then
    for ln = lnum - 1, 1, -1 do
      if vim.fn.getline(ln):match(close_re) then
        local end_line = ln
        for sl = ln, 1, -1 do
          if vim.fn.getline(sl):match(open_re) then
            return sl, end_line
          end
        end
      end
    end
    return nil
  else
    for ln = lnum, total do
      if vim.fn.getline(ln):match(close_re) then
        local end_line = ln
        for sl = end_line, 1, -1 do
          if vim.fn.getline(sl):match(open_re) then
            if sl <= lnum then
              return sl, end_line
            end
            break
          end
        end
        break
      end
    end
    return nil
  end
end

-- Build the inner region for a simple comment block: strip leader and trailing whitespace.
local function simple_comment_inner(start_line, end_line, leader)
  local leader_re = '^%s*' .. vim.pesc(leader)
  local first_content_col = nil
  for ln = start_line, end_line do
    local line = vim.fn.getline(ln)
    local _, e = line:find(leader_re)
    if e then
      local rest = line:sub(e + 1)
      local trimmed_start = rest:find('%S')
      if trimmed_start and not first_content_col then
        first_content_col = e + trimmed_start
      end
    end
  end
  local last_line = vim.fn.getline(end_line)
  local last_col = #last_line:match('(.-)%s*$')
  return {
    from = { line = start_line, col = first_content_col or 1 },
    to = { line = end_line, col = math.max(last_col, 1) },
  }
end

-- Build the inner region for a paired comment block: skip open/close delimiters.
local function paired_comment_inner(start_line, end_line, open, close)
  local open_line = vim.fn.getline(start_line)
  local _, oe = open_line:find(vim.pesc(open))
  local rest_after_open = open_line:sub((oe or 0) + 1)
  local nonws = rest_after_open:find('%S')

  local from_line, from_col, to_line, to_col

  if nonws and start_line == end_line then
    -- Single-line: /* content */
    local close_line = vim.fn.getline(end_line)
    local cs = close_line:find('%s*' .. vim.pesc(close) .. '%s*$')
    from_line = start_line
    from_col = (oe or 0) + nonws
    to_line = end_line
    to_col = (cs or #close_line + 1) - 1
    if to_col < from_col then
      return nil
    end
  else
    -- Multi-line: first non-blank char after open, last non-blank char before close
    from_line = start_line
    from_col = (oe or 0) + (nonws or #rest_after_open + 1)
    if not nonws then
      -- open delimiter is alone on its line; content starts on the next line
      from_line = start_line + 1
      local next_line = vim.fn.getline(from_line)
      from_col = next_line:find('%S') or 1
    end
    local close_line_str = vim.fn.getline(end_line)
    local cs = close_line_str:find('%s*' .. vim.pesc(close) .. '%s*$')
    local content_before_close = close_line_str:sub(1, (cs or #close_line_str + 1) - 1)
    local last_nonws = #content_before_close:match('(.-)%s*$')
    to_line = end_line
    to_col = last_nonws
    if last_nonws == 0 then
      to_line = end_line - 1
      local prev = vim.fn.getline(to_line)
      to_col = #prev:match('(.-)%s*$')
    end
  end

  return {
    from = { line = from_line, col = from_col },
    to = { line = to_line, col = math.max(to_col, 1) },
  }
end

-- Port of vim-textobj-comment to mini.ai textobject specification.
-- Supports both simple (// ...) and paired (/* ... */) comment delimiters.
-- Uses the 'comments' and 'commentstring' options to determine comment leaders.
M.gen_ai_spec.comment = function()
  return function(ai_type)
    local simple_leaders, paired_leaders = get_comment_leaders()
    if #simple_leaders == 0 and #paired_leaders == 0 then
      return nil
    end

    local lnum = vim.fn.line('.')

    -- 1. Try simple line comment at cursor
    local start_line, end_line, leader = find_simple_comment_block(lnum, simple_leaders)
    if start_line then
      if ai_type == 'i' then
        return simple_comment_inner(start_line, end_line, leader)
      else
        local end_col = #vim.fn.getline(end_line)
        return { from = { line = start_line, col = 1 }, to = { line = end_line, col = math.max(end_col, 1) } }
      end
    end

    -- 2. Try paired comment containing cursor
    for _, pair in ipairs(paired_leaders) do
      start_line, end_line = find_paired_comment_block(lnum, pair.open, pair.close, false)
      if start_line then
        if ai_type == 'i' then
          return paired_comment_inner(start_line, end_line, pair.open, pair.close)
        else
          local end_col = #vim.fn.getline(end_line)
          return { from = { line = start_line, col = 1 }, to = { line = end_line, col = math.max(end_col, 1) } }
        end
      end
    end

    -- 3. Search upward for nearest comment (simple first, then paired)
    for ln = lnum - 1, 1, -1 do
      start_line, end_line, leader = find_simple_comment_block(ln, simple_leaders)
      if start_line then
        local end_col = #vim.fn.getline(end_line)
        return { from = { line = start_line, col = 1 }, to = { line = end_line, col = math.max(end_col, 1) } }
      end
    end

    for _, pair in ipairs(paired_leaders) do
      start_line, end_line = find_paired_comment_block(lnum, pair.open, pair.close, true)
      if start_line then
        local end_col = #vim.fn.getline(end_line)
        return { from = { line = start_line, col = 1 }, to = { line = end_line, col = math.max(end_col, 1) } }
      end
    end

    return nil
  end
end

return M

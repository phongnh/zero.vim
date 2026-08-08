local M = {}

M.gen_ai_spec = {}

-- Port of vim-textobj-comment to mini.ai textobject specification.
-- Supports both simple (// ...) and paired (/* ... */) comment delimiters.
-- Uses the 'comments' and 'commentstring' options to detect comment leaders.
M.gen_ai_spec.comment = function()
  -- Parse 'comments' option into {flags, leader} pairs, with 'commentstring' as fallback.
  local function get_leaders()
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

    -- Separate into simple and paired leaders
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
      -- Simple leaders: flags contain only b, n, O or are empty (no s/e/m)
      if not l.flags:match('[sem]') then
        table.insert(simple, l.leader)
      end
    end

    return simple, paired
  end

  local function escape_pattern(s)
    return s:gsub('[%(%)%.%%%+%-%*%?%[%]%^%$]', '%%%1')
  end

  local function is_blank(lnum)
    return vim.fn.getline(lnum):match('^%s*$') ~= nil
  end

  -- Find a contiguous block of simple comment lines that includes lnum.
  local function find_simple_block(lnum, simple_re)
    if not vim.fn.getline(lnum):match(simple_re) then
      return nil
    end
    local start_line = lnum
    while start_line > 1 and vim.fn.getline(start_line - 1):match(simple_re) do
      start_line = start_line - 1
    end
    local end_line = lnum
    while end_line < vim.fn.line('$') and vim.fn.getline(end_line + 1):match(simple_re) do
      end_line = end_line + 1
    end
    return start_line, end_line
  end

  -- Find a paired comment block that contains or is nearest above lnum.
  local function find_paired_block(lnum, open, close, upwards)
    local open_re = '^%s*' .. escape_pattern(open)
    local close_re = escape_pattern(close) .. '%s*$'
    local total = vim.fn.line('$')

    if upwards then
      -- Search above cursor for the nearest paired comment end
      for ln = lnum - 1, 1, -1 do
        if vim.fn.getline(ln):match(close_re) then
          local end_line = ln
          -- Now find the matching open
          for sl = ln, 1, -1 do
            if vim.fn.getline(sl):match(open_re) then
              return sl, end_line
            end
          end
        end
      end
      return nil
    else
      -- Search from lnum downward for a paired comment containing or starting at lnum
      for ln = lnum, total do
        if vim.fn.getline(ln):match(close_re) then
          local end_line = ln
          -- Search upward from end_line for the matching open
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

  return function(ai_type)
    local simple_leaders, paired_leaders = get_leaders()
    if #simple_leaders == 0 and #paired_leaders == 0 then
      return nil
    end

    local lnum = vim.fn.line('.')

    -- Build a combined simple leader pattern
    local simple_re = nil
    if #simple_leaders > 0 then
      local parts = vim.tbl_map(function(l)
        return escape_pattern(l)
      end, simple_leaders)
      simple_re = '^%s*(' .. table.concat(parts, '|') .. ')'
    end

    -- 1. Try simple line comment at cursor
    if simple_re then
      local start_line, end_line = find_simple_block(lnum, simple_re)
      if start_line then
        if ai_type == 'i' then
          -- Strip comment leader from each line; select trimmed content
          local first_content_col = nil
          for ln = start_line, end_line do
            local line = vim.fn.getline(ln)
            for _, leader in ipairs(simple_leaders) do
              local _, e = line:find('^%s*' .. escape_pattern(leader))
              if e then
                local rest = line:sub(e + 1)
                local trimmed_start = rest:find('%S')
                if trimmed_start then
                  local col = e + trimmed_start
                  if not first_content_col then
                    first_content_col = col
                  end
                end
                break
              end
            end
          end
          local last_line = vim.fn.getline(end_line)
          local last_col = #last_line:match('(.-)%s*$')
          return {
            from = { line = start_line, col = first_content_col or 1 },
            to = { line = end_line, col = math.max(last_col, 1) },
          }
        else
          -- 'a': select whole lines
          local end_col = #vim.fn.getline(end_line)
          return {
            from = { line = start_line, col = 1 },
            to = { line = end_line, col = math.max(end_col, 1) },
          }
        end
      end
    end

    -- 2. Try paired comment containing or surrounding cursor
    for _, pair in ipairs(paired_leaders) do
      local start_line, end_line = find_paired_block(lnum, pair.open, pair.close, false)
      if start_line then
        if ai_type == 'i' then
          -- Inner: skip open/close delimiters
          local from_line, from_col, to_line, to_col
          local open_line = vim.fn.getline(start_line)
          local _, oe = open_line:find(escape_pattern(pair.open))
          local rest_after_open = open_line:sub((oe or 0) + 1)
          local nonws = rest_after_open:find('%S')
          if nonws and start_line == end_line then
            -- Single-line paired comment
            local close_line = vim.fn.getline(end_line)
            local cs = close_line:find('%s*' .. escape_pattern(pair.close) .. '%s*$')
            from_line = start_line
            from_col = (oe or 0) + nonws
            to_line = end_line
            to_col = (cs or #close_line + 1) - 1
            if to_col < from_col then
              return nil
            end
          else
            -- Multi-line: first non-blank after open, last non-blank before close
            from_line = start_line
            from_col = (oe or 0) + (nonws or #rest_after_open + 1)
            if not nonws then
              -- open is on its own line, start content from next line
              from_line = start_line + 1
              local next_line = vim.fn.getline(from_line)
              local col = next_line:find('%S')
              from_col = col or 1
            end
            local close_line_str = vim.fn.getline(end_line)
            local cs = close_line_str:find('%s*' .. escape_pattern(pair.close) .. '%s*$')
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
        else
          local end_col = #vim.fn.getline(end_line)
          return {
            from = { line = start_line, col = 1 },
            to = { line = end_line, col = math.max(end_col, 1) },
          }
        end
      end
    end

    -- 3. Search upward for nearest comment
    if simple_re then
      for ln = lnum - 1, 1, -1 do
        if vim.fn.getline(ln):match(simple_re) then
          local start_line, end_line = find_simple_block(ln, simple_re)
          if start_line then
            local end_col = #vim.fn.getline(end_line)
            return {
              from = { line = start_line, col = 1 },
              to = { line = end_line, col = math.max(end_col, 1) },
            }
          end
        end
      end
    end

    for _, pair in ipairs(paired_leaders) do
      local start_line, end_line = find_paired_block(lnum, pair.open, pair.close, true)
      if start_line then
        local end_col = #vim.fn.getline(end_line)
        return {
          from = { line = start_line, col = 1 },
          to = { line = end_line, col = math.max(end_col, 1) },
        }
      end
    end

    return nil
  end
end

return M

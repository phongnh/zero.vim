local M = {}

function M.ccword()
  return "\\b" .. vim.fn.expand("<cword>") .. "\\b"
end

function M.cword()
  return vim.fn.expand("<cword>")
end

function M.word()
  return vim.fn.expand("<cWORD>")
end

function M.vword()
  if vim.fn.exists("*getregion") == 1 then
    local lines = vim.fn.getregion(vim.fn.getpos("'<"), vim.fn.getpos("'>"))
    return vim.trim(#lines > 0 and lines[1] or "")
  end
  local line = vim.fn.getline("'<")
  local _b1, l1, c1, _o1 = unpack(vim.fn.getpos("'<"))
  local _b2, l2, c2, _o2 = unpack(vim.fn.getpos("'>"))
  if l1 ~= l2 then
    return vim.trim(line:sub(c1))
  end
  return vim.trim(line:sub(c1, c2))
end

function M.visual()
  if vim.fn.exists("*getregion") == 1 then
    local lines = vim.fn.getregion(vim.fn.getpos("'<"), vim.fn.getpos("'>"))
    return vim.trim(#lines > 0 and lines[1] or "")
  end
  local line = vim.fn.getline("'<")
  local _b1, l1, c1, _o1 = unpack(vim.fn.getpos("'<"))
  local _b2, l2, c2, _o2 = unpack(vim.fn.getpos("'>"))
  if l1 ~= l2 then
    return vim.trim(line:sub(c1))
  end
  return vim.trim(line:sub(c1, c2))
end

function M.pword()
  local search = vim.fn.getreg("/")
  if search == "" or search == "\n" then
    return ""
  end
  return search:gsub("^\\<(.+)\\>$", "\\b%1\\b")
end

return M

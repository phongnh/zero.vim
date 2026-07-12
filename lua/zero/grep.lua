local M = {}

M.escape = function(text)
  return vim.fn.shellescape(text)
end

M.vim_escape = function(text, chars)
  -- Replicate Vim's escape() function
  local result = text
  for i = 1, #chars do
    local c = chars:sub(i, i)
    -- escape the pattern char itself for gsub
    local escaped_c = c:gsub("([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1")
    result = result:gsub(escaped_c, "\\" .. c)
  end
  return result
end

M.ccword = function()
  return M.escape(require("zero").ccword())
end

M.cword = function()
  return M.escape(require("zero").cword())
end

M.word = function()
  return M.escape(require("zero").word())
end

M.vword = function()
  return M.escape(require("zero").vword())
end

M.visual = function()
  return M.escape(require("zero").visual())
end

M.pword = function()
  return M.escape(require("zero").pword())
end

return M

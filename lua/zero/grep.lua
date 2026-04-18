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

M.grepper_escape = function(text)
  local shell = vim.o.shell
  local ok, result = pcall(function()
    vim.o.shell = "sh"
    return vim.fn.shellescape(text)
  end)
  vim.o.shell = shell
  return ok and result or text
end

M.grepper_ccword = function()
  return M.grepper_escape(require("zero").ccword())
end

M.grepper_cword = function()
  return M.grepper_escape(require("zero").cword())
end

M.grepper_word = function()
  return M.grepper_escape(require("zero").word())
end

M.grepper_vword = function()
  return M.grepper_escape(require("zero").vword())
end

M.grepper_visual = function()
  return M.grepper_escape(require("zero").visual())
end

M.grepper_pword = function()
  return M.grepper_escape(require("zero").pword())
end

M.leaderf_escape = function(text)
  local shell = vim.o.shell
  local ok, result = pcall(function()
    vim.o.shell = "sh"
    return vim.fn.shellescape(vim.fn.escape(text, '"'))
  end)
  vim.o.shell = shell
  return ok and result or text
end

M.leaderf_ccword = function()
  return M.leaderf_escape(require("zero").ccword())
end

M.leaderf_cword = function()
  return M.leaderf_escape(require("zero").cword())
end

M.leaderf_word = function()
  return M.leaderf_escape(require("zero").word())
end

M.leaderf_vword = function()
  return M.leaderf_escape(require("zero").vword())
end

M.leaderf_visual = function()
  return M.leaderf_escape(require("zero").visual())
end

M.leaderf_pword = function()
  return M.leaderf_escape(require("zero").pword())
end

return M

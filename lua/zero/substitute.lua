local M = {}

-- Escape regex characters
local escape_characters = "^$.*\\/~[]"

M.escape = function(text)
  local escaped = vim.fn.escape(text, escape_characters)
  return escaped:gsub("\n", "\\n")
end

M.ccword = function()
  return "\\<" .. require("zero").ccword() .. "\\>"
end

M.cword = function()
  return require("zero").cword()
end

M.word = function()
  return M.escape(require("zero").word())
end

M.vword = function(boundary)
  if boundary or boundary == 1 then
    return "\\<" .. M.escape(require("zero").vword()) .. "\\>"
  end
  return M.escape(require("zero").vword())
end

M.pword = function()
  return M.escape(require("zero").pword())
end

return M

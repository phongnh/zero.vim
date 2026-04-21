local M = {}

M.patterns = function(...)
  return vim.fn['zero#dumb_jump#Patterns'](...)
end

return M

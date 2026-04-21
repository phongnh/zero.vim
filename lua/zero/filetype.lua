local M = {}

M.args = function(...)
  return vim.fn['zero#filetype#Args'](...)
end

M.rg_args = function(...)
  return vim.fn['zero#filetype#RgArgs'](...)
end

M.git_args = function(...)
  return vim.fn['zero#filetype#GitArgs'](...)
end

return M

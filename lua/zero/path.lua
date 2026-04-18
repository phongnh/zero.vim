local M = {}

local H = {}

H.default_config = {
  user_commands = false,
  mappings = true,
}

H.copy = function(path)
  vim.fn.setreg('"', path)
  if vim.fn.has("clipboard") == 1 then
    vim.fn.setreg("*", path)
    vim.fn.setreg("+", path)
  end
  vim.api.nvim_echo({ { "Copied: " .. path } }, false, {})
end

H.expand_path = function(path, line_number)
  local result = vim.fn.expand(path)
  if line_number then
    result = result .. ":" .. vim.fn.line(".")
  end
  return result
end

H.do_copy_path = function(path, line_number)
  H.copy(H.expand_path(path, line_number))
end

H.do_copy_dir_path = function(path)
  local result = H.expand_path(path, false)
  if result == "." then
    result = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end
  H.copy(result)
end

H.copy_path = function(line_number)
  H.do_copy_path("%:~:.", line_number)
end

H.copy_full_path = function(line_number)
  H.do_copy_path("%:p:~", line_number)
end

H.copy_absolute_path = function(line_number)
  H.do_copy_path("%:p", line_number)
end

H.copy_dir_path = function()
  H.do_copy_dir_path("%:p:.:h")
end

H.copy_full_dir_path = function()
  H.do_copy_dir_path("%:p:~:h")
end

H.copy_absolute_dir_path = function()
  H.do_copy_dir_path("%:p:h")
end

H.setup_user_commands = function()
  vim.api.nvim_create_user_command("CopyPath", function(opts)
    H.copy_path(opts.bang)
  end, { bang = true })

  vim.api.nvim_create_user_command("CopyFullPath", function(opts)
    H.copy_full_path(opts.bang)
  end, { bang = true })

  vim.api.nvim_create_user_command("CopyAbsolutePath", function(opts)
    H.copy_absolute_path(opts.bang)
  end, { bang = true })

  vim.api.nvim_create_user_command("CopyDirPath", function(_)
    H.copy_dir_path()
  end, {})

  vim.api.nvim_create_user_command("CopyFullDirPath", function(_)
    H.copy_full_dir_path()
  end, {})

  vim.api.nvim_create_user_command("CopyAbsoluteDirPath", function(_)
    H.copy_absolute_dir_path()
  end, {})
end

H.setup_mappings = function()
  -- stylua: ignore start
  vim.keymap.set("n", "yc", function() H.copy_path(false) end, { silent = true })
  vim.keymap.set("n", "yC", function() H.copy_path(true) end, { silent = true })
  vim.keymap.set("n", "yp", function() H.copy_full_path(false) end, { silent = true })
  vim.keymap.set("n", "yP", function() H.copy_full_path(true) end, { silent = true })
  vim.keymap.set("n", "yu", function() H.copy_absolute_path(false) end, { silent = true })
  vim.keymap.set("n", "yU", function() H.copy_absolute_path(true) end, { silent = true })
  vim.keymap.set("n", "y.", function() H.copy_dir_path() end, { silent = true })
  vim.keymap.set("n", "yd", function() H.copy_full_dir_path() end, { silent = true })
  vim.keymap.set("n", "yD", function() H.copy_absolute_dir_path() end, { silent = true })
  -- stylua: ignore end
end

H.setup_config = function(config)
  vim.validate("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  vim.validate("user_commands", config.user_commands, "boolean")
  vim.validate("mappings", config.mappings, "boolean")

  return config
end

H.apply_config = function(config)
  -- Commands
  if H.user_commands or not config.mappings then
    H.setup_user_commands()
  end

  -- Mappings
  if config.mappings then
    H.setup_mappings()
  end
end

function M.setup(config)
  -- Setup config
  config = H.setup_config(config)

  -- Apply config
  H.apply_config(config)
end

return M

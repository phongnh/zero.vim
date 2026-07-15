-- Grep Class
local Grep = {}
Grep.__index = Grep

function Grep.new(opts)
  opts = opts or {}
  local self = setmetatable({}, Grep)
  self.opts = opts
  self.cmd = opts.cmd or "grep"
  self.args = opts.args or {}
  self.path = opts.path or ""
  return self
end

function Grep:execute()
  local args = vim.tbl_filter(function(val)
    return val ~= ""
  end, self.args)

  if vim.tbl_isempty(args) then
    local cword = vim.fn.expand("<cword>")
    if cword ~= "" then
      vim.list_extend(args, { vim.fn.shellescape("\\b" .. cword .. "\\b") })
    end
  end

  if vim.tbl_isempty(args) then
    return
  end

  if self.path ~= nil and self.path ~= "" then
    table.insert(args, vim.fn.fnameescape(self.path))
  end

  vim.cmd({
    cmd = self.cmd,
    args = args,
    bang = true,
    mods = { silent = true },
    magic = { file = false, bar = false },
  })
end

function Grep.run(opts)
  Grep.new(opts):execute()
end

function Grep.run_in_project(opts)
  opts = vim.tbl_extend("force", {}, opts or {})
  opts.path = vim.fn.fnamemodify(require("zero.project").find(), ":p:.")
  Grep.run(opts)
end

function Grep.run_in_buffer_dir(opts)
  opts = vim.tbl_extend("force", {}, opts or {})
  opts.path = vim.fn.expand("%p:.:h")
  Grep.run(opts)
end

local M = {}

local H = {}

H.default_config = {
  user_commands = true,
}

H.setup_user_commands = function()
  vim.api.nvim_create_user_command("Grep", function(opts)
    Grep.run({ cmd = "grep", args = opts.fargs })
  end, { nargs = "*", complete = "file_in_path" })

  vim.api.nvim_create_user_command("LGrep", function(opts)
    Grep.run({ cmd = "lgrep", args = opts.fargs })
  end, { nargs = "*", complete = "file_in_path" })

  vim.api.nvim_create_user_command("BGrep", function(opts)
    Grep.run({ cmd = "lgrep", args = opts.fargs, path = vim.fn.expand("%:p:.") })
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("GrepProject", function(opts)
    Grep.run_in_project({ cmd = "grep", args = opts.fargs })
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("LGrepProject", function(opts)
    Grep.run_in_project({ cmd = "lgrep", args = opts.fargs })
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("GrepBufferDir", function(opts)
    Grep.run_in_buffer_dir({ cmd = "grep", args = opts.fargs })
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("LGrepBufferDir", function(opts)
    Grep.run_in_buffer_dir({ cmd = "lgrep", args = opts.fargs })
  end, { nargs = "*" })
end

H.setup_autocmds = function()
  local on_quickfix_cmd_post = function(loclist)
    local total = 0
    if loclist then
      vim.cmd("belowright lwindow")
      total = vim.fn.getloclist(0, { id = 0, size = 0 }).size
    else
      vim.cmd("botright cwindow")
      total = vim.fn.getqflist({ id = 0, size = 0 }).size
    end
    vim.cmd("redraw!")
    if total > 0 then
      vim.api.nvim_echo({ { string.format("Found %d %s.", total, total == 1 and "match" or "matches") } }, false, {})
    else
      vim.api.nvim_echo({ { "No matches found." } }, false, {})
    end
  end

  local group = vim.api.nvim_create_augroup("ZeroVimGrepAutoOpenQuickfix", { clear = true })

  vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    group = group,
    pattern = { "grep", "grepadd" },
    callback = function()
      vim.schedule(function()
        on_quickfix_cmd_post(false)
      end)
    end,
  })

  vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    group = group,
    pattern = { "lgrep", "lgrepadd" },
    callback = function()
      vim.schedule(function()
        on_quickfix_cmd_post(false)
      end)
    end,
  })
end

H.setup_config = function(config)
  vim.validate("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  vim.validate("user_commands", config.user_commands, "boolean")

  return config
end

H.apply_config = function(config)
  -- Commands
  if config.user_commands then
    H.setup_user_commands()
  end

  H.setup_autocmds()
end

function M.setup(config)
  -- Setup config
  config = H.setup_config(config)

  -- Apply config
  H.apply_config(config)
end

M.run = Grep.run
M.run_in_project = Grep.run_in_project
M.run_in_buffer_dir = Grep.run_in_buffer_dir

return M

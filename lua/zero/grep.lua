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

function Grep:_on_quickfix_cmd_post()
  local loclist = self.cmd == "lgrep"
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

function Grep:execute()
  local args = vim.tbl_filter(function(val)
    return val ~= ""
  end, self.args)

  if vim.fn.visualmode() == "" then
    if vim.tbl_isempty(args) then
      local cword = vim.fn.expand("<cword>")
      if cword ~= "" then
        vim.list_extend(args, { "-w", cword })
      end
    end
  else
    local vword = require("zero").vword()
    if vword ~= "" then
      args = vim.list_extend({ "-F", "-e", vim.fn.shellescape(vword) }, args)
    end
    vim.fn.visualmode(1)
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
  vim.schedule(self._on_quickfix_cmd_post)
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
  extra_user_commands = false,
}

H.setup_user_commands = function()
  vim.api.nvim_create_user_command("Grep", function(opts)
    Grep.run({ args = opts.fargs })
  end, { nargs = "*", range = true, complete = "file_in_path" })

  vim.api.nvim_create_user_command("LGrep", function(opts)
    Grep.run({ cmd = "lgrep", args = opts.fargs })
  end, { nargs = "*", range = true, complete = "file_in_path" })

  vim.api.nvim_create_user_command("BGrep", function(opts)
    Grep.run({ cmd = "lgrep", args = opts.fargs, path = vim.fn.expand("%:p:.") })
  end, { nargs = "*", range = true })

  vim.api.nvim_create_user_command("GrepProject", function(opts)
    Grep.run_in_project({ args = opts.fargs })
  end, { nargs = "*", range = true })

  vim.api.nvim_create_user_command("LGrepProject", function(opts)
    Grep.run_in_project({ cmd = "lgrep", args = opts.fargs })
  end, { nargs = "*", range = true })

  vim.api.nvim_create_user_command("GrepBufferDir", function(opts)
    Grep.run_in_buffer_dir({ args = opts.fargs })
  end, { nargs = "*", range = true })

  vim.api.nvim_create_user_command("LGrepBufferDir", function(opts)
    Grep.run_in_buffer_dir({ cmd = "lgrep", args = opts.fargs })
  end, { nargs = "*", range = true })
end

H.create_extra_user_commands = function(opts)
  local prefix, cmd, fn = opts.prefix, opts.cmd, opts.fn

  vim.api.nvim_create_user_command(prefix .. "CCword", function(opts)
    fn({ cmd = cmd, args = vim.list_extend({ "-w", vim.fn.expand("<cword>") }, opts.fargs) })
  end, { nargs = "*", complete = "file_in_path" })

  vim.api.nvim_create_user_command(prefix .. "Cword", function(opts)
    opts.fn({ cmd = opts.cmd, args = vim.list_extend({ "-F", "-e", vim.fn.expand("<cword>") }, opts.fargs) })
  end, { nargs = "*", complete = "file_in_path" })

  vim.api.nvim_create_user_command(prefix .. "Word", function(opts)
    fn({
      cmd = cmd,
      args = vim.list_extend({ "-F", "-e", vim.fn.shellescape(vim.fn.expand("<cWORD>")) }, opts.fargs),
    })
  end, { nargs = "*", complete = "file_in_path" })

  vim.api.nvim_create_user_command(prefix .. "Vword", function(opts)
    fn({
      cmd = cmd,
      args = vim.list_extend({ "-F", "-e", vim.fn.shellescape(require("zero").vword()) }, opts.fargs),
    })
  end, { nargs = "*", range = true, complete = "file_in_path" })
end

H.setup_extra_user_commands = function()
  H.create_extra_user_commands({ prefix = "Grep", cmd = "grep", fn = Grep.run })
  H.create_extra_user_commands({ prefix = "LGrep", cmd = "lgrep", fn = Grep.run })
  H.create_extra_user_commands({ prefix = "GrepProject", cmd = "grep", fn = Grep.run_in_project })
  H.create_extra_user_commands({ prefix = "LGrepProject", cmd = "lgrep", fn = Grep.run_in_project })
  H.create_extra_user_commands({ prefix = "GrepBufferDir", cmd = "grep", fn = Grep.run_in_buffer_dir })
  H.create_extra_user_commands({ prefix = "LGrepBufferDir", cmd = "lgrep", fn = Grep.run_in_buffer_dir })
end

H.setup_config = function(config)
  vim.validate("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  vim.validate("user_commands", config.user_commands, "boolean")
  vim.validate("extra_user_commands", config.extra_user_commands, "boolean")

  return config
end

H.apply_config = function(config)
  -- Commands
  if H.user_commands then
    H.setup_user_commands()

    if H.extra_user_commands then
      H.setup_extra_user_commands()
    end
  end
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

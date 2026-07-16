local function on_quickfix_cmd_post(quickfix)
  quickfix = vim.nonnil(quickfix, true)
  local total = 0
  if quickfix then
    vim.cmd("botright cwindow")
    total = vim.fn.getqflist({ id = 0, size = 0 }).size
  else
    vim.cmd("belowright lwindow")
    total = vim.fn.getloclist(0, { id = 0, size = 0 }).size
  end
  vim.cmd("redraw!")
  if total > 0 then
    -- vim.api.nvim_echo({ { string.format("Found %d %s.", total, total == 1 and "match" or "matches") } }, false, {})
    vim.notify(string.format("Found %d %s.", total, total == 1 and "match" or "matches"), vim.log.levels.INFO)
  else
    -- vim.api.nvim_echo({ { "No matches found." } }, false, {})
    vim.notify("No matches found.", vim.log.levels.INFO)
  end
end

-- Grep Class
local Grep = {}
Grep.__index = Grep

-- Track current running background progress
local current_obj = nil

function Grep.new(opts)
  local self = setmetatable({}, Grep)
  opts = self:extract_options(opts or {})
  self.opts = opts
  self.quickfix = opts.quickfix
  self.args = opts.args
  self.path = opts.path
  self.escape = opts.escape
  self.grepprg = opts.grepprg
  self.grepformat = opts.grepformat
  self.append = self.append
  self.cword = opts.cword
  self.async = opts.async
  return self
end

function Grep:build_grepprg(grepprg)
  if type(grepprg) == "table" and vim.islist(grepprg) and #grepprg > 0 then
    return grepprg
  elseif type(grepprg) ~= "string" or #grepprg == 0 then
    grepprg = vim.o.grepprg
  end
  local cmd = {}
  local tokens = vim.split(grepprg, "%s+", { trimempty = true })
  for _, token in ipairs(tokens) do
    if not token:match("^[$%%]") then
      table.insert(cmd, token)
    end
  end
  return cmd
end

function Grep:extract_options(opts)
  local options = vim.tbl_extend("keep", vim.deepcopy(opts or {}), {
    quickfix = true,
    escape = "\\",
    grepprg = vim.o.grepprg,
    grepformat = vim.o.grepformat,
    append = false,
    cword = false,
    async = true,
  })

  options.args = vim.tbl_filter(function(val)
    return val ~= nil and val ~= ""
  end, options.args or {})

  if not options.path then
    options.path = {}
  elseif type(options.path) == "string" then
    options.path = { options.path }
  elseif not type(options.path) == "table" or not vim.islist(options.path) then
    options.path = {}
  end

  options.path = vim.tbl_filter(function(val)
    return val ~= nil and val ~= ""
  end, options.path)

  options.grepprg = self:build_grepprg(options.grepprg)

  return options
end

function Grep:build_escaped_args()
  return vim
    .iter(self.args)
    :map(function(arg)
      return vim.fn.escape(arg, self.escape)
    end)
    :totable()
end

function Grep:build_escaped_path()
  return vim
    .iter(self.path)
    :map(function(path)
      return vim.fn.fnameescape(path)
    end)
    :totable()
end

function Grep:execute_async()
  local title = table.concat(vim.iter({ self.grepprg, self.args, self.path }):flatten():totable(), " ")
  local efm = self.grepformat
  local on_stdout
  if self.quickfix then
    if self.append then
      vim.fn.setqflist({}, "a", { title = title })
    else
      vim.fn.setqflist({}, "r", { items = {}, title = title })
    end
    on_stdout = function(_, data)
      if data and data ~= "" then
        vim.schedule(function()
          local lines = vim.split(data, "\n", { trimempty = true })
          vim.fn.setqflist({}, "a", { lines = lines, efm = efm })
        end)
      end
    end
  else
    if self.append then
      vim.fn.setloclist(0, {}, "a", { title = title })
    else
      vim.fn.setloclist(0, {}, "r", { items = {}, title = title })
    end
    on_stdout = function(_, data)
      if data and data ~= "" then
        vim.schedule(function()
          local lines = vim.split(data, "\n", { trimempty = true })
          vim.fn.setloclist(0, {}, "a", { lines = lines, efm = efm })
        end)
      end
    end
  end

  local on_exit = function(obj)
    if obj.code == 0 or obj.code == 1 then
      on_quickfix_cmd_post(self.quickfix)
    else
      -- vim.api.nvim_echo({ { string.format("Grep failed with error code: %d", obj.code), "ErrorMsg" } }, false, {})
      vim.notify(string.format("Grep failed with error code: %d", obj.code), vim.log.levels.INFO)
    end
  end

  local cmd = table.concat(
    vim.iter({ self.grepprg, self:build_escaped_args(), self:build_escaped_path() }):flatten():totable(),
    " "
  )

  if current_obj then
    current_obj:kill(15) -- Sends SIGTERM
  end

  current_obj = vim.system({ vim.o.shell, vim.o.shellcmdflag, cmd }, {
    stdout = on_stdout,
  }, function(obj)
    current_obj = nil

    vim.schedule(function()
      on_exit(obj)
    end)
  end)
end

function Grep:execute_sync()
  local args = vim.list_extend(self:build_escaped_args(), self:build_escaped_path())
  local cmd = self.quickfix and "grep" or "lgrep"
  cmd = cmd .. (self.append and "add" or "")
  vim.cmd({
    cmd = cmd,
    args = args,
    bang = true,
    mods = { silent = true },
    magic = { file = false, bar = false },
  })
end

function Grep:execute()
  if #self.args == 0 then
    return
  end

  if self.async then
    self:execute_async()
  else
    self:execute_sync()
  end
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
    Grep.run({ args = opts.fargs, quickfix = true })
  end, { nargs = "*", complete = "file_in_path" })

  vim.api.nvim_create_user_command("LGrep", function(opts)
    Grep.run({ args = opts.fargs, quickfix = false })
  end, { nargs = "*", complete = "file_in_path" })

  vim.api.nvim_create_user_command("BGrep", function(opts)
    Grep.run({ args = opts.fargs, path = vim.fn.expand("%:p:."), quickfix = false })
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("GrepProject", function(opts)
    Grep.run_in_project({ args = opts.fargs, quickfix = true })
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("LGrepProject", function(opts)
    Grep.run_in_project({ args = opts.fargs, quickfix = false })
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("GrepBufferDir", function(opts)
    Grep.run_in_buffer_dir({ args = opts.fargs, quickfix = true })
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("LGrepBufferDir", function(opts)
    Grep.run_in_buffer_dir({ args = opts.fargs, quickfix = false })
  end, { nargs = "*" })
end

H.setup_autocmds = function()
  local group = vim.api.nvim_create_augroup("ZeroVimGrepAutoOpenQuickfix", { clear = true })

  vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    group = group,
    pattern = { "grep", "grepadd" },
    callback = function()
      vim.schedule(function()
        on_quickfix_cmd_post(true)
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

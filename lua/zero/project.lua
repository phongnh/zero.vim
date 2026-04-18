local M = {}

local H = {}

H.config = {
  vcs_root_markers = {
    ".git",
    ".hg",
    ".svn",
    ".bzr",
    "_darcs",
  },
  file_root_markers = {
    "Gemfile",
    "rebar.config",
    "mix.exs",
    "Cargo.toml",
    "shard.yml",
    "go.mod",
    ".root",
  },
  ignored_root_dirs = {
    "/",
    "/root",
    "/Users",
    "/home",
    "/usr",
    "/usr/local",
    "/opt",
    "/etc",
    "/var",
    vim.fn.expand("~"),
  },
}

M.find = function(starting_dir)
  vim.validate("starting_dir", starting_dir, "string", true)

  -- Handle optional starting directory argument
  if starting_dir == nil or starting_dir == "" then
    starting_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
  end

  -- Return empty if directory is invalid
  if starting_dir == "" then
    return ""
  end

  local root_dir = ""

  -- Search for VCS markers first (prioritize them as they're more reliable)
  for _, marker in ipairs(H.config.vcs_root_markers) do
    root_dir = vim.fn.finddir(marker, starting_dir .. ";")
    if root_dir ~= "" then
      return vim.fn.fnamemodify(root_dir, ":p:h:h:~")
    end
  end

  -- Search for file markers
  for _, marker in ipairs(H.config.file_root_markers) do
    root_dir = vim.fn.findfile(marker, starting_dir .. ";")
    if root_dir ~= "" then
      return vim.fn.fnamemodify(root_dir, ":p:h:~")
    end
  end

  -- No marker found, determine fallback directory
  local cwd = vim.fn.getcwd()

  if
    not vim.tbl_contains(H.config.ignored_root_dirs, cwd)
    and vim.startswith(starting_dir, vim.fn.fnamemodify(cwd, ":p"))
  then
    -- Use cwd if it's valid and starting_dir is under it
    return vim.fn.fnamemodify(cwd, ":~")
  else
    -- Fall back to starting directory
    return vim.fn.fnamemodify(starting_dir, ":~")
  end
end

return M

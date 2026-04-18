local M = {}

local H = {}

H.default_config = {
  move_mappings = nil,
  insert_move_mappings = nil,
  unimpaired_mappings = nil,
}

H.echo = function(...)
  local args = {}
  for idx = 1, select("#", ...) do
    args[idx] = select(idx, ...)
  end
  vim.api.nvim_echo({ { table.concat(args, " ") } }, false, {})
end

-- Move line up/down
H.setup_move_mappings = function(config)
  vim.keymap.set({ "n", "i" }, "<Plug>(MoveLineUp)", "<Cmd>move .-2<Bar>normal! ==<CR>", { silent = true })
  vim.keymap.set({ "n", "i" }, "<Plug>(MoveLineDown)", "<Cmd>move .+1<Bar>normal! ==<CR>", { silent = true })
  vim.keymap.set("v", "<Plug>(MoveLineUp)", ":move '<-2<Bar>normal! gv=gv<CR>", { silent = true })
  vim.keymap.set("v", "<Plug>(MoveLineDown)", ":move '>+1<Bar>normal! gv=gv<CR>", { silent = true })

  if config.move_mappings ~= false then
    vim.keymap.set({ "n", "v" }, "<M-k>", "<Plug>(MoveLineUp)", { remap = true })
    vim.keymap.set({ "n", "v" }, "<M-j>", "<Plug>(MoveLineDown)", { remap = true })
  end

  if config.insert_move_mappings ~= false then
    vim.keymap.set("i", "<M-k>", "<Plug>(MoveLineUp)", { remap = true })
    vim.keymap.set("i", "<M-j>", "<Plug>(MoveLineDown)", { remap = true })
  end
end

-- Setup unimpaired-style mappings
H.setup_unimpaired_mappings = function()
  local opts = { silent = true }

  -- Background
  vim.keymap.set("n", "yob", function()
    vim.o.background = vim.o.background == "dark" and "light" or "dark"
    H.echo("set background=" .. vim.o.background)
  end, opts)

  -- Cursorline
  vim.keymap.set("n", "yoc", "<Cmd>setlocal cursorline! cursorline!<CR>", opts)
  vim.keymap.set("n", "yo-", "<Cmd>setlocal cursorline! cursorline!<CR>", opts)
  vim.keymap.set("n", "yo_", "<Cmd>setlocal cursorline! cursorline!<CR>", opts)

  -- Cursorcolumn
  vim.keymap.set("n", "you", "<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>", opts)
  vim.keymap.set("n", "yo<Bar>", "<Cmd>setlocal cursorcolumn! cursorcolumn?<CR>", opts)

  -- Hlsearch
  vim.keymap.set("n", "yoh", "<Cmd>set hlsearch! hlsearch?<CR>", opts)

  -- Ignorecase
  vim.keymap.set("n", "yoi", "<Cmd>set ignorecase! ignorecase?<CR>", opts)

  -- List
  vim.keymap.set("n", "yol", "<Cmd>setlocal list! list?<CR>", opts)

  -- Number
  vim.keymap.set("n", "yon", "<Cmd>setlocal number! number?<CR>", opts)

  -- Relativenumber
  vim.keymap.set("n", "yor", "<Cmd>setlocal relativenumber! relativenumber?<CR>", opts)

  -- Spell
  vim.keymap.set("n", "yos", "<Cmd>setlocal spell! spell?<CR>", opts)

  -- Wrap
  vim.keymap.set("n", "yow", "<Cmd>setlocal wrap! wrap?<CR>", opts)

  -- Virtualedit
  vim.keymap.set("n", "yov", function()
    if vim.tbl_contains(vim.opt.virtualedit:get(), "all") then
      vim.opt.virtualedit:remove("all")
      H.echo("set virtualedit-=all")
    else
      vim.opt.virtualedit:append("all")
      H.echo("set virtualedit+=all")
    end
  end, opts)

  local toggle_cursorline_and_cursorcolumn = function()
    if vim.wo.cursorline and vim.wo.cursorcolumn then
      vim.wo.cursorline = false
      vim.wo.cursorcolumn = false
      H.echo("set nocursorline nocursorcolumn")
    else
      vim.wo.cursorline = true
      vim.wo.cursorcolumn = true
      H.echo("set cursorline cursorcolumn")
    end
  end

  vim.keymap.set("n", "yox", toggle_cursorline_and_cursorcolumn, opts)
  vim.keymap.set("n", "yo+", toggle_cursorline_and_cursorcolumn, opts)

  -- Colorcolumn
  vim.keymap.set("n", "yot", function()
    vim.wo.colorcolumn = vim.wo.colorcolumn == "" and "+1" or ""
    H.echo("set cursorcolumn=" .. vim.wo.colorcolumn)
  end, opts)

  -- Diff
  if vim.fn.has("diff") == 1 then
    vim.keymap.set("n", "yod", function()
      if vim.wo.diff then
        vim.cmd("diffoff")
        H.echo("diffoff")
      else
        vim.cmd("diffthis")
        H.echo("diffthis")
      end
    end, opts)
  end

  -- Move lines up/down
  vim.keymap.set({ "n", "v" }, "[e", "<Plug>(MoveLineUp)", { remap = true })
  vim.keymap.set({ "n", "v" }, "]e", "<Plug>(MoveLineDown)", { remap = true })
end

function H.setup_toggle_mappings()
  local opts = { silent = true }

  -- Change shiftwidth / tabstop
  local change_shiftwidth_or_tabstop = function(size)
    return function()
      if vim.bo.expandtab then
        vim.bo.shiftwidth = size
        vim.cmd("set shiftwidth?")
      else
        vim.bo.tabstop = size
        vim.cmd("set tabstop?")
      end
    end
  end

  vim.keymap.set("n", "yo2", change_shiftwidth_or_tabstop(2), opts)
  vim.keymap.set("n", "yo4", change_shiftwidth_or_tabstop(4), opts)
  vim.keymap.set("n", "yo8", change_shiftwidth_or_tabstop(8), opts)

  -- Toggle incsearch
  vim.keymap.set("n", "yoS", "<Cmd>set incsearch! incsearch?<CR>", opts)

  -- Toggle expandtab
  vim.keymap.set("n", "yoe", "<Cmd>setlocal expandtab! expandtab?<CR>", opts)

  -- Toggle "keep current line centred" (scrolloff trick)
  vim.keymap.set("n", "yoz", "<Cmd>lua vim.o.scrolloff = 1000 - vim.o.scrolloff<CR><Cmd>set scrolloff?<CR>", opts)

  -- Toggle gj/gk <-> j/k mappings.
  vim.keymap.set("n", "yom", function()
    if vim.fn.mapcheck("j", "n") == "" or vim.fn.mapcheck("k", "n") == "" then
      vim.keymap.set({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
      vim.keymap.set({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })
      vim.keymap.set({ "n", "x" }, "gj", "j")
      vim.keymap.set({ "n", "x" }, "gj", "k")
      H.echo("Enabled gj/gk!")
    else
      for _, lhs in ipairs({ "j", "k", "gj", "gk" }) do
        pcall(vim.keymap.del, "n", lhs)
        pcall(vim.keymap.del, "x", lhs)
      end
      H.echo("Disabled gj/gk!")
    end
  end, opts)

  -- Toggle clipboard
  if vim.fn.has("clipboard") == 1 then
    local clipboard = vim.fn.has("unnamedplus") == 1 and "unnamedplus" or "unnamed"

    vim.keymap.set("n", "yoy", function()
      if vim.tbl_contains(vim.opt.clipboard:get(), clipboard) then
        vim.opt.clipboard:remove(clipboard)
        H.echo("set clipboard-=" .. clipboard)
      else
        vim.opt.clipboard:prepend(clipboard)
        H.echo("set clipboard^=" .. clipboard)
      end
    end, opts)
  end

  -- Toggle conceallevel
  if vim.fn.has("conceal") == 1 then
    vim.keymap.set("n", "yoC", function()
      vim.wo.conceallevel = vim.wo.conceallevel > 0 and 0 or 2
      H.echo("set conceallevel=" .. vim.wo.conceallevel)
    end, opts)
  end

  -- Cycle diff algorithm (patience <-> histogram)
  if vim.fn.has("diff") == 1 then
    vim.keymap.set("n", "yoD", function()
      if vim.tbl_contains(vim.opt.diffopt:get(), "algorithm:histogram") then
        vim.opt.diffopt:remove("algorithm:histogram")
        vim.opt.diffopt:append("algorithm:patience")
        H.echo("set diffopt+=algorithm:patience")
      else
        vim.opt.diffopt:append("algorithm:histogram")
        H.echo("set diffopt+=algorithm:histogram")
      end
    end, opts)
  end

  -- Toggle EOL in listchars
  vim.keymap.set("n", "yoE", function()
    local listchars = vim.opt_local.listchars:get()
    if listchars.eol ~= nil then
      H.echo("setlocal listchars-=eol:" .. listchars.eol)
      listchars.eol = nil
      vim.opt_local.listchars = listchars
    else
      vim.opt_local.listchars:append({ eol = "§" })
      H.echo("setlocal listchars+=eol:§")
    end
  end, opts)

  -- Toggle trailing space in listchars
  vim.keymap.set("n", "yo<Space>", function()
    local listchars = vim.opt_local.listchars:get()
    if listchars.trail ~= nil then
      H.echo("setlocal listchars-=trail:" .. listchars.trail)
      listchars.trail = nil
      vim.opt_local.listchars = listchars
    else
      vim.opt_local.listchars:append({ trail = "·" })
      H.echo("setlocal listchars+=trail:·")
    end
  end, opts)

  -- Toggle indent guides via leadmultispace (Neovim always supports this)
  vim.keymap.set("n", "yoI", function()
    local listchars = vim.opt_local.listchars:get()
    if listchars.leadmultispace ~= nil then
      local value = listchars.leadmultispace
      listchars.leadmultispace = nil
      vim.opt_local.listchars = listchars
      H.echo("setlocal listchars-=leadmultispace:" .. value)
    else
      local value = "┊" .. string.rep(" ", math.max(vim.fn.shiftwidth() - 1, 0))
      vim.opt_local.listchars:append({ leadmultispace = value })
      H.echo("setlocal listchars+=" .. value)
    end
  end, opts)

  vim.api.nvim_create_autocmd("OptionSet", {
    group = vim.api.nvim_create_augroup("ZeroToggleShiftwidth", { clear = true }),
    pattern = "shiftwidth",
    callback = function()
      local listchars = vim.opt_local.listchars:get()
      if not listchars.leadmultispace then
        return
      end
      local new_shiftwidth = tonumber(vim.v.option_new) or vim.fn.shiftwidth()
      local value = "┊" .. string.rep(" ", math.max(new_shiftwidth - 1, 0))
      listchars.leadmultispace = value
      vim.opt_local.listchars = listchars
    end,
  })

  -- Improved fold mappings — echo foldlevel after each change
  vim.keymap.set("n", "zr", "zr<Cmd>setlocal foldlevel?<CR>", opts)
  vim.keymap.set("n", "zm", "zm<Cmd>setlocal foldlevel?<CR>", opts)
  vim.keymap.set("n", "zR", "zR<Cmd>setlocal foldlevel?<CR>", opts)
  vim.keymap.set("n", "zM", "zM<Cmd>setlocal foldlevel?<CR>", opts)
  vim.keymap.set("n", "zi", "zi<Cmd>setlocal foldlevel?<CR>", opts)
  vim.keymap.set("n", "z]", "<Cmd>let &foldcolumn = &foldcolumn + 1<CR><Cmd>setlocal foldcolumn?<CR>", opts)
  vim.keymap.set("n", "z[", "<Cmd>let &foldcolumn = &foldcolumn - 1<CR><Cmd>setlocal foldcolumn?<CR>", opts)
end

H.setup_config = function(config)
  vim.validate("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  vim.validate("move_mappings", config.unimpaired_mappings, "boolean", true)
  vim.validate("insert_move_mappings", config.unimpaired_mappings, "boolean", true)
  vim.validate("unimpaired_mappings", config.unimpaired_mappings, "boolean", true)

  return config
end

H.apply_config = function(config)
  H.setup_move_mappings(config)
  if config.unimpaired_mappings then
    H.setup_unimpaired_mappings()
  elseif config.unimpaired_mappings == nil and vim.fn.globpath(vim.o.rtp, "plugin/unimpaired.vim") == "" then
    H.setup_unimpaired_mappings()
  end
  H.setup_toggle_mappings()
end

M.setup = function(config)
  -- Setup config
  config = H.setup_config(config)

  -- Apply config
  H.apply_config(config)
end

return M

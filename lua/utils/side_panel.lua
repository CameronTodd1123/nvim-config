local tools = {
  goose = { cmd = "goose", buf = nil, win = nil, active = false },
  codex = { cmd = "codex -p openai", buf = nil, win = nil, active = false },
  console = { cmd = os.getenv("SHELL") or "$SHELL", buf = nil, win = nil, active = false },
}

local right_col_win = nil

local function ensure_column()
  if right_col_win and vim.api.nvim_win_is_valid(right_col_win) then
    return right_col_win
  end
  vim.cmd("vsplit")
  right_col_win = vim.api.nvim_get_current_win()
  vim.cmd("wincmd L")
  vim.api.nvim_win_set_width(right_col_win, math.floor(vim.o.columns / 2))
  return right_col_win
end

local function close_tool(name)
  local t = tools[name]
  if t.win and vim.api.nvim_win_is_valid(t.win) then
    vim.api.nvim_win_close(t.win, true)
  end
  t.win = nil
  t.active = false
end

local function toggle_tool(name)
  local t = tools[name]

  -- If tool is active, close it
  if t.active and t.win and vim.api.nvim_win_is_valid(t.win) then
    close_tool(name)
    return
  end

  -- Ensure right-hand column exists
  local anchor = ensure_column()

  -- Move to correct anchor or last valid tool window in the column
  vim.api.nvim_set_current_win(anchor)

  -- If another tool is open, split below it
  for _, other in pairs(tools) do
    if other ~= t and other.active and other.win and vim.api.nvim_win_is_valid(other.win) then
      vim.api.nvim_set_current_win(other.win)
      vim.cmd("split")
      break
    end
  end

  local cur = vim.api.nvim_get_current_win()

  -- Reuse existing buffer
  if t.buf and vim.api.nvim_buf_is_valid(t.buf) then
    vim.api.nvim_win_set_buf(cur, t.buf)
  else
    vim.cmd("term " .. t.cmd)
    t.buf = vim.api.nvim_get_current_buf()
  end

  t.win = cur
  t.active = true
  vim.cmd("startinsert")
end

return {
  toggle_goose = function() toggle_tool("goose") end,
  toggle_openai = function() toggle_tool("codex") end,
  toggle_console = function() toggle_tool("console") end,
}

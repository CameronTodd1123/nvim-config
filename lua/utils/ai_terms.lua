-- helper that creates a self‑contained toggle object
local function new_toggle(cmd, open_cmd)
  local T = { win = nil, buf = nil }

  function T.toggle()
    -- 1. If still visible → close window only
    if T.win and vim.api.nvim_win_is_valid(T.win) then
      vim.api.nvim_win_close(T.win, true)
      T.win = nil
      return
    end

    -- 2. Buffer exists → reopen it
    if T.buf and vim.api.nvim_buf_is_valid(T.buf) then
      vim.cmd(open_cmd)                            -- e.g. "topleft vsplit"
      T.win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(T.win, T.buf)
      return
    end

    -- 3. First launch → create split + terminal buffer
    vim.cmd(open_cmd)
    T.win = vim.api.nvim_get_current_win()
    vim.cmd("term " .. cmd)
    T.buf = vim.api.nvim_get_current_buf()
    vim.cmd("startinsert")                         -- drop into insert‑mode
  end

  return T
end

-------------------------------------------------------------------------------
-- configure the two AI panes (both appear along the *top* of the current tab)
-------------------------------------------------------------------------------
local goose = new_toggle("goose",       "topleft vsplit")
local codex = new_toggle('codex -p',    "topleft split")   -- right of Goose

return {
  goose = goose.toggle,
  codex = codex.toggle,
}

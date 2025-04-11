local TerminalToggle = {}

TerminalToggle.term_bufnr = nil
TerminalToggle.term_winid = nil

function TerminalToggle.toggle()
  -- If the terminal is already visible
  if TerminalToggle.term_winid and vim.api.nvim_win_is_valid(TerminalToggle.term_winid) then
    vim.api.nvim_win_close(TerminalToggle.term_winid, true)
    TerminalToggle.term_winid = nil
    return
  end

  -- If buffer exists, just open it in a vertical split
  if TerminalToggle.term_bufnr and vim.api.nvim_buf_is_valid(TerminalToggle.term_bufnr) then
    vim.cmd("vsplit")
    TerminalToggle.term_winid = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(TerminalToggle.term_winid, TerminalToggle.term_bufnr)
    return
  end

  -- Create a new terminal
  vim.cmd("vsplit")
  TerminalToggle.term_winid = vim.api.nvim_get_current_win()
  vim.cmd("term")
  TerminalToggle.term_bufnr = vim.api.nvim_get_current_buf()
end

return TerminalToggle

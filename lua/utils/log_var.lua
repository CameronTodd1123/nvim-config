local M = {}

M.log_variable = function()
  local var = vim.fn.expand("<cword>")
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local ft = vim.bo.filetype
  local indent_level = vim.fn.indent(vim.fn.line('.'))
  local indent = string.rep(" ", indent_level)
  local log_line = ""

  if ft == "java" then
    log_line = indent .. 'System.out.println("' .. var .. ': " + ' .. var .. ');'
  elseif ft == "python" then
    log_line = indent .. 'print(f"' .. var .. ': {' .. var .. '}")'
  elseif ft == "javascript" or ft == "typescript" then
    log_line = indent .. 'console.log("' .. var .. ':", ' .. var .. ');'
  elseif ft == "sh" or ft == "bash" or ft == "zsh" then
    log_line = indent .. 'echo "' .. var .. ': $' .. var .. '"'
  else
    log_line = indent .. 'print("' .. var .. ': " .. ' .. var .. ')' -- default fallback
  end

  vim.api.nvim_buf_set_lines(0, line, line, false, { log_line })
end

return M

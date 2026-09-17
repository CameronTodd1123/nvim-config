if vim.fn.executable("jq") == 0 then
  return
end

vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    if vim.bo.modified == false then
      return
    end

    if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
      return
    end

    local view = vim.fn.winsaveview()
    local ok = pcall(vim.cmd, "%!jq .")

    vim.fn.winrestview(view)

    if not ok then
      vim.notify("jq: invalid JSON, skipping autoformat", vim.log.levels.WARN)
    end
  end,
})

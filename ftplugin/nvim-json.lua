
-- Autoformat JSON on save using jq

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.json",
  callback = function()
    -- Validate JSON first
    local file = vim.fn.expand("%:p")
    local ok = vim.fn.system("jq empty " .. vim.fn.shellescape(file)) == ""

    if ok then
      -- Pretty-print whole buffer
      vim.cmd([[%!jq .]])
    else
      vim.notify("jq: invalid JSON, skipping autoformat", vim.log.levels.WARN)
    end
  end,
})

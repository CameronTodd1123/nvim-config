return {
  "nvimtools/none-ls.nvim", -- replaces null-ls
  dependencies = {
    "williamboman/mason.nvim",
    "jay-babu/mason-null-ls.nvim",
  },
  config = function()
    require("mason-null-ls").setup({
      ensure_installed = { "black", "isort" },
      automatic_installation = true,
    })

    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          -- Format before save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                async = false,
                filter = function(c) return c.name == "null-ls" end,
              })
            end,
          })
        end
      end,
    })

    -- Optional manual keymap
    vim.keymap.set({"n","v"}, "<leader>gf", function()
      vim.lsp.buf.format({
        async = true,
        filter = function(c) return c.name == "null-ls" end,
      })
    end, { desc = "Format with Black (null-ls)" })
  end,
}

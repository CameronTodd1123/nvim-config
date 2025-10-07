return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      -- inline ghost-text UI
      suggestion = {
        enabled = true,          -- show inline suggestions
        auto_trigger = true,     -- appear automatically while typing
        debounce = 75,
        keymap = {
          accept = "<C-z>",      -- ✅ accept suggestion with Ctrl+Z
          next   = "<M-]>",      -- alt-]
          prev   = "<M-[>",      -- alt-[
          dismiss= "<C-]>",      -- close current suggestion
        },
      },
      -- side panel UI (usually not needed)
      panel = { enabled = false },

      -- optional: disable Copilot for some filetypes
      -- filetypes = { python = false, ["*"] = true },
    })

    -- ---- Quick toggles ----

    -- Toggle auto-trigger (inline popup on/off)
  end,
}

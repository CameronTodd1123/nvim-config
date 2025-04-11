local M = {}

function M.load_env_file(env_file)
  local path = env_file or ".env"
  local file = io.open(path, "r")
  if not file then
    vim.notify("No .env file found at " .. path, vim.log.levels.WARN)
    return {}
  end

  local env = {}
  for line in file:lines() do
    local key, value = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
    if key and value then
      vim.fn.setenv(key, value)
      vim.env[key] = value
      env[key] = value
    end
  end

  file:close()
  return env
end

return M

--[[
--
-- This file is not required for your own configuration,
-- but helps people determine if their system is setup correctly.
--
--]]

local health = {
  start = vim.health.start or vim.health.report_start,
  ok = vim.health.ok or vim.health.report_ok,
  warn = vim.health.warn or vim.health.report_warn,
  error = vim.health.error or vim.health.report_error,
  info = vim.health.info or vim.health.report_info,
}

local check_version = function()
  local verstr = string.format('%s.%s.%s', vim.version().major, vim.version().minor, vim.version().patch)
  if not vim.version.cmp then
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if vim.version.cmp(vim.version(), { 0, 9, 4 }) >= 0 then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

local programs = {
  {
    cmd = { 'git' },
    type = 'error',
    msg = 'Used for core functionality such as updater and plugin management',
  },
  {
    cmd = { 'xdg-open', 'rundll32', 'wslview', 'open' },
    type = 'warn',
    msg = 'Used for `gx` mapping for opening files with system opener (Optional)',
  },
  { cmd = { 'lazygit' }, type = 'warn', msg = 'Used for mappings to pull up git TUI (Optional)' },
  { cmd = { 'node' }, type = 'warn', msg = 'Used for mappings to pull up node REPL (Optional)' },
  {
    cmd = { vim.fn.has 'mac' == 1 and 'gdu-go' or 'gdu' },
    type = 'warn',
    msg = 'Used for mappings to pull up disk usage analyzer (Optional)',
  },
  { cmd = { 'btm' }, type = 'warn', msg = 'Used for mappings to pull up system monitor (Optional)' },
  { cmd = { 'python', 'python3' }, type = 'warn', msg = 'Used for mappings to pull up python REPL (Optional)' },
}

local check_external_reqs = function()
  -- Basic utils: `git`, `make`, `unzip`
  for _, program in ipairs(programs) do
    local name = table.concat(program.cmd, '/')
    local found = false
    for _, cmd in ipairs(program.cmd) do
      if vim.fn.executable(cmd) == 1 then
        name = cmd
        if not program.extra_check or program.extra_check(program) then
          found = true
        end
        break
      end
    end

    if found then
      health.ok(('`%s` is installed: %s'):format(name, program.msg))
    else
      health[program.type](('`%s` is not installed: %s'):format(name, program.msg))
    end
  end

  return true
end

return {
  check = function()
    vim.health.start 'kickstart.nvim'

    vim.health.info [[NOTE: Not every warning is a 'must-fix' in `:checkhealth`

  Fix only warnings for plugins and languages you intend to use.
    Mason will give warnings for languages that are not installed.
    You do not need to install, unless you want to use those languages!]]

    local uv = vim.uv or vim.loop
    vim.health.info('System Information: ' .. vim.inspect(uv.os_uname()))

    check_version()
    check_external_reqs()
  end,
}

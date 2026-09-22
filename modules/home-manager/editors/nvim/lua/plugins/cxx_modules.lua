local M = {}

local default_options = {
  build_dir = "build",
  debounce_ms = 250,
  extensions = { "cppm", "ixx", "mpp", "cpp" },
}

local function get_clangd_root(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })
  for _, client in ipairs(clients) do
    if client.config.root_dir then
      return vim.fs.normalize(client.config.root_dir)
    end
  end
  return nil
end

local function build_command(root, options)
  return { "cmake", "--build", root .. "/" .. options.build_dir }
end

local function restart_clangd(root)
  for _, client in ipairs(vim.lsp.get_clients({ name = "clangd" })) do
    if vim.fs.normalize(client.config.root_dir) == root then
      client:stop()
    end
  end

  vim.defer_fn(function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.api.nvim_buf_get_name(bufnr)
      if vim.api.nvim_buf_is_loaded(bufnr) and vim.fs.dirname(name):sub(1, #root) == root then
        vim.api.nvim_exec_autocmds("FileType", { buffer = bufnr, modeline = false })
      end
    end
  end, 150)
end

function M.setup(user_options)
  local options = vim.tbl_deep_extend("force", default_options, user_options or {})
  local states = {}

  local function rebuild(root)
    local state = states[root]
    if state.building then
      state.pending = true
      return
    end

    state.building = true
    vim.system(build_command(root, options), { cwd = root, text = true }, function(result)
      vim.schedule(function()
        state.building = false
        if result.code == 0 then
          restart_clangd(root)
        else
          vim.notify(result.stderr ~= "" and result.stderr or result.stdout, vim.log.levels.ERROR, {
            title = "C++ module build failed",
          })
        end

        if state.pending then
          state.pending = false
          rebuild(root)
        end
      end)
    end)
  end

  local patterns = {}
  for _, extension in ipairs(options.extensions) do
    table.insert(patterns, "*." .. extension)
  end

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("cxx-module-diagnostics", { clear = true }),
    pattern = patterns,
    callback = function(event)
      local root = get_clangd_root(event.buf)
      if not root or not vim.uv.fs_stat(root .. "/" .. options.build_dir) then
        return
      end

      local state = states[root]
      if not state then
        state = { timer = assert(vim.uv.new_timer()), building = false, pending = false }
        states[root] = state
      end
      state.timer:stop()
      state.timer:start(options.debounce_ms, 0, vim.schedule_wrap(function()
        rebuild(root)
      end))
    end,
  })
end

M.setup({})

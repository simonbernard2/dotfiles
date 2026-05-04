-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function eslint_fix_on_save(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })
  if #clients == 0 then
    return
  end

  for _, client in ipairs(clients) do
    client:request_sync("workspace/executeCommand", {
      command = "eslint.applyAllFixes",
      arguments = {
        {
          uri = vim.uri_from_bufnr(bufnr),
          version = vim.lsp.util.buf_versions[bufnr],
        },
      },
    }, 2000, bufnr)
  end
end

local function organize_imports_on_save(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "vtsls" })
  if #clients == 0 then
    clients = vim.lsp.get_clients({ bufnr = bufnr, name = "tsserver" })
  end
  if #clients == 0 then
    return
  end

  local last_line = math.max(vim.api.nvim_buf_line_count(bufnr) - 1, 0)
  local last_text = vim.api.nvim_buf_get_lines(bufnr, last_line, last_line + 1, true)[1] or ""
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
    range = {
      start = { line = 0, character = 0 },
      ["end"] = { line = last_line, character = #last_text },
    },
    context = {
      only = { "source.organizeImports" },
      diagnostics = {},
    },
  }

  local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 2000)
  if not results then
    return
  end

  for client_id, res in pairs(results) do
    local client = vim.lsp.get_client_by_id(client_id)
    for _, action in ipairs(res.result or {}) do
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, client and client.offset_encoding or "utf-8")
      end
      if action.command then
        vim.lsp.buf.execute_command(action.command)
      end
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("eslint_fix_on_save", { clear = true }),
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  callback = function(args)
    eslint_fix_on_save(args.buf)
    organize_imports_on_save(args.buf)
  end,
})

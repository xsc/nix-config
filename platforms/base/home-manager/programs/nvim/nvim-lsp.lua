local capabilities = require("cmp_nvim_lsp").default_capabilities()
local fzf = require("fzf-lua")
local lspconfig = require("lspconfig")

-- Language Servers
lspconfig.lua_ls.setup({
  capabilities = capabilities,

  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    })
  end,
  settings = {
    Lua = {},
  },
})

lspconfig.nixd.setup({
  capabilities = capabilities,
})

lspconfig.ts_ls.setup({
  capabilities = capabilities,
})

-- Helpers
local function formatSync()
  vim.lsp.buf.format({
    async = false,
    timeout_ms = 5000,
    filter = function(client)
      return client.name == "null-ls"
    end,
  })
end

-- Create mappings
local auFormatOnSave = vim.api.nvim_create_augroup("LspFormatOnSave", {})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    if client == nil then
      return
    end

    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = auFormatOnSave, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = auFormatOnSave,
        buffer = bufnr,
        callback = formatSync,
      })
      vim.keymap.set("n", "<leader>ff", formatSync, { buffer = bufnr })
    end

    if client.supports_method("textDocument/codeAction") then
      vim.keymap.set("n", "gra", vim.lsp.buf.code_action, { buffer = bufnr })
      vim.keymap.set("n", "<leader>qf", fzf.lsp_code_actions, { buffer = bufnr })
    end

    if client.supports_method("textDocument/definition") then
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
    end

    if client.supports_method("textDocument/references") then
      vim.keymap.set("n", "grr", vim.lsp.buf.references, { buffer = bufnr })
      vim.keymap.set("n", "<leader>gr", fzf.lsp_references, { buffer = bufnr })
    end

    if client.supports_method("textDocument/implementation") then
      vim.keymap.set("n", "<leader>gi", fzf.lsp_implementations, { buffer = bufnr })
    end

    if client.supports_method("textDocument/rename") then
      if client.supports_method("textDocument/documentHighlight") then
        local renamer = require("renamer")
        vim.keymap.set("n", "<leader>rn", renamer.rename, { buffer = bufnr, noremap = true, silent = true })
      else
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
      end
    end
  end,
})

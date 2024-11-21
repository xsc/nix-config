local null_ls = require("null-ls")

-- LSP Sources
local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics

local sources = {
  -- Clojure
  diagnostics.clj_kondo,

  -- CloudFormation
  diagnostics.cfn_lint,

  -- Kotlin
  diagnostics.ktlint,
  formatting.ktlint,

  -- LUA
  formatting.stylua,

  -- Markdown
  diagnostics.alex,
  diagnostics.markdownlint_cli2,

  -- Python
  formatting.black,

  -- Nix
  formatting.alejandra,
  code_actions.statix,
  diagnostics.statix,

  -- TS/JS
  formatting.prettierd,
}

null_ls.setup({ sources = sources })

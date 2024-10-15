local fzf = require("fzf-lua")

fzf.setup({
  winopts = { split = "belowright new" },
  fzf_opts = {
    ["--layout"] = "default",
  },
})

vim.keymap.set("n", "<C-P>", fzf.files, { desc = "Files" })
vim.keymap.set("n", "<leader>b", fzf.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader><leader>", fzf.grep_project, { desc = "Find" })

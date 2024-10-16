local fzf = require("fzf-lua")

vim.keymap.set("n", "<C-P>", fzf.files, { desc = "Files" })
vim.keymap.set("n", "<leader>b", fzf.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader><leader>", fzf.grep_project, { desc = "Find" })

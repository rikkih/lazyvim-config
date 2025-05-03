-- Spaces
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.expandtab = true

-- Disable relative line numbers for easier navigation
vim.wo.relativenumber = true

-- Set commentstring for Java
vim.bo.commentstring = "// %s"

-- Format on save if LSP supports it
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    require("jdtls").organize_imports()
    vim.lsp.buf.format({ async = false })
  end,
})

-- keymaps
vim.keymap.set("n", "<leader>r", ":!java %<CR>", { buffer = true, desc = "Run current Java file" })

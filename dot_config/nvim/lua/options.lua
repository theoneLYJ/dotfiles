local set = vim.o
set.number = true
set.relativenumber = true
set.clipboard = "unnamed"
set.ignorecase = true
set.smartcase = true
set.autoindent = true
set.expandtab = false
set.tabstop = 2
set.smarttab = true
set.shiftwidth = 2
set.softtabstop = 2
set.scrolloff = 8
set.sidescrolloff = 8
set.pumwidth = 10
set.showmode = false

-- copy after highlight
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({
			timeout = 300,
		})
	end,
})

-- keybindings
vim.g.mapleader = " "
vim.keymap.set("n", "j", [[v:count ? 'j' : 'gj']], { noremap = true, expr = true })
vim.keymap.set("n", "k", [[v:count ? 'k' : 'gk']], { noremap = true, expr = true })

return {
	{ "windwp/nvim-ts-autotag" },
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				modules = {},
				ensure_installed = { "lua", "vim", "json", "rust" },
				ignore_install = {},
				sync_install = false,
				auto_install = true,

				highlight = {
					enable = true,
				},

				autotag = {
					enable = true,
				},
			})
		end,
	}
}

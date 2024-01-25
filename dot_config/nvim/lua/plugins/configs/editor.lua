return {
	{
		"romainl/vim-cool",
		event = "VeryLazy",
	},

	{
		"moll/vim-bbye",
		event = "VeryLazy",
	},

	{
		"ahmedkhalf/project.nvim",
		event = "VeryLazy",
		init = function()
			require("project_nvim").setup {
				manual_mode = false,
				detection_methods = { "pattern" },
				patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pom.xml" },
				ignore_lsp = {},
				exclude_dirs = {},
				show_hidden = false,
				silent_chdir = true,
				scope_chdir = 'global',
				datapath = vim.fn.stdpath("data"),
			}
		end
	},

	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup {
				filetypes = { "*" },
				user_default_options = {
					RGB = true,      -- #RGB hex codes
					RRGGBB = true,   -- #RRGGBB hex codes
					names = true,    -- "Name" codes like Blue or blue
					RRGGBBAA = true, -- #RRGGBBAA hex codes
					AARRGGBB = true, -- 0xAARRGGBB hex codes
					rgb_fn = true,   -- CSS rgb() and rgba() functions
					hsl_fn = true,   -- CSS hsl() and hsla() functions
					css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
					css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
					-- Available modes for `mode`: foreground, background,  virtualtext
					mode = "virtualtext", -- Set the display mode.
					-- Available methods are false / true / "normal" / "lsp" / "both"
					-- True is same as normal
					tailwind = false,                           -- Enable tailwind colors
					-- parsers can contain values used in |user_default_options|
					sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
					virtualtext = "■",
					-- update color values even if buffer is not focused
					-- example use: cmp_menu, cmp_docs
					always_update = false
				},
				-- all the sub-options of filetypes apply to buftypes
				buftypes = {},
			}
		end
	},
	{
		'numToStr/Comment.nvim',
		opts = {
			-- add any options here
		},
		lazy = false,
	}
}

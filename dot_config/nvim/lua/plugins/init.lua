I = mo.styles.icons
require("lazy").setup(
	{
		import = "",
		spec = {
			require("plugins.configs.colortheme"),
			require("plugins.configs.treesitter"),
			require("plugins.configs.neotree"),
			require("plugins.configs.ui"),
			require("plugins.configs.whichkey"),
			require("plugins.configs.editor"),
			require("plugins.configs.telescope"),
			require("plugins.configs.lsp"),
			require("plugins.configs.debugger"),
			require("plugins.configs.completion"),
			require("plugins.configs.markdown"),
		},
		install = {
			-- install missing plugins on startup. This doesn't increase startup time.
			missing = true,
			-- try to load one of these colorschemes when starting an installation during startup
			colorscheme = { "catppuccin" },
		},
		icons = {
			loaded = I.plugin.installed,
			not_loaded = I.plugin.uninstalled,
			cmd = I.misc.terminal,
			config = I.misc.setting,
			event = I.lsp.kinds.event,
			ft = I.documents.file,
			init = I.dap.controls.play,
			keys = I.misc.key,
			plugin = I.plugin.plugin,
			runtime = I.misc.vim,
			source = I.lsp.kinds.snippet,
			start = I.dap.play,
			task = I.misc.task,
			lazy = I.misc.lazy,
			list = {
				I.misc.creation,
				I.misc.fish,
				I.misc.star,
				I.misc.pulse,
			},
		}
	}
)

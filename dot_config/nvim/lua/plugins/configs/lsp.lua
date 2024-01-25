return {
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = I.plugin.installed,
						package_pending = I.plugin.pedding,
						package_uninstalled = I.plugin.uninstalled,
					},
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		config = function()
			local fmt = string.format
			local icons = mo.styles.icons.diagnostics
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			for name, icon in pairs(icons) do
				name = "DiagnosticSign" .. name:gsub("^%l", string.upper)
				vim.fn.sign_define(name, { text = icon, texthl = name })
			end

			require("lspconfig.ui.windows").default_options.border = "rounded"

			vim.lsp.handlers["textDocument/hover"] =
					vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

			vim.diagnostic.config({
				severity_sort = true,
				virtual_text = {
					source = false,
					severity = vim.diagnostic.severity.ERROR,
					spacing = 1,
					format = function(d)
						local level = vim.diagnostic.severity[d.severity]
						return fmt("%s %s", icons[level:lower()], d.message)
					end,
				},
				float = {
					header = "",
					source = false,
					border = mo.styles.border,
					prefix = function(d)
						local level = vim.diagnostic.severity[d.severity]
						local prefix = fmt("%s ", icons[level:lower()])
						return prefix, "DiagnosticFloating" .. level
					end,
					format = function(d)
						return d.source and fmt("%s: %s", string.gsub(d.source, "%.$", ""), d.message) or d.message
					end,
					suffix = function(d)
						local code = d.code or (d.user_data and d.user_data.lsp.code)
						local suffix = code and fmt(" (%s)", code) or ""
						return suffix, "Comment"
					end,
				},
			})

			require("mason-lspconfig").setup()
			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions

					local opts = { buffer = ev.buf }
					local wk = require("which-key")
					wk.register({
						["<Leader>"] = {
							h = { vim.lsp.buf.hover, "Type info" },
							H = { vim.lsp.buf.signature_help, "View doc" },
						},
					}, opts)
				end,
			})

			vim.api.nvim_create_autocmd("CursorHold", {
				group = vim.api.nvim_create_augroup("LspDiagnostics", {}),
				desc = "LSP: show diagnostics",
				callback = function()
					vim.diagnostic.open_float({ scope = "cursor", focus = false })
				end
			})

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
						},
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			})

			lspconfig.pyright.setup({
				capabilities = capabilities,
			})

			lspconfig.clangd.setup({
				capabilities = capabilities,
			})

			lspconfig.jdtls.setup({
				capabilities = capabilities,
			})

			lspconfig.volar.setup({
				capabilities = capabilities,
			})
		end,
	},
	{ "mfussenegger/nvim-jdtls", ft = { "java" }},
	{
		"folke/neodev.nvim",
		config = function()
			require("neodev").setup({
				lspconfig = true,
				override = function() end,
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "BufReadPost",
		opts = {
			bind = true,
			hint_scheme = "Comment",
			handler_opts = { border = mo.styles.border },
		},
	},
	{
		"CRAG666/code_runner.nvim",
		event = "VeryLazy",
		config = function()
			local function microsoft_edge()
				if vim.loop.os_uname().sysname == "Linux" then
					return "google-chrome-stable $fileName"
				else
					return "/Applications/Microsoft\\ Edge.app/Contents/MacOS/Microsoft\\ Edge $file"
				end
			end

			require("code_runner").setup({
				term = {
					position = "belowright",
					size = 15,
				},
				filetype = {
					python = "python3 $file",
					c = "cd $dir && gcc -Wall -lpthread -fno-omit-frame-pointer -pg -g "
					.. "-lm $fileName -o $fileNameWithoutExt.out && $dir/$fileNameWithoutExt.out",
					cpp = "cd $dir && g++ -std=c++20 -lpthread -g $fileName -o"
					.. "$fileNameWithoutExt.out  && $dir/$fileNameWithoutExt.out",
					sh = "bash $file",
					html = microsoft_edge(),
					rust = "cargo run",
					r = "Rscript $file",
					lua = "lua $file",
					nix = "nix eval -f $file",
				},
			})
			local wk = require("which-key")
			wk.register({
				["<leader>"] = {
					l = {
						name = "+language",
						r = { "<cmd>RunCode<cr>", "run code" },
					}
				}
			})
		end,
	},
}

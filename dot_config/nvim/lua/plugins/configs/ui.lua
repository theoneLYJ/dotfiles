return {
	{
		"shellRaining/hlchunk.nvim",
		init = function()
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, { pattern = "*", command = "EnableHL" })
			require("hlchunk").setup({
				chunk = {
					enable = true,
					use_treesitter = true,
					style = {
            { fg = "#8294C4" },
					},
				},
				indent = {
					chars = { "│", "¦", "┆", "┊" },
					use_treesitter = true,
					style = {
            { fg = "#7D7C7C" }
					},
				},
				blank = {
					enable = false,
				},
				line_num = {
					use_treesitter = true,
				},
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "williamboman/mason-lspconfig.nvim" },
		event = "BufReadPost",
		config = function()
			local conditions = {
				buffer_not_empty = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
				hide_in_width = function()
					return vim.o.columns > 80
				end,
			}
			local components = {
				branch = {
					"branch",
					icon = { I.git.branch },
				},
				diagnostics = {
					"diagnostics",
					sources = { "nvim_diagnostic" },
					sections = { "error", "warn", "info", "hint" },
					symbols = {
						error = I.diagnostics.error .. " ",
						warn = I.diagnostics.warn .. " ",
						info = I.diagnostics.info .. " ",
						hint = I.diagnostics.hint .. " ",
					},
				},
				mode = {
					"mode",
					fmt = function(str)
						return "-- " .. str .. " --"
					end,
				},
				diff = {
					"diff",
					symbols = {
						added = I.git.added .. " ",
						modified = I.git.modified .. " ",
						removed = I.git.deleted .. " ",
					},
					cond = conditions.hide_in_width,
				},
				spaces = {
					function()
						if not vim.api.nvim_buf_get_option(0, "expandtab") then
							return "Tab:" .. vim.api.nvim_buf_get_option(0, "tabstop")
						end
						local size = vim.api.nvim_buf_get_option(0, "shiftwidth")
						if size == 0 then
							size = vim.api.nvim_buf_get_option(0, "tabstop")
						end
						return "Spaces:" .. size
					end,
					padding = { left = 1, right = 2 },
					cond = conditions.hide_in_width,
				},
				filetype = {
					"filetype",
					icons_enabled = false,
					icon = nil,
				},
				progress = {
					function()
						local current_line = vim.fn.line(".")
						local total_lines = vim.fn.line("$")
						local chars = I.misc.progress
						local line_ratio = current_line / total_lines
						local index = math.ceil(line_ratio * #chars)
						return chars[index]
					end,
				},
				lsp = {
					function()
						local msg = 'No Active Lsp'
						local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
						local clients = vim.lsp.get_active_clients()
						if next(clients) == nil then
							return msg
						end
						for _, client in ipairs(clients) do
							local filetypes = client.config.filetypes
							if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
								return client.name
							end
						end
						return msg
					end,
					icon = I.lsp.lsp .. ' Lsp:',
				},
			}

			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = 'auto',
					component_separators = { left = '', right = '' },
					section_separators = { left = '', right = '' },
					always_divide_middle = true,
					disabled_filetypes = {
						statusline = {
							"qf",
							"lazy",
							"help",
							"diff",
							"alpha",
							"mason",
							"undotree",
							"toggleterm",
							"neo-tree",
							"dap-repl",
							"dapui_stacks",
							"dapui_scopes",
							"dapui_watches",
							"dapui_breakpoints",
							"TelescopePrompt",
						},
					},
				},
				sections = {
					lualine_a = { components.branch, components.diagnostics },
					lualine_b = { components.mode },
					lualine_c = { components.diff },
					lualine_x = { components.lsp, components.spaces, components.filetype },
					lualine_y = {},
					lualine_z = { components.progress }
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {}
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {}
			})
		end,
	},
	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			require("bufferline").setup {}

			local opt = {
				noremap = true,
				silent = true,
			}

			-- 本地变量
			local map = vim.api.nvim_set_keymap
			-- bufferline
			-- 左右Tab切换
			map("n", "<S-h>", ":BufferLineCyclePrev<CR>", opt)
			map("n", "<S-l>", ":BufferLineCycleNext<CR>", opt)
			-- "moll/vim-bbye" 关闭当前 buffer
			map("n", "<leader>c", ":Bdelete!<CR>", opt)
			map("n", "<leader>C", ":BufferLineCloseOthers<CR>", opt)
		end
	}
}

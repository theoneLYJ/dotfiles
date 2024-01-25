return {
	{
		"mfussenegger/nvim-dap",
		dependencies = { "rcarriga/nvim-dap-ui" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			vim.fn.sign_define('DapBreakpoint', {text = mo.styles.icons.dap.signs.breakpoint, texthl = '', linehl = '', numhl = ''})
			vim.fn.sign_define('DapStopped', {text = mo.styles.icons.dap.signs.stopped, texthl = '', linehl = '', numhl = ''})
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			dap.adapters.cppdbg = {
				id = 'cppdbg',
				type = 'executable',
				command = '/home/theoneLYJ/.local/share/nvim/mason/bin/OpenDebugAD7',
			}

			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "cppdbg",
					request = "launch",
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					cwd = '${workspaceFolder}',
					stopAtEntry = true,
				},
				{
					name = 'Attach to gdbserver :1234',
					type = 'cppdbg',
					request = 'launch',
					MIMode = 'gdb',
					miDebuggerServerAddress = 'localhost:1234',
					miDebuggerPath = '/usr/bin/gdb',
					cwd = '${workspaceFolder}',
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
				},
			}
			dap.configurations.c = dap.configurations.cpp

			dap.adapters.python = function(cb, config)
				if config.request == 'attach' then
					---@diagnostic disable-next-line: undefined-field
					local port = (config.connect or config).port
					---@diagnostic disable-next-line: undefined-field
					local host = (config.connect or config).host or '127.0.0.1'
					cb({
						type = 'server',
						port = assert(port, '`connect.port` is required for a python `attach` configuration'),
						host = host,
						options = {
							source_filetype = 'python',
						},
					})
				else
					cb({
						type = 'executable',
						command = '/usr/bin/python',
						args = { '-m', 'debugpy.adapter' },
						options = {
							source_filetype = 'python',
						},
					})
				end
			end

			dap.configurations.python = {
				{
					-- The first three options are required by nvim-dap
					type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
					request = 'launch',
					name = "Launch file",
					program = "${file}", -- This configuration will launch the current file if used.
					pythonPath = function()
						return "/usr/bin/python"
					end
				}
			}

			vim.keymap.set("n", "<Leader>de", function()
				dap.toggle_breakpoint()
			end)
			vim.keymap.set("n", "<Leader>dr", function()
				dap.continue()
			end)

			vim.keymap.set("n", "<F11>", ":lua require'dap'.step_out()<CR>")
			vim.keymap.set("n", "<F10>", ":lua require'dap'.step_into()<CR>")
			-- 弹窗
			vim.keymap.set("n", "<leader>dh", ":lua require'dapui'.eval()<CR>")

		end,
	},
}

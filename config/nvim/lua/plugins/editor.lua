return {
	{
		"iguanacucumber/magazine.nvim",
		name = "nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-path" },
		},
		config = function()
			local cmp = require("cmp")
			local cmdline_mapping = cmp.mapping.preset.cmdline()
			cmp.setup.cmdline("/", {
				mapping = cmdline_mapping,
				sources = cmp.config.sources({
					{ name = "buffer" },
				}),
			})
			cmp.setup.cmdline("?", {
				mapping = cmdline_mapping,
				sources = cmp.config.sources({
					{ name = "buffer" },
				}),
			})
			cmp.setup.cmdline(":", {
				mapping = cmdline_mapping,
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline", option = { ignore_cmds = { "Man", "!", "terminal" } } },
				}),
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		cmd = "Telescope",
		keys = {
			{ "g!", "<Cmd>lua require('skippi.picker').pkill()<CR>" },
			{ "g]", ":<C-u>TSelect <C-r><C-w><CR>", silent = true },
			{ "g<C-]>", ":<C-u>TJump <C-r><C-w><CR>", silent = true },
			{ "<C-q>", "<Cmd>Telescope quickfix<CR>" },
			{ "<Space>.", "<Cmd>Telescope resume<CR>" },
			{ "<Space>>", "<Cmd>Telescope pickers<CR>" },
			{
				"<Space>/",
				function()
					local util = require("skippi.util")
					local opts = {
						cwd = util.workspace_root() or vim.fn.getcwd(),
					}
					if vim.v.count ~= 0 then
						opts.type_filter = util.ft_to_ripgrep_type(vim.bo.filetype)
					end
					require("telescope.builtin").live_grep(opts)
				end,
			},
			{
				"<Space>?",
				function()
					local util = require("skippi.util")
					local opts = {}
					if vim.v.count ~= 0 then
						opts.type_filter = util.ft_to_ripgrep_type(vim.bo.filetype)
					end
					require("telescope.builtin").live_grep(opts)
				end,
			},
			{ "<Space>b", "<Cmd>Telescope buffers<CR>" },
			{ "<Space>d", "<Cmd>Telescope diagnostics bufnr=0<CR>" },
			{ "<Space>D", "<Cmd>Telescope diagnostics<CR>" },
			{
				"<Space>f",
				function()
					require("telescope.builtin").find_files({
						cwd = require("skippi.util").workspace_root() or vim.fn.getcwd(),
					})
				end,
			},
			{ "<Space>F", "<Cmd>Telescope find_files<CR>" },
			{ "<Space>l", "<Cmd>Telescope lsp_document_symbols<CR>" },
			{ "<Space>L", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>" },
			{
				"z/",
				function()
					if vim.bo.buftype == "quickfix" then
						require("telescope.builtin").quickfix({ previewer = false })
					else
						require("telescope.builtin").current_buffer_fuzzy_find({ previewer = false })
					end
				end,
			},
		},
		opts = function()
			local actions = require("telescope.actions")
			return {
				defaults = {
					mappings = {
						i = {
							["<Esc>"] = actions.close,
							["<Tab>"] = actions.move_selection_next,
							["<S-Tab>"] = actions.move_selection_previous,
							["<C-k>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-j>"] = actions.toggle_selection + actions.move_selection_worse,
							["<C-y>"] = require("telescope.actions.layout").toggle_preview,
							["<PageUp>"] = actions.preview_scrolling_up,
							["<PageDown>"] = actions.preview_scrolling_down,
							["<C-u>"] = actions.results_scrolling_up,
							["<C-d>"] = actions.results_scrolling_down,
							["<C-a>"] = actions.toggle_all,
							["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
							["<C-r><C-w>"] = require("skippi.actions").insert_cword,
							["<C-r><C-a>"] = require("skippi.actions").insert_cWORD,
						},
					},
					layout_config = {
						prompt_position = "top",
						width = 0.9,
					},
					sorting_strategy = "ascending",
					results_title = "",
					cache_picker = {
						num_pickers = 20,
					},
				},
				extensions = {
					fzf = {
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			}
		end,
		config = function(_, opts)
			local picker = require("skippi.picker")
			local util = require("skippi.util")
			util.create_user_command("TSelect", function(params)
				opts = {}
				if #params.args ~= 0 then
					opts.tagname = params.args
				end
				picker.tselect(opts)
			end, {
				abbrev = "ts[elect]",
				desc = "tselect with fuzzy finder",
				nargs = "?",
			})
			util.create_user_command("TJump", function(params)
				opts = {}
				if #params.args ~= 0 then
					opts.tagname = params.args
				end
				picker.tjump(opts)
			end, {
				abbrev = "tj[ump]",
				desc = "tjump with fuzzy finder",
				nargs = "?",
			})
			require("telescope").setup(opts)
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"tpope/vim-eunuch",
		config = function()
			vim.keymap.set("n", "ZR", [[:Rename! .<C-r>=expand("%:e")<CR><C-B><C-Right><Right>]], {
				desc = "rename current file",
			})
			vim.keymap.set("n", "ZX", "<Cmd>Remove!<CR>", { desc = "delete current file" })
		end,
	},
	{ "tpope/vim-characterize", keys = { "ga" } },
	{
		"tpope/vim-sleuth",
		event = "BufReadPre",
		config = function()
			vim.g.sleuth_lua_defaults = "tabstop=2"
		end,
	},
	{
		"tpope/vim-fugitive",
		dependencies = { "tpope/vim-rhubarb" },
		config = function()
			vim.keymap.set({ "n", "x" }, "gX", ":GBrowse<CR>", { silent = true })
			vim.keymap.set("n", "g.", "<Cmd>Gvdiffsplit<CR>")
			vim.keymap.set("n", "g<CR>", "<Cmd>G<CR>")
			vim.keymap.set("n", "g<Space>", ":G<Space>")
			vim.keymap.set("n", "gL", function()
				local cmd = "G log --oneline"
				if vim.v.count ~= 0 then
					cmd = cmd .. " -n" .. vim.v.count
				end
				vim.cmd(cmd)
			end)
			vim.keymap.set("n", "gb", "<Cmd>G blame<CR>")
		end,
	},
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		event = "LspAttach",
		config = function()
			require("lsp_lines").setup()
			vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
			vim.keymap.set("n", "yoq", require("lsp_lines").toggle, { desc = "toggle lsp_lines" })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		keys = {
			{ "do", "<Cmd>Diffget<CR>", mode = { "n" } },
			{ "dp", "<Cmd>Diffput<CR>", mode = { "n" } },
			{ "dO", "<Cmd>%Diffget<CR>", mode = { "n" } },
			{ "dP", "<Cmd>%Diffput<CR>", mode = { "n" } },
			{ "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, silent = true },
			{ "ah", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, silent = true },
			{
				"]c",
				function()
					if vim.wo.diff then
						return "]c"
					end
					local gs = require("gitsigns")
					vim.schedule(gs.next_hunk)
					return "<Ignore>"
				end,
				mode = { "n", "x", "o" },
				expr = true,
			},
			{
				"[c",
				function()
					if vim.wo.diff then
						return "[c"
					end
					local gs = require("gitsigns")
					vim.schedule(gs.prev_hunk)
					return "<Ignore>"
				end,
				mode = { "n", "x", "o" },
				expr = true,
			},
		},
		config = function()
			local gs = require("gitsigns")
			local util = require("skippi.util")
			util.create_user_command("Diffput", function(args)
				local cmd = ""
				if args.range == 1 then
					cmd = args.line1
				elseif args.range == 2 then
					cmd = args.line1 .. "," .. args.line2
				end
				cmd = cmd .. (vim.wo.diff and "diffput" or "Gitsigns stage_hunk")
				vim.cmd(cmd)
			end, { abbrev = { "diffpu[t]", "dp" }, range = true })
			util.create_user_command("Diffget", function(args)
				local cmd = ""
				if args.range == 1 then
					cmd = args.line1
				elseif args.range == 2 then
					cmd = args.line1 .. "," .. args.line2
				end
				cmd = cmd .. (vim.wo.diff and "diffget" or "Gitsigns reset_hunk")
				vim.cmd(cmd)
			end, { abbrev = { "diffg[et]", "do" }, range = true })
			gs.setup({
				signs = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "┃" },
					topdelete = { text = "┃" },
					changedelete = { text = "┃" },
				},
				update_debounce = 0,
			})
			local group = vim.api.nvim_create_augroup("skippi.gitsigns", { clear = true })
			vim.api.nvim_create_autocmd("User", {
				pattern = "GitSignsChanged",
				group = group,
				desc = "auto reload fugitive",
				callback = function()
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
						if ft == "fugitive" then
							vim.schedule(function()
								vim.api.nvim_buf_call(buf, vim.cmd.edit) -- refresh the buffer
							end)
						end
					end
				end,
			})
		end,
	},
	{ "axelf4/vim-strip-trailing-whitespace" },
}

return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{},
		},
		keys = {
			{ "g!", require("skippi.picker").pkill, desc = "telescope kill process" },
			{ "<C-q>", "<Cmd>Telescope quickfix<CR>" },
			{ "<C-s>", require("skippi.picker").tselect, desc = "telescope tselect" },
			{ "<Space>F", ":lua require('telescope.builtin').fd{cwd=''}<Left><Left>" },
			{ "<Space>f", "<Cmd>Telescope find_files<CR>" },
			{ "<Space>g", "<Cmd>Telescope git_files<CR>" },
			{ "<Space>.", "<Cmd>Telescope resume<CR>" },
			{ "<Space><BS>", "<Cmd>Telescope buffers<CR>" },
			{
				"z/",
				function()
					require("telescope.builtin").current_buffer_fuzzy_find({ previewer = false })
				end,
			},
		},
		opts = function()
			local actions = require("telescope.actions")
			return {
				defaults = require("telescope.themes").get_ivy({
					mappings = {
						i = {
							["<C-a>"] = actions.toggle_all,
							["<C-q>"] = require("skippi.actions").send_to_qflist,
							["<C-r><C-w>"] = require("skippi.actions").insert_cword,
							["<C-r><C-a>"] = require("skippi.actions").insert_cWORD,
						},
					},
					layout_config = { height = 17 },
					results_title = "",
					selection_caret = "  ",
					cache_picker = {
						num_pickers = 10,
					},
				}),
				extensions = {
					fzf = {
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			}
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		dependencies = "nvim-telescope/telescope.nvim",
		build = "make",
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		dependencies = "nvim-telescope/telescope.nvim",
		config = function()
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"smartpde/telescope-recent-files",
		keys = {
			{
				"<Space>h",
				function()
					require("telescope").extensions.recent_files.pick()
				end,
				desc = "telescope recent files",
			},
		},
		dependencies = "nvim-telescope/telescope.nvim",
		config = function()
			require("telescope").load_extension("recent_files")
		end,
	},
	"jghauser/mkdir.nvim",
	"tpope/vim-obsession",
	"tpope/vim-sleuth",
	"tpope/vim-vinegar",
}

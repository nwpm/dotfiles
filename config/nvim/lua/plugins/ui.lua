return {
	-- LuaLine(materia)
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					icons_enabled = true,
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
				lualine_c = {
					{
						"filename",
						file_status = true,
						path = 1,
					},
				},
			})
		end,
	},

	-- Colortheme
	{
		"Mofiqul/vscode.nvim",
		priority = 1000,
		config = function()
			---@diagnostic disable-next-line: missing-fields
			vim.cmd.colorscheme("vscode")
		end,
	},

	-- Dashboard
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("dashboard").setup({
				theme = "hyper",
				config = {
					header = {
						[[    _   __                _         ]],
						[[   / | / /__  ____ _   __(_)___ ___ ]],
						[[  /  |/ / _ \/ __ \ | / / / __ `__ \]],
						[[ / /|  /  __/ /_/ / |/ / / / / / / /]],
						[[/_/ |_/\___/\____/|___/_/_/ /_/ /_/ ]],
						[[                                    ]],
					},
					shortcut = {
						{
							icon = " ",
							icon_hl = "@variable",
							desc = "Find File",
							group = "@text.uri",
							action = "Telescope find_files",
							key = "f",
						},
						{
							icon = " ",
							icon_hl = "@variable",
							desc = "Grep Text",
							group = "@text.uri",
							action = "Telescope live_grep",
							key = "g",
						},
						{
							icon = " ",
							icon_hl = "@variable",
							desc = "Recent Files",
							group = "@text.uri",
							action = "Telescope oldfiles",
							key = "r",
						},
						{
							icon = " ",
							icon_hl = "@variable",
							desc = "Edit Config",
							group = "@text.uri",
							action = "edit ~/.config/nvim/init.lua",
							key = "c",
						},
						{
							icon = " ",
							icon_hl = "@variable",
							desc = "Quit",
							group = "@text.uri",
							action = "qa",
							key = "q",
						},
					},
					project = { enable = true, limit = 8 },
					mru = { limit = 10 },
					footer = { "Powered by Neovim" },
				},
			})
		end,
	},
	-- WhichKey
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			spec = {
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},
	-- Tabs viewer
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = "|",
				tab_char = ">",
			},
			scope = { enabled = true },
			exclude = {
				filetypes = {
					"dashboard",
					"alpha",
					"help",
					"terminal",
					"packer",
					"NvimTree",
					"neo-tree",
					"Trouble",
				},
				buftypes = {
					"terminal",
					"nofile",
					"quickfix",
				},
			},
		},
	},
}

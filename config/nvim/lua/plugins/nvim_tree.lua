return {
	-- Nvim-Tree
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				renderer = {
					group_empty = true,
					icons = {
						glyphs = {
							git = {
								unstaged = "✗",
								staged = "✓",
								unmerged = "",
								renamed = "➜",
								untracked = "★",
								deleted = "",
								ignored = "◌",
							},
						},
						git_placement = "signcolumn",
					},
				},
				git = {
					enable = false,
					timeout = 500,
				},
				view = {
					width = 35,
				},
			})
		end,
	},
}

return {
	-- CMakeTools
	{
		"Civitasv/cmake-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("cmake-tools").setup({
				cmake_command = "cmake",
				cmake_build_directory = "build",
			})
			vim.keymap.set("n", "<leader>cb", ":CMakeBuild<CR>", {})
			vim.keymap.set("n", "<leader>cr", ":CMakeRun<CR>", {})
		end,
	},
}

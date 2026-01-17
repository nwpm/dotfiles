return {
	-- Formatting null-ls
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {

					-- Formatters
					null_ls.builtins.formatting.stylua, -- lua
					null_ls.builtins.formatting.clang_format, -- c/c++
					null_ls.builtins.formatting.asmfmt, -- asm
					null_ls.builtins.formatting.black, -- python
					null_ls.builtins.formatting.stylua, -- lua

					-- Linters
					null_ls.builtins.diagnostics.pylint, -- python
				},
			})
		end,
	},
}

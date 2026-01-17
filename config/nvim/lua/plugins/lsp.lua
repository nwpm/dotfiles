return {
	-- Mason
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	-- Mason-LSPConfig
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "clangd", "lua_ls", "asm_lsp" },
			})
		end,
	},
	-- Lsp checker
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"clangd", -- C/C++
					"clang-format", -- C/C++ formatter
					"asm-lsp", -- ASM
					"asmfmt", -- ASM formatter
					"rust-analyzer", -- Rust
					"stylua", -- Lua
					"prettier", -- JS/TS
					"pylsp", -- python
				},

				run_on_start = true,
				start_delay = 3000,
				debounce_hours = 5,
			})
		end,
	},

	-- nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			{ "nvim-telescope/telescope.nvim" },
		},

		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- cpp
			vim.lsp.config("clangd", {
				cmd = { "clangd", "--background-index", "--clang-tidy" },
				filetypes = { "c", "cpp", "objc", "objcpp" },
				capabilities = capabilities,
			})

			-- asm
			vim.lsp.config("asm_lsp", {
				cmd = { "asm-lsp" },
				filetypes = { "asm", "s", "S" },
				capabilities = capabilities,
			})

			-- python
			vim.lsp.config("pylsp", {
				cmd = { "pylsp" },
				filetypes = { "python" },
				capabilities = capabilities,
				settings = {
					pylsp = {
						plugins = {
							pyflakes = { enabled = true },
							pycodestyle = { enabled = true, maxLineLength = 100 },
							mccabe = { enabled = false },
						},
					},
				},
			})

			-- lua
			vim.lsp.config("lua_ls", {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
							path = vim.split(package.path, ";"),
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = { enable = false },
					},
				},
				capabilities = capabilities,
			})

			-- bash
			vim.lsp.config("bashls", {
				cmd = { "bash-language-server", "start" },
				filetypes = { "sh", "bash", "zsh" },
				capabilities = capabilities,
			})

			vim.lsp.config("racket", {
				cmd = { "racket", "-l", "racket-langserver" },
				filetypes = { "racket", "scheme" },
				capabilities = capabilities,
			})

			vim.lsp.enable({ "clangd", "asm_lsp", "pylsp", "lua_ls", "bashls" })

			-- lsp keybindings
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Lsp signature
					require("lsp_signature").on_attach({
						bind = true,
						floating_window = true,
						handler_opts = { border = "rounded" },
					}, event.buf)

					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
				end,
			})
		end,
	},
}

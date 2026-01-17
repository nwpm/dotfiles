return {
	-- Lsp signature
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			bind = true,
			floating_window = true,
			handler_opts = {
				border = "rounded",
			},
		},
	},

	-- nvim-cmp Autocomplition
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")

			-- Define custom highlight groups for completion kinds
			vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#4EC9B0" }) -- Turquoise for classes/structs
			vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#9CDCFE" }) -- Light blue for variables
			vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#DCDCAA" }) -- Yellow-green for functions/methods
			vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#C586C0" }) -- Pink-purple for keywords
			vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#CE9178" }) -- Peach for constants
			vim.api.nvim_set_hl(0, "CmpItemKindDefault", { fg = "#BBBBBB" }) -- Light gray for others

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 750 },
					{ name = "buffer", priority = 500 },
					{ name = "path", priority = 250 },
				}),
				-- Custom formatting for detailed and pretty completion
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						vim_item.kind = lspkind.symbolic(vim_item.kind, { with_text = true })

						-- Add detailed info (parameters, return type) for LSP
						if entry.source.name == "nvim_lsp" then
							local item = entry:get_completion_item()

							if item.detail then
								vim_item.menu = vim_item.menu .. " " .. item.detail
							end
							if item.documentation then
								local docs = type(item.documentation) == "string" and item.documentation
									or item.documentation.value
								-- Limit documentation length for compactness
								if docs then
									local max_length = 50
									vim_item.menu = vim_item.menu
										.. "\n"
										.. string.sub(docs, 1, max_length)
										.. (string.len(docs) > max_length and "..." or "")
								end
							end
						end

						-- Remove duplicates
						vim_item.dup = ({ nvim_lsp = 0, buffer = 1, path = 1, luasnip = 0 })[entry.source.name] or 0

						return vim_item
					end,
				},
				-- Compact and bordered completion windows
				window = {
					completion = cmp.config.window.bordered({
						border = "rounded",
						winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
						col_offset = -3,
						side_padding = 0,
						scrollbar = true,
					}),
					documentation = cmp.config.window.bordered({
						border = "rounded",
						winhighlight = "Normal:Normal,FloatBorder:BorderBG",
						max_width = 80,
						max_height = 20,
						scrollbar = true,
					}),
				},

				-- Sorting and filtering
				sorting = {
					priority_weight = 2,
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
			})
		end,
	},
	-- nvim-autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true, -- Integrate with Treesitter
				ts_config = {
					lua = { "string" }, -- Don't autopair in Lua strings
					python = { "string", "comment" }, -- Don't autopair in Python strings/comments
				},
				fast_wrap = {
					map = "<M-e>", -- Alt+e for fast wrap
					chars = { "{", "[", "(", '"', "'" },
					pattern = [=[[%'%"%>%]%)%}%,]]=],
					end_key = "$",
					keys = "qwertyuiopzxcvbnmasdfghjkl",
				},
			})

			-- Integrate with nvim-cmp
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
}

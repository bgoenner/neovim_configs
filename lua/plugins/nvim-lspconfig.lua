local on_attach = require("util.lsp").on_attach

local config = function()
	local lspconfig = require("lspconfig")

	local signs = { Error = "x", Warn = "!", Hint = "+ ", Info = "i" }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	-- local on_attach = function(client, bufnr)
		--keyoptions
		-- local opts = { noremap = true, silent = true, buffer = bufnr }

		--set keybinds
		-- vim.keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts)
		-- vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
		-- vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)

		-- vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
	-- end
	-- python
	lspconfig.pyright.setup({
		-- capabilities = capabilities
		on_attach = on_attach,
		settings = {
			pyright = {
				disableOrganizeImports = false,
				analysis = {
					useLibraryCodeForTypes = true,
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					autoImportCompletions = true,
				},
			},
		},
	})
	-- lua
	lspconfig.lua_ls.setup({

		on_attach = on_attach,
		settings = {
			Lua = {
				-- make the lanuage server recognize "vim" global
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					-- make language server aware of runtime
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
				},
			},
		},
	})

	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")
	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")

	-- configure efm server
	lspconfig.efm.setup({
		filetypes = {
			"lua",
      "python",
		},
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
			hover = true,
			documentSymbol = true,
			codeAction = true,
			completion = true,
		},
		settings = {
			languages = {
				lua = { luacheck, stylua },
				python = { flake8, black },
			},
		},
	})

	local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = lsp_fmt_group,
		callback = function()
			local efm = vim.lsp.get_active_clients({ name = "efm" })

			if vim.tbl_isempty(efm) then
				return
			end

			vim.lsp.buf.format({ name = "efm" })
		end,
	})
end

return {
	"neovim/nvim-lspconfig",
	config = config,
	lazy = false,
	dependencies = {
		"windwp/nvim-autopairs",
		"williamboman/mason.nvim",
		"creativenull/efmls-configs-nvim",
	},
}

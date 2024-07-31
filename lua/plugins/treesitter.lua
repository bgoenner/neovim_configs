local config = function()
	require("nvim-treesitter.configs").setup({
		indent = {
			enable = true,
		},
		autotag = {
			enable = true,
		},
		ensure_installed = {
			"markdown",
			"json",
			"javascript",
			"typescript",
			"yaml",
			"html",
			"css",
			"markdown",
			"bash",
			"lua",
			"dockerfile",
			"solidity",
			"gitignore",
			"python",
			"vue",
		},
		auto_install = true,
		highlight = {
			enable = true, -- true
			additional_vim_regex_highlight = true, -- true
		},
	})
end

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	config = config,
}

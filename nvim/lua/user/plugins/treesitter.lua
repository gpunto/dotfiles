return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"query",
				"rust",
				"kotlin",
				"bash",
				"json",
				"toml",
				"yaml",
				"markdown",
				"markdown_inline",
			},
			sync_install = false,
			ignore_install = { "" }, -- List of parsers to ignore installing
			highlight = {
				enable = true, -- false will disable the whole extension
				disable = { "" }, -- list of language that will be disabled
				additional_vim_regex_highlighting = true,
			},
			indent = { enable = true, disable = { "" } },
		})
	end,
}

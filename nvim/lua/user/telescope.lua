local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

telescope.load_extension "file_browser"

vim.api.nvim_set_keymap("n", "<leader>f", ":Telescope file_browser<CR>", { noremap = true })

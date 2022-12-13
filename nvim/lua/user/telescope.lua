local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

telescope.load_extension "file_browser"

vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fF", ":Telescope file_browser<CR>", { noremap = true })

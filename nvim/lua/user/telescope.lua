local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

require("user.neoclip")

telescope.load_extension("file_browser")
telescope.load_extension("neoclip")

vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fl", ":Telescope live_grep<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fF", ":Telescope file_browser<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fh", ":Telescope oldfiles<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fp", ":Telescope neoclip initial_mode=normal<CR>", { noremap = true })

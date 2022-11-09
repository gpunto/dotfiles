local status_ok, hop = pcall(require, "hop")
if not status_ok then
	return
end

vim.keymap.set('', "<leader>j", hop.hint_words)

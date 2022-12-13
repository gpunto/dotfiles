local status_ok, neoclip = pcall(require, "neoclip")
if not status_ok then
	return
end

neoclip.setup({
	enable_persistent_history = true,
	default_register = '+',
	on_paste = {
		set_reg = true,
	},
})

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("user.neoclip")
      local telescope = require("telescope")

      telescope.load_extension("file_browser")
      telescope.load_extension("neoclip")

      telescope.setup({
        pickers = {
          oldfiles = {
            cwd_only = true
          }
        }
      })
      vim.api.nvim_set_keymap(
        "n",
        "<leader>fb",
        ":Telescope buffers<CR> initial_mode=normal<CR>",
        { noremap = true }
      )
      vim.api.nvim_set_keymap("n", "<leader>fl", ":Telescope live_grep<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>fF", ":Telescope file_browser<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>fh", ":Telescope oldfiles<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>fp", ":Telescope neoclip initial_mode=normal<CR>", { noremap = true })
    end,
  },
  "nvim-telescope/telescope-fzf-native.nvim",
  "nvim-telescope/telescope-file-browser.nvim",
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      { "kkharji/sqlite.lua" },
      { "nvim-telescope/telescope.nvim" },
    },
  },
}

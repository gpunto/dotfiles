return {
  "ellisonleao/gruvbox.nvim",

  "nvim-lua/plenary.nvim",

  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  "knubie/vim-kitty-navigator",

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    url = "https://codeberg.org/andyg/leap.nvim",
    config = function()
      vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
      vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
      vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')
    end,
  },

  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
  },

  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
      vim.keymap.set("v", "gS", "<Plug>(nvim-surround-visual)")
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      }
    }
  }
}

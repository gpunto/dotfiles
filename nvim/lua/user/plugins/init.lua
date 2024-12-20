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
    "ggandor/leap.nvim",
    config = function()
      require("leap").add_default_mappings()
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
      require("nvim-surround").setup({
        keymaps = {
          visual = "gS",
        },
      })
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

vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.showmode = false

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "christoomey/vim-tmux-navigator",
  { "catppuccin/nvim", name = "catppuccin" },
  "nvim-lualine/lualine.nvim",
  { "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
      require("nvim-treesitter.configs").setup {
          ensure_installed = {
            "c",
            "lua",
            "rust",
            "go",
            "gitcommit",
            "gitignore",
            "dockerfile",
            "java",
            "json",
            "kotlin",
            "python",
            "sql",
            'typescript',
            "yaml"
          },
          highlight = { enable = true, }
      }
  end },
})

require("catppuccin").setup({
	flavour = "macchiato",
  integrations = {
    treesitter = true
  }
})

vim.cmd.colorscheme "catppuccin-macchiato"

require("lualine").setup {
    options = {
        theme = "catppuccin"
        -- ... the rest of your lualine config
    }
}

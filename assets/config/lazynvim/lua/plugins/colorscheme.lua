-- VSCode-like colorscheme configuration for LazyVim

return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({
        -- Enable transparent background
        transparent = false,
        -- Enable italic comment
        italic_comments = true,
        -- Disable nvim-tree background color
        disable_nvimtree_bg = true,
        -- Other style customizations can go here
      })
      -- Set colorscheme
      vim.cmd.colorscheme("vscode")
    end,
  },
}

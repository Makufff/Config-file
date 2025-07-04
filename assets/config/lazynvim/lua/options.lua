-- LazyVim Options: VSCode Style

local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.showmode = false
opt.cmdheight = 1
opt.laststatus = 3 -- global statusline
opt.showtabline = 2

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.autoindent = true

-- Font (for GUI clients like Neovide/GUI Vim)
vim.g.gui_font_default = "JetBrainsMono Nerd Font:h14"
vim.opt.guifont = vim.g.gui_font_default

-- Clipboard
opt.clipboard = "unnamedplus"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Split windows
opt.splitbelow = true
opt.splitright = true

-- Mouse
opt.mouse = "a"

-- Colorscheme (set in plugins/colorscheme.lua)
-- vim.cmd("colorscheme vscode")

-- Other
opt.updatetime = 300
opt.timeoutlen = 400

-- Keymap leader (set in init.lua, but can be here for clarity)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- VSCode-like UI tweaks
opt.fillchars:append({ eob = " " }) -- Hide ~ at end of buffer

-- End of options.lua

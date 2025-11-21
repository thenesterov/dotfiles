(local iva-vim-theme {})

(fn iva-vim-theme.solarized []
  $(iva-vim-deps.add   {:source "maxmx03/solarized.nvim"})
  $(iva-vim-deps.setup "solarized" {})

  (set vim.o.termguicolors true)
  (set vim.o.background "light")

  (vim.cmd.colorscheme "solarized"))

iva-vim-theme


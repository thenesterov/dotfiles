;; install plugin-manager
$(iva-vim-deps.install)

;; default settings
(set vim.opt.number true)

;; theme
$(iva-vim-theme.solarized)

;; navigation
$(iva-vim-deps.add   {:source   "nvim-mini/mini.jump2d"
                      :checkout "stable"})
$(iva-vim-deps.setup "mini.jump2d")


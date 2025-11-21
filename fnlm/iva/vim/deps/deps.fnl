(local iva-vim-deps {})

(fn iva-vim-deps.install []
  (let [path-package (.. (vim.fn.stdpath "data") "/site/")
        mini-path    (.. path-package "pack/deps/start/mini.nvim")]
    (when (not (vim.loop.fs_stat mini-path))
      (vim.fn.system ["git" "clone" "--filter=blob:none" "https://github.com/nvim-mini/mini.nvim" mini-path]))

    ((. (require "mini.deps") :setup) {:path {:package path-package}})))

(fn iva-vim-deps.add [...]
  (MiniDeps.add ...))

(fn iva-vim-deps.setup [deps-name opts]
  ((. (require deps-name) :setup) opts))

iva-vim-deps


local iva_vim_deps
package.preload["iva.vim.deps.deps"] = package.preload["iva.vim.deps.deps"] or function(...)
  local iva_vim_deps = {}
  iva_vim_deps.install = function()
    local path_package = (vim.fn.stdpath("data") .. "/site/")
    local mini_path = (path_package .. "pack/deps/start/mini.nvim")
    if not vim.loop.fs_stat(mini_path) then
      vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/nvim-mini/mini.nvim", mini_path})
    else
    end
    return require("mini.deps").setup({path = {package = path_package}})
  end
  iva_vim_deps.add = function(...)
    return MiniDeps.add(...)
  end
  iva_vim_deps.setup = function(deps_name, opts)
    return require(deps_name).setup(opts)
  end
  return iva_vim_deps
end
iva_vim_deps = require("iva.vim.deps.deps")
local iva_vim_theme
package.preload["iva.vim.theme.theme"] = package.preload["iva.vim.theme.theme"] or function(...)
  local iva_vim_deps = require("iva.vim.deps.deps")
  local iva_vim_deps0 = require("iva.vim.deps.deps")
  local iva_vim_theme = {}
  iva_vim_theme.solarized = function()
    iva_vim_deps0.add({source = "maxmx03/solarized.nvim"})
    iva_vim_deps0.setup("solarized", {})
    vim.o.termguicolors = true
    vim.o.background = "light"
    return vim.cmd.colorscheme("solarized")
  end
  return iva_vim_theme
end
iva_vim_theme = require("iva.vim.theme.theme")
local iva_vim_deps0 = require("iva.vim.deps.deps")
local iva_vim_deps1 = require("iva.vim.deps.deps")
iva_vim_deps1.install()
vim.opt.number = true
iva_vim_theme.solarized()
iva_vim_deps1.add({source = "nvim-mini/mini.jump2d", checkout = "stable"})
return iva_vim_deps1.setup("mini.jump2d")

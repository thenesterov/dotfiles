(fn fmf-list-contains [list value]
  (each [_ item (ipairs list)]
    (when (= item value) (lua "return true")))
  false)


(local fmf-list-remove {})

(fn fmf-list-remove.value [list value]
  (each [i v (ipairs list)]
    (when (= v value)
      (table.remove list i)
      (lua :break))))

fmf-list-remove


(local fmf-debug-print {})

(fn fmf-debug-print.table [tbl indent]
  (set-forcibly! indent (or indent ""))
  (when (not= (type tbl) :table)
    (print (.. indent (tostring tbl)))
    (lua "return "))
  (print (.. indent "{"))
  (each [k v (pairs tbl)]
    (var key-str (tostring k))
    (when (= (type k) :string) (set key-str (.. "\"" key-str "\"")))
    (io.write (.. indent "  [" key-str "] = "))
    (if (= (type v) :table) (fmf-debug-print.table v (.. indent "  "))
        (print (tostring v))))
  (print (.. indent "}")))

fmf-debug-print


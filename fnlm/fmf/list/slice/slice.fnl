(fn fmf-list-slice [tbl first last step]
  (let [sliced {}]
    (for [i (or first 1) (or last (length tbl)) (or step 1)]
      (tset sliced (+ (length sliced) 1) (. tbl i)))
    sliced))


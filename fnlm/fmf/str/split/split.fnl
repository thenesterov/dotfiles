(fn fmf-str-split [str sep]
  (icollect [sym (string.gmatch str (.. "[^" sep "]+"))]
    sym))


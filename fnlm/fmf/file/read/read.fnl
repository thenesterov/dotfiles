(fn fmf-file-read [path]
  (local file (io.open path :rb))
  (file:read "*all"))


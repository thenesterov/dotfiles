(fn fmf-file-write [path content parents]
  (let [parents (or parents false)
	path-parts $(fmf-str-split path "/")
	path-dir    (table.concat $(fmf-list-slice path-parts 1 (- (length path-parts) 1)) "/")]
    (when parents (os.execute (.. "mkdir -p " path-dir))))
    (local file (io.open path :w))
    (file:write content)
    (file:close))


(fn fmf-fqn-to-path [name include-source-file env]
  (let [name-parts $(fmf-str-split name "-")
        env (or env "")]
    (.. (table.concat name-parts "/") "/"
        (if include-source-file
            (.. $(fmf-list-last name-parts) (if (not= env "") (.. "." env) "") ".fnl") ""))))


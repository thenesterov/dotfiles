(fn save-module [module-name processed]
  (let [module-path (.. ".fnlm/" $(fmf-fqn-to-path module-name true))]
    $(fmf-file-write module-path processed true)))

;; fnlfmt: skip
(fn source-processor [source]
  (local states {:normal (fn [char]
			   (if (= char "$")  {:next :dollar :keep []}
			       (= char "\"") {:next :text   :keep [char]}
			       (= char ";")  {:next :note   :keep [char]}
			                     {:next :normal :keep [char]}))
	         :dollar (fn [char]
                           (if (= char "(")  {:next :name   :keep [char] :start-collect true}
			                     {:next :normal :keep ["$" char]}))
		 :name   (fn [char]
			   (if (= char " ")  {:next :normal :keep [char] :end-collect true}
			       (= char ".")  {:next :normal :keep [char] :end-collect true}
			       (= char ")")  {:next :normal :keep [char] :end-collect true}
			                     {:next :name   :keep [char]}))
		 :note   (fn [char]
			   (if (= char "\n") {:next :normal :keep [char]}
			                     {:next :note   :keep [char]}))
		 :text   (fn [char]
			   (if (= char "\"") {:next :normal :keep [char]}
			                     {:next :text   :keep [char]}))})

  (local buffer [])

  (local collected [])
  (var collected-buffer [])

  (var collecting false)

  (fn keep [char]
    (table.insert buffer char)
    (when collecting (table.insert collected-buffer char)))

  (var state :normal)
  (each [char (source:gmatch utf8.charpattern)]
    (let [action ((. states state) char)]
      (when (. action :end-collect)
	(set collecting false)
	(table.insert collected (table.concat collected-buffer))
	(set collected-buffer []))
      (each [_ to-keep (pairs (. action :keep))]
	(keep to-keep))
      (when (. action :start-collect) (set collecting true))
      (set state (. action :next))))

  (local requires [])
  (each [_ module (pairs collected)]
    (let [module-path       (string.gsub module "-" ".")
	  filename         $(fmf-list-last $(fmf-str-split module "-"))
	  require-path      (.. module-path "." filename)
	  generated-require (string.format "(local %s (require \"%s\"))" module require-path)]
      (table.insert requires generated-require)))

  (values collected (.. (table.concat requires "\n") "\n\n" (table.concat buffer ""))))

(fn bundle-module [module-name visited visiting]
  (local visited  (or visited  []))
  (local visiting (or visiting []))

  (local content $(fmf-file-read $(fmf-fqn-to-path module-name true)))
  (local (collected processed) (source-processor content))

  (each [_ module (pairs collected)]
    (when $(fmf-list-contains visiting module)
      (error (string.format "circular import: %s <=> %s" module module-name)))

    (table.insert visiting module)

    (bundle-module module visited visiting)

    $(fmf-list-remove.value visiting module))

  (table.insert visited module-name)
  (save-module module-name processed))

;; fnlfmt: skip
(let [command (. arg 1)]
  (if (= command "bundle")
        (let [module-name (. arg 2)
	      module-path $(fmf-fqn-to-path module-name true)
              command     "(cd .fnlm && fennel --compile --require-as-include %s) && rm -rf .fnlm"]
	  (do (bundle-module module-name)
	      (os.execute (string.format command module-path))))
      (= command "run")
        (let [module-name (. arg 2)
	      module-path $(fmf-fqn-to-path module-name true)
	      command     "(cd .fnlm && fennel %s) && rm -rf .fnlm"]
	  (do (bundle-module module-name)
	      (os.execute (string.format command module-path))))))


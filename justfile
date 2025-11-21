[private]
default:
	@just --list

[doc("Launch Emacs in a special environment")]
@emacs environment filepath='':
	cd environments/{{environment}} && \
	nix develop -i --command \
		env \
			TERM=$TERM \
			DISPLAY=$DISPLAY \
			XAUTHORITY=$XAUTHORITY \
			bash -c "emacs -l {{justfile_directory()}}/configs/.emacs {{filepath}}"

@fnlm *ARGS:
	cd fnlm && lua fmf/tool/tool.lua {{ARGS}}


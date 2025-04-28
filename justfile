[private]
default:
	@just --list

[doc("Launch Emacs in a special environment")]
emacs environment:
	cd environments/{{environment}} && \
	nix develop --command bash -c "emacs -q -l {{justfile_directory()}}/.emacs"


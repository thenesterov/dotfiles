{ pkgs }:

with pkgs; [
	(emacs.pkgs.withPackages (epkgs: with epkgs; [
		evil
		white-sand-theme
	]))
	fira-code
]


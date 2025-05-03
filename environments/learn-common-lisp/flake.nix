{
	inputs = {
		nixpkgs = {
			url = "github:nixos/nixpkgs";
		};
	};

	outputs = { self, nixpkgs } @ inputs:
		let 
			system = "x86_64-linux";
			pkgs = inputs.nixpkgs.legacyPackages.${system};
		in {
			devShells.${system}.default = pkgs.mkShell {
				packages = with pkgs; [
					(emacs.pkgs.withPackages (epkgs: with epkgs; [
						sly
						evil

						white-sand-theme
					]))

					emacs
					sbcl

					fira-code
				];
				shellHook = ''
					export LISP_PATH="${pkgs.sbcl}/bin/sbcl"
				'';
			};
		};
}


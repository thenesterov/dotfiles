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

			emacsPkgs = import ../emacs.nix { inherit pkgs; };
		in {
			devShells.${system}.default = pkgs.mkShell {
				packages = emacsPkgs ++ (with pkgs; [
					(emacs.pkgs.withPackages (epkgs: with epkgs; [
						sly
					]))

					sbcl
				]);
				shellHook = ''
					export LISP_PATH="${pkgs.sbcl}/bin/sbcl"
				'';
			};
		};
}


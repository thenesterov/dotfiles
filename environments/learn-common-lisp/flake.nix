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
					]))

					emacs
					sbcl
				];
			};
		};
}


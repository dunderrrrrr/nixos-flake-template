{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShell = pkgs.mkShell {
        name = "pythonenv";
        venvDir = "./.venv";
        buildInputs = with pkgs.python312Packages; [python venvShellHook];
        postVenvCreation = ''
          if [ -f requirements.txt ]; then
            pip install -r requirements.txt
          fi
        '';
        packages = [
          (pkgs.python312.withPackages (p: [
            p.flask
          ]))
          pkgs.nmap
        ];
      };
    });
}

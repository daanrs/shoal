{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };

        haskellPackages = pkgs.haskellPackages;

        rootDir = builtins.path { path = ./.; name = "nao";};
        haskellName = "hanao";
        pythonName = "pynao";
        futharkName = "futnao";

        pynaoProject = {
          projectDir = rootDir;
          overrides = pkgs.poetry2nix.overrides.withDefaults (
            self: super: {}
          );
        };

        pynao = pkgs.poetry2nix.mkPoetryApplication pynaoProject;
        pynaoEnv = pkgs.poetry2nix.mkPoetryEnv pynaoProject;

        hanao = returnShellEnv:
          haskellPackages.developPackage {
            inherit returnShellEnv;
            root = rootDir;
            name = haskellName;
            modifier = drv:
              pkgs.haskell.lib.addBuildTools drv
                (with pkgs.haskellPackages; pkgs.lib.lists.optionals returnShellEnv [
                  cabal-fmt
                  cabal-install
                  haskell-language-server
                  ormolu
                  pkgs.nixpkgs-fmt
                ]);
          };
        hanaoEnv = hanao true;
      in
      {
        packages.${haskellName} = hanao false;

        defaultPackage = self.packages.${system}.${haskellName};

        devShell = pkgs.mkShell {
          inputsFrom = [ pynaoEnv.env hanaoEnv ];
          buildInputs = [ pkgs.python39Packages.ipython ];
        };
      }
    );
}

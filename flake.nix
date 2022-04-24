{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };

        haskellPackages = pkgs.haskellPackages;
        pythonPackages = pkgs.python39Packages;
        poetry2nix = pkgs.poetry2nix;

        name = "shoal";
        rootDir = builtins.path { path = ./.; name = name; };

        pyshoalProject = {
          projectDir = rootDir;
          overrides = pkgs.poetry2nix.overrides.withDefaults (
            self: super: { }
          );
        };

        pyshoal = pkgs.poetry2nix.mkPoetryApplication pyshoalProject;
        pyshoalEnv = (pkgs.poetry2nix.mkPoetryEnv pyshoalProject).env.overrideAttrs (
          old: {
            buildInputs = (old.buildInputs or [ ]) ++ [
              pythonPackages.ipython
              pythonPackages.poetry
            ];
          }
        );

        shoalhs = returnShellEnv:
          haskellPackages.developPackage {
            inherit returnShellEnv name;
            root = rootDir;
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
        shoalhsEnv = shoalhs true;
      in
      {
        packages.${name} = shoalhs false;

        defaultPackage = self.packages.${system}.${name};

        devShell = pkgs.mkShell {
          inputsFrom = [ pyshoalEnv shoalhsEnv ];
        };
      }
    );
}

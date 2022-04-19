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

        rootDir = builtins.path { path = ./.; name = "nao"; };
        haskellName = "hanao";
        pythonName = "pynao";
        futharkName = "futnao";

        pynaoProject = {
          projectDir = rootDir;
          overrides = pkgs.poetry2nix.overrides.withDefaults (
            self: super: { }
          );
        };

        pynao = pkgs.poetry2nix.mkPoetryApplication pynaoProject;
        pynaoEnv = (pkgs.poetry2nix.mkPoetryEnv pynaoProject).env.overrideAttrs (
          old: {
            buildInputs = (old.buildInputs or [ ]) ++ [
              pythonPackages.ipython
              # pythonPackages.poetry
              pkgs.poetry
            ];
          }
        );

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
          inputsFrom = [ pynaoEnv hanaoEnv ];
        };
      }
    );
}

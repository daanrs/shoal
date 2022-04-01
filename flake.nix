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

        packageName = "hanao";

        project = returnShellEnv:
          haskellPackages.developPackage {
            inherit returnShellEnv;
            root = ./.;
            name = packageName;
            modifier = drv:
                pkgs.haskell.lib.addBuildTools drv
                  (with pkgs.haskellPackages; pkgs.lib.lists.optionals returnShellEnv [
                    # Specify your build/dev dependencies here.
                    cabal-fmt
                    cabal-install
                    ghcid
                    haskell-language-server
                    ormolu
                    pkgs.nixpkgs-fmt
                  ]);
          };
      in {
        packages.${packageName} = project false;

        defaultPackage = self.packages.${system}.${packageName};

        devShell = project true;
      });
}

{
  description = "my_description";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        rEnv = pkgs.rWrapper.override {
          packages = with pkgs.rPackages; [
            Rcpp
          ];
        };

        buildR = { stdenv, ... }: pkgs.rPackages.buildRPackage {
          name = "my_title";
          src = ./.;
          nativeBuildInputs = [ rEnv ];
        };

        packageName = "my_title";
      in
      {
        packages.${packageName} = buildR pkgs;

        defaultPackage = self.packages.${system}.${packageName};

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            # R
            rEnv

            # c++
            llvmPackages_latest.clang
          ];
        };
      });
}

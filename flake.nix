{
  inputs = {
    # Temporary until `haskell-updates` is merged. Move it back to `nixpkgs-unstable` once it is.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils/main";
    flake-compat = {
      url = "github:edolstra/flake-compat/master";
      flake = false;
    };
  };

  description =
    "process status display with automatic layout.";

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      overlay = se: su: {
        haskellPackages = su.haskellPackages.override {
          overrides =  hse: hsu: {
            "bloohm" = hse.callCabal2nix "bloohm" self { };
          };
        };
        bloohm = se.haskell.lib.justStaticExecutables se.haskellPackages.bloohm;
      };
    in {
      inherit overlay;
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
          config = { allowBroken = true; }; # THIS MAKES ME SAD
        };
      in {

        defaultPackage = pkgs.bloohm;
        devShell = pkgs.haskellPackages.shellFor {
          packages = p: [ p."bloohm" ];
          buildInputs = [
            pkgs.haskellPackages.haskell-language-server
            pkgs.haskellPackages.cabal-install
            pkgs.haskellPackages.ghcid
            pkgs.haskellPackages.ormolu
            pkgs.haskellPackages.hlint
            pkgs.nixpkgs-fmt
            pkgs.bash
          ];
          withHoogle = false;
        };
      });
}

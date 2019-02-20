let
  lib = nixpkgs.haskell.lib;
  config = {
    allowUnfree = true;
    packageOverrides = pkgs: rec {
      # llvm-config = nixpkgs.llvm_7;
      haskellPackages = pkgs.haskellPackages.override {
        overrides = haskellPackagesNew: haskellPackagesOld:
          let

            # Overrides from cabal2nix files
            derivationsOverrides = lib.packagesFromDirectory { directory = ./derivations; } haskellPackagesNew haskellPackagesOld;

            callInternal = name: path: args: haskellPackages.callCabal2nix name path args;
            internal = rec {
              exp-exp = callInternal "exp-exp" ../. { };
            };

          in
            derivationsOverrides // internal // {
              # Overrides from nixpkgs
              # accelerate = lib.dontCheck derivationsOverrides.accelerate;
              # llvm-hs = lib.dontCheck ( haskellPackagesOld.llvm-hs.override { llvm-config = nixpkgs.llvm_7; } );
              # llvm-hs-pure = lib.dontCheck derivationsOverrides.llvm-hs-pure;
            };
      };
    };
  };

  nixpkgs = import ((import <nixpkgs> {}).fetchFromGitHub {
      owner = "NixOS";
      repo  = "nixpkgs";
      inherit (builtins.fromJSON (builtins.readFile ./nixpkgs.json)) rev sha256;
    }) { inherit config; };

  self = rec {
    inherit nixpkgs;
    exp-exp-projects = {
      inherit (nixpkgs.haskellPackages)
        exp-exp
        ;
      };
    };
in self

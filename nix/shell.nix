let release = import ./release.nix;
    nixpkgs = release.nixpkgs;
in release.nixpkgs.haskellPackages.shellFor {
    nativeBuildInputs = with nixpkgs.haskellPackages; [
      cabal-install
    ];
    buildInputs = with nixpkgs; [
    ];
    packages = _: nixpkgs.lib.attrValues release.exp-exp-projects;
  }

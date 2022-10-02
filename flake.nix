{
  description = "yesod-static-remote";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    nixpkgs-22_05.url = "github:NixOS/nixpkgs?ref=nixos-22.05";
    nixpkgs-21_11.url = "github:NixOS/nixpkgs?ref=nixos-21.11";
    nixpkgs-21_05.url = "github:NixOS/nixpkgs?ref=nixos-21.05";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-22_05
    , nixpkgs-21_11
    , nixpkgs-21_05
    , flake-utils
    , pre-commit-hooks
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgsFor = nixpkgs: import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.${system}
        ];
      };
      pkgs = pkgsFor nixpkgs;
    in
    {
      overlays = final: prev:
        with final.haskell.lib;
        {
          haskellPackages =
            prev.haskellPackages.override (
              old:
              {
                overrides =
                  final.lib.composeExtensions (old.overrides or (_: _: { })) (
                    self: super: {
                      yesod-static-remote =
                        failOnAllWarnings (self.callPackage ./default.nix { });
                    }
                  );
              }
            );
        };

      packages.yesod-static-remote = pkgs.haskellPackages.yesod-static-remote;
      packages.default = self.packages.${system}.yesod-static-remote;
      checks =
        let
          backwardCompatibilityCheckFor = nixpkgs:
            let pkgs' = pkgsFor nixpkgs;
            in pkgs'.haskellPackages.yesod-static-remote;
          allNixpkgs = {
            inherit
              nixpkgs-22_05
              nixpkgs-21_11
              nixpkgs-21_05;
          };
          backwardCompatibilityChecks = pkgs.lib.mapAttrs (_: nixpkgs: backwardCompatibilityCheckFor nixpkgs) allNixpkgs;
        in
        backwardCompatibilityChecks // {
          pre-commit = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              hlint.enable = true;
              hpack.enable = true;
              ormolu.enable = true;
              nixpkgs-fmt.enable = true;
              nixpkgs-fmt.excludes = [ "default.nix" ];
              cabal2nix.enable = true;
            };
          };
        };
      devShells.default = pkgs.haskellPackages.shellFor {
        name = "yesod-static-remote-shell";
        packages = (p: with p; [
          yesod-static-remote
        ]);
        withHoogle = true;
        doBenchmark = true;
        buildInputs = with pkgs; [
          niv
          zlib
          cabal-install
        ] ++ (with pre-commit-hooks;
          [
            hlint
            hpack
            nixpkgs-fmt
            ormolu
            cabal2nix
          ]);
        shellHook = self.checks.${system}.pre-commit.shellHook;
      };
    });
}

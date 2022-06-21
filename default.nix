let
  pkgs = import ./nix/pkgs.nix { };
in
pkgs.haskellPackages.yesod-static-remote

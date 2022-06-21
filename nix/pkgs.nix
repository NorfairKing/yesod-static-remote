{ sources ? import ./sources.nix
, nixpkgs ? sources.nixpkgs
, system ? builtins.currentSystem
}:
import nixpkgs {
  overlays =
    [
      (final: previous: { inherit (import sources.gitignore { inherit (final) lib; }) gitignoreSource; })
      (import ./overlay.nix)
    ];
}

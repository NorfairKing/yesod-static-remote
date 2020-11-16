final: previous:
with final.haskell.lib;

{
  haskellPackages =
    previous.haskellPackages.override (
      old:
        {
          overrides =
            final.lib.composeExtensions (old.overrides or (_: _: {})) (
              self: super: {
                yesod-static-remote = disableLibraryProfiling (dontCheck (failOnAllWarnings (self.callCabal2nix "yesod-static-remote" (final.gitignoreSource ../.) {})));
              }
            );
        }
    );
}

{ mkDerivation, base, bytestring, directory, filepath, http-client
, http-client-tls, lib, template-haskell, yesod-static
}:
mkDerivation {
  pname = "yesod-static-remote";
  version = "0.0.0.1";
  src = ./.;
  libraryHaskellDepends = [
    base bytestring directory filepath http-client http-client-tls
    template-haskell yesod-static
  ];
  homepage = "https://github.com/NorfairKing/yesod-static-remote#readme";
  license = lib.licenses.mit;
}

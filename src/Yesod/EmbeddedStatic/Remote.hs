module Yesod.EmbeddedStatic.Remote
  ( embedRemoteFile,
    embedRemoteFileAt,
    ensureFile,
  )
where

import Control.Monad
import qualified Data.ByteString.Lazy as LB
import Language.Haskell.TH
import Network.HTTP.Client
import Network.HTTP.Client.TLS
import System.Directory
import System.FilePath
import Yesod.EmbeddedStatic
import Yesod.EmbeddedStatic.Types

-- | Embed a file after downloading it (once, and caching it locally)
embedRemoteFile ::
  -- | The path to put it (relative)
  FilePath ->
  -- | The url to download it from
  String ->
  Generator
embedRemoteFile fp url = do
  runIO $ ensureFile fp fp url
  embedFile fp

-- | Embed a file after downloading it (once, and caching it locally)
embedRemoteFileAt ::
  -- | The path to generate for it (for the yesod naming) (relative)
  String ->
  -- | The path to put it (relative)
  FilePath ->
  -- | The url to download it from
  String ->
  Generator
embedRemoteFileAt fp' fp url = do
  runIO $ ensureFile fp' fp url
  embedFileAt fp' fp

ensureFile :: String -> FilePath -> String -> IO ()
ensureFile rp' rp url = do
  createDirectoryIfMissing True $ takeDirectory rp
  exists <- doesFileExist rp
  unless exists $ do
    man <- newManager tlsManagerSettings
    putStrLn $ unwords ["Downloading", url, "to put it at", rp, "and embed it at", rp']
    req <- parseUrlThrow url
    resp <- httpLbs req man
    LB.writeFile rp $ responseBody resp

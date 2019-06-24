{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Yesod.EmbeddedStatic.Remote
  ( embedRemoteFileAt
  , ensureFile
  ) where

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
embedRemoteFileAt ::
     FilePath -- ^ The path to put it (relative)
  -> String -- ^ The url to download it from
  -> Generator
embedRemoteFileAt fp url = do
  runIO $ ensureFile fp url
  embedFile fp

ensureFile :: FilePath -> String -> IO ()
ensureFile rp url = do
  createDirectoryIfMissing True $ takeDirectory rp
  exists <- doesFileExist rp
  unless exists $ do
    man <- newManager tlsManagerSettings
    putStrLn $ unwords ["Downloading", url, "to put it at", rp]
    req <- parseUrlThrow url
    resp <- httpLbs req man
    LB.writeFile rp $ responseBody resp

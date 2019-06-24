{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Yesod.EmbeddedStatic.Remote
  ( embedRemoteFileAt
  , ensureFile
  ) where

import Control.Monad
import qualified Data.ByteString as SB
import Language.Haskell.TH
import Network.Download
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
  embedFileAt fp url

ensureFile :: FilePath -> String -> IO ()
ensureFile rp url = do
  createDirectoryIfMissing True $ takeDirectory rp
  exists <- doesFileExist rp
  unless exists $ do
    putStrLn $ unwords ["Downloading", url, "to put it at", rp]
    errOrBs <- openURI url
    case errOrBs of
      Left err -> fail $ unwords ["Failed to download ", url, "with error", err]
      Right bs -> SB.writeFile rp bs

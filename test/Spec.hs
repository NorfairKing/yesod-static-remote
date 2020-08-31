{-# LANGUAGE TemplateHaskell #-}

module Main where

import Yesod.EmbeddedStatic
import Yesod.EmbeddedStatic.Remote

mkEmbeddedStatic
  False
  "myStatic"
  [ embedRemoteFile
      "tmp/test/deep/README.md"
      "https://raw.githubusercontent.com/NorfairKing/yesod-static-remote/master/README.md",
    embedRemoteFileAt
      "tmp/dir/for/storage/deep/README.md"
      "tmp/test/deep/README.md"
      "https://raw.githubusercontent.com/NorfairKing/yesod-static-remote/master/README.md"
  ]

main :: IO ()
main = pure ()

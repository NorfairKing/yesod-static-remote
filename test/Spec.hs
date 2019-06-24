{-# LANGUAGE TemplateHaskell #-}

module Main where

import Yesod.EmbeddedStatic
import Yesod.EmbeddedStatic.Remote

mkEmbeddedStatic
  False
  "myStatic"
  [ embedRemoteFileAt
      "tmp/test/deep/README.md"
      "https://raw.githubusercontent.com/NorfairKing/yesod-static-remote/master/README.md"
  ]

main :: IO ()
main = pure ()

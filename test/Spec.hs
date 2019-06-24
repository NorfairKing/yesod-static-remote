{-# LANGUAGE TemplateHaskell #-}

module Main where

import Yesod.EmbeddedStatic
import Yesod.EmbeddedStatic.Remote

mkEmbeddedStatic
  False
  "myStatic"
  [ embedRemoteFileAt "test/deep/README.md"
   "https://github.com/NorfairKing/yesod-static-remote/blob/master/README.md"
  ]

main :: IO ()
main = pure ()

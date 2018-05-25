{-# LANGUAGE OverloadedStrings #-}

module Lib where

import Control.Lens (to, only, (^?), ix, toListOf)
import Data.ByteString.Lazy (ByteString)
import Data.Text (Text)
import qualified Data.Text as T
import Data.Text.Encoding.Error (lenientDecode)
import Data.Text.Lazy.Encoding (decodeUtf8With)
import Network.HTTP.Client (Response)
import Network.Wreq (responseBody, get)
import Text.Taggy (Node)
import Text.Taggy.Lens (html, elements, children, contents,allNamed)

texts :: Response ByteString -> [Text]
texts = toListOf
  $ responseBody . to (decodeUtf8With lenientDecode)
  . html . allNamed (only "tr") . children
  . to (toListOf $ ix 0 . contents)
  . to T.concat

main :: IO ()
main = get "https://matonix.github.io/taggy-lens-sample/sample.html"
  >>= print <$> texts

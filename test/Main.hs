{-# LANGUAGE TemplateHaskell #-}

module Main where

import Bloohm
import Hedgehog
import Hedgehog.Main

prop_test :: Property
prop_test = property $ do
  doBloohm === "Bloohm"

main :: IO ()
main = defaultMain [checkParallel $$(discover)]

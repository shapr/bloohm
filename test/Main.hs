{-# LANGUAGE TemplateHaskell #-}

module Main where

import Hedgehog
import Hedgehog.Main
import Bloohm

prop_test :: Property
prop_test = property $ do
  doBloohm === "Bloohm"

main :: IO ()
main = defaultMain [checkParallel $$(discover)]

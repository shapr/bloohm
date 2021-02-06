module Main where

import Bloohm
import System.Environment (getArgs)

main = do
  args <- getArgs
  print $ findPos $ concat args

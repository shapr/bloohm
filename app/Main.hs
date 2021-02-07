{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Bloohm (findPos)
import qualified Data.ByteString.Char8 as B
import ReadArgs (readArgs)
import System.Environment (getArgs)
import System.Hardware.Serialport
  ( CommSpeed (CS115200),
    SerialPortSettings (commSpeed),
    closeSerial,
    defaultSerialSettings,
    openSerial,
    send,
  )
import System.IO ()

main = do
  (serialPort, color :: Color, dir, cmdline) <- readArgs
  let indices = findPos $ dir <> cmdline
      c = B.pack $ show color
      combined = (c <>) <$> (B.pack . show <$> indices) -- 1,13 -> r1,r13
      total = B.intercalate "," combined
  s <- openSerial serialPort $ defaultSerialSettings {commSpeed = CS115200}
  print $ "sending " <> total <> " to " <> B.pack serialPort
  send s total
  closeSerial s

data Color = Red | Green | Blue | Yellow deriving (Read, Eq, Ord)

instance Show Color where
  show = \case
    Red -> "r"
    Green -> "g"
    Blue -> "b"
    Yellow -> "y"

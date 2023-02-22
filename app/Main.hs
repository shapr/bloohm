{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Bloohm (findPos)
import qualified Data.ByteString.Char8 as B
import Data.List ( intercalate )
import ReadArgs (readArgs)
import System.Environment (getArgs)
import System.Hardware.Serialport
    ( hOpenSerial,
      defaultSerialSettings,
      CommSpeed(CS115200),
      SerialPortSettings(commSpeed) )
import System.IO ( hClose, hPutStr )

main = do
  (serialPort, color :: Color, dir, cmdline) <- readArgs
  let indices = findPos $ dir <> cmdline
      c = show color
      combined = (c <>) <$> (show <$> indices) -- 1,13 -> r1,r13
      total = intercalate "," combined
  h <- hOpenSerial serialPort $ defaultSerialSettings {commSpeed = CS115200}
  -- print $ "sending " <> total <> " to " <> serialPort
  hPutStr h (total <> "\r") -- circuit python wants
  hClose h

data Color = Red | Green | Blue | Yellow deriving (Read, Eq, Ord)

instance Show Color where
  show = \case
    Red -> "r"
    Green -> "g"
    Blue -> "b"
    Yellow -> "y"

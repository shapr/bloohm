module Bloohm where

import Crypto.Hash (hashWith)
import Crypto.Hash.Algorithms
import Data.Bits
import qualified Data.ByteArray.Encoding as B (Base (..), convertToBase)
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import Data.List (foldl')
import Data.Word (Word8)

doBloohm :: String
doBloohm = "Bloohm"

runhashMD2 :: ByteString -> ByteString
runhashMD2 v = B.convertToBase B.Base16 $ hashWith MD2 v

runhashMD4 :: ByteString -> ByteString
runhashMD4 v = B.convertToBase B.Base16 $ hashWith MD4 v

runhashMD5 :: ByteString -> ByteString
runhashMD5 v = B.convertToBase B.Base16 $ hashWith MD5 v

runhashTiger :: ByteString -> ByteString
runhashTiger v = B.convertToBase B.Base16 $ hashWith Tiger v

roll :: [Word8] -> Integer
roll = foldr unstep 0
  where
    unstep b a = a `shiftL` 8 .|. fromIntegral b

roll' :: [Word8] -> Integer
roll' = foldl' unstep 0
  where
    unstep a b = a `shiftL` 8 .|. fromIntegral b

giveMeNumber :: ByteString -> Integer
giveMeNumber bs = roll $ BS.unpack bs

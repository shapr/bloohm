module Bloohm where

import Crypto.Hash (hashWith)
import Crypto.Hash.Algorithms
import Data.Bits
import qualified Data.ByteArray.Encoding as B (Base (..), convertToBase)
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as BS8
import Data.List (foldl', sort)
import Data.Word (Word8)

findPos :: String -> [Integer]
findPos s = findBits $ BS8.pack s

findBits :: ByteString -> [Integer]
findBits bs = sort $ hashMod <$> hashFuncs
  where
    hashMod f = giveMeNumber (f bs) `mod` 32

hashFuncs :: [ByteString -> ByteString]
hashFuncs = [runhashMD4, runhashTiger, runhashMD5]

giveMeNumber :: ByteString -> Integer
giveMeNumber bs = roll $ BS.unpack bs

roll :: [Word8] -> Integer
roll = foldr unstep 0
  where
    unstep b a = a `shiftL` 8 .|. fromIntegral b

roll' :: [Word8] -> Integer
roll' = foldl' unstep 0
  where
    unstep a b = a `shiftL` 8 .|. fromIntegral b

runhashMD2 :: ByteString -> ByteString
runhashMD2 v = B.convertToBase B.Base16 $ hashWith MD2 v

runhashMD4 :: ByteString -> ByteString
runhashMD4 v = B.convertToBase B.Base16 $ hashWith MD4 v

runhashMD5 :: ByteString -> ByteString
runhashMD5 v = B.convertToBase B.Base16 $ hashWith MD5 v

runhashTiger :: ByteString -> ByteString
runhashTiger v = B.convertToBase B.Base16 $ hashWith Tiger v

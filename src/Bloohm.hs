module Bloohm where

import Crypto.Hash (hashWith)
import Crypto.Hash.Algorithms ( MD5(MD5) )
import Data.Bits ( Bits((.|.), shiftL) )
import qualified Data.ByteArray.Encoding as B (Base (..), convertToBase)
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as BS8
import Data.List (sort)
import Data.Word (Word8)

doBloohm :: String
doBloohm = "Bloohm"

findPos :: String -> [Integer]
findPos s = findBits $ BS8.pack s

findBits :: ByteString -> [Integer]
findBits bs = sort $ [int1, int2, int3]
    where wz = BS.unpack $ runhashMD5 bs
          wzLength = length wz
          wzThird = wzLength `div` 3
          multipleOfThree = drop (wzLength `mod` 3) wz
          tmWz = tritMod wzThird
          (int1,ws) = tmWz multipleOfThree
          (int2,ws') = tmWz ws
          (int3,_) = tmWz ws'

tritMod :: Int -> [Word8] -> (Integer,[Word8])
tritMod _ [] = error "tritMod got empty list"
tritMod n ws = (roll (take n ws) `mod` 32, drop n ws)

roll :: [Word8] -> Integer
roll = foldr unstep 0
  where
    unstep b a = a `shiftL` 8 .|. fromIntegral b

runhashMD5 :: ByteString -> ByteString
runhashMD5 v = B.convertToBase B.Base16 $ hashWith MD5 v

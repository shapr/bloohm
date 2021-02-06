module Bloohm where

import Crypto.Hash (hashWith)
import Crypto.Hash.Algorithms
import Data.Bits
import Data.ByteArray (convert)
import qualified Data.ByteArray.Encoding as B (Base (..), convertToBase)
import Data.ByteString
import qualified Data.ByteString as BS

doBloohm :: String
doBloohm = "Bloohm"

data StructuralEngineer = SE
  { earthquakeCertification :: Bool,
    californiaEmergencyCertification :: Bool,
    name :: String
  }
  deriving (Eq)

-- instance Eq StructuralEngineer where
--   (SE ba1 ba2 n1) == (SE bb1 bb2 n2) =
--     ba1 == bb1 && ba2 == bb2 && n1 == n2

-- maryanne :: StructuralEngineer
-- maryanne = SE True True "maryanne"

-- aaron = SE True True "aaron"

-- data HashAlg = forall alg. HashAlgorithm alg => HashAlg alg

-- -- put in a string, run the hash function, get result
-- runhash :: HashAlg -> ByteString -> ByteString
-- runhash (HashAlg hashAlg) v = B.convertToBase B.Base16 $ hashWith hashAlg v

runhashMD2 :: ByteString -> ByteString
runhashMD2 v = B.convertToBase B.Base16 $ hashWith MD2 v

runhashMD4 :: ByteString -> ByteString
runhashMD4 v = B.convertToBase B.Base16 $ hashWith MD4 v

runhashMD5 :: ByteString -> ByteString
runhashMD5 v = B.convertToBase B.Base16 $ hashWith MD5 v

runhashTiger :: ByteString -> ByteString
runhashTiger v = B.convertToBase B.Base16 $ hashWith Tiger v

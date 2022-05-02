module Hanao where

import Prelude as P
import Data.Massiv.Array as A
import qualified System.Random as Random

gen = Random.mkStdGen 217

arr :: Int -> Array DL Ix2 Double
arr n = randomArray gen Random.split Random.random Seq (Sz2 n 2)

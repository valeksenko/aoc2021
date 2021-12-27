{-
Solve using https://github.com/LeventErkok/sbv

Had to manually parse the input to define the rules based on the `x` value

inp w
mul x 0
add x z
mod x 26
div z 1
add x 13
eql x w
eql x 0 | x = 1
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 5
mul y x
add z y | z = 6..14 -- x1 + 5

inp w
mul x 0
add x z
mod x 26
div z 1
add x 15
eql x w
eql x 0 | x = 1
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 14
mul y x
add z y | z = (6*26+15)..(14*26+23) -- ((x1 + 5) * 26 + x2 + 14)


inp w | 
mul x 0
add x z
mod x 26
div z 1
add x 15
eql x w
eql x 0 | x = 1
mul y 0
add y 25
mul y x 
add y 1 
mul z y
mul y 0
add y w
add y 15
mul y x
add z y | z = ((6*26+15) * 26 + 16) ..((14*26+23) * 26 + 24) -- (((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15)

inp w
mul x 0
add x z
mod x 26
div z 1
add x 11
eql x w
eql x 0 | x = 1
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 16
mul y x
add z y  | z = ((((6*26+15) * 26 + 16) * 26) + 17) ..((((14*26+23) * 26 + 24) * 26) + 25) -- ((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)

inp w
mul x 0
add x z
mod x 26
div z 26 
add x -16
eql x w 
eql x 0 | x = 1
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 8
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26 
add x -11
eql x w 
eql x 0 | x = 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 9
mul y x
add z y

inp w
mul x 0
add x z
mod x 26
div z 26
add x -6
eql x w 
eql x 0 | x = 0
mul y 0
add y 25
mul y x
add y 1 
mul z y
mul y 0
add y w
add y 2
mul y x
add z y

inp w
mul x 0
add x z
mod x 26
div z 1
add x 11
eql x w
eql x 0 | x = 1
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 13
mul y x
add z y

inp w
mul x 0
add x z
mod x 26
div z 1
add x 10
eql x w
eql x 0 | x = 1
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 16
mul y x
add z y

inp w
mul x 0
add x z
mod x 26
div z 26
add x -10
eql x w
eql x 0 | x = 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 6
mul y x
add z y

inp w
mul x 0
add x z
mod x 26
div z 26
add x -8
eql x w  
eql x 0 | x = 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 6
mul y x
add z y

inp w | <<-- z=12..20
mul x 0
add x z
mod x 26
div z 26 | z < 26
add x -11
eql x w | x = 0 -> ^z = (? + 11 + w)
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 9
mul y x 
add z y

inp w 
mul x 0
add x z
mod x 26
div z 1
add x 12
eql x w 
eql x 0 x = 1
mul y 0
add y 25
mul y x 
add y 1
mul z y | -> ^z = 0
mul y 0
add y w
add y 11
mul y x
add z y | z = w + 11

inp w | z=16..24, z - 15 = w
mul x 0
add x z
mod x 26 *x=26 * ? + 15
div z 26 *z<26, z=16..24
add x -15 *x=16..24, w=x
eql x w
eql x 0 | x = 0
mul y 0
add y 25
mul y x
add y 1
mul z y *z=0
mul y 0
add y w
add y 5
mul y x *x=0
add z y *z=0, y=0
-}

{-# LANGUAGE ScopedTypeVariables  #-}

module Part1 (
    solveProblem
) where

import Debug.Trace
import Data.Bifunctor
import qualified Data.Map.Strict as Map
import Data.SBV
import Data.SBV.Tuple

solveProblem = do
    LexicographicResult model <- optimize Lexicographic $ problem
    putStr $ showResult $ getModelDictionary model
    return ()

showResult :: Show v => Map.Map String v -> String
showResult m =
  foldr toStr "" (Map.toList m)
  where toStr (k,v) s = k <> " = " <> show v <> "\n" <> s

-- maximize manually one at a time, there might be a better way
problem :: Goal
problem = do
        x1 <- sInteger "X1"
        -- constrain $ x1 .> 0
        -- constrain $ x1 .< 10
        constrain $ x1 .== 9

        x2 <- sInteger "X2"
        -- constrain $ x2 .> 0
        -- constrain $ x2 .< 10
        constrain $ x2 .== 1

        x3 <- sInteger "X3"
        -- constrain $ x3 .> 0
        -- constrain $ x3 .< 10
        constrain $ x3 .== 5

        x4 <- sInteger "X4"
        -- constrain $ x4 .> 0
        -- constrain $ x4 .< 10
        constrain $ x4 .== 9

        x5 <- sInteger "X5"
        -- constrain $ x5 .> 0
        -- constrain $ x5 .< 10
        constrain $ x5 .== 9

        constrain $ ((((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)) `sMod` 26) .== (16 + x5)

        x6 <- sInteger "X6"
        -- constrain $ x6 .> 0
        -- constrain $ x6 .< 10
        constrain $ x6 .== 9

        constrain $ (((((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)) `sDiv` 26) `sMod` 26) .== (11 + x6)

        x7 <- sInteger "X7"
        -- constrain $ x7 .> 0
        -- constrain $ x7 .< 10
        constrain $ x7 .== 9

        constrain $ ((((((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)) `sDiv` 26) `sDiv` 26) `sMod` 26) .== (6 + x7)

        x8 <- sInteger "X8"
        -- constrain $ x8 .> 0
        -- constrain $ x8 .< 10
        constrain $ x8 .== 4

        x9 <- sInteger "X9"
        -- constrain $ x9 .> 0
        -- constrain $ x9 .< 10
        constrain $ x9 .== 3

        x10 <- sInteger "X10"
        -- constrain $ x10 .> 0
        -- constrain $ x10 .< 10
        constrain $ x10 .== 9

        constrain $ (((((((((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)) `sDiv` 26) `sDiv` 26) `sDiv` 26) * 26 + x8 + 13) * 26 + x9 + 16) `sMod` 26) .== (10 + x10)

        x11 <- sInteger "X11"
        -- constrain $ x11 .> 0
        -- constrain $ x11 .< 10
        constrain $ x11 .== 9

        constrain $ ((((((((((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)) `sDiv` 26) `sDiv` 26) `sDiv` 26) * 26 + x8 + 13) * 26 + x9 + 16) `sDiv` 26) `sMod` 26) .== (8 + x11)

        x12 <- sInteger "X12"
        constrain $ x12 .> 0
        constrain $ x12 .< 10

        constrain $ (((((((((((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)) `sDiv` 26) `sDiv` 26) `sDiv` 26) * 26 + x8 + 13) * 26 + x9 + 16) `sDiv` 26) `sDiv` 26) `sMod` 26) .== (11 + x12)
        constrain $ (((((((((((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)) `sDiv` 26) `sDiv` 26) `sDiv` 26) * 26 + x8 + 13) * 26 + x9 + 16) `sDiv` 26) `sDiv` 26) `sDiv` 26) .== 0

        -- maximize "max_x1" x1
        -- maximize "max_x2" x2
        -- maximize "max_x3" x3
        -- maximize "max_x4" x4
        -- maximize "max_x5" x5
        -- maximize "max_x6" x6
        -- maximize "max_x7" x7
        -- maximize "max_x8" x8
        -- maximize "max_x9" x9
        -- maximize "max_x10" x10
        -- maximize "max_x11" x11
        maximize "max_x12" x12

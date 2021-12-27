{-# LANGUAGE ScopedTypeVariables  #-}

module D13P2 (
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

-- minimize manually one at a time, there might be a better way
problem :: Goal
problem = do
        x1 <- sInteger "X1"
        constrain $ x1 .> 0
        constrain $ x1 .< 10
        constrain $ x1 .== 7

        x2 <- sInteger "X2"
        constrain $ x2 .> 0
        constrain $ x2 .< 10
        constrain $ x2 .== 1

        x3 <- sInteger "X3"
        constrain $ x3 .> 0
        constrain $ x3 .< 10
        constrain $ x3 .== 1

        x4 <- sInteger "X4"
        constrain $ x4 .> 0
        constrain $ x4 .< 10
        constrain $ x4 .== 1

        x5 <- sInteger "X5"
        constrain $ x5 .> 0
        constrain $ x5 .< 10
        constrain $ x5 .== 1

        constrain $ ((((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)) `sMod` 26) .== (16 + x5)

        x6 <- sInteger "X6"
        constrain $ x6 .> 0
        constrain $ x6 .< 10
        constrain $ x6 .== 5

        constrain $ (((((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)) `sDiv` 26) `sMod` 26) .== (11 + x6)

        x7 <- sInteger "X7"
        constrain $ x7 .> 0
        constrain $ x7 .< 10
        constrain $ x7 .== 9

        constrain $ ((((((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)) `sDiv` 26) `sDiv` 26) `sMod` 26) .== (6 + x7)

        x8 <- sInteger "X8"
        constrain $ x8 .> 0
        constrain $ x8 .< 10
        constrain $ x8 .== 1

        x9 <- sInteger "X9"
        constrain $ x9 .> 0
        constrain $ x9 .< 10
        constrain $ x9 .== 1

        x10 <- sInteger "X10"
        constrain $ x10 .> 0
        constrain $ x10 .< 10
        constrain $ x10 .== 7

        constrain $ (((((((((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)) `sDiv` 26) `sDiv` 26) `sDiv` 26) * 26 + x8 + 13) * 26 + x9 + 16) `sMod` 26) .== (10 + x10)

        x11 <- sInteger "X11"
        constrain $ x11 .> 0
        constrain $ x11 .< 10
        constrain $ x11 .== 6

        constrain $ ((((((((((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)) `sDiv` 26) `sDiv` 26) `sDiv` 26) * 26 + x8 + 13) * 26 + x9 + 16) `sDiv` 26) `sMod` 26) .== (8 + x11)

        x12 <- sInteger "X12"
        constrain $ x12 .> 0
        constrain $ x12 .< 10

        constrain $ (((((((((((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)) `sDiv` 26) `sDiv` 26) `sDiv` 26) * 26 + x8 + 13) * 26 + x9 + 16) `sDiv` 26) `sDiv` 26) `sMod` 26) .== (11 + x12)
        constrain $ (((((((((((((x1 + 5) * 26 + x2 + 14) * 26 + x3 + 15) * 26 + x4 + 16)) `sDiv` 26) `sDiv` 26) `sDiv` 26) * 26 + x8 + 13) * 26 + x9 + 16) `sDiv` 26) `sDiv` 26) `sDiv` 26) .== 0

        -- minimize "min_x1" x1
        -- minimize "min_x2" x2
        -- minimize "min_x3" x3
        -- minimize "min_x4" x4
        -- minimize "min_x5" x5
        -- minimize "min_x6" x6
        -- minimize "min_x7" x7
        -- minimize "min_x8" x8
        -- minimize "min_x9" x9
        -- minimize "min_x10" x10
        -- minimize "min_x11" x11
        minimize "min_x12" x12

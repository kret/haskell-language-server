{-# LANGUAGE OverloadedStrings #-}


{-# OPTIONS_GHC -Wall #-}



{-# LANGUAGE TupleSections #-}




class Semigroup a => SomeData a
instance SomeData All

#! nix-shell --pure -i runghc -p "haskellPackages.ghcWithPackages (hp: with hp; [ turtle ])"
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
import Data.Monoid

addOne :: Int -> Int
addOne x = x + 1

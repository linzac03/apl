{-# OPTIONS_GHC -Wall #-}
module HW06 where

import Data.List
import Data.Functor

-- Exercise 1 -----------------------------------------

fib :: Integer -> Integer
fib 0 = 1
fib 1 = 1
fib n = fib (n-1) + fib (n-2)

fibs1 :: [Integer]
fibs1 = fmap fib [0..]

-- Exercise 2 -----------------------------------------

fibs2 :: [Integer]
fibs2 = 1:1:zipWith (+) fibs2 (tail fibs2)

-- Exercise 3 -----------------------------------------

data Stream a = Cons a (Stream a)

-- Show instance prints the first 20 elements followed by ellipsis
instance Show a => Show (Stream a) where
    show s = "[" ++ intercalate ", " (map show $ take 10 $ streamToList s)
             ++ ",..."

streamToList :: Stream a -> [a]
streamToList (Cons n (ns)) = n:streamToList ns

-- Exercise 4 -----------------------------------------

instance Functor Stream where
    fmap = mapStream where
		mapStream f (Cons c (cs)) = Cons (f c) (mapStream f cs) 

-- Exercise 5 -----------------------------------------

sRepeat :: a -> Stream a
sRepeat n = Cons n (sRepeat n)

sIterate :: (a -> a) -> a -> Stream a
sIterate f n = Cons n (sIterate f (f n))

sInterleave :: Stream a -> Stream a -> Stream a
sInterleave (Cons x (xs)) ys = Cons x (Cons (head ys) (sInterleave xs (tail ys)))
	where
		head (Cons m (_)) = m
		tail (Cons _ (ms)) = ms

sTake :: Int -> Stream a -> [a]
sTake n str = take n $ streamToList str

-- Exercise 6 -----------------------------------------

nats :: Stream Integer
nats = sIterate (+1) 0

ruler :: Stream Integer
ruler = undefined

-- Exercise 7 -----------------------------------------
-- I keep getting a stack overflow from the recursion not sure I have enough memory 
-- | Implementation of C rand
rand :: Int -> Stream Int
rand n = sIterate fn n
	where
		fn 1 = (1103515245 + 12345) `mod` 2147483648
		fn m = (1103515245 * (fn (m-1)) + 12345) `mod` 2147483648 

-- Exercise 8 -----------------------------------------

{- Total Memory in use: ??? MB -}
minMaxSlow :: [Int] -> Maybe (Int, Int)
minMaxSlow [] = Nothing   -- no min or max if there are no elements
minMaxSlow xs = Just (minimum xs, maximum xs)

minmax_test :: Maybe (Int, Int)
minmax_test = minMaxSlow $ sTake 1000 $ rand 1

-- Exercise 9 -----------------------------------------

{- Total Memory in use: ??? MB -}
minMax :: [Int] -> Maybe (Int, Int)
minMax = undefined

main :: IO ()
main = print $ minMaxSlow $ sTake 1000000 $ rand 7666532

-- Exercise 10 ----------------------------------------

fastFib :: Int -> Integer
fastFib = undefined

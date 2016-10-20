{-# OPTIONS_GHC -Wall #-}
module HW01 where

-- Exercise 1 -----------------------------------------

-- Get the last digit from a number
lastDigit :: Integer -> Integer
lastDigit = (`mod` 10)  

-- Drop the last digit from a number
dropLastDigit :: Integer -> Integer
dropLastDigit = (\ n -> (n - (lastDigit n)) `div` 10)

-- Exercise 2 -----------------------------------------

toRevDigits :: Integer -> [Integer]
toRevDigits n
	| n == 0 = []
	| otherwise = (lastDigit n) : toRevDigits (dropLastDigit n)

-- Exercise 3 -----------------------------------------

-- Double every second number in a list starting on the left.
doubleEveryOther :: [Integer] -> [Integer]
doubleEveryOther = doubleEveryOther' 1
	where 
		doubleEveryOther' _ [] = []
		doubleEveryOther' n (x : xs)
			| n `mod` 2 == 0 	= x*2 : doubleEveryOther' (n+1) xs
			| otherwise 		= x : doubleEveryOther' (n+1) xs

-- Exercise 4 -----------------------------------------

-- Calculate the sum of all the digits in every Integer.
sumDigits :: [Integer] -> Integer
sumDigits = foldr breakdown 0
	where 
		breakdown n acc 
			| n >= 10	= lastDigit n + dropLastDigit n + acc
			| otherwise = n + acc 


-- Exercise 5 -----------------------------------------

-- Validate a credit card number using the above functions.
luhn :: Integer -> Bool
luhn = (==0)  . lastDigit . sumDigits . doubleEveryOther . toRevDigits 

-- Exercise 6 -----------------------------------------

-- Towers of Hanoi for three pegs
type Peg = String
type Move = (Peg, Peg)

hanoi :: Integer -> Peg -> Peg -> Peg -> [Move]
hanoi = undefined

{-# OPTIONS_GHC -Wall #-}
module HW02 where

-- Mastermind -----------------------------------------

-- A peg can be one of six colors
data Peg = Red | Green | Blue | Yellow | Orange | Purple
         deriving (Show, Eq, Ord)

-- A code is defined to simply be a list of Pegs
type Code = [Peg]

-- A move is constructed using a Code and two integers; the number of
-- exact matches and the number of regular matches
data Move = Move Code Int Int
          deriving (Show, Eq)

-- List containing all of the different Pegs
colors :: Code
colors = [Red, Green, Blue, Yellow, Orange, Purple]

-- Exercise 1 -----------------------------------------

-- Get the number of exact matches between the actual code and the guess
exactMatches :: Code -> Code -> Int
exactMatches xs ys = count $ zipWith (==) xs ys
	where
		count = foldr (\ n m -> if n then 1+m else m) 0

-- Exercise 2 -----------------------------------------

-- For each peg in xs, count how many times is occurs in ys
countColors :: Code -> [Int]
countColors xs =  countColors' colors xs [] 
	where
		countColors' [] _ out = out 
		countColors' (y:ys) xss out = 
			countColors' ys xss (out ++ [length $ filter (==y) xss])

-- Count number of matches between the actual code and the guess
matches :: Code -> Code -> Int
matches c1 c2 = sum $ zipWith (\n m -> if n > m then m else n) (countColors c1) (countColors c2)

-- Exercise 3 -----------------------------------------

-- Construct a Move from a guess given the actual code
getMove :: Code -> Code -> Move
getMove xs ys = Move ys (em) (ms - em)
	where
		em = exactMatches xs ys
		ms = matches xs ys

-- Exercise 4 -----------------------------------------

isConsistent :: Move -> Code -> Bool
isConsistent (Move gs em ms) cs = em == exactMatches cs gs 
									&& ms == (matches cs gs) - (exactMatches cs gs)

-- Exercise 5 -----------------------------------------

filterCodes :: Move -> [Code] -> [Code]
filterCodes _ [] = [] 
filterCodes m (c:cs) 
	| isConsistent m c	= c : filterCodes m cs
	| otherwise = filterCodes m cs
 

-- Exercise 6 -----------------------------------------

allCodes :: Int -> [Code]
allCodes n = code n colors [] 

code :: Int -> Code -> [Code] -> [Code]
code 0 _ os = os
code m cols [] = code (m-1) cols (ini cols)
code m cols os = code (m-1) cols (expand os cols)
	where
		expand [] _ = []
		expand (o:oss) cs = (fmap (:o) cs) ++ expand oss cs
		 

ini :: Code -> [Code]
ini [] = []
ini (c:cs) = [c] : ini cs
		
-- Exercise 7 -----------------------------------------

solve :: Code -> [Move]
solve c = solver c (allCodes (length c)) []
	where
		solver _ [] ms = ms
		solver c' (x:xs) ms = if x /= c' then solver c' (filterCodes move xs) (ms++[move]) else (ms++[move])
			where 
				move = getMove c' x

-- Bonus ----------------------------------------------

fiveGuess :: Code -> [Move]
fiveGuess = undefined

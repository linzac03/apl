{-# OPTIONS_GHC -Wall #-}
module HW04 where

newtype Poly a = P [a]

-- Exercise 1 -----------------------------------------

x :: Num a => Poly a
x = P [1]  

-- Exercise 2 ----------------------------------------

instance (Num a, Eq a) => Eq (Poly a) where
    (==) (P xs) (P ys) = and $ zipWith (==) xs ys
 
-- Exercise 3 -----------------------------------------

instance (Num a, Eq a, Show a, Ord a) => Show (Poly a) where
	show (P []) = ""
	show (P (y:ys)) 
		| (abs y) == 1 && (length ys) > 1 	= "x^" ++ show (length ys) ++ " + " ++ show (P ys)
		| (abs y) == 1 && (length ys) == 1	= "x" ++ " + " ++ show (P ys)
		| (abs y) > 0 && (length ys) > 1		= show y ++ "x^" ++ show (length ys) ++ " + " ++ show (P ys)
		| (abs y) > 0 && (length ys) == 1 	= show y ++ "x" ++ " + " ++ show (P ys)
		| (abs y) > 0 && (length ys) == 0		= show y
		| otherwise							= show (P ys)

-- Exercise 4 -----------------------------------------

plus :: Num a => Poly a -> Poly a -> Poly a
plus (P xs) (P ys)
	| length xs > length ys	= plus (P xs) (P $ 0:ys)
	| length xs < length ys = plus (P $ 0:xs) (P ys)	
	| otherwise			    = P $ (zipWith (+) xs ys) 

-- Exercise 5 -----------------------------------------

times :: Num a => Poly a -> Poly a -> Poly a
times (P []) (P ss) = plus (P []) (P ss)
times (P (f:fs)) (P ss) = foldr plus (P []) (timesHelp (P (f:fs)) (P ss))
	where
		timesHelp (P []) _ 	   		   = []
		timesHelp (P (f':fs')) (P ss') = [P (fmap (*f') ss')] ++ (timesHelp (P fs') (P $ ss'++[0])) 

-- Exercise 6 -----------------------------------------

instance Num a => Num (Poly a) where
    (+) = plus
    (*) = times
    negate (P ks)   = P $ fmap (\ n -> n - 2*n) ks 
    fromInteger n   = P [fromIntegral n] 
    -- No meaningful definitions exist
    abs    = undefined
    signum = undefined

-- Exercise 7 -----------------------------------------

applyP :: Num a => Poly a -> a -> a
applyP (P []) _		= 0
applyP (P (n:ns)) m = n*m^(length ns) + applyP (P ns) m

-- Exercise 8 -----------------------------------------

class Num a => Differentiable a where
    deriv  :: a -> a
    nderiv :: Int -> a -> a
    nderiv n p = nderiv (n-1) (deriv p)

-- Exercise 9 -----------------------------------------

instance Num a => Differentiable (Poly a) where
    deriv = undefined


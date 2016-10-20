>	import Control.Monad

GADTs

Before learning about GADTs, you should learn algebraic types. See algebraic data type First. Here is a simple example:


>	data Pair = P Int Double
>		deriving Show

This type says that a Pair is constructed using the constructor P and an Int and a Double. So here is a Pair::

>	pr1 = P 5 4.2

Alternatively, we could say that a Pair is EITHER an Int or a Double:

>	data OrPair = I Int | D Double
>		deriving Show

The second kind of pair is called a "sum" and the first kid is called a "product". Sometimes we actually call the sum a "discriminated sum". The reason for that is that we have said that an OrPair can be constructed in one of two ways. So we're creating a set of values. But sometimes when we create a set of values we loose the original type (eg when we create a List in Java, all values in the list loose their original type and become just Objects.)
In a discriminated sum (or sometimes discriminated union) we still know what each value is by the constructor (the tag).

By the way, an abstract data type is not an algebraic data type. An abstract data type is a type that has defined associated operations, but whose representation is hidden (like an interface in Java). Modules support abstract data types, because we can restrict what is exported from a module (so we can't see the representation).

Here is an example of an algebraic data type:


>	data BTree a = Leaf | Node (BTree a) a (BTree a)
>		deriving Show

>	tree1 = Node (Node (Node Leaf 1 Leaf) 3 (Node Leaf 4 Leaf)) 5 (Node Leaf 7 Leaf)

This tree looks like (the spacing may not come out):
             5
           /    \
         3        7
       /   \
     1      4

Note that here (unlike in abstract data types) we can see the representation (ie the tags/constructors ARE the representation); Algebraic types are very handy, but they don't do everything. Some of the things they do very well is support pattern matching, since we can tell what kind of value we have. Here is a traversal of a BTree

>	traverse Leaf = []
>	traverse (Node l v r) = traverse l ++ [v] ++ traverse r

Which determines what to do based on what kind of value the arg is (ie either a leaf or a non-leaf.)
Q0. Can you think of a way that algebraic data types can be implemented in Java or in C++? There is a very interesting paper Generalized Algebraic Data Types and Object Oriented Programming . But in general it's not as direct and pattern matching is a challenge (though there's another paper on that).

Check out Functional Programming for Java Developers . for ideas on how to implement algebraic types in Java. Does this sound similar to something we did in Scala?

Example. Here is a simple term langauge:

>	data Term a where
>		Lit		:: Int -> Term Int
>		Succ	:: Term Int -> Term Int
>		IsZero	:: Term Int -> Term Bool
>		If		:: Term Bool -> Term a -> Term a -> Term a
>		Pair	:: Term a -> Term b -> Term (a,b)

>	eval :: Term a -> a
>	eval (Lit i)		= i
>	eval (Succ t)		= 1 + eval t
>	eval (IsZero t)		= eval t == 0
>	eval (If b e1 e2)	= if (eval b) then (eval e1) else (eval e2)
>	eval (Pair e1 e2)	= (eval e1, eval e2)

use ghci -XGADTs file
So why is this so interesting? Let's look at how we would do this without gadts:

>	data Verm = VLit Int | VSucc Verm | VIsZero Verm
>				| VIf Verm Verm Verm | VPr  Verm Verm
>					deriving Show

And we could write an evaluator:

	veval (VLit x)		= x
	veval (VSucc t)		= 1 + (veval t)
	veval (VIsZero t)	= (veval t) == 0
	veval (VIf b t1 t2)	= if (veval b) then (veval t1) else (veval t2)
	veval (VPr t1 t2)	= (veval t1, veval t2)

Unfortunately this won't quite type check, because the type checker can't quite figure out a unifying type for values (are they ints? bools? pairs?) (You can try it.)
So we can add a Value type:

>	data Val = VInt Int | VBool Bool | Vpr Val Val
>					deriving Show

which gives enough information to the type checker. Values are either ints, bools, or pairs. And now veval can be written to return a value:
And here is the evaluator:

	
>	veval (VLit x)		= VInt x
>	veval (VSucc t)		= case (veval t) of
>						(VInt i) -> VInt (i+1)
>	veval (VIsZero t)	= case (veval t) of
>						(VInt i) -> VBool (i== 0)
>	veval (VIf b t1 t2)	= case (veval b) of
>						(VBool True) ->  (veval t1)
>						(VBool False) -> (veval t2)
>	veval (VPr t1 t2)	= Vpr (veval t1) (veval t2)

Q1. This works. Let's create some Terms and Verms to see what these mini-languages look like.
But you can see that we had to do a lot of work in the second case to define both a type for terms and a type for values, to allow the type inference to find a unifying type. In a larger language this would be a burden.
Moreover, the type for Verm doesn't prevent us from creating nonesense terms: eg

>	term1 = (VSucc (VIsZero (VLit 0)))

	term2 = (Succ (IsZero (Lit 0)))

>	term3 = (VIf (VIsZero (VLit 1)) (VLit 2) (VLit 3))
> 	term4 = (If (IsZero (Lit 1)) (Lit 2) (Lit 3))
>	term5 = (VPr (VSucc (VLit 2)) (VIf (VIsZero (VLit 0)) (VLit 1) (VLit 2)))
>	term6 = (Pair (Succ (Lit 2)) (If (IsZero (Lit 0)) (Lit 1) (Lit 2)))

which identifies that the first arg of Succ must be an int, while IsZero gives us a bool. So we're getting some type checking in the syntactic definition of a type. A great advantage!
Q2. So what does the gadt do for us? It gives us some type information on the constructors. Construct some terms in each data type and evaluate.

>	t1 = veval term3
>	t2 = eval term4
>	t3 = veval term5
>	t4 = eval term6

Another example. Some data types include basic methods that are partial, for instance Lists. A list can be empty or not, but head can only be applied to a non-empty list. Usually we just generate a runtime error. But we could get a statically detected error:

>	data Empty
>	data NonEmpty
>	data List x y where
>		Nil :: List a Empty
>		Cons :: a -> List a b -> List a NonEmpty

which says that Nil encodes the Empty type, so that we can distinguish an empty list at the type level.
Now we can write a safeHead:

>	safeHead :: List x NonEmpty -> x
>	safeHead (Cons a b) = a

But there is a downside to this. We've restricted lists (perhaps) too much. Here's a silly function that creates either an empty list or a non-empty list, but since they are different types, they don't unify:

	silly 0 = Nil
	silly 1 = Cons 1 Nil

Use: ghci -XGADTs -XEmptyDataDecls gadt.lhs
We get:

    Couldn't match expected type `Empty'
           against inferred type `NonEmpty'
      Expected type: List a Empty
      Inferred type: List a NonEmpty

Q2. Why does this happen? Is it useful then to have empty lists and non-empty lists really have different types?

This error occurs because empty lists and non-empty lists are different types. I don't think it is useful for empty lists and non-empty lists to have different lists because the standard definition of a list is that every non-empty list ends with the cons of an empty list. The standard defintion also makes pattern matching quite easy when looking for base cases when dealing with recursion.

Q3. (Optional) You can try the parsing examples from parsing examples . They are fun.

>	data Parser tok a where
>	    Zero :: Parser tok ()
>	    One :: Parser tok ()
>	    Check :: (tok -> Bool) -> Parser tok tok
>	    Satisfy :: ([tok] -> Bool) -> Parser tok [tok]
>	    Push :: tok -> Parser tok a -> Parser tok a
>	    Plus :: Parser tok a -> Parser tok b -> Parser tok (Either a b)
>	    Times :: Parser tok a -> Parser tok b -> Parser tok (a,b)
>	    Star :: Parser tok a -> Parser tok [a]

>	parse :: Parser tok a -> [tok] -> Maybe a
 
Zero always fails.

>	parse Zero ts = mzero
 
One matches only the empty string.

>	parse One [] = return ()
>	parse One _  = mzero
 
Check p matches a string with exactly one token t such that p t holds.

>	parse (Check p) [t] = if p t then return t else mzero
>	parse (Check p) _ = mzero
 
Satisfy p any string such that p ts holds.

>	parse (Satisfy p) xs = if p xs then return xs else mzero
 
Push t x matches a string ts when x matches (t:ts).

>	parse (Push t x) ts = parse x (t:ts)
 
Plus x y matches when either x or y does.

>	parse (Plus x y) ts = liftM Left (parse x ts) `mplus` liftM Right (parse y ts)
 
Times x y matches the concatenation of x and y.

>	parse (Times x y) [] = liftM2 (,) (parse x []) (parse y [])
>	parse (Times x y) (t:ts) = 
>	    parse (Times (Push t x) y) ts `mplus`
>	    liftM2 (,) (parse x []) (parse y (t:ts))
 
Star x matches zero or more copies of x.

>	parse (Star x) [] = return []
>	parse (Star x) (t:ts) = do
>	    (v,vs) <- parse (Times x (Star x)) (t:ts)
>	    return (v:vs)

TESTS

>	token x = Check (== x)
>	string xs = Satisfy (== xs)
 
>	p = Times (token 'a') (token 'b')
>	p1 = Times (Star (token 'a')) (Star (token 'b'))
>	p2 = Star p1
 
>	blocks :: (Eq tok) => Parser tok [[tok]]
>	blocks = Star (Satisfy allEqual)
>	    where allEqual xs = and (zipWith (==) xs (drop 1 xs))
 
>	evenOdd = Plus (Star (Times (Check even) (Check odd)))
>	               (Star (Times (Check odd) (Check even)))

>	tst1 = parse p "ab"
>	tst2 = parse p "ac"
>	tst3 = parse p1 "aaabbbb"
>	tst4 = parse p2 "aaabbbbaabbbbbbbaaabbabab"
>	tst5 = parse blocks "aaaabbbbbbbbcccccddd"
>	tst6 = parse evenOdd [0..9]
>	tst7 = parse evenOdd [1..10]

Further reading: Fun with Phanton types
Here are some more "advanced questions" on gadt's and type inferencing . So why is type inferencing and static type checking of interest?

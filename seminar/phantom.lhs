Fun with Phantom Types

1) Why can't the Term type on slide 3 be translated into a data declaration?

Term is being used to declare a possible data type, this actually looks like a spec for a typeclass.

2) What does it mean for a type variable α to be existentially quantified?

It means you are putting a group of types into a single type for that variable.

3) What does it mean for a type to be "empty" or uninhabited?

It means you have not defined the type.

4)What does it mean for a function to be "tag free"?

You don't have to explicitly type the function.

Here is the Term data type from slide 4 in the syntax our ghci uses:

>	data Term a where
>		Zero     :: Term Int
>		Succ    :: Term Int -> Term Int
>		Pred    :: Term Int -> Term Int
>		IsZero  :: Term Int -> Term Bool
>		If      :: Term Bool -> Term a -> Term a -> Term a

Contrast with:

    data Term a where
        Zero								with a = Int
        Succ (Term Int)						with a = Int
        Pred (Term Int)						with a = Int
        IsZero (Term Int)					with a = Bool
        If (Term Bool) (Term b) (Term b)	with a = b

We can write the eval for this:

>	eval :: Term a -> a
>	eval (Zero)			= 0
>	eval (Succ a)		= eval a + 1
>	eval (Pred a)		= eval a - 1
>	eval (IsZero e)		= eval e == 0
>	eval (If e1 e2 e3)	= if eval e1 then eval e2 else eval e3

Why do we need the type signature for this function?

The interpreter doesn't know what to do with Zero without the type signature.

6) Load this file and do the steps on slide 6. Why do you get a type error? Can you even construct IsZero (IsZero one) (ie try typing:
:t (IsZero (IsZero one))

You get a type error because you are trying to do an IsZero on a Term Bool, and isZero only performs on Term Int. The inner isZero returns type Bool and the outer isZero doesn't know what to do with that.


7) How can these phantom types help us write generic functions?

Since phantom types are not related to any component (ie phantom), they can implement functions that work for multiple types.

8) Describe what compress does. (If ambitious you could write your own compressInt and compressChar, converting the indicated type to its it representation.)

Compress, compresses data to a string of bits.

9) What might you use dynamic values for?

You could use dynamic values for representing binary. Say you might want to represent the number as an int "1" or the number as bits "01".

10) Try the implementation comp.lhs to fool around with.
where is this file??

11) Describe what the dynamic types are doing and why.

12)Using comp as an example, try to implement the dynamic type. (See an expanded version of fun with phantom types slides: the paper fun with phantom types for additional information. Advanced: First Class Phatom Types . (Note that you probably can't do it all. But it's fun to try. Just try to understand what it's doing.)

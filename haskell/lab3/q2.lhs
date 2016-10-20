<title> GADTs </title>
<h1> GADTs </h1>

<p>
Before learning about GADTs, you should learn algebraic types. See <a href="http://www.haskell.org/haskellwiki/Algebraic_data_type"> algebraic data type </a> First. Here is a simple example:

</p>

<p>
<blockquote>
<pre>

>	data Pair = P Int Double
>		deriving Show

</pre>
</blockquote>

This type says that a Pair is constructed using the constructor <b>P</b>  and
an Int and a Double. So here is a Pair::

<blockquote>
<pre>

>	p1 = P 5 4.2

</pre>
</blockquote>

Alternatively, we could say that a Pair is EITHER an Int or a Double:

<blockquote>
<pre>

>	data OrPair = I Int | D Double
>		deriving Show

</pre>
</blockquote>

The second kind of pair is called a "sum" and the first kid is called a "product". Sometimes we actually call the sum a "discriminated sum". The reason for that is that we have said that an OrPair can be constructed in one of two ways. So
we're creating a set of values. But sometimes when we create a set of values we
loose the original type (eg when we create a List<Object> in Java, all values in
the list loose their original type and become just Objects.)

</p>
<p>
In a discriminated sum (or sometimes discriminated union) we still know what each
value is by the constructor (the tag).

</p>
<p>
By the way, an abstract data type is not an algebraic data type. An abstract data type is a type that has defined associated operations, but whose representation is hidden (like an interface in Java).  Modules support abstract data types, because we can restrict what is exported from a module (so we can't see the representation).
</p>

<p>
Here is an example of an algebraic data type:
<blockquote>
<pre>

>	data BTree a = Leaf | Node (BTree a) a (BTree a)
>		deriving Show

>	tree1 = Node (Node (Node Leaf 1 Leaf) 3 (Node Leaf 4 Leaf)) 5 (Node Leaf 7 Leaf)

</pre>
</blockquote>

This tree looks like (the spacing may not come out):


<blockquote>
<pre>
             5
           /    \
         3        7
       /   \
     1      4

</pre>
</blockquote>


Note that here (unlike in abstract data types) we can see the representation
(ie the tags/constructors ARE the representation); Algebraic types are very
handy, but they don't do everything. Some of the things they do very well is
support pattern matching, since we can tell what kind of value we have. Here is
a traversal of a BTree

<blockquote>
<pre>

>	traverse Leaf = []
>	traverse (Node l v r) = traverse l ++ [v] ++ traverse r

</pre>
</blockquote>

Which determines what to do based on what kind of value the arg is (ie either
a leaf or a non-leaf.)
</p>
<p>

Q0. Can you think of a way that algebraic data types can be implemented in Java
or in C++? There is a very interesting paper <a href="http://research.microsoft.com/apps/pubs/default.aspx?id=64040"> Generalized Algebraic Data Types and Object Oriented Programming </a>. But in general it's not as direct and pattern matching is a challenge (though there's another paper on that). 
</p>
<p>

Check out
<a href="http://openhome.cc/eGossip/Blog/FunctionalProgrammingforJavaDevelopers2.html"> Functional Programming for Java Developers </a>. for ideas on how to implement algebraic types in Java. Does this sound similar to something we did in Scala?


</p>

<ul>
<li> Example. Here is a simple term langauge:
<blockquote>
<pre>

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

</pre>
</blockquote>


<div> use ghci -XGADTs file </div>

</li>

<li> So why is this so interesting? Let's look at how we would do this without
gadts:

<blockquote>
<pre>

>	data Verm = VLit Int | VSucc Verm | VIsZero Verm
>				| VIf Verm Verm Verm | VPr  Verm Verm
>					deriving Show

</pre>
</blockquote>

<li>
<li>
And we could write an evaluator:
<blockquote>
<pre>

	veval (VLit x)		= x
	veval (VSucc t)		= 1 + (veval t)
	veval (VIsZero t)	= (veval t) == 0
	veval (VIf b t1 t2)	= if (veval b) then (veval t1) else (veval t2)
	veval (VPr t1 t2)	= (veval t1, veval t2)

</pre>
</blockquote>
</li>

<li> Unfortunately this won't quite type check, because the type checker
can't quite figure out a unifying type for values (are they ints? bools? pairs?)
(You can try it.)
</li>
<li>
So we can add a Value type:

<blockquote>
<pre>

>	data Val = VInt Int | VBool Bool | Vpr Val Val
>					deriving Show

</pre>
</blockquote>

which gives enough information to the type checker. Values are either 
ints, bools, or pairs. And now veval can be written to return a value:
</li>
<li>
And here is the evaluator:
<blockquote>
<pre>

	
>	veval (VLit x)		= VInt x
>	veval (VSucc t)		= case (veval t) of
>						(VInt i) -> VInt (i+1)
>	veval (VIsZero t)	= case (veval t) of
>						(VInt i) -> VBool (i== 0)
>	veval (VIf b t1 t2)	= case (veval b) of
>						(VBool True) ->  (veval t1)
>						(VBool False) -> (veval t2)
>	veval (VPr t1 t2)	= Vpr (veval t1) (veval t2)

</pre>
</blockquote>


<li> 
Q1. This works. Let's create some Terms and Verms to see what these mini-languages look like.
</li>
<li>

But you can see that we had to do a lot of work in the second case to
define both a type for terms and a type for values, to allow the type inference
to find a unifying type. In a larger language this would be a burden.
</li>
<li>
Moreover, the type for Verm doesn't prevent us from creating nonesense terms:
eg
<blockquote>
<pre>

>	term1 = (VSucc (VIsZero (VLit 0)))

	term2 = (Succ (IsZero (Lit 0)))

</pre>
</blockquote>

which identifies that the first arg of Succ must be an int, while IsZero
gives us a bool. So we're getting some type checking in the syntactic 
definition of a type. A great advantage!


</li>
<li>
Q2. So what does the gadt do for us? It gives us some type information on
the constructors. Construct some terms in each data type and evaluate.
</li>
<li>
Another example. Some data types include basic methods that are partial, for 
instance Lists. A list can be empty or not, but head can only be applied
to a non-empty list. Usually we just generate a runtime error. But we could get
a statically detected error:

<blockquote>
<pre>

>	data Empty
>	data NonEmpty
>	data List x y where
>		Nil :: List a Empty
>		Cons :: a -> List a b -> List a NonEmpty

</pre>
</blockquote>

which says that Nil encodes the Empty type, so that we can distinguish an
empty list at the type level.
</li>
<li> Now we can write a safeHead:

<blockquote>
<pre>

>	safeHead :: List x NonEmpty -> x
>	safeHead (Cons a b) = a

</pre>
</blockquote>
</li>
<li>

But there is a downside to this. We've restricted lists (perhaps) too much.
Here's a silly function that creates either an empty list or a non-empty
list, but since they are different types, they don't unify:

<blockquote>
<pre>

	silly 0 = Nil
	silly 1 = Cons 1 Nil

</pre>
</blockquote>

<div> Use: ghci -XGADTs -XEmptyDataDecls gadt.lhs </div>
</li>
<li> We get:

<blockquote>
<pre>

    Couldn't match expected type `Empty'
           against inferred type `NonEmpty'
      Expected type: List a Empty
      Inferred type: List a NonEmpty

</pre>
</blockquote>

</li>
<li>

Q2. Why does this happen? Is it useful then to have empty lists and non-empty
lists really have different types?
</li>
<li>


Q3.  (Optional) You can try the parsing examples from <a href="http://www.haskell.org/haskellwiki/Generalised_algebraic_datatype"> parsing examples </a>. They are fun.

</li>
</ul>

Further reading: <a href="http://www.cs.ox.ac.uk/ralf.hinze/publications/With.pdf"> Fun with Phanton types </a>


<p>
Here are some more "advanced questions" on <a href="q2.save.html"> gadt's and type inferencing </a>. So why is type inferencing and static type checking of interest?

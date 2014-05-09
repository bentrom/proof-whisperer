proof-whisperer
===============

A prolog (SWI-prolog) progarm that uses basic logic steps to create proofs for different mathemaical results.

#### Definitions

The proof whisperer uses the following basic mathematical defitions:

##### Copy Rule:

    A |- A
    If you know that A is true if A is true.

##### AND-introduction:

    [A,B] |- and(A,B)
    If you know that A is true and that B is true, then and(A,B) is true.

##### AND-elimination:

    and(A,B) |- A
    and(A,B) |- B
    If you know that and(A,B) is true, than you can deduce A, and you can deduce B

##### OR-introduction:

    A |- or(A,B)
    A |- or(B,A)
    If you know that A is true, then or(A,B) is true, and or(B,A) is true

##### OR-elimination:

    [or(A,B), imply(A,C), imply(B,C)] |- C
    If you know that or(A,B) is true, that A implies that C is true, and that B implies that C is true, then C is true.

##### Modes Ponens:

    [imply(A,B), A] |- B
    If you know that A implies B, and that A is true, then B is true

##### Implication Introduction:

    [A |- B] |- imply(A,B)
    If you can show that when A is true, then be will always be true, then imply(A,B) is true.

##### Negation Introduction:

    [A |- false] |- not(a)
    [not(A) |- false] |- A
    If by assuming A to be true you can prove a falsehood, then not(A) is true, and vice versa.

##### Falsehood Introduction:

    [A, not(A)] |- false
    If A and not(A) are both true, then you can deduce falsehood

##### Falsehood Elimination:

    [false] |- A
    From falsehood, you can deduce anything

##### Double Negation Introduction:

    A |- not(not(A))
    If A is true then not(not(A)) is true

##### Double Negation Elimination

    not(not(A)) |- A
    if not(not(A)) is true then A is true

#### Proofs

The proof whisperer has built-in support to guarantee a proof generation for the following statements:

    (Note that you can call all of these at once by call test_me.)

##### AND Commutativity

    Prove that and(A,B) |- and(B,A)
    Call test_and_commutativity.

##### OR Commutativity

    Prove that or(A,B) |- or(B,A)
    Call test_or_commutativity.

##### Associativity

    Prove that and(A,and(B,C)) |- and(and(A,B),C)
    Call test_associativity.

##### Distributivity

    Prove that or(A,and(B,C)) |- and(or(A,B),or(A,C))
    Call test_distributivity.

##### Contrapositive

    Prove that imply(A,B) |- imply(not(B),not(A))
    Call test_contrapositive.

##### DeMorgan's Law

    Prove that not(or(A,B)) |- and(not(A),not(B))
    Call test_demorgan.

##### Modus Tollens

    Prove that [imply(A,B), not(B)] |- not(A)
    Call test_modus_tollens.

#### Notes

If you want to see every single predicate that Prolog attempts while running the program, uncomment the first line in the try() predicate. Note that this can get quite unruly at times.

Also, the falsehood elimination predicate can cause the program to spin out infinitely. Since the program keeps track of how deep it is into its deduction (for purpose of indenting), then I just set I cut off at 8.  If you would like the cutoff to go deeper, than in the second line of the deduce with {FALSEHOOD-introduction}, chance the N < 8 to whatever you desire.

Worth noting, the program prints a line for every success (in order to show the proof steps) other than the Copy Rule. This is because they are not very useful statements in the first place, and often clutter the proof results.  You can make the program show these if you want by uncommenting the catch() line in the deduce with {Copy-rule}

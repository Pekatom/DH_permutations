This repository is for the code related to Tommy Pham's master thesis. The current contributors to this repository are Vasily A. Dolgushev and Tommy Pham.
So far we use README as the log of various updates and changes. Comments are given in the reversed chronological order: the most recent one is at the top. 

Mar 11, 2026, TP: I uploaded a text file containing the list of elements of the form
((b1, c1), (b2, c2), cycle type of the permutation \tau_{173, b1,c1} \composed \tau_{173, b2, c2}), for p = 173. Notice that 24 distinct primitive roots are appearing in the file, and whenever a primitive root appears, its inverse appears as well. However, for this particular prime, composing \tau_{173, b, c1} with \tau_{173, b^{-1}, c2} does not always produce the most number of cycles. Note also that 173 is not a safe prime. 

Feb 17, 2026, VD: Only a minor update in "DH_Perm.sage"...

Feb 17, 2026, TP: I uploaded the newest version of "DH_Perm_General.sage," which contains some new functions such as best_pairs_b_c. This function takes a prime p and an integer t and returns a sorted list that contains the best pairs (b,c) that give the most number of fixed points after composing t times.

Feb 17, 2026, VD: the new version of "DH_Perm.sage" has the tested function best_pairs( , ); here is the info about this function: 
for a prime p and a positive integer r, the command best_pairs(p,r)
returns the tuple (m, out) m is the maximum of the set 

{number of fixed points(\tau_{p,b,c}^r) |  b is a primitive root mod p and 0 \le c \le p-2}

and out is the list of pairs (b,c), "primitive root, shift", such that 
the number of fixed points of \tau_{p,b,c}^r is m (the largest one);
I tested this function using the function testing best_pairs( , )


Feb 3, 2026, TP: I updated the newest version of "DH_PermGeneral.sage." I completed the best_sequence function, which takes a prime p, a primitive b, an integer t, and beam_width, then returns the best sequence of length t.

Feb 2, 2026, TP: I uploaded the newest version of "DH_PermGeneral.sage". It makes sense to look below the line 964. A couple of new functions are fixed_points_count_for_b(p,b),
top_pairs_fixed_points(p, top, frac_threshold), power_map(p). I plan to use those functions for the function best_sequence(p, t), which computes the best sequence of 
(b_t, c_t), ..., (b_0, -1). The fixed_points_count_for_b(p, b) functions runs in O(p), and power_map runs in O(euler_phi(p-1)(p-1)). 

Jan 26, 2026, VD: I uploaded a new version of "DH_Perm.sage"; the couple of new functions are num_fp_sage() and list_DH_perm_sage( ); here is the description for 
list_DH_perm_sage( ): for a prime p, the pairs (b,c), where b is a primitive root and 0 \leq c \leq p-2 is an integer, 
are organized in some order; the command  list_DH_perm_sage(p)  returns the list L;  the j-th entry of 
L is the DH permutation corresponding to the pair (b_j, c_j) in the SageMath format
WARNING: please apply this command only to very small primes 

Here is the link to a helfpul video: 

https://temple.zoom.us/rec/share/2vyg0LJHebZtPVF2jhX9wZcSS7YQ0c3ZABUoj04FxYbYEJxz7JEo7J2eYE5LKHhX.RBOWO0PhYDRYQdyR?startTime=1769454210000

Jan 22, 2026, VD: I uploaded my current version of "DH_Perm.sage"; it does not make sense to looks below line 276; some functions above this line correctly but some do not; 
for example the function vul_exp( , ) does not work correctly...

Jan 20, 2026, VD: I uploaded the book by Crandall and Pomerance. I will delete the file in a couple of weeks... 

Jan 18, 2026, VD: I uploaded various file: "DH_proposal.pdf" is the proposal I wrote in the fall of 2025; "PomeranceDiscreteLog.pdf" is a paper by C. Pomerance; 
"Landrock_DLP.pdf" is the paper by Peter Landrock; "LPS_FixedPoints.pdf" is the paper by M. Levin, C. Pomerance and K. Soundararajan; "Straightening_TP.sage" is Tommy's 
sage code written earlier

This repository is for the code related to Tommy Pham's master thesis. The current contributors to this repository are Vasily A. Dolgushev and Tommy Pham.
So far we use README as the log of various updates and changes. Comments are given in the reversed chronological order: the most recent one is at the top. 

June 11, 2026: I uploaded experimental results estimating P(DH permutations having k fixed points)→1/(e⋅k!) as p→∞. In the abs_diff_actual_decimal_scale plot, 
I computed the ratio #{permutations having k fixed points} / #{all tested permutations} and plotted the number of fixed points on the x-axis, while ∣1/(ek!)−ratio∣
is on the y-axis. I considered all 200 families from the first 200 safe primes. Here, a family means that for a given prime p, the primitive roots and shifts c vary.
For the convergence_max_error_200_safe_primes plot, I computed the same ratio as in the previous plot, but the x-axis is now the number of safe primes used, and the 
y-axis shows the maximum absolute error between the ratio and 1/(ek!). For the exact_error_vs_p plot, I used the exact summation formula instead of the limiting formula
1/(ek!). The rest consists of computing the mean, variance, and total variation distance of the number of fixed points for the first 200 safe primes.

May 28, 2026, TP: I uploaded my version of DH_Perm.sage, which includes two new functions. The first function is f(x,p), 
which takes an exponent x and returns a primitive root b_x such that rem(b_x^x, p) = x + 1 mod p. The second function is secret_exp_DH_generator(p, k = 256), 
which takes a prime p and an integer k. If no value of k is provided, the function assumes k = 256 by default. It then returns a secret exponent x_A or x_B for the DH key exchange protocol.
Also, I accidentally uploaded the file as DH_Perm.sage initially, which overwrote the file that Dr. Dolgushev had uploaded. However, I have since renamed my file to DH_Perm_TP.sage.

May 25, 2026, VD: I uploaded two interesting plots "rel_max_nfp_for120_safe_primes9839.png" and 
"rel_max_nfp_for120_safe_primes32843.png"; for both plots, I considered the compositons of the key DH permutation with 
an arbitrary shift; for each prime I computed this number: 100 times the largest number of fixed points in this family 
of permutations divided by (p-1); in the first plot, the horizontal axis represents 120 safe primes between 
9839 and 25799 (including both primes) and the vertical axis shows the above percetage; in the second plot, the horizontal 
axis represents 100 safe primes between 32843 and 47963 (including these primes) and the vertical axis shows the above 
percetage: 100* max number of fixed points/(p-1). 

May 5, 2026, VD: I uploaded the file "Logjam_paper.pdf"; as far as I understand, this is the official description of the logjam attack.

May 5, 2026, VD: In the updated version of "DH_Perm.sage", I have two new functions gener_unlock_tup( , ) and tuple2perm( , , );
I found unlocking tuples of length r = 4 for (mostly safe) primes p \leq 107; so far, I do not see any paterns...

April 28, 2026, VD: I save the old version of "DH_Perm.sage" as "DH_Perm_April2026.sage" and uploaded the new version of DH_Perm. Here is the video about the new version: 

https://temple.zoom.us/rec/share/SZ4W7POPn5yl8z5g1EBcm-uq873eccW6RhMQxKUVbHyx9nzI25y_IKoJuNtkrGSE.3kQqoS95AfAz8waN?startTime=1777400526000

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

This repository is for the code related to Tommy Pham's master thesis. The current contributors to this repository are Vasily A. Dolgushev and Tommy Pham.
So far we use README as the log of various updates and changes. Comments are given in the reversed chronological order: the most recent one is at the top. 

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

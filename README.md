This repository is for the code related to Thien (Tommy) Pham's master thesis "AN EXPLORATION OF DIFFIE-HELLMAN PERMUTATIONS". 
The current contributors to this repository are Sophia V. Breslavets, Vasily A. Dolgushev and Tommy Pham. All scripts are written in SageMath. 

Here, we put a couple of paragraphs (in very general terms) about what one can do using the code in this repository. 
(To be written)

DESCRIPTIONS OF SELECTED FUNCTIONS: 

- The function num_fp_rho_c_tau takes a prime p and returns the max number of fixed points for 
rho^{-c} \circ tau_p, where 0 <= c <= p-2 and tau_p = rem(g_p^x, p), where g_p is the smallest
primitive root relative to p.

DESCRIPTION OF IMAGE FILES: 

- The plot in 'brute_force_p_vs_time.png' shows the relationship between the prime p (x-axis) and the running time of the brute-force method (y-axis).
For this method, we generated a random integer c satisfying 0 <= c <= p-2 and performed up to p-2 iterations to find a fixed point of
the permutation rho^{-c} \circ \tau_p, where tau_p(x) := rem(g^x, p).

- The plot "fp_rou_c_tau_87620_prime.png" displays the prime values on the x-axis while the maximum number of fixed points of the permutations \rho^{c} \circ \tau_{p}, 0 <= c <= p-2, on the y-axis. The first 87260 primes were investigated in this experiment.

- The plots "good_pairs_p1307.png" and "good_pairs_sp719.png" display the pairs (j, k) for which the permutation \rho^{j} \circ \mu_2 \circ \rho^{k} \circ \tau_p has the greatest number of fixed points for prime p= 1307 and p=719, respectively.

- The plot "normalized_good_pairs_30sp.png" display the pairs (j/(p-1),k/(p-1)) for which the permutation \rho^{j} \circ \mu_2 \circ \rho^{k} \circ \tau_p has the greatest number of fixed points for the first 30 safe primes.

- The plot "Theoretical_vs_Practical_bounds.png" displays the values of prime p on the x-axis, while the greatest (theoretical and practical) number of fixed points of the permutation \rho^{c} \circ \tau_{p}, 0 <= c <= p-2. From VD: very good; please give useful information about the range of primes for the experimental results...

TESTING:

VD: We need to describe (somewhat briefly) how the code was tested...

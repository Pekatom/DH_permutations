This repository is for the code related to Thien (Tommy) Pham's master thesis "AN EXPLORATION OF DIFFIE-HELLMAN PERMUTATIONS". 
The current contributors to this repository are Sophia V. Breslavets, Vasily A. Dolgushev and Tommy Pham. All scripts are written in SageMath. 

Here, we put a couple of paragraphs (in very general terms) about what one can do using the code in this repository. 
(To be written)

DESCRIPTIONS OF SELECTED FUNCTIONS: 

- The function max_num_fp4shifts(p, b) takes a prime p, a primitive root b modulo p, and returns the max number of fixed points for 
rho^{-c} \circ tau_{p,b}, where 0 <= c <= p-2 and tau_{p,b} = rem(b^x, p).

DESCRIPTION OF IMAGE FILES: 

- The plot in 'brute_force_p_vs_time.png' shows the relationship between the prime p (x-axis) and the running time of the brute-force method (y-axis).
For this method, we generated a random integer c satisfying 0 <= c <= p-2 and performed up to p-2 iterations to find a fixed point of
the permutation rho^{-c} \circ \tau_p, where tau_p(x) := rem(g^x, p).

- The plot "fp_rou_c_tau_87620_prime.png" displays the prime values on the x-axis while the maximum number of fixed points of the permutations \rho^{c} \circ \tau_{p}, 0 <= c <= p-2, on the y-axis. The first 87260 primes were investigated in this experiment.

- The plots "good_pairs_p1307.png" and "good_pairs_sp719.png" display the pairs (j, k) for which the permutation \rho^{j} \circ \mu_2 \circ \rho^{k} \circ \tau_p has the greatest number of fixed points for prime p= 1307 and p=719, respectively.

- The plot "normalized_good_pairs_30sp.png" display the pairs (j/(p-1),k/(p-1)) for which the permutation \rho^{j} \circ \mu_2 \circ \rho^{k} \circ \tau_p has the greatest number of fixed points for the first 30 safe primes.

- The plot "Theoretical_Bound_vs_Exp_Bound.png" displays the values of prime p on the x-axis and the greatest (theoretical and experimental) number of fixed points of the permutation \rho^{c} \circ \tau_{p}, 0 <= c <= p-2, on the y-axis. Here, primes p values are between
7 and 163853. There are 15000 primes in this range. 

DESCRIPTION OF STORAGE FILES:

'ManySafePrimes' contains the list of all safe primes 11 <= p <= 50000747; altogether, there are 124,849 (safe) primes in this range.

TESTING:

VD: We need to describe (somewhat briefly) how the code was tested...

This repository is for the code related to Thien (Tommy) Pham's master thesis "AN EXPLORATION OF DIFFIE-HELLMAN PERMUTATIONS". 
The current contributors to this repository are Sophia V. Breslavets, Vasily A. Dolgushev and Tommy Pham. All scripts are written in SageMath. 

Here, we put a couple of paragraphs (in very general terms) about what one can do using the code in this repository. 
(To be written)

DESCRIPTIONS OF SELECTED FUNCTIONS: 

- The function num_fp_rho_c_tau takes a prime p and returns the max number of fixed points for 
rho^{-c} \circ tau_p, where 0 <= c <= p-2 and tau_p = rem(g_p^x, p), where g_p is the smallest
primitive root relative to p.

DESCRIPTION OF IMAGE FILES: 

- The plot in 'brute_force_p_vs_time.ong' shows the relationship between the prime p (x-axis) and the running time of the brute-force method (y-axis).
For this method, we generated a random integer c satisfying 0 <= c <= p-2 and performed up to p-2 iterations to find a fixed point of
the permutation rho^{-c} \circ \tau_p, where tau_p(x) := rem(g^x, p).




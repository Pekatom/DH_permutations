This repository is for the code related to Thien (Tommy) Pham's master thesis "AN EXPLORATION OF DIFFIE-HELLMAN PERMUTATIONS". 
The current contributors to this repository are Sophia V. Breslavets, Vasily A. Dolgushev and Tommy Pham. All scripts are written in SageMath. 

Here, we put a couple of paragraphs (in very general terms) about what one can do using the code in this repository. 
(To be written)

DESCRIPTIONS OF SELECTED FUNCTIONS: 

- The function 'max_num_fp4shifts(p, b)' takes a prime p, a primitive root b modulo p, and returns the max number of fixed points for 
rho^{-c} \circ tau_{p,b}, where 0 <= c <= p-2 and tau_{p,b} = rem(b^x, p).

- For an odd prime p, the command 'is_safe(p)' returns True if p is of the form
2q + 1 with q being prime; otherwise False.

- For an integer n, the command 'next_safe_prime(n)' returns the smallest safe
prime p such that p > n.

- For a prime p and a primitive root b (mod p), the command 'order_mod(b, p)'
returns the order of the residue class of b (mod p) in the multiplicative group of units
(Z/pZ)^×.

- For a prime p and an integer b coprime to p, the command 'is_primitive(b, p)'
returns True if b is a primitive root mod p; otherwise, False.

- For a prime p, 'prim_roots(p)' is a generator of all primitive roots modulo p, e.g.
the command list(prim roots(23)) returns
[5, 10, 20, 17, 11, 21, 19, 15, 7, 14].

- For a prime p, the command 'DH_key(p)' returns the key DH permutation as an instance
of the class
’sage.groups.perm gps.permgroup element.SymmetricGroupElement’;
the key DH permutation sends an integer x ∈ {1, ..., p − 1} to rem(gp, p), where gp
is the smallest primitive root modulo p.

- For an integer N > 1, the command 'the_cycle(N)' returns the cycle (1, 2, 3, ...,N)
as the permutation in the Sage format.

- Let p be prime; for an integer u coprime to (p − 1), command 'dot(u)' returns the
permutation of degree (p − 1) that sends x to ux (mod p − 1).

- Let p be a prime; for an integer v ∈ {1, 2, ..., (p − 1)}, the command star(v)
returns the permutation of degree (p − 1) that send x to vx (mod p).

- For a prime p and an integer j, the command 'DH_shift(p, j)' returns the composition
of τ_p with the shift by j.

- For a prime p, the command 'exp_long_ct(p)' returns the list of integers j for
which ρ^j ◦ τ_p has the longest cycle type.

- For a prime p, its primitive root b and a shift c, there is at least one integer x ∈
{1, . . . , p−1} such that rx ≡ (x+c) (mod p−1), where rx := rem(bx, p); the command
'brute_force(p, b, c)' returns the smallest such integer; it also prints
how much time (in seconds) it took to find x.

- For a prime p, its primitive root b and a shift c, there is at least one integer x ∈
{1 . . . , p − 1} such that rx ≡ (x + c) (mod p − 1), where rx := rem(bx, p); the
command 'BSGS(p, b, c)' returns one such integer x; it also prints how much
time (in seconds) it took to find x.

- For a prime p, its primitive root b and an integer c, the command 'num_signs_slow(p,
b, c)' returns the number of integers 0 ≤ x ≤ p − 2 such that bx ≡ x (mod p).

- For a prime p and a primitive root b modulo p, the command 'list_num_fp4shifts(p,
b)' returns a list L of length p − 1. The entry L[c] is the number of fixed points of
the permutation ρ^{−c} ◦ τ_p,b, where τ_{p,b} is the permutation of degree p − 1 defined by
the formula τ_{p,b}(x) := rem(b^x, p).

- For a prime p and a primitive root b modulo p, the command 'max_num_fp4shifts(p,
b)' returns the maximum number of fixed points among the permutations ρ^c ◦ τ_{p,b} for
c = 0, 1, . . . , p − 2, where τ_{p,b} is defined by τ_{p,b}(x) := rem(b^x, p).

- For a prime p, the command 'max_num_fp(p)' returns the largest number of fixed
points for the family of DH permutations ρ^c ◦ τ_p, 1 ≤ c ≤ p − 1.

- For a prime p and an integer 1 ≤ c ≤ p−1, the command 'DH_perm(p, tau, c)'
returns the DH permutation τ_{p,gp,c} of degree (p − 1) in the Sage format, where tau
is the key DH permutation.

- For a prime p, the function 'num_fp_all_roots(p)' returns the max number of
fixed points for ρ^c ◦ τ_{p,b}, where τ_{p,b} := rem(b^x, p), for all shifts 1 ≤ c ≤ p − 1 and
all primitive roots b modulo p.

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

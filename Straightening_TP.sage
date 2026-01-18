'''
This Sage script is for experimenting with the straightening of Diffie-Hellman permutations. 
The current contributors to the script are Vasily Dolgushev, Nathan Graff, and Tommy Pham.
'''
import itertools

import time
#time is shown in seconds

import random
#for a list L, the command random.choice(L) returns a random element of the list L


from itertools import product
'''
product( ) realizes the cartesian product; for instance 
product((0,1), repeat = 3) is a generator of all tuples of 0's and 1's of length 3
'''

from itertools import combinations as comb
'''
for instance, comb([1,2,3], 2) generates (1,2), (1,3) and (2,3)
'''

from pickle import dump, load
#this is for storing and loading various objects
'''
How to use PICKLE:
Given a Python object obJecT, we can store it in the file FILE 
by doing this:
    
dump(obJecT,open('FILE','wb'))

To unpickle the obJecT back, we do this:
    
FO = open('FILE','rb'); obJecT = load(FO)

Another option is to use the function load_now. One should 
not forget to use ' ' around the name of the file. 
'''

import numpy as np
#needed to working with ANN

#tested
def load_now(FILE):
    '''
    loads (unpickles) the object from the FILE 'FileName'.
    One should not forget to use ' '.
    '''
    FO = open(FILE,'rb')
    return load(FO)

'''
From SageMath documentation: for an integer N > 1 and integers b, x the command
power_mod(b, x, N) returns the remainder of division of b^x by N; note that
the output is an instance of the class 'sage.rings.integer.Integer'; the output of 
the command int(power_mod(b, x, N)) is an instance of the class 'int'
'''

'''
for a prime p and an integer b coprime to p, the command 
order_mod(b, p) returns the order of the residue class of b (mod p)
in the multiplicative group of units in ZZ/pZZ 
'''
#tested
def order_mod(b, p):
    div = divisors(p-1)
    for d in div[:(len(div)-1)]:
        if power_mod(b, d, p) == 1:
            return d
    return (p-1) 


'''
for a prime p and an integer b coprime to p, the command 
is_primitive(b, p) returns True is b in a primitive root mod p; otherwise, 
False 
'''
#tested
def is_primitive(b, p):
    return order_mod(b, p) == (p-1)


'''
for a prime p, the commands prim_roots(p) returns the sorted 
list of all primitive roots (between 1 and p-1) modulo p; we code 
is borrowed from the SageMath documentation
'''
#tested
def prim_roots(p):
    g = primitive_root(p)
    znorder = p - 1
    is_coprime = lambda x: gcd(x, znorder) == 1
    good_odd_integers = filter(is_coprime, [1..p-1, step=2])
    all_primroots = [power_mod(g, k, p) for k in good_odd_integers]
    all_primroots.sort()
    return all_primroots

#for testing prim_roots( )
def prim_roots1(p):
    b = primitive_root(p)
    out = [b]
    for k in range(3, p-1, 2):
        if gcd(k, p-1) == 1:
            out.append(power_mod(b, k, p))
    return out

#for testing prim_roots( )
def test_prim_roots(p):
    t0 = time.time()
    Test = prim_roots(p)
    print(time.time()-t0)
    t0 = time.time()
    Test1 = prim_roots1(p)
    print(time.time()-t0)
    return sorted(Test1) == Test


'''
let p be prime and b be a primitive root mod p;
the command DH_perm(p, b, x) returns the result of applying 
the corresponding Diffie-Hellman permutation to an integer 0 <= x <= p-2 
VD: for every pair (p, b), i.e. (prime, its primitive root), the assignment 
x  --> b^x mod gives us a bijection {0,1,2, ..., p-2} to  {1,2, ..., p-1}; 
composing this bijection with y --> y-1 be get a permutation of the set
{0,1,2, ..., p-2}  
'''
#tested
def DH_perm(p, b, x):
    return int(power_mod(b, x, p)) - 1 


'''
let p be prime and b be a primitive root mod p; the command 
fixed_points(p, b) returns the tuple of all fixed points of the Diffie-Hellman 
permutation corresponding to the pair (p, b); 
'''
#tested
def fixed_points(p, b):
    return tuple(x for x in range(1, (p-1)) if DH_perm(p, b, x) == x)



'''
Straightening via  DH permutations...
'''

'''
for a prime p and its primitive root b, the command 
best_root(p, b) the pair (r_best, m), where r_best is the optimal 
primitive root in the sense that tau_{p, r_best} \circ \tau_{p, b} has 
the largest number m of fixed points
'''
#
def best_root(p, b):
    m = 0 
    for bb in prim_roots(p):
        fp = []
        for x in range(1,p-1):
            if DH_perm(p, bb, DH_perm(p, b, x))==x: fp.append(x)
        if len(fp)>m:
            r_best = bb; m = len(fp)
    return (r_best, m)

#
def exper_compose(p):
    for b in prim_roots(p):
        print(b,'  ', len(fixed_points(p, b)))
        print('the best outcome is ...', best_root(p,b))
        print('        ')
        
'''
for a prime p, the command best(p) returns the tuple ((bb, b), m) where ...
'''
#tested
def best_pair(p):
    PR = prim_roots(p)
    m = 0
    for b in PR:
        m0 = len(fixed_points(p, b))
        for bb in PR:
            fp = [x for x in range(1,p-1) if DH_perm(p, bb, DH_perm(p, b, x))==x]
            if (len(fp)-m0)>m:
                pr = (bb, b); m=len(fp)-m0
    return (pr, m)

'''
1 step, terminates when # of fixed points can no longer be increased
'''

def iterative_straightening_one_step_i(p):
    """
    Straighten the DH permutation by composing with other DH permutations.
    
    Args:
        p (int): Prime modulus
        
    Returns:
        tuple: (list of bases [b0, b1, ..., bn], final fixed point count)
    """
    # Initialize with smallest primitive root
    b0 = min(prim_roots(p))
    current_bases = [b0]
    
    # Build initial permutation: τ_{p,b0}
    n_domain = p - 1  # Domain: 0 to p-2
    current_perm = [DH_perm(p, b0, x) for x in range(n_domain)]
    
    # Count fixed points in [1, p-2] (exclude 0 and p-2)
    current_count = sum(1 for x in range(1, n_domain) if current_perm[x] == x)
    
    # Iteratively improve by composing with new primitive roots
    improved = True
    while improved:
        improved = False
        best_b = None
        best_count = current_count
        best_perm = None
        
        # Try all primitive roots in increasing order
        for b in sorted(prim_roots(p)):
            # Compute new permutation: τ_b ∘ current_perm
            new_perm = [DH_perm(p, b, y) for y in current_perm]
            
            # Count fixed points in [1, p-2]
            new_count = sum(1 for x in range(1, n_domain) if new_perm[x] == x)
            
            # Update if improvement found (prefer smallest b on tie)
            if new_count > best_count:
                best_count = new_count
                best_b = b
                best_perm = new_perm
        
        # Apply the best improvement found
        if best_count > current_count:
            current_count = best_count
            current_bases.append(best_b)
            current_perm = best_perm
            improved = True
    
    return (current_bases, current_count)






'''
1 step look-ahead, terminates when # of fixed points can not be maintained
'''
def iterative_straighten_one_step_m(p):
    """
    Iteratively composes DH permutations to maximize fixed points.
    
    Args:
        p (int): Prime modulus.
        
    Returns:
        tuple: (list of primitive roots used, final fixed point count)
    """
    def count_fixed_points(perm):
        """Count fixed points in the permutation for indices 1 to len(perm)-1."""
        count = 0
        for x in range(1, len(perm)):
            if perm[x] == x:
                count += 1
        return count

    # Initialize with the smallest primitive root
    b0 = min(prim_roots(p))
    n = p - 1  # Domain size
    perm = [DH_perm(p, b0, x) for x in range(n)]
    sequence = [b0]
    current_count = count_fixed_points(perm)
    
    while True:
        best_count = -1
        best_b = None
        
        # Evaluate all primitive roots
        for b in prim_roots(p):
            new_perm = [DH_perm(p, b, y) for y in perm]
            new_count = count_fixed_points(new_perm)
            
            # Update best candidate
            if new_count > best_count or (new_count == best_count and b < best_b):
                best_count = new_count
                best_b = b
        
        # Stop if no improvement or maintenance
        if best_count < current_count:
            break
        
        # Update permutation and sequence
        perm = [DH_perm(p, best_b, y) for y in perm]
        current_count = best_count
        sequence.append(best_b)
    
    return sequence, current_count


'''
1 step look-ahead, terminates when # of fixed points will decrease by 2 or more
'''
def iterative_straighten_one_step_d(p):
    """
    Iteratively composes DH permutations to maximize fixed points,
    but allows a drop of up to 1 fixed point before terminating.

    Args:
        p (int): Prime modulus.

    Returns:
        tuple: (list of primitive roots used, final fixed point count)
    """
    def count_fixed_points(perm):
        count = 0
        for x in range(1, len(perm)):
            if perm[x] == x:
                count += 1
        return count

    # Initialize with the smallest primitive root
    b0 = min(prim_roots(p))
    n = p - 1
    perm = [DH_perm(p, b0, x) for x in range(n)]
    sequence = [b0]
    current_count = count_fixed_points(perm)

    while True:
        best_count = -1
        best_b = None

        for b in prim_roots(p):
            new_perm = [DH_perm(p, b, y) for y in perm]
            new_count = count_fixed_points(new_perm)

            if new_count > best_count or (new_count == best_count and (best_b is None or b < best_b)):
                best_count = new_count
                best_b = b

        # Now only break if the best choice would lose >= 2 fixed points
        if current_count - best_count >= 2:
            break

        # Otherwise, accept this step (even if it loses 1 fixed point)
        perm = [DH_perm(p, best_b, y) for y in perm]
        current_count = best_count
        sequence.append(best_b)

    return sequence, current_count


#tested
def iterative_straighten_two_step(p):
    """
    Iteratively composes DH permutations using a 2-step lookahead to maintain or improve fixed points.
    Terminates when no 2-step sequence can keep the fixed-point count the same or higher.

    Args:
        p (int): Prime modulus.

    Returns:
        tuple: (list of primitive roots used, final fixed point count)
    """
    def count_fixed_points(perm):
        return sum(1 for x in range(1, len(perm)) if perm[x] == x)

    # Initialize
    b0 = min(prim_roots(p))
    n = p - 1
    perm = [DH_perm(p, b0, x) for x in range(n)]
    sequence = [b0]
    current_count = count_fixed_points(perm)

    while True:
        best_count = -1
        best_pair = None  # (b1, b2)

        # Evaluate all pairs of primitive roots
        roots = prim_roots(p)
        for b1 in roots:
            # First apply b1
            perm1 = [DH_perm(p, b1, y) for y in perm]
            for b2 in roots:
                # Then apply b2
                perm2 = [DH_perm(p, b2, y) for y in perm1]
                cnt2 = count_fixed_points(perm2)
                # Track best 2-step result, tie-breaking on lexicographically smallest pair
                if (cnt2 > best_count) or (
                    cnt2 == best_count and best_pair is not None and (b1, b2) < best_pair
                ) or (best_pair is None and cnt2 == best_count):
                    best_count = cnt2
                    best_pair = (b1, b2)

        # Stop if the best 2-step cannot maintain current_count
        if best_count < current_count:
            break

        # Otherwise, apply both steps and update
        b1, b2 = best_pair
        # apply first
        perm = [DH_perm(p, b1, y) for y in perm]
        sequence.append(b1)
        # apply second
        perm = [DH_perm(p, b2, y) for y in perm]
        sequence.append(b2)
        current_count = best_count

    return sequence, current_count

'''
Brute Force Fixed Length sequences, maximizes 
'''

def brute_force_fixed_length(p, length):
    """
    Brute-force search over all length-tuples of primitive roots modulo p,
    finding those sequences whose composed DH permutation maximizes fixed points.

    Args:
        p (int): Prime modulus.
        length (int): Desired tuple length.

    Returns:
        tuple: (max_count, best_sequences)
            - max_count (int): The highest number of fixed points achieved.
            - best_sequences (list of tuples): All length-tuples achieving max_count.
    """
    from itertools import product

    def count_fixed_points(perm):
        """Count fixed points in perm for indices 1..len(perm)-1."""
        return sum(1 for x in range(1, len(perm)) if perm[x] == x)

    # Gather primitive roots and domain size
    roots = sorted(prim_roots(p))
    n = p - 1

    max_count = -1
    best_sequences = []

    # Identity permutation to start compositions
    identity = list(range(n))

    # Enumerate all sequences of the given length
    for seq in product(roots, repeat=length):
        perm = identity.copy()
        # Compose DH steps for each root in the tuple
        for b in seq:
            perm = [DH_perm(p, b, x) for x in perm]


'''
Straightening via affine transformations...
'''


'''
p is prime, b is a primitive root modulo p,  c \in {0,1,..., p-2} and u is an integer 1 \le u \le p-2 such that 
gcd(u, p-1) = 1 (i.e. u represents a unit in ZZ/(p-1)ZZ); the command num_fixed_pts(p, b, u,  c)
returns the number of fixed points of the composition of the Diffie-Hellman permutation corresponding to (p, b)
with affine permutation x --> u*x +c (mod p-1)
'''
#
def num_fixed_pts(p, b, u, c):
    L = [x for x in range(p-1) if x==((u*DH_perm(p, b, x)+c)%(p-1))]
    return len(L)


'''
for a prime p, generate_affine(p) is a generator of all elements of the group Aff(ZZ/(p-1)ZZ)
in the form (u, c), where u is an integer in {1,..., p-2} coprime to (p-1) and c is any integer 
in {1,2,..., p-2} 
'''
#
def generate_affine(p):
    for u in range(1, p-1):
        if gcd(u, p-1)==1:
            for c in range(p-1):
                yield (u,c)

'''
p is a prime integer and b is a primitive root modulo p;
best_affine(p, b) returns the tuple (m, u, c), where (u,c) is the smallest 
optimal element of Aff(ZZ/(p-1)ZZ); in other words, the permutation aff_{u,c} \circ \tau_{p, b}
has the largest number m of fixed points and (u,c) is the smallest pair in the lexicographic order;

WARNING: it works very slowly...
'''
#
def best_affine(p, b):
    m = 0; out = (1, 0) # (1,0) is the identity element of Aff(ZZ/(p-1)ZZ)
    for t in generate_affine(p):
        new = num_fixed_pts(p, b,  t[0], t[1])
        if new > m:
            out = t
            m = new
    return (m, out[0], out[1])




import itertools
import time

def iterative_straightening_two_roots(p, m):
    """
    Searches for a sequence (of arbitrary length) whose entries are only the
    smallest and second-smallest primitive root modulo p, terminating as soon as
    it finds one that fixes at least m points or no new best has been found in 90 seconds.

    While running, whenever it encounters a sequence fixing more points than
    any seen before, it prints that sequence and its fixed-point count.

    Args:
        p (int): Prime modulus.
        m (int): Target number of fixed points to reach or exceed.

    Returns:
        tuple: (best_sequence, fixed_count) where fixed_count >= m (if found).
    """
    roots = sorted(prim_roots(p))[:2]
    n = p - 1
    identity = list(range(n))

    best_count = 0
    best_seq = None
    last_improvement_time = time.time()

    for length in itertools.count(1):
        for seq in itertools.product(roots, repeat=length):
            perm = identity[:]
            for b in seq:
                perm = [DH_perm(p, b, x) for x in perm]
            cnt = sum(1 for i in range(1, n) if perm[i] == i)

            if cnt > best_count:
                best_count = cnt
                best_seq = seq
                last_improvement_time = time.time()
                print(f"New best sequence: {seq}, fixed points = {cnt}")

            if cnt >= m:
                print(f"Target reached: sequence {seq} fixes {cnt} points (>= {m})")
                return seq, cnt

            if time.time() - last_improvement_time > 90:
                print("Terminating: no new best sequence found in 90 seconds.")
                return best_seq, best_count

    return best_seq, best_count

def DH_list(p, b):
    # loop over x=0..p-2 so you get exactly p-1 values
    T = [ DH_perm(p, b, x) for x in range(p-1) ]
    # shift back up into {1..p-1}
    images = [ t + 1 for t in T ]
    # sanity‐check
    assert sorted(images) == list(range(1, p))
    return images

def next_safe_prime(n):
    """
    Return the smallest safe prime p>n,
    where p and (p-1)/2 are both prime.
    """
    p=next_prime(n)
    while not ((p-1)//2).is_prime():
        p=next_prime(p)
    return p
 
def safe_prime_list():
    """This function returns a list of 100000 safe primes """

    SP=[]
    buffer = 5

    while len(SP) < 100000:
        SP.append(next_safe_prime(buffer))
        buffer = next_safe_prime(buffer)

    return SP

def cycle_fractions(g, digits=None):
    n = g.parent().degree()
    fracs = [QQ(L)/n for L in g.cycle_type()]
    if digits is None:
        return fracs                     # rationals
    else:
        return [f.n(digits=digits) for f in fracs]  # decimals

def prim_root_list(p,t):
    """take two parameters prime p and a fixed t 
    to return a list of primitive root from b_0 up
    to b_t"""
    L= []
    g=primitive_root(p)
    L.append(g)
    for k in range(3,p-1,2):
        if(len(L) == t+1):
            break
        if(gcd(k,p-1)==1):
            L.append(pow(g,k,p))
            
    L.sort()
    return L

def best_sequence_of_b_t(p):
    """This function takes a safe prime p

    and returns the best sequence (the more cycles 

    the better) in the form \tao_p,b_t \composed 

    ...\composed \tao_p,b_0, where t ranges from 

    0 to euler_phi(p-1)"""

    L= prim_root_list(p,euler_phi(p-1))
    G=SymmetricGroup(p-1)
    
    T_1=DH_list(p,L[0])
    g_1=G(T_1)

    T_2=DH_list(p,L[1])
    g_2=G(T_2)

    temp_g=g_2*g_1

    if(len(g_1.cycle_tuples()) < len(temp_g.cycle_tuples())):
        best_g=temp_g
    else:
        best_g=g_1

    for i in range (2,euler_phi(p-1)):
        T=DH_list(p,L[i])
        g=G(T)
        current_g= g*temp_g
        temp_g=current_g
        if(len(best_g.cycle_tuples()) < len(current_g.cycle_tuples())):
            best_g=current_g
            best_t=i
            longest_cycle=len(best_g.cycle_tuples())

    print("num of primitive roots:", len(L))
    print("\nthe best t is ", best_t, "\n")
    print("best_g cycle type ", best_g.cycle_type())
    print("longest num of cycles:", longest_cycle)
    


def best_sequence_of_b_t_fixed_t(p, t):
    """
    Given a safe prime p and integer t,
    computes the best index b (0 ≤ b ≤ t) for which
    τ_{p,b_t} ∘ … ∘ τ_{p,b_0} has the maximum number of cycles.
    If t > φ(p−1), this function does nothing.
    """
    # If t is too big, skip this p
    if t > euler_phi(p-1):
        print(f"Skipping p={p}: t={t} > φ(p−1)={euler_phi(p-1)}")
        return None

    # Build primitive roots up to index t
    first_prim_list=prim_root_list(p,t)
    perm_prim_list = Permutations(first_prim_list)

    L = [list(perm) for perm in perm_prim_list ]
    if not L:
        print(f"No primitive roots found for p={p} up to t={t}")
        return None

    # Initialize group and first element
    G = SymmetricGroup(p-1)
    g_0 = first_prim_list[0]
    temp_g = G(DH_list(p, g_0))
    best_g = temp_g
    best_t = 0
    longest_cycle = len(temp_g.cycle_tuples()) #num of cycles

    # Loop through the rest up to t
    for i in range (len(L)):
        for j in range(1, min(t+1, len(L[0]))):
            gi = G(DH_list(p, L[i][j]))
            temp_g = gi * temp_g
            num_cycles = len(temp_g.cycle_tuples())
            if num_cycles > longest_cycle:
                longest_cycle = num_cycles
                best_g = temp_g
                best_t = j
                best_sequence= i

    # Report results
    print(f"\nExamined {len(L[0])} primitive roots {L[0]}")
    print(f"Best index b = {best_t} with {longest_cycle} cycles")
    print(f"Best Sequence: {L[best_sequence]}")
    print("Cycle structure of best_g:", best_g.cycle_type())
  #  return best_t, best_g


def best_greedy_sequence(p,t):
    """this function takes a safe prime p and an integer t 
    and computes in the following manner:
    set a primitive root b_0, 
    compute \tao_p,b_0
    given a list of primitive roots = [b1,b2,,b3,...,bt]
    outer loop will keep track of "step", which is how many compositions of permutations we have
    composed 
    the inner loop will perform \tao_p,b_i \composed \tao_p,b_(#the number of times the outer loop run -1)\composed \tao_p,b_0
    where i ranges from 1 to t. 
    it will stop after not finding any improvements in the number of cycles """

    if t > euler_phi(p-1):
        print("skip p={p}")
        return None

    # build and cache all single-step permutations
    roots = prim_root_list(p,t)
    G = SymmetricGroup(p-1)
    perms = [G(DH_list(p,g)) for g in roots]
    
    # starts from g_0
    temp = perms[0]
    best_seq = [roots[0]]
    best_count = len(temp.cycle_type())

    # greedily append the root that maximizes the cycle_count at each step
  
    for step in range (1, t+1):
        best_gain = 0
        best_choice = None
        best_temp = None

        for i, j in enumerate(perms[:t+1]):
            candidate = j*temp
            count = len(candidate.cycle_type())
            gain = count - best_count
            if best_gain < gain:
                best_gain, best_choice,best_temp = gain, roots[i], candidate
            
        if best_choice is None:
            break
        temp, best_count = best_temp, best_count + best_gain
        best_seq.append(best_choice)

    print("\nGreedy count: " , best_count)
    print("\nBest sequence: ", best_seq)
    print("\ncycle type of best sequence: ", temp.cycle_type())




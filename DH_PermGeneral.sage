'''
This Sage script is for experimenting with fixed points of Diffie-Hellman permutations. 
The current version has many commands from FixedPoints_DH.sage that can be found in the 
GitHub repository 

https://github.com/Pekatom/DiffieHellman_FixedPoints

Current contributors are Vasily Dolgushev and Tommy Pham 

'''
import heapq
import time
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
from heapq import nlargest

'''
this is for the function best_sequence
'''

from pickle import dump, load
#this is for storing and loading the results
'''
How to use 'pickle':
Given a Python/SageMath object obJecT, we can store it in the file FILE 
by doing this:
    
dump(obJecT,open('FILE','wb'))

To unpickle the obJecT back, we do this:
    
FO = open('FILE','rb'); obJecT = load(FO)

Another option is to use the function load_now. One should 
not forget to use ' ' around the name of the file. 
'''

'''
loads (unpickles) the object from the FILE 'FileName'; 
one should not forget to use ' '.
'''
#tested
def load_now(FILE):
    FO = open(FILE,'rb')
    return load(FO)

'''
From SageMath documentation: for an integer N > 1 and integers b, x the command
power_mod(b, x, N) returns the remainder of division of b^x by N; note that
the output is an instance of the class 'sage.rings.integer.Integer'; the output of 
the command int(power_mod(b, x, N)) is an instance of the class 'int'

for a positive integer n, the command nth_prime(n) returns the n-the prime, e.g. 
the command [nth_prime(n) for n in range(1,11)] returns the list 
[2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
'''

'''
for an integer n, the built-in  SageMath command next_prime(n) returns the smallest prime p such that p > n
'''

'''
for an odd prime p, the command is_safe(p) returns True if p is of the form 
2q+1 with q being prime; otherwise False 
'''
#tested
def is_safe(p):
    return is_prime( (p-1)//2 )

'''
for an integer n, the command next_safe_prime(n) returns the smallest safe prime p such that p >  n 
'''
#tested
def next_safe_prime(n):
    p = next_prime(n)
    while True:
        if is_safe(p):
            return p
        p = next_prime(p)

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
is_primitive(b, p) returns True if b is a primitive root mod p; otherwise, 
False 
'''
#tested
def is_primitive(b, p):
    return order_mod(b, p) == (p-1)


'''
for an odd prime p, prim_roots(p) is a generator of all primitive roots (between 1 and p-1) modulo p; 
note that, usually, the roots are not generated in the natural order
'''
#tested
def prim_roots(p):
    b = primitive_root(p)
    yield b
    for k in range(3, p-1, 2):
        if gcd(k, p-1) == 1:
            yield power_mod(b, k, p)

'''
the code for prim_roots_doc() is borrowed from SageMath documentation 
'''
#for testing prime roots 
def prim_roots_doc(p):
    g = primitive_root(p)
    znorder = p - 1
    is_coprime = lambda x: gcd(x, znorder) == 1
    good_odd_integers = filter(is_coprime, [1..p-1, step=2])
    all_primroots = [power_mod(g, k, p) for k in good_odd_integers]
    all_primroots.sort()
    return all_primroots

#for testing prim_roots( )
def test_prim_roots(p):
    t0 = time.time()
    Test = list(prim_roots(p))
    print(time.time()-t0)
    t0 = time.time()
    Test1 = prim_roots_doc(p)
    print(time.time()-t0)
    return Test1 == sorted(Test)

'''
for a prime p, its primitive root b and an integer 1 <= y <= (p-1), 
the command DLP_brute_force(p, b, y) finds the integer 
1 <= x <= (p-1) such that b^x is congruent to y mod p
'''
#tested
def DLP_brute_force(p, b, y):
    t0 = time.time( )
    for x in range(1,p):
        if power_mod(b, x, p) == y:
            print('It took ', time.time( ) - t0, ' seconds.')
            break
    return x

'''
let p be prime, b be a primitive root mod p and c be an integer (considered modulo p-1);
the command DH_perm(p, b, c, x) returns the result of applying 
the corresponding Diffie-Hellman permutation to an integer 0 <= x <= p-2; 
in fact, x can be any integer
'''
#tested
def DH_perm(p, b, c, x):
    return (int(power_mod(b, x, p)) + c)%(p-1)


'''
let p be prime, b be a primitive root mod p and c be an integer;
the command DH_perm_sage(p, b, c) returns the corresponding DH permutation 
as an instance of the class 'sage.groups.perm_gps.permgroup_element.SymmetricGroupElement'; 
note that the corresponding permutation acts on {1,2,..., p-1}, not on {0,1,2,..., p-2} 
'''
#
def DH_perm_sage(p, b, c):
    aux = [(DH_perm(p, b, c, x)+1) for x in range(p-1)]
    return SymmetricGroup(p-1)(aux)

'''
let p be prime, b be a primitive root mod p and c be an integer;
the command DH_order(p, b, c) returns the order of the DH permutation \tau_{p, b, c}
'''
#
def DH_order(p, b, c):
    return DH_perm_sage(p, b, c).order()

'''
let p be prime, b be a primitive root mod p and c be an integer;
the command DH_cycle_type(p, b, c) returns the cycle type of the DH permutation \tau_{p, b, c} 
'''
#
def DH_cycle_type(p, b, c):
    return DH_perm_sage(p, b, c).cycle_type()

'''
for a prime p, the command lengths(p) returns the list of lengths of cycle types of 
all DH permutations 
'''
#
def lengths(p):
    PR = list(prim_roots(p)); Shifts = list(range(p-1))
    return [len(DH_cycle_type(p, b, c)) for (b, c) in product(PR, Shifts)]

'''
let p be prime, b be a primitive root mod p and c be an integer;
the command fixed_points(p, b, c) returns the list of all fixed points of the Diffie-Hellman 
permutation corresponding to the triple (p, b, c)
'''
#
def fixed_points(p, b, c):
    return [x for x in range(p-1) if DH_perm(p, b, c, x) == x]

'''
for a prime p, the pairs (b,c), where b is a primitive root and 0 \leq c \leq p-2 is an integer, 
are organized in some order; the command list_num_fp(p) returns the list L;  the j-th entry of 
L is the number of fixed points for the DH permutation corresponding to the pair (b_j, c_j)
'''
#
def list_num_fp(p):
    PR = list(prim_roots(p)); Shifts = list(range(p-1))
    return [len(fixed_points(p, b, c)) for (b, c) in product(PR, Shifts)]


'''
for a prime p and an integers  0 \leq x, c \leq p-2, the command 
is_vul_exp(x, p, c) returns True if x is a vulnerable exponent relative to the pair (p, c); 
the command is used for testing
'''
#for testing
def is_vul_exp(x, p, c):
    for b in prim_roots(p):
        if DH_perm(p, b, c, x) == x:
            return True
    return False

'''
this is a slow version of vul_exp( , ); it used the above function is_vul_exp;
for a pair (p, c) with p being prime the command returns the list of all 
vulnerable exponents relative to the pair (p, c)
'''
#
def vul_exp_slow(p, c):
    return [x for x in range(p-1) if is_vul_exp(x,p, c)]

'''
this is a subroutine for vul_exp( , ); q is prime, c is an integer and L is a list of integers
'''
#
def aux_vul_exp(x, q, c, L):
    if (power_mod(x-c, L[len(L)-1], q) != 1): return False
    for r in L[:(len(L)-1)]:
        if (power_mod(x-c, r, q) ==1): return False
    return True

'''
for a prime p > 7, the command vul_exp(p, c) returns the list 
of all vulnerable exponents relative to the pair (p, c); usually, the resulting
list is not sorted; the CURRENT command should work for c \neq (p-1)/2
'''
#
def vul_exp(p, c):
    div = divisors(p-1)
    out = [ ]
    for d in div[:(len(div)-1)]:
        m = (p-1)//d
        div_m = [r for r in div if (m%r==0)]
        for t in range(1, m):
            if gcd(t, m)==1:
                x = d*t
                if aux_vul_exp(x, p, c, div_m):
                    out.append(x)    
    return out


#the code below this line SHOULD BE UPDATED...
    
'''
for a prime p > 7, the command vul_exp1(p) returns the list 
of all vulnerable exponents relative to p; usually, the resulting
list is not sorted
'''
#
def vul_exp1(p):
    div = divisors(p-1); div = div[:(len(div)-1)]
    out = []
    for d in div:
        m = (p-1)//d
        div_m = divisors(m)
        for t in range(1, m):
            if gcd(t,m)==1:
                x = d*t
                if aux_vul_exp(x, p, div_m):
                    out.append(x)    
    return out


'''
for a prime p > 7, vul_exp_gen(p) is a generator of all 
vulnerable exponents relative to p
'''
#
def vul_exp_gen(p):
    div = divisors(p-1)
    for d in div[:(len(div)-1)]:
        m = (p-1)//d
        div_m = [r for r in div if (m%r==0)]
        for t in range(1, m):
            if gcd(t, m)==1:
                x = d*t
                if aux_vul_exp(x, p, div_m):
                    yield x


'''
Note: the time performance of vul_exp() and vul_exp1() is comparable;
for some primes, vul_exp() runs faster than vul_exp1(); for other primes, 
vul_exp1() runs faster than vul_exp() 
'''

'''
for a prime p and an integer 1 \le x \le (p-2), the command 
is_vul_exp_better(x,p) returns True if x is vulnerable relative to p 
'''
#
def is_vul_exp_better(x,p):
    m = (p-1)//gcd(x,p-1)
    if (power_mod(x+1, m, p) != 1):
        return False  
    for d in divisors(m):
        if d<m:
           if (power_mod(x+1, d, p) ==1):
                return False
    return True


#for testing
def test_vul_exp_old(p):
    tup = tuple(x for x in range(1, p-1) if is_vul_exp(x, p))
    VE = vul_exp(p); VE.sort()
    return tuple(VE) == tup

#for testing vul_exp( ) and vul_exp1( )
def test_vul_exp(p):
    T0 = time.time()
    VE_slow = vul_exp_slow(p)
    print(' Time elapsed  = ', time.time()-T0)
    T0 = time.time()
    VE1 = vul_exp1(p)
    print(' Time elapsed  = ', time.time()-T0)
    T0 = time.time()
    VE = vul_exp(p)
    print(' Time elapsed  = ', time.time()-T0)
    VE.sort(); VE1.sort()
    return VE_slow==tuple(VE) and VE_slow==tuple(VE1)
 
'''
let p be a safe prime > 7; the command vul_exp4safe(p) returns the list of 
all vulnerable exponents relative to p; note that, under our assumptions, q and p-2 are not 
vulnerable exponents; so we ignore them; also, (x+1)^2 is not congruent to 1 if 
1 \le x \le p-4 and x in odd  
'''
#
def vul_exp4safe(p):
    q = (p-1)//2; out =[]
    for x in range(2, p-1, 2):
        if power_mod(x+1, q, p)==1: out.append(x)
    for x in range(1, q, 2):
        if (x!=q) and (power_mod(x+1, q, p)!=1): out.append(x)
    # (q+1) is even...
    for x in range(q+2, p-2, 2):
        if (x!=q) and (power_mod(x+1, q, p)!=1): out.append(x)
    return out

#for testing vul_exp4safe( )
def test_VE4safe(p):
    if not is_safe(p):
        print(p, '  is not a safe prime')
        return []
    #T0 = time.time() # if you want to time then you need to uncomment 4 lines
    VE = vul_exp(p)
    #print(' Time elapsed  = ', time.time()-T0)
    #T0 = time.time()
    VE4safe = vul_exp4safe(p)
    #print(' Time elapsed  = ', time.time()-T0)
    return sorted(VE)==sorted(VE4safe)
    

'''
p is a safe prime > 7 and b is a primitive root modulo p; the command 
fixed_points4safe(p, b) returns the list of all fixed points of 
the DH permutation corresponding to the pair (p, b) 
'''
#
def fixed_points4safe(p, b):
    q = (p-1)//2; out =[]
    for x in range(2, p-1, 2):
        if int(power_mod(b, x, p))==(x+1): out.append(x)
    for x in range(1, q, 2):
        if int(power_mod(b, x, p))==(x+1): out.append(x)
    for x in range(q+2, p-2, 2):
        if int(power_mod(b, x, p))==(x+1): out.append(x)
    return out


#for testing fixed_points4safe( )
def test_fp4safe(p, b):
    if not is_safe(p):
        print(p, '  is not a safe prime')
        return []
    print('First, for fixed_points, second, for fixed_points4safe')
    T0 = time.time()
    fp = fixed_points(p,b)
    print('    Time elapsed  = ', time.time()-T0)
    T0 = time.time()
    fp1 = fixed_points4safe(p, b)
    print('    Time elapsed  = ', time.time()-T0)
    return set(fp1)==set(fp)


'''
for an odd prime p, the command has_vul_exp(p) returns True if p has at least one vulnerable exponent; 
otherwise, False  
'''
#
def has_vul_exp(p):
    for x in range(1, p-1):
        if order_mod((x+1),p)*gcd(x,p-1)==(p-1):
            return True
    return False


'''
for an odd prime p, the command has_vul_exp_gt1(p) returns True if p has at least one vulnerable exponent x > 1; 
otherwise, False  
'''
#
def has_vul_exp_gt1(p):
    for x in range(2, p-1):
        if order_mod((x+1),p)*gcd(x,p-1)==(p-1):
            return True
    return False
 
'''
for a prime p > 7, the command percentage_vul_exp(p) returns 
the percentage of vulnerable exponents among the total number of (p-2) exponents 
'''
#
def percentage_vul_exp(p):
    num = len(vul_exp(p))
    return 100.0*num/(p-2)
 
'''
p is prime > 7 and r is a real number < 100 (e.g. r =7); the command
percentage_vul_exp_gt(p, r) returns True if the percentage of vulnerable exponents 
relative to p is > 7; otherwise False
'''
#tested 
def percentage_vul_exp_gt(p, r):
    c = 0
    for x in vul_exp_gen(p):
        c+=1
        if 100.0*c>r*(p-2):
            return True
    return False
 
'''
for a safe prime p > 7, the command percentage_vul_exp4safe(p) returns 
the percentage of vulnerable exponents among the total number of (p-2) exponents 
'''
#tested
def percentage_vul_exp4safe(p):
    if not is_safe(p):
        print(p,' is not a safe prime')
        return None
    num = len(vul_exp4safe(p))
    return 100.0*num/(p-2)

#for testing percentage_vul_exp4safe( )
def test_percentage_vul_exp4safe(p):
    print(' First, we execute percentage_vul_exp4safe, then percentage_vul_exp')
    T0 = time.time()
    r4safe = percentage_vul_exp4safe(p)
    print('Time elapsed = ', time.time()-T0)
    T0 = time.time()
    r = percentage_vul_exp(p)
    print('Time elapsed = ', time.time()-T0)
    return r4safe==r    

'''
p is prime and x is an integer 1 <= x <= p-2;
the command disting_prim_roots(x, p) 
returns the tuple of primitive roots b mod p 
such that x is a fixed point of the Diffie-Hellman permutation 
corresponding to (p,b)
'''
#tested
def disting_prim_roots(x, p):
    return tuple(b for b in prim_roots(p) if DH_perm(p, b, x) == x)

'''
for a prime p, the command max_num_fp_slow(p) returns the 
maximum of the following set: 

{# of fixed points of \tau_{p, b} | b is a primitive root modulo p }

max_num_fp() is a faster version of this command
'''
#tested
def max_num_fp_slow(p):
    VE = vul_exp(p)
    Len = [ ]
    for b in prim_roots(p):
        Len.append( len([x for x in VE if (DH_perm(p, b, x)==x)]) )
    return max(Len)

'''
max_num_fp4testing( ) is a slower version of max_num_fp_slow( );
it is used for testing max_num_fp( ) and max_num_fp_slow() 
'''
def max_num_fp4testing(p):
    S = {len(fixed_points(p, b)) for b in prim_roots(p)}
    return max(S)

'''
given two positive integers m, d the command gcpd(d, m) returns the greatest positive 
divisor d_1 of d such that d_1 is coprime to m
'''
#test
def gcpd(d, m):
    q = d
    while gcd(q, m)>1:
        q = q//gcd(q,m)
    return q

'''
gcpd1( , ) is a more direct implementation of gcpd; 
VD: to my surprise, the performance in terms of time is comparable 
to that of gcpd
'''
#for testing 
def gcpd1(d,m):
    for t in divisors(d)[::-1]:
        if gcd(t, m) == 1:
            return t

#for testing
def test_gcpd(n, N):
    out = [ ]
    T0 = time.time()
    out = [gcpd(t[0], t[1]) for t in product(range(n,N), repeat = 2)]
    print('Time elapsed = ', time.time() - T0)
    T0 = time.time()
    out1 = [gcpd1(t[0], t[1]) for t in product(range(n,N), repeat = 2)]
    print('Time elapsed = ', time.time() - T0)
    return out==out1

'''
for a prime p and a vulnerable exponent x, the command 
num_disting_prim_roots(x, p) returns the number of primitive roots b (mod p)
such that tau_{p, b} (x) = x; the command should not be applied if x is 
not a vulnerable exponent
'''
#tested
def num_disting_prim_roots(x, p):
    if (order_mod(x+1, p)*gcd(x, p-1) != (p-1)):
        return 0
    d = gcd(x, p-1); m = (p-1)//d
    d1 = gcpd(d, m); d2 = d//d1
    return d2*euler_phi(d1)

'''
x is a vulnerable exponent relative to a prime p and b is a 
primitive root modulo p; the command disting_exp(x, p, b) returns the tuple of integers 
k \in {1,..., p-2} such that \tau_{p, b^k}(x) = x
'''
#tested
def disting_exp(x, p, b):
    d = gcd(x, p-1); m = (p-1)//d; x1 = x//d 
    aux = power_mod(b, d, p) 
    for t1 in range(1, m):
        if (gcd(t1, m) == 1 and power_mod(aux, t1, p) == x+1):
            break
    k0 = (inverse_mod(x1, m)*t1)%m
    d1 = gcpd(d, m); d2 = d//d1
    m_inv = inverse_mod(m, d1) 
    if d1 == 1:
        return tuple((k0 + m*h) for h in range(d2))
    out = ( )
    for nu in range(1, d1):
        if gcd(nu, d1) == 1:
            rhs = (nu - k0)%d1
            s_nu = (m_inv*rhs)%d1
            for h in range(d2):
                out = out + (k0 + m *(s_nu + d1*h),)
    return out


#for testing disting_exp( , , ) and disting_prim_roots( , )  
def test_disting_exp(p, b):
    out = [ ]
    for x in vul_exp(p):
        S = {power_mod(b,k,p) for k in disting_exp(x, p, b)}
        SS = set(disting_prim_roots(x, p))
        out.append(S==SS)
    return set(out)

'''
for a prime p, the command root_profile(p, timed = None) returns the list L of nonnegative integers
of length p-1; if k is coprime to (p-1), then L[k] is the number of fixed points of the DH permutation 
\tau_{p, gp^k}, where gp is the smallest primitive root modulo p; if k is not coprime to (p-1), 
then L[k] == 0
'''
#tested
def root_profile(p, timed = None):
    gp = primitive_root(p)
    if timed:
        T0 = time.time( )
    L = [0]*(p-1) # we ignore L[0]
    for x in vul_exp(p):
        for k in disting_exp(x, p, gp):
            L[k]+=1
    if timed:
        print('Time elapsed = ', time.time()-T0)
    return L

'''
for a safe prime p = 2*q+1, the command root_profile4safe(p) returns the 
list L of length (p-1)  of non-negative integers with L[0] = 0; if gcd(k, 2q)!=1, 
L[k] =0, if gcd(k, 2q)==1, then L[k] is the number of fixed points of tau_{p, g_p^k}, 
where g_p is the smallest primitive root modulo p
'''
#tested
def root_profile4safe(p):
    L = [0]*(p-1) # we ignore L[0]
    gp = primitive_root(p); q = (p-1)//2
    #taking care of the even vulnerable exponents
    for t in range(2, p-1, 2):
        x = power_mod(gp, t, p) - 1
        if x%2==0:
            x1 = x//2; t1= t//2
            k = (inverse_mod(x1, q)*t1)%q
            if k%2==0: k=k+q
            if k>(p-2): print(x, t, k)
            L[k]+=1
    #taking care of odd vulnerable exponents
    for t in range(1,q,2):
        x = power_mod(gp, t, p) - 1
        if (x%2==1 and x!=q):
            k = (inverse_mod(x, p-1)*t)%(p-1)
            L[k]+=1
    for t in range(q+2,p-1,2):
        x = power_mod(gp, t, p) - 1
        if (x%2==1 and x!=q):
            k = (inverse_mod(x, p-1)*t)%(p-1)
            L[k]+=1
    return L

#for testing root_profile4safe( )
def test_root_profile(p):
    if not is_safe(p):
        print(p,' is not a safe prime')
        return []
    #T0 = time.time()
    L = root_profile(p)
    #print('   Time elapsed = ', time.time()-T0)
    #T0 = time.time()
    L1 = root_profile4safe(p)
    #print('   Time elapsed = ', time.time()-T0)
    return L==L1

'''
for a prime p > 7, the command max_num_fp(p) returns the maximum of the following set 
{# of fixed points of \tau_{p, b} | b is a primitive root modulo p }
'''
#tested
def max_num_fp(p):
    return max(root_profile(p))
     
'''
for a safe prime p > 7, the command max_num_fp4safe(p) returns the maximum of the following set 

{# of fixed points of \tau_{p, b} | b is a primitive root modulo p }

it uses the command root_profile4safe( )
'''
#tested
def max_num_fp4safe(p):
    return max(root_profile4safe(p))


#for testing the functions max_num_fp( ) and max_num_fp_slow( )
def testing_max_num_fp(p):
    print('The commands are executed in this order: max_num_fp( ), max_num_fp_slow( ), max_num_fp4testing( )')
    T0 = time.time()
    m = max_num_fp(p)
    print('   times elapsed = ', time.time()-T0)
    T0 = time.time()
    m_slow = max_num_fp_slow(p)
    print('   times elapsed = ', time.time()-T0)
    T0 = time.time()
    m_test = max_num_fp4testing(p)
    print('   times elapsed = ', time.time()-T0)
    return (m==m_slow and m==m_test)  

#for testing max_num_fp4safe( )
def testing_max_num_fp4safe(p):
    print('The commands are executed in this order: max_num_fp4safe( ), max_num_fp( )')
    T0 = time.time( )
    m4safe = max_num_fp4safe(p)
    print('   time elapsed = ', time.time( )-T0)
    T0 = time.time( )
    m = max_num_fp(p)
    print('   time elapsed = ', time.time( )-T0)
    return m==m4safe

'''
for a prime p, the command vul_prim_roots(p) returns the list of 
vulnerable primitive roots modulo p; the output may not be sorted
'''
#tested
def vul_prim_roots(p):
    gp = primitive_root(p); out = [ ]
    RP = root_profile(p); m = 0
    for k in range(1, len(RP)):
        if gcd(k, p-1)==1:
            if RP[k]==m: out.append(power_mod(gp, k, p))
            if RP[k]>m:
                out = []; out.append(power_mod(gp, k, p))
                m = RP[k]
    return out

'''
for a prime p, the command vul_prim_roots_slow(p) returns the list of 
vulnerable primitive roots modulo p; the output may not be sorted;
the command vul_prim_roots_slow() is usually slower than vul_prim_roots( )
'''
#for testing
def vul_prim_roots_slow(p):
    m = 0; out = []
    for b in prim_roots(p):
        new = len(fixed_points(p, b))
        if new==m: out.append(b)
        if new>m:
            out =[ ]; out.append(b)
            m = new       
    return out

#for testing vul_prim_roots()
def test_vul_prim_roots(p):
    print('   First, we execute vul_prim_roots')
    T0 =time.time()
    VPR = vul_prim_roots(p)
    print('Time elapsed = ', time.time()-T0)
    T0 =time.time()
    VPR_slow = vul_prim_roots_slow(p)
    print('Time elapsed = ', time.time()-T0)
    return sorted(VPR)==sorted(VPR_slow)



'''
let p = 2*q+1 be a safe prime and M be the largest number of fixed points of DH permutations 
corresponding to p; the command frequencies4safe(p) returns the list L (of floats) of length 
M+1 with L[n] being the quotient of the number of DH permutations with exactly n fixed points  
by phi(p-1) = q-1, i.e. by the total number of primitive roots modulo p
'''
#tested
def frequencies4safe(p):
    RP = root_profile4safe(p)
    q  = (p-1)//2; qm1 = q-1 
    M = max(RP)
    C0 = [1 for k in range(1, len(RP), 2) if (k!=q and RP[k]==0)]
    out = [len(C0)*1.0/qm1]
    for n in range(1,M+1):
        out.append(RP.count(n)*1.0/qm1)
    return out
    
'''
let p be a prime > 7 and M be the largest number of fixed points of DH permutations 
corresponding to p; the command frequencies_slow(p) returns the list L (of floats) of length M+1
with L[n] being the quotient of the number of DH permutations with exactly n fixed points  
by phi(p-1), i.e. by the total number of primitive roots modulo p
'''
#for testing frequencies4safe( ):
def frequencies_slow(p):
    num_fp = [len(fixed_points(p,b)) for b in prim_roots(p)] # list of the numbers if fixed points
    M = max(num_fp)
    return [num_fp.count(n)*1.0/len(num_fp) for n in range(M+1)]
  
#for testing frequencies4safe( )
# note that the function test_frequencies4safe compares floats...
def test_frequencies4safe(p):
    if not is_safe(p):
        print(p, ' is not a safe prime!')
        return None
    print('First, for the slow function; second, for the faster one')
    T0 = time.time()
    fr_slow = frequencies_slow(p)
    print('Time elapsed = ', time.time()-T0)
    T0 = time.time()
    fr4safe = frequencies4safe(p)
    print('Time elapsed = ', time.time()-T0)
    return fr4safe==fr_slow 

#SP = load_now('ManySafePrimes')
#the above line loads a list of  124,849 safe primes starting with p = 11

'''
for a prime p and its primitive root b, fixed_points_gen(p, b) is a generator of 
all fixed points of the permutation tau_{p, b} 
'''
#tested
def fixed_points_gen(p, b):
    div = divisors(p-1)
    for d in div[:(len(div)-1)]:
        m = (p-1)//d; aux = power_mod(b, d, p)
        for x1 in range(1, m):
            if gcd(x1, m)==1:
                x = d*x1
                if (x+1)==power_mod(aux, x1, p):
                    yield x

'''
p is prime and num is the largest number of primitive roots used for testing
'''
#for testing fixed_points_gen( , )
def testing_fixed_points_gen(p, num):
    PR = list(prim_roots(p))
    if num<len(PR): PR = PR[:num]
    print('First, we use fixed_points_gen and, second, we use fixed_points')
    T0 = time.time()
    L = [tuple(fixed_points_gen(p,b)) for b in PR]
    print('   time elapsed = ', time.time()-T0)
    T0 = time.time()
    LL = [fixed_points(p,b) for b in PR]
    print('   time elapsed = ', time.time()-T0)
    L = [set(a) for a in L]; LL = [set(a) for a in LL]
    return L==LL


'''
The code below is for comparing DH permutations with random permutations
'''
    
#VD: I am guessing that it is extremely unlikely to find a DH permutation with > 41 fixed points; so I chose range(42) below  
Poisson = [exp(-1.0)/factorial(k) for k in range(42)] # well, it is the Poisson distribution for lambda = 1

'''
for a safe prime p; the command distance(p) returns the 'distance' between the 
empirical distribution frequencies4safe(p) and the theoretical one, i.e. the Poisson distribution 
'''
#
def distance(p):
    if not is_safe(p):
        print(p, ' is not a safe prime!')
        return None
    fr = frequencies4safe(p)
    fr = fr + [0]*(len(Poisson)-len(fr)) #appending the necessary number of zeros
    aux = [(t[0] - t[1])**2 for t in zip(fr, Poisson)]
    return (sum(aux))**0.5

#
def cab_distance(p):
    if not is_safe(p):
        print(p, ' is not a safe prime!')
        return None
    fr = frequencies4safe(p)
    fr = fr + [0]*(len(Poisson)-len(fr)) #appending the necessary number of zeros
    aux = [abs(t[0] - t[1]) for t in zip(fr, Poisson)]
    return sum(aux)/len(Poisson)

'''
D is a dictionary of the form {p:freq(p) for a subset of primes p}, where freq(p) is the list 
of frequencies of numbers of fixed points; the command cab_distances4dict(D) 
'''
#
def cab_distances4dict(D):
    out = []
    for p in D.keys():
        fr = D[p]
        fr = fr + [0]*(len(Poisson)-len(fr)) #appending the necessary number of zeros
        aux = [abs(t[0] - t[1]) for t in zip(fr, Poisson)]
        out.append(sum(aux)/len(Poisson))
    return out 



'''
alternating_prefix takes a safe prime p, a primitive root b0, and a positive integer t then 
computes the following permutations (exactly t permutations will be computed) 

\composed \tau_{p,b0,i} \composed...\composed \tau_{p,b0,c_2} \composed \tau_{p,b0inv,c_1} \composed \tau_{p,b0,-1} , 1<= i <=t,
 where b0 is a primitive root, b0inv is b0 inverse, and integers c_k (mod p-1). It will track and print the cycle type
 of the sequence that has the largest number of cycles
'''
def alternating_prefix(p, b, t):
    b0 = b
    b0inv = inverse_mod(b, p)

    
    roots = [b0, b0inv]
    G = SymmetricGroup(p-1)
    perms = [None, None]
    perms[0] = G(DH_perm_sage(p,b0,-1))
    
    cur = G.identity()

    best_k = None
    best_count = -1
    best_perm = None

    for k in range(1, t+1):
        # apply the next permutation (alternating)
        perms[(k-1)%2] = G(DH_perm_sage(p,roots[(k-1)%2], -1)) 
        #cur = cur * perms[(k-1) % 2]     
        cur = perms[(k-1) % 2] * cur  
        num_cycles = len(cur.cycle_type())

        if num_cycles > best_count:
            best_count = num_cycles
            best_k = k
            best_perm = cur

    print("\nBest k:", best_k)
    print("Max #cycles:", best_count)
    print("Cycle type at best k:", best_perm.cycle_type())
   
''' primitive_root_list function return a list of all primitive roots of a prime p'''

def primitive_root_list(p):
    b = primitive_root(p)
    list = []
    for k in range (1,p-1):
        if(gcd(k,p-1)==1):
            list.append(power_mod(b,k,p))
    return list


''' this DH_list function takes a prime p and returns a dictionary that includes all the permutations with
keys being pairs (b,c), where b is a primitive root of p and c is an integer mod (p-1)
'''

def DH_list(p):
    prim_roots = primitive_root_list(p)
    DH_perm = {}
    DH = DH_perm_sage                 

    for b in prim_roots:
        for c in range (0,p-1):
            DH_perm[(b, c)] = DH(p, b, c)

    return DH_perm


def num_fp(perm):
    n = perm.parent().degree()
    return sum(1 for x in range (1,n+1) if perm(x) == x)





def fixed_point_counts_for_b(p, b):
    """
    Returns counts[c] = number of fixed points of DH_perm(p,b,c,·) for each c mod (p-1).
    Runs in O(p).
    """

    counts = [0]*(p-1)
    y = 1 
    for x in range(1,p):
        c = (x - int(y)) % (p-1)
        counts[c]+=1
        y = (int(y)*int(b)) %p

    return counts

def top_pairs_fixed_points(p, top, frac_threshold):
    """
    Scans all primitive roots b and all c.
    Returns:
      - hits: pairs with >= frac_threshold*(p-1) fixed points
      - best: top pairs by fixed-point count
    """
    hits = []
    heap = []
    primitive_roots = primitive_root_list(p)

    for b in primitive_roots:
        counts = fixed_point_counts_for_b(p,b)

        for c, fp in enumerate(counts):
            if fp >= floor(frac_threshold*(p-1)):
                hits.append((fp, b, c))
    
            if len(heap) < top:
                heapq.heappush(heap, (fp, b, c))
            else:
                if fp > heap[0][0]:
                    heapq.heapreplace(heap, ((fp, b, c)))

    heap = sorted(heap, reverse = True)
    hits.sort(reverse = True)

    return hits, heap[:top]

    """
    List the fixed points x in {0,...,p-2} for the given (b,c),
    without building the permutation.
    """

def fixed_points_fast(p, b, c):
    
    fp = []
    y = 1

    for x in (1,p):
        if (x - int(y) % p) == c:
            fp.append(x)
            y = (int(y)*int(b)) % p 

    return fp

''' for a given prime p, return a dictionary with keys being (b,x), b is a primitive root,
    and save the corresponding b^x mod p, where x = 0,1,..., p-2 
'''
def power_map(p):
    b = primitive_root(p)
    d = {}

    for x in range (0,p-1):
        d[(b,x)] = power_mod(b,x,p)

    for k in range(3, p-1, 2):
        if gcd(k,p-1) == 1:
            for x in range (0,p-1):
                x0 = (k*x) % (p-1)
                d[(power_mod(b,k,p),x)] = d[(b,x0)] 

    return d  


'''this function takes a prime p, primitive root b, an integer c, a power_map, and a SymmetricGroup then returns
a DH'''

def dh_perm_from_power_map(p, b, c, pm, G):
    images0 = []
    for x in range (p-1):
        y= int(pm[(b,x)])
        img = (y + int(c)) % (p-1)
        images0.append(img)

    return G([u + 1 for u in images0])


''' best_sequence takes a prime p and an integer t and returns a sequence
(b_t,c_t),...,(b_0,c_0) that produces the most fixed points
'''
        
def best_sequence(p, b0, t, beam_width = 50):
    pm = power_map(p)
    G = SymmetricGroup(p-1)

    bases = sorted({k[0] for k in pm.keys()})

    def score(perm):
        return num_fp(perm)

    states = []
    for c in range(p-1):
        perm0 = dh_perm_from_power_map(p, b0, c, pm, G)
        states.append( (((b0,c),), perm0, score(perm0)))

    for step in range(2, t+1):
        pool = []
        for seq, perm, sc in states:
            for b in bases:
                for c in range (p-1):
                    new_seq = seq + ((b,c),)
                    new_perm = perm * dh_perm_from_power_map(p,b,c,pm,G)
                    pool.append((new_seq, new_perm, score(new_perm)))
        states = nlargest(beam_width, pool, key=lambda s: s[2])
        
    return states
    


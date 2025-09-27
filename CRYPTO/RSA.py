import random
import secrets

def power(a, n, p):
     
    res = 1
    a = a % p 
     
    while n > 0:
        if n % 2:
            res = (res * a) % p
            n = n - 1
        else:
            a = (a ** 2) % p
            n = n // 2

    return res % p

def eEuclid(x, p): 
    t1 = 0
    t2 = 1
    while(1):
        r = p%x
        if(r == 0):
            return t2
        q = int(p/x)
        t = t1 - q*t2
        t1 = t2
        t2 = t
        p = x
        x = r
        

def isPrime(n, k):
     
    if n == 1 or n == 4:
        return False
    elif n == 2 or n == 3:
        return True
     
    else:
        for i in range(k):

            a = random.randint(2, n - 2)
            if power(a, n - 1, n) != 1:
                return False
                 
    return True

def genPrime(n):

    while(1):
        p = secrets.randbits(n)
        if(isPrime(p,200)):
            return p


def random_choose(p):
    return random.randint(2,p-2)



def gcd(a, b):
    gcd_val = 0
    for i in range(1, min(a, b) + 1):
        if (a % i == 0) and (b % i == 0):
            gcd_val = i
    return gcd_val

def get_e(phi):

    while(1):
        #e = random.randint(2, phi-1)
        for e in range(60, phi-1):
            if(gcd(e,phi)==1):
                return e

pd = int(input("Enter Digit of Primes "))
#pd = 8
p = genPrime(pd)
q = genPrime(pd)
while( p==q):
    q = genPrime(pd)

print(f"Value of (p, q): ,({p},{q})")

n = p*q
phi = (p-1)*(q-1)

e= get_e(phi)
einv = eEuclid(e,phi)
d = einv
if(d < 0):
    d = phi - d
print("phi ",phi, " gcd of phi and e = ", gcd(e,phi)," and phi*e mod phi = ",(d*e)%phi)
print("*"*50)
print(f"Public Key (e, n): ({e}, {n})")
print(f"Private Key (d p,q): ({d}, {p}, {q})")
print("*"*50)

ch = 'y'
print()
while(ch == 'y'):
    M = int(input("Enter the message (in numerals 0-9): "))
    
    #encryption
    C = power(M,e,n)
    print("Encrypted Message (C):", C)
    print("*"*50)
    
    
    # decryption
    P = power(C,d,n)
    print("Decrypted Message:", P)
    print("*"*50)
    ch = input("Continue y/n ")
    
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


def generator(p: int):
    fact: List[int] = []
    phi = p - 1
    n = phi
    for i in range(2, int(n**0.5)+1):
        if n % i == 0:
            fact.append(i)
            while n % i == 0:
                n //= i
    if n > 1:
        fact.append(n)

    for res in range(2, p):
        ok = True
        for f in fact:
            if power(res, phi//f, p) == 1:
                ok = False
                break
        if ok:
            return res
    return -1

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


pd = int(input("Enter bits of prime number "))

p = genPrime(pd)
print("Value of p" ,p)
x = random_choose(p)

g = generator(p)
y = power(g,x,p)
print("*"*50)
print(f"Public Key (y, g, p): ({y}, {g}, {p})")
print("Private Key (x):", x)
print("*"*50)

ch = 'y'
while(ch == 'y'):
    M = int(input("Enter the message (in numerals 0-9): "))
    r = random_choose(p)

    C1 = (power(g,r,p)) % p
    C2 = ((power(y,r,p)) * M) % p
    print("Encrypted Message (C1):", C1)
    print("Encrypted Message (C2):", C2)
    print("*"*50)

    C1n = power(C1,x,p)
    P = (C2 * (power(C1n,p-2,p))) % p
    print("Decrypted Message:", P)
    print("*"*50)
    ch = input("Continue y/n ")
    
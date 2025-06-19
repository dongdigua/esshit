# rickroll keys

These keys were left here intentionally

I run https://github.com/danielewood/vanityssh-go
and found this key with fingerprint

```
SHA256:EHmAwM3nwEexo/N85QHMjBjR1cKroLumPRFWkg0YekU rick@roll (ED25519)
                              ^^^^^^^
```

So users can see the rickroll fingerprint when first connecting

lets do a simple calculation using high school knowledge:

say the regex is `r[1i]ckr[0o][1l]` and the SHA256 fingerprint's length is 44

then

$p=\dfrac{(44-7+1)\times2^4\times3^3}{64^{44}}$

$q=1-p$

and the expectation of total try is

$E(x)=p\times\sum_{i=1}^{+\infty}i\times q^{i-1}$

$=p\times(\lim_{n \to +\infty}(\dfrac{n}{q-1}-\dfrac{1}{(q-1)^2})\times q^n+\dfrac{1}{(q-1)^2})$

$=\dfrac{1}{p}$

$\approx 1.8057245884961589e+75$

my machine is 1e+5 key/s

=> a long time

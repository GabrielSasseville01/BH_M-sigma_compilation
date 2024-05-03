library(rstan)
library(rmutil)

N = 100000
mu = 7
c = 0.5
Y = rlevy(N, m=mu, s=c)

hist(Y, breaks=200)

fit = stan('levy.stan', data = list(N=N, Y=Y))

print(fit, pars = c("mu", "c"), digits = 4)

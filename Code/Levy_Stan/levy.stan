functions {
   /* ... function declarations and definitions ... */
   real levy_lpdf(real y, real mu, real c) {
    return log(sqrt(c / (2.0 * pi())) * exp(- c / (2.0 * (y - mu))) * pow(y - mu, -3.0/2.0));
  }

}
data {
  int<lower = 1> N;
  vector[N] Y;
}
parameters {
  real mu;
  real<lower = 0> c;
}
model {
  target += normal_lpdf(mu | 10, 5);
  target += normal_lpdf(c | 1, 0.5);
  for (n in 1:N) {
    target += levy_lpdf(Y[n] | mu, c);
  }
}

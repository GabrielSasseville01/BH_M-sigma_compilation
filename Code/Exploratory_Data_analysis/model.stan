data {
  int<lower=0> N;
  vector[N] X;
  vector[N] Y;
  vector[N] Y_err;
}
parameters {
  real alpha;
  real beta;
}
model {
  Y ~ normal(alpha + beta * X, Y_err);
}

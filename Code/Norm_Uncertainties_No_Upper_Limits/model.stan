// generated with brms 2.20.4
functions {
  /* hurdle lognormal log-PDF of a single response
   * logit parameterization of the hurdle part
   * Args:
   *   y: the response value
   *   mu: mean parameter of the lognormal distribution
   *   sigma: sd parameter of the lognormal distribution
   *   hu: linear predictor for the hurdle part
   * Returns:
   *   a scalar to be added to the log posterior
   */
  real hurdle_lognormal_logit_lpdf(real y, real mu, real sigma, real hu) {
    if (y == 0) {
      return bernoulli_logit_lpmf(1 | hu);
    } else {
      return bernoulli_logit_lpmf(0 | hu) +
             lognormal_lpdf(y | mu, sigma);
    }
  }
}
data {
  int<lower=1> N;  // total number of observations
  vector[N] Y;  // response variable (MBH)
  vector[N] Y_err; // measurement error on response variable (MBH)
  int<lower=1> K;  // number of population-level effects
  matrix[N, K] X;  // population-level design matrix
  int<lower=1> Kc;  // number of population-level effects after centering
  int<lower=1> K_hu;  // number of population-level effects
  matrix[N, K_hu] X_hu;  // population-level design matrix
  int<lower=1> Kc_hu;  // number of population-level effects after centering
  int Z[N]; // 1 if non-zero otherwise 0
  int prior_only;  // should the likelihood be ignored?
}
transformed data {
  matrix[N, Kc] Xc;  // centered version of X without an intercept
  vector[Kc] means_X;  // column means of X before centering
  matrix[N, Kc_hu] Xc_hu;  // centered version of X_hu without an intercept
  vector[Kc_hu] means_X_hu;  // column means of X_hu before centering
  for (i in 2:K) {
    means_X[i - 1] = mean(X[, i]);
    Xc[, i - 1] = X[, i] - means_X[i - 1];
  }
  for (i in 2:K_hu) {
    means_X_hu[i - 1] = mean(X_hu[, i]);
    Xc_hu[, i - 1] = X_hu[, i] - means_X_hu[i - 1];
  }
}
parameters {
  vector[Kc] b;  // regression coefficients
  real Intercept;  // temporary intercept for centered predictors
  real<lower=0> sigma;  // dispersion parameter
  vector[Kc_hu] b_hu;  // regression coefficients
  real Intercept_hu;  // temporary intercept for centered predictors
}
transformed parameters {
  real lprior = 0;  // prior contributions to the log posterior
  lprior += student_t_lpdf(Intercept | 3, 7.7, 2.5); # MODIFIED TO PRIOR OF LINEAR REGRESSION
  lprior += student_t_lpdf(sigma | 3, 0, 2.5)
    - 1 * student_t_lccdf(0 | 3, 0, 2.5);
  lprior += logistic_lpdf(Intercept_hu | 0, 1);
}
model {
  // likelihood including constants
  if (!prior_only) {
    // initialize linear predictor term
    vector[N] mu = rep_vector(0.0, N);
    // initialize linear predictor term
    vector[N] hu = rep_vector(0.0, N);
    mu += Intercept + Xc * b;
    hu += Intercept_hu + Xc_hu * b_hu;

    target += bernoulli_logit_lpmf(Z | hu);

    for (n in 1:N) {
      target += normal_lpdf(Y[n] | mu[n], Y_err[n]);
    }
  }
  // priors including constants
  target += lprior;
}
generated quantities {
  // actual population-level intercept
  real b_Intercept = Intercept - dot_product(means_X, b);
  // actual population-level intercept
  real b_hu_Intercept = Intercept_hu - dot_product(means_X_hu, b_hu);
}


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
  real levy_lpdf(real y, real mu, real c) {
    return (mu <= y && mu >= 0) ? log(sqrt(c / (2.0 * pi())) * exp(- c / (2.0 * (y - mu))) * pow(y - mu, -3.0/2.0)) : negative_infinity();
  }

  real truncated_normal_lpdf(real y, real mu, real sigma, real a, real b) {
    real A = (Phi((b - mu) / sigma) - Phi((a - mu) / sigma));
    if (y < a || y > b) {
      return negative_infinity();
    } else {
      return normal_lpdf(y | mu, sigma) - log(A);
    }
  }

  real mixture_lpdf(real y, real mu1, real sigma1, real mu2, real sigma2, real lambda, real a, real b) {
    real p1 = lognormal_lpdf(exp(y) | mu1, sigma1);
    real p2 = truncated_normal_lpdf(y | mu2, sigma2, a, b);
    return log_mix(lambda, p1, p2);
  }
}
data {
  int<lower=1> N;  // total number of observations
  int<lower=1> M; // number of simulated data points
  real<lower=0> sigma_mu; // mean of velocity dispersions for simulating data
  real<lower=0> sigma_std; // standard deviation of velocity dispersions for simulating data
  vector[N] Y;  // response variable (MBH)
  vector[N] Y_err; // measurement error on response variable (MBH)
  int<lower=1> K;  // number of population-level effects
  matrix[N, K] X;  // population-level design matrix
  int<lower=1> Kc;  // number of population-level effects after centering
  int<lower=1> K_hu;  // number of population-level effects
  matrix[N, K_hu] X_hu;  // population-level design matrix
  int<lower=1> Kc_hu;  // number of population-level effects after centering
  int Z[N]; // 1 if non-zero otherwise 0
  int U[N]; // 1 if upper limit otherwise 0
  int prior_only;  // should the likelihood be ignored?
  int weak_priors; // set to 1 if you want weakly informative priors. 0 for uniform
  real avgErr; // average uncertainty on non upper limits. Used for data simulation in generated quantities
}
transformed data {
  int<lower=1> P = M*10;
  int<lower=1> Q = M*100;
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
  vector[Kc_hu] b_hu;  // regression coefficients
  real Intercept_hu;  // temporary intercept for centered predictors
  real<lower=0, upper=1> lambda; // mixture weight
  real Intercept_ulimit;
  vector[Kc] b_ulimit;
}
transformed parameters {
  real lprior = 0;  // prior contributions to the log posterior
  // lprior += student_t_lpdf(Intercept | 3, 7.7, 2.5); # MODIFIED TO PRIOR OF LINEAR REGRESSION
  lprior -= student_t_lccdf(0 | 3, 0, 2.5);

  if (weak_priors) {
    lprior += normal_lpdf(b | 5, 5);
    lprior += normal_lpdf(Intercept | dot_product(means_X, b), 5); // 1 on uncentered
    lprior += normal_lpdf(b_hu | 5, 5);
    lprior += normal_lpdf(Intercept_hu | dot_product(means_X_hu, b_hu), 5); // 0 on uncentered
  } else {
    lprior += logistic_lpdf(Intercept_hu | 0, 1); // uniform prior for logistic intercept
  }
}
model {
  // likelihood including constants
  if (!prior_only) {
    // initialize linear predictor term
    vector[N] mu = rep_vector(0.0, N);
    vector[N] mu_ulimit = rep_vector(0.0, N);
    // initialize linear predictor term
    vector[N] hu = rep_vector(0.0, N);
    mu += Intercept + Xc * b;
    mu_ulimit += Intercept_ulimit + Xc * b_ulimit;
    hu += Intercept_hu + Xc_hu * b_hu;

    // increment logprob for hurdle portion
    target += bernoulli_logit_lpmf(Z | hu);

    // increment logprob for linear portion
    for (n in 1:N) {
      if (Y[n] != 0) { // only increment logprob for non-zeros
        if (U[n] == 1){
          // target += levy_lpdf(Y[n] | mu[n], Y_err[n]); // upper limit
          // target += truncated_normal_lpdf(Y[n] | mu[n], Y_err[n], 0, Y[n]);
          target += mixture_lpdf(Y[n] | mu[n], Y_err[n], mu_ulimit[n], Y_err[n], lambda, 0, Y[n] + Y_err[n]);
        } else {
          target += lognormal_lpdf(exp(Y[n]) | mu[n], Y_err[n]); // not upper limit
        }
      }
    }
  }
  // priors including constants
  target += lprior;
}
generated quantities {
  // actual population-level intercept
  real b_Intercept = Intercept - dot_product(means_X, b);
  real b_Intercept_ulimit = Intercept_ulimit - dot_product(means_X, b_ulimit);
  // actual population-level intercept
  real b_hu_Intercept = Intercept_hu - dot_product(means_X_hu, b_hu);

  // Posterior/Prior Predictive Checks (PPC) for 10 points
  vector[M] X_rep;

  for (m in 1:M) {
    X_rep[m] = normal_rng(1.96, 0.27); // from normal distribution fit to x data
  }

  // initialize linear predictor term
  vector[M] mu_sim = rep_vector(0.0, M);
  vector[M] hu_sim = rep_vector(0.0, M);

  mu_sim = b_Intercept + X_rep * b[1];
  hu_sim = b_hu_Intercept + X_rep * b_hu[1];

  // PPC samples
  real tmp; // temporary variable
  vector[M] linear_sim;
  vector[M] hurdle_sim;

  for (m in 1:M) {
    tmp = normal_rng(mu_sim[m], avgErr);
    if (!prior_only) {
      while (tmp < 0) { // removing non physical negative outliers
        tmp = normal_rng(mu_sim[m], avgErr);
      }
    }
    linear_sim[m] = tmp;
    hurdle_sim[m] = bernoulli_logit_rng(hu_sim[m]);
  }

  // Posterior/Prior Predictive Checks (PPC) for 100 points
  vector[P] X_rep_10x;

  for (p in 1:P) {
    X_rep_10x[p] = normal_rng(2.143, 0.266); // from normal distribution fit to x data
  }

  // initialize linear predictor term
  vector[P] mu_sim_10x = rep_vector(0.0, P);
  vector[P] hu_sim_10x = rep_vector(0.0, P);

  mu_sim_10x = b_Intercept + X_rep_10x * b[1];
  hu_sim_10x = b_hu_Intercept + X_rep_10x * b_hu[1];

  // PPC samples
  real tmp_10x; // temporary variable
  vector[P] linear_sim_10x;
  vector[P] hurdle_sim_10x;

  for (p in 1:P) {
    tmp_10x = normal_rng(mu_sim_10x[p], avgErr);
    if (!prior_only) {
      while (tmp_10x < 0) { // removing non physical negative outliers
        tmp_10x = normal_rng(mu_sim_10x[p], avgErr);
      }
    }
    linear_sim_10x[p] = tmp_10x;
    hurdle_sim_10x[p] = bernoulli_logit_rng(hu_sim_10x[p]);
  }

  // Posterior/Prior Predictive Checks (PPC) for 100 points
  vector[Q] X_rep_100x;

  for (q in 1:Q) {
    X_rep_100x[q] = normal_rng(2.143, 0.266); // from normal distribution fit to x data
  }

  // initialize linear predictor term
  vector[Q] mu_sim_100x = rep_vector(0.0, Q);
  vector[Q] hu_sim_100x = rep_vector(0.0, Q);

  mu_sim_100x = b_Intercept + X_rep_100x * b[1];
  hu_sim_100x = b_hu_Intercept + X_rep_100x * b_hu[1];

  // PPC samples
  real tmp_100x; // temporary variable
  vector[Q] linear_sim_100x;
  vector[Q] hurdle_sim_100x;

  for (q in 1:Q) {
    tmp_100x = normal_rng(mu_sim_100x[q], avgErr);
    if (!prior_only) {
      while (tmp_100x < 0) { // removing non physical negative outliers
        tmp_100x = normal_rng(mu_sim_100x[q], avgErr);
      }
    }
    linear_sim_100x[q] = tmp_100x;
    hurdle_sim_100x[q] = bernoulli_logit_rng(hu_sim_100x[q]);
  }
  
}

library(bayesplot)
library(ggplot2)
library(rstan)

posterior_samples <- read.table('./samples.txt', header = FALSE)
colnames(posterior_samples) <- c('beta0_post', 'beta1_post', 'gamma0_post', 'gamma1_post')

posterior_samples_ulimit <- read.table('./samples_ulimit.txt', header = FALSE)
colnames(posterior_samples_ulimit) <- c('beta0_post', 'beta1_post', 'gamma0_post_ulimit', 'gamma1_post_ulimit')

posterior_samples_lambda <- read.table('./lambda.txt', header = FALSE)
colnames(posterior_samples_lambda) <- c('lambda')

mcmc_samples <- as.array(as.matrix(posterior_samples))
mcmc_samples_ulimit <- as.array(as.matrix(posterior_samples_ulimit))
mcmc_samples_lambda <- as.array(as.matrix(posterior_samples_lambda))

mcmc_trace(mcmc_samples, pars = c('beta0_post', 'beta1_post', 'gamma0_post', 'gamma1_post')) +
  ggtitle("Trace Plots for Regression Coefficients")

mcmc_trace(mcmc_samples_ulimit, pars = c('gamma0_post_ulimit', 'gamma1_post_ulimit')) +
  ggtitle("Trace Plots for Upper Limit Coefficients")

mcmc_trace(mcmc_samples_lambda, pars = 'lambda') +
  ggtitle("Trace Plots for Mixture Weight")

mcmc_dens(mcmc_samples, pars = c('beta0_post', 'beta1_post', 'gamma0_post', 'gamma1_post')) +
  ggtitle("Posterior Density for Regression Coefficients")

mcmc_dens(mcmc_samples_ulimit, pars = c('gamma0_post_ulimit', 'gamma1_post_ulimit')) +
  ggtitle("Posterior Density for Upper Limit Coefficients")

mcmc_dens(mcmc_samples_lambda, pars = 'lambda') +
  ggtitle("Posterior Density for Mixture Weight")

mcmc_intervals(mcmc_samples, pars = c('beta0_post', 'beta1_post', 'gamma0_post', 'gamma1_post')) +
  ggtitle("Posterior Intervals for Regression Coefficients")

mcmc_intervals(mcmc_samples_ulimit, pars = c('gamma0_post_ulimit', 'gamma1_post_ulimit')) +
  ggtitle("Posterior Intervals for Upper Limit Coefficients")

mcmc_intervals(mcmc_samples_lambda, pars = 'lambda') +
  ggtitle("Posterior Intervals for Mixture Weight")

x_rep <- read.table('./post_pred_check_x.txt', header = FALSE)
linear_rep <- read.table('./post_pred_check_lin.txt', header = FALSE)
hurdle_rep <- read.table('./post_pred_check_hur.txt', header = FALSE)

mcmc_areas(as.matrix(x_rep), prob = 0.8) +
  ggtitle("Posterior Predictive Check for X")

mcmc_areas(as.matrix(linear_rep), prob = 0.8) +
  ggtitle("Posterior Predictive Check for Linear Simulations")

mcmc_areas(as.matrix(hurdle_rep), prob = 0.8) +
  ggtitle("Posterior Predictive Check for Hurdle Simulations")

pp_check(stan_fit, ndraws = 100) + 
  ggtitle("Posterior Predictive Check")

pp_check()

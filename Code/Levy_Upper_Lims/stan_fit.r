library(rstan)

# Read the CSV file
full_data = read.csv('../../Data/BHcompilation_updated.csv', encoding = 'ISO-8859-1')

# Data for fitting
data = full_data[full_data$SELECTED == 1, ]

# Normalizing uncertainties to 3-sigma values
data$DMBH[data$CONFLEVEL == 1] = data$DMBH[data$CONFLEVEL == 1] * 3
data$DMBH[data$CONFLEVEL == 2] = data$DMBH[data$CONFLEVEL == 2] * (3/2)

# Reset the indices to avoid issues later on
data = data[ , !(names(data) %in% "index")]  # Remove the existing index column
row.names(data) = NULL  # Reset row names

isZero = ifelse(data$MBH > 0, 1, 0)
isUpperLimit = data$UPPERLIMIT

avgErr = mean(data$DMBH[data$UPPERLIMIT == 0])

# Prior Predictive Checking
# Define the data for Stan
stan_data = list(
  N = nrow(data),
  M = 10,
  sigma_mu = 1.96,
  sigma_std = 0.27,
  Y = exp(data$MBH),
  Y_err = data$DMBH,
  Z = isZero,
  U = isUpperLimit,
  K = ncol(model.matrix(~ SIG, data)),
  X = model.matrix(~ SIG, data),
  Kc = ncol(model.matrix(~ SIG - 1, data)),
  K_hu = ncol(model.matrix(~ SIG, data)),
  X_hu = model.matrix(~ SIG, data),
  Kc_hu = ncol(model.matrix(~ SIG - 1, data)),
  prior_only = 1, # Set to 1 if you want to ignore likelihood and sample from the prior
  weak_priors = 1, # Set to 0 for uniform priors or 1 for weak priors
  avgErr = avgErr
)

stan_fit = stan('model.stan', data = stan_data, iter = 2000, chains = 4, init = 0, seed = 1)

posterior_samples = extract(stan_fit)

x_rep = posterior_samples$X_rep
linear_rep = posterior_samples$linear_sim
hurdle_rep = posterior_samples$hurdle_sim
y_rep = posterior_samples$Y_rep

write.table(x_rep, './prior_pred_check_x.txt', row.names=FALSE, col.names=FALSE, fileEncoding='UTF-8')
write.table(linear_rep, './prior_pred_check_lin.txt', row.names=FALSE, col.names=FALSE, fileEncoding='UTF-8')
write.table(hurdle_rep, './prior_pred_check_hur.txt', row.names=FALSE, col.names=FALSE, fileEncoding='UTF-8')
write.table(y_rep, './prior_pred_check_y.txt', row.names=FALSE, col.names=FALSE, fileEncoding='UTF-8')

beta0_post = c(extract(stan_fit, pars = 'b_hu_Intercept', permuted = FALSE, inc_warmup=TRUE))
beta1_post = c(extract(stan_fit, pars = 'b_hu', permuted = FALSE, inc_warmup=TRUE))
gamma0_post = c(extract(stan_fit, pars = 'b_Intercept', permuted = FALSE, inc_warmup=TRUE))
gamma1_post = c(extract(stan_fit, pars = 'b', permuted = FALSE, inc_warmup=TRUE))

stan_samples = data.frame(beta0_post, beta1_post, gamma0_post, gamma1_post, row.names=NULL)

write.table(stan_samples, './prior_samples_full.txt', row.names=FALSE, col.names=FALSE, fileEncoding = 'UTF-8')

# Fitting the model
# Define the data for Stan
stan_data = list(
  N = nrow(data),
  M = 10,
  sigma_mu = 1.96,
  sigma_std = 0.27,
  Y = exp(data$MBH),
  Y_err = data$DMBH,
  Z = isZero,
  U = isUpperLimit,
  K = ncol(model.matrix(~ SIG, data)),
  X = model.matrix(~ SIG, data),
  Kc = ncol(model.matrix(~ SIG - 1, data)),
  K_hu = ncol(model.matrix(~ SIG, data)),
  X_hu = model.matrix(~ SIG, data),
  Kc_hu = ncol(model.matrix(~ SIG - 1, data)),
  prior_only = 0, # Set to 1 if you want to ignore likelihood and sample from the prior
  weak_priors = 1, # Set to 0 for uniform priors or 1 for weak priors
  avgErr = avgErr
)

# Fit the Stan model
stan_fit = stan('model.stan', data = stan_data, iter = 2000, chains = 4, init = 0, seed = 1)

# Save chain samples (after warmup) to compute statistics 
posterior_samples = extract(stan_fit)

beta0_post = posterior_samples$b_hu_Intercept
beta1_post = posterior_samples$b_hu
gamma0_post = posterior_samples$b_Intercept
gamma1_post = posterior_samples$b

stan_samples = data.frame(beta0_post, beta1_post, gamma0_post, gamma1_post, row.names=NULL)

write.table(stan_samples, './samples.txt', row.names=FALSE, col.names=FALSE, fileEncoding = 'UTF-8')


# Save all chain samples to visualize convergence
beta0_post = c(extract(stan_fit, pars = 'b_hu_Intercept', permuted = FALSE, inc_warmup=TRUE))
beta1_post = c(extract(stan_fit, pars = 'b_hu', permuted = FALSE, inc_warmup=TRUE))
gamma0_post = c(extract(stan_fit, pars = 'b_Intercept', permuted = FALSE, inc_warmup=TRUE))
gamma1_post = c(extract(stan_fit, pars = 'b', permuted = FALSE, inc_warmup=TRUE))

stan_samples = data.frame(beta0_post, beta1_post, gamma0_post, gamma1_post, row.names=NULL)

write.table(stan_samples, './samples_full.txt', row.names=FALSE, col.names=FALSE, fileEncoding = 'UTF-8')


# Posterior Predictive  Checking
x_rep = posterior_samples$X_rep
linear_rep = posterior_samples$linear_sim
hurdle_rep = posterior_samples$hurdle_sim

write.table(x_rep, './post_pred_check_x.txt', row.names=FALSE, col.names=FALSE, fileEncoding='UTF-8')
write.table(linear_rep, './post_pred_check_lin.txt', row.names=FALSE, col.names=FALSE, fileEncoding='UTF-8')
write.table(hurdle_rep, './post_pred_check_hur.txt', row.names=FALSE, col.names=FALSE, fileEncoding='UTF-8')

x_rep_10x = posterior_samples$X_rep_10x
linear_rep_10x = posterior_samples$linear_sim_10x
hurdle_rep_10x = posterior_samples$hurdle_sim_10x

write.table(x_rep_10x, './post_pred_check_x_10x.txt', row.names=FALSE, col.names=FALSE, fileEncoding='UTF-8')
write.table(linear_rep_10x, './post_pred_check_lin_10x.txt', row.names=FALSE, col.names=FALSE, fileEncoding='UTF-8')
write.table(hurdle_rep_10x, './post_pred_check_hur_10x.txt', row.names=FALSE, col.names=FALSE, fileEncoding='UTF-8')

x_rep_100x = posterior_samples$X_rep_100x
linear_rep_100x = posterior_samples$linear_sim_100x
hurdle_rep_100x = posterior_samples$hurdle_sim_100x

write.table(x_rep_100x, './post_pred_check_x_100x.txt', row.names=FALSE, col.names=FALSE, fileEncoding='UTF-8')
write.table(linear_rep_100x, './post_pred_check_lin_100x.txt', row.names=FALSE, col.names=FALSE, fileEncoding='UTF-8')
write.table(hurdle_rep_100x, './post_pred_check_hur_100x.txt', row.names=FALSE, col.names=FALSE, fileEncoding='UTF-8')















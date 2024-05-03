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

obs_x = data$SIG[data$UPPERLIMIT == 0]
obs_y = data$MBH[data$UPPERLIMIT == 0]
obs_err = data$DMBH[data$UPPERLIMIT == 0]
obs_N = length(obs_x)

upp_x = data$SIG[data$UPPERLIMIT == 1]
upp_y = data$MBH[data$UPPERLIMIT == 1]
upp_err = data$DMBH[data$UPPERLIMIT == 1]
upp_N = length(upp_y)

# Define the data for Stan
obs_stan_data = list(
  N = obs_N,
  X = obs_x,
  Y = obs_y,
  Y_err = obs_err
)

upp_stan_data = list(
  N = upp_N,
  X = upp_x,
  Y = upp_y,
  Y_err = upp_err
)

# Fit the Stan model
obs_stan_fit = stan('model.stan', data = obs_stan_data, iter = 2000, chains = 4)

upp_stan_fit = stan('model.stan', data = upp_stan_data, iter = 2000, chains = 4)

# Extract data
posterior_samples = extract(obs_stan_fit)

gamma0_post = posterior_samples$alpha
gamma1_post = posterior_samples$beta

stan_samples = data.frame(gamma0_post, gamma1_post, row.names=NULL)

write.table(stan_samples, './obs_samples.txt', row.names=FALSE, col.names=FALSE, fileEncoding = 'UTF-8')

posterior_samples = extract(upp_stan_fit)

gamma0_post = posterior_samples$alpha
gamma1_post = posterior_samples$beta

stan_samples = data.frame(gamma0_post, gamma1_post, row.names=NULL)

write.table(stan_samples, './upp_samples.txt', row.names=FALSE, col.names=FALSE, fileEncoding = 'UTF-8')


# Save chain samples to visualize convergence

beta0_post = c(extract(stan_fit, pars = 'b_hu_Intercept', permuted = FALSE, inc_warmup=TRUE))
beta1_post = c(extract(stan_fit, pars = 'b_hu', permuted = FALSE, inc_warmup=TRUE))
gamma0_post = c(extract(stan_fit, pars = 'b_Intercept', permuted = FALSE, inc_warmup=TRUE))
gamma1_post = c(extract(stan_fit, pars = 'b', permuted = FALSE, inc_warmup=TRUE))

stan_samples = data.frame(beta0_post, beta1_post, gamma0_post, gamma1_post, row.names=NULL)

write.table(stan_samples, './stan_samples_full.txt', row.names=FALSE, col.names=FALSE, fileEncoding = 'UTF-8')



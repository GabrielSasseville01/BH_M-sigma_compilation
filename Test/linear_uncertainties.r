# library(brms)
# library(ggplot2)
# library(latex2exp)

## Method 1 - BRMS

# Read the CSV file
full_data = read.csv('../../../Data/BHcompilation_updated.csv', encoding = 'ISO-8859-1')

# Data for fitting
data = full_data[full_data$SELECTED == 1, ]

# Normalizing uncertainties to 3-sigma values
data$DMBH[data$CONFLEVEL == 1] = data$DMBH[data$CONFLEVEL == 1] * 3
data$DMBH[data$CONFLEVEL == 2] = data$DMBH[data$CONFLEVEL == 2] * (3/2)

# Reset the indices to avoid issues later on
data = data[ , !(names(data) %in% "index")]  # Remove the existing index column
row.names(data) = NULL  # Reset row names

isZero = ifelse(data$MBH > 0, 1, 0)

# data_nonzero = data[data$MBH != 0, ]
# data_zero = data[data$MBH == 0, ]

# # Fitting model
# hurdlefit = brm(brmsformula(MBH ~ SIG, hu ~ SIG), family='hurdle_lognormal', data=data)

# # Visualize the fit with conditional effects
# data_hurdlefit = conditional_effects(hurdlefit)[[1]]

# brmsdf = data.frame(data_hurdlefit$SIG, data_hurdlefit$estimate__, data_hurdlefit$lower__, data_hurdlefit$upper__, row.names=NULL)
# write.table(brmsdf, './brms_conditional_effects.txt', row.names=FALSE, col.names=FALSE, fileEncoding = 'UTF-8')

# ggplot(data, aes(x = SIG, y = MBH, color = TYPE)) +
#   geom_point() +
#   geom_line(data = data_hurdlefit, mapping = aes(x = SIG, y = estimate__), color = "black") +
#   labs(x = expression(paste(sigma, " log(km/s)")),
#        y = expression(paste("M", subscript("bullet"), " log(M", subscript("\u2609"), ")")))

# # Visualize the fit with posterior samples
# post_samples = posterior_samples(hurdlefit, )

# beta0 = (post_samples$b_hu_Intercept)
# beta1 = (post_samples$b_hu_SIG)
# gamma0 = exp(post_samples$b_Intercept)
# gamma1 = exp(post_samples$b_SIG)

# brms_samples = data.frame(beta0, beta1, gamma0, gamma1, row.names=NULL)
# write.table(brms_samples, './brms_samples.txt', row.names=FALSE, col.names=FALSE, fileEncoding = 'UTF-8')

## Method 2 - Stan

# stan_code = make_stancode(brmsformula(MBH ~ SIG, hu ~ SIG), family='hurdle_lognormal', data=data)
# writeLines(stan_code, 'makecode.stan')

library(rstan)

# Define the data for Stan
stan_data = list(
  N = nrow(data),
  Y = data$MBH,
  Y_err = data$DMBH,
  Z = isZero,
  K = ncol(model.matrix(~ SIG, data)),
  X = model.matrix(~ SIG, data),
  Kc = ncol(model.matrix(~ SIG - 1, data)),
  K_hu = ncol(model.matrix(~ SIG, data)),
  X_hu = model.matrix(~ SIG, data),
  Kc_hu = ncol(model.matrix(~ SIG - 1, data)),
  prior_only = 0  # Set to 1 if you want to ignore likelihood and sample from the prior
)

# Fit the Stan model
stan_fit = stan('linear_uncertainties.stan', data = stan_data, iter = 2000, chains = 4)

posterior_samples = extract(stan_fit)

beta0_post = posterior_samples$b_hu_Intercept
beta1_post = posterior_samples$b_hu
gamma0_post = posterior_samples$b_Intercept
gamma1_post = posterior_samples$b

stan_samples = data.frame(beta0_post, beta1_post, gamma0_post, gamma1_post, row.names=NULL)

write.table(stan_samples, './linear_uncertainties.txt', row.names=FALSE, col.names=FALSE, fileEncoding = 'UTF-8')


# beta0_post = c(extract(stan_fit, pars = 'b_hu_Intercept', permuted = FALSE, inc_warmup=TRUE))
# beta1_post = c(extract(stan_fit, pars = 'b_hu', permuted = FALSE, inc_warmup=TRUE))
# gamma0_post = c(extract(stan_fit, pars = 'b_Intercept', permuted = FALSE, inc_warmup=TRUE))
# gamma1_post = c(extract(stan_fit, pars = 'b', permuted = FALSE, inc_warmup=TRUE))

# stan_samples = data.frame(beta0_post, beta1_post, gamma0_post, gamma1_post, row.names=NULL)

# write.table(stan_samples, './stan_samples_full_linear.txt', row.names=FALSE, col.names=FALSE, fileEncoding = 'UTF-8')

library(brms)
library(ggplot2)
library(ggpubr)
library(latex2exp)

# Importing data
data <- read.csv('C:\\Users\\Owner\\Desktop\\Stage_2022\\BH_M-sigma_compilation\\Data\\potentialerror.csv')

# Creating data for fits
data_fitting <- data.frame(data)
data_fitting <- subset(data, SELECTED == 1)

# Fitting data (Bayesian lognormal hurdle model)
hurdlefit <- brm(brmsformula(MBH ~ SIG, hu ~ SIG),
                 family="hurdle_lognormal", data = data_fitting)

# Fitting data (Bayesian linear regression)
linregB <- brm(MBH | se(DMBH) ~ SIG, data = data_fitting)

# Fitting data (Frequentist linear regression)
linregF <- lm(MBH ~ SIG, data = data_fitting)

# Acquiring data from fits for plotting
data_hurdlefit <- conditional_effects(hurdlefit)[[1]]
data_linregB <- conditional_effects(linregB)[[1]]

# Modifying upper limits of data for plot labels
data_range <- 1:length(data$MBH)

for (i in data_range) {
  if (data[[10]][[i]] == 1) {
    data[[10]][[i]] = 'yes'
  } else {
    data[[10]][[i]] = 'no'
  }
}

# Modifying types of BHs for plot labels
for (i in data_range) {
  # gas and CO
  if (data[[27]][[i]] == 'CO') {
    data[[27]][[i]] = 'gas'
  }
  
  # stars
  if (data[[27]][[i]] == 'star') {
    data[[27]][[i]] = 'stars'
  }
  
  # reverberation
  if (data[[27]][[i]] == 'reverb') {
    data[[27]][[i]] = 'reverberation'
  }
  
  # omitted
  if (data[[3]][[i]] != 1) {
    data[[27]][[i]] = 'omitted'
  }
}

# Customizing labels for plots
methods = c('reverberation' = '#E69F00', 'gas' = '#56B4E9', 'stars' = '#CC79A7', 'maser' = '#009E73', 'omitted' = "#999999")
upplims = c('yes' = 6, 'no' = 20)
sizes = c('yes' = 1, 'no' = 2)

# Plotting
ggplot(NULL) +
  geom_point(data = data, mapping = aes(SIG, MBH, colour = TYPE, shape = UPPERLIMIT, size = UPPERLIMIT)) +
  scale_color_manual(values = methods) +
  scale_shape_manual(values = upplims) +
  scale_size_manual(values = sizes) +
  geom_line(data = data_hurdlefit, mapping = aes(SIG, estimate__)) +
  geom_ribbon(data = data_hurdlefit, mapping = aes(x = SIG, ymin = lower__, ymax = upper__), fill = 'grey70', alpha = 0.3) +
  geom_line(data = data_linregB, mapping = aes(SIG, estimate__), linetype = 'dashed', color = '#D55E00') +
  geom_smooth(data = data_fitting, mapping = aes(SIG, MBH), method = 'lm', linetype = 'dotted', color = 'green', size = 0.6, se = FALSE) +
  stat_regline_equation(data = data_fitting, mapping = aes(x = SIG, y = MBH), label.y = 8) +
  stat_cor(data = data_fitting, mapping = aes(x = SIG, y = MBH, label =  ..rr.label..), label.y = 9) +
  xlim(1.1, 2.8) +
  ylim(-1, 11) +
  guides(size = 'none') +
  labs(x = TeX(r'($\sigma$ (log km/s))'), y = TeX(r'($M_{\bullet}$ (log$M_{\odot}$) )'), color = 'Method', shape = 'Upper limit') +
  theme_bw()

# Saving plot
ggsave(filename = 'R_fig3.png', path = 'C:\\Users\\Owner\\Desktop\\Stage_2022\\BH_M-sigma_compilation\\Figures\\', units = 'in', width = 8, height = 8, dpi = 700)



library(comprehenr)
library(ggplot2)
library(latex2exp)
library(brms)

data <- read.csv('C:\\Users\\Owner\\Desktop\\Stage_2022\\Project\\Black-Hole-Mass-compilation\\Data\\BHcompilation_updated.csv')

mass = data$MBH
mass_err = data$DMBH
sigma = data$SIG
sigma_err = data$DSIG
upplims = data$UPPERLIMIT
selected = data$SELECTED
method = data$TYPE

data_range = 1:length(mass)


## All data is stored in a list of 4 lists indexed as such: 0 --> sigma  1 --> mass  2 --> sigma error  3 --> mass error
# upper limits
ul_reverb = list(to_list(for (i in data_range) if (method[i] == 'reverb' && selected[i] == 1 && upplims[i] == 1) sigma[i]), to_list(for (i in data_range) if (method[i] == 'reverb' && selected[i] == 1 && upplims[i] == 1) mass[i]), to_list(for (i in data_range) if (method[i] == 'reverb' && selected[i] == 1 && upplims[i] == 1) sigma_err[i]), to_list(for (i in data_range) if (method[i] == 'reverb' && selected[i] == 1 && upplims[i] == 1) mass_err[i]))
ul_gas = list(to_list(for (i in data_range) if ((method[i] == 'gas' || method[i] == 'CO') && selected[i] == 1 && upplims[i] == 1) sigma[i]), to_list(for (i in data_range) if ((method[i] == 'gas' || method[i] == 'CO') && selected[i] == 1 && upplims[i] == 1) mass[i]), to_list(for (i in data_range) if ((method[i] == 'gas' || method[i] == 'CO') && selected[i] == 1 && upplims[i] == 1) sigma_err[i]), to_list(for (i in data_range) if ((method[i] == 'gas' || method[i] == 'CO') && selected[i] == 1 && upplims[i] == 1) mass_err[i]))
ul_stars = list(to_list(for (i in data_range) if ((method[i] == 'stars' || method[i] == 'star') && selected[i] == 1 && upplims[i] == 1) sigma[i]), to_list(for (i in data_range) if ((method[i] == 'stars' || method[i] == 'star') && selected[i] == 1 && upplims[i] == 1) mass[i]), to_list(for (i in data_range) if ((method[i] == 'stars' || method[i] == 'star') && selected[i] == 1 && upplims[i] == 1) sigma_err[i]), to_list(for (i in data_range) if ((method[i] == 'stars' || method[i] == 'star') && selected[i] == 1 && upplims[i] == 1) mass_err[i]))
ul_maser = list(to_list(for (i in data_range) if (method[i] == 'maser' && selected[i] == 1 && upplims[i] == 1) sigma[i]), to_list(for (i in data_range) if (method[i] == 'maser' && selected[i] == 1 && upplims[i] == 1) mass[i]), to_list(for (i in data_range) if (method[i] == 'maser' && selected[i] == 1 && upplims[i] == 1) sigma_err[i]), to_list(for (i in data_range) if (method[i] == 'maser' && selected[i] == 1 && upplims[i] == 1) mass_err[i]))
ul_omitted = list(to_list(for (i in data_range) if (selected[i] != 1 && upplims[i] == 1) sigma[i]), to_list(for (i in data_range) if (selected[i] != 1 && upplims[i] == 1) mass[i]), to_list(for (i in data_range) if (selected[i] != 1 && upplims[i] == 1) sigma_err[i]), to_list(for (i in data_range) if (selected[i] != 1 && upplims[i] == 1) mass_err[i]))

# true masses
t_reverb = list(to_list(for (i in data_range) if (method[i] == 'reverb' && selected[i] == 1 && upplims[i] == 0) sigma[i]), to_list(for (i in data_range) if (method[i] == 'reverb' && selected[i] == 1 && upplims[i] == 0) mass[i]), to_list(for (i in data_range) if (method[i] == 'reverb' && selected[i] == 1 && upplims[i] == 0) sigma_err[i]), to_list(for (i in data_range) if (method[i] == 'reverb' && selected[i] == 1 && upplims[i] == 0) mass_err[i]))
t_gas = list(to_list(for (i in data_range) if ((method[i] == 'gas' || method[i] == 'CO') && selected[i] == 1 && upplims[i] == 0) sigma[i]), to_list(for (i in data_range) if ((method[i] == 'gas' || method[i] == 'CO') && selected[i] == 1 && upplims[i] == 0) mass[i]), to_list(for (i in data_range) if ((method[i] == 'gas' || method[i] == 'CO') && selected[i] == 1 && upplims[i] == 0) sigma_err[i]), to_list(for (i in data_range) if ((method[i] == 'gas' || method[i] == 'CO') && selected[i] == 1 && upplims[i] == 0) mass_err[i]))
t_stars = list(to_list(for (i in data_range) if ((method[i] == 'stars' || method[i] == 'star') && selected[i] == 1 && upplims[i] == 0) sigma[i]), to_list(for (i in data_range) if ((method[i] == 'stars' || method[i] == 'star') && selected[i] == 1 && upplims[i] == 0) mass[i]), to_list(for (i in data_range) if ((method[i] == 'stars' || method[i] == 'star') && selected[i] == 1 && upplims[i] == 0) sigma_err[i]), to_list(for (i in data_range) if ((method[i] == 'stars' || method[i] == 'star') && selected[i] == 1 && upplims[i] == 0) mass_err[i]))
t_maser = list(to_list(for (i in data_range) if (method[i] == 'maser' && selected[i] == 1 && upplims[i] == 0) sigma[i]), to_list(for (i in data_range) if (method[i] == 'maser' && selected[i] == 1 && upplims[i] == 0) mass[i]), to_list(for (i in data_range) if (method[i] == 'maser' && selected[i] == 1 && upplims[i] == 0) sigma_err[i]), to_list(for (i in data_range) if (method[i] == 'maser' && selected[i] == 1 && upplims[i] == 0) mass_err[i]))
t_omitted = list(to_list(for (i in data_range) if (selected[i] != 1 && upplims[i] == 0) sigma[i]), to_list(for (i in data_range) if (selected[i] != 1 && upplims[i] == 0) mass[i]), to_list(for (i in data_range) if (selected[i] != 1 && upplims[i] == 0) sigma_err[i]), to_list(for (i in data_range) if (selected[i] != 1 && upplims[i] == 0) mass_err[i]))

# modifying upper limits of data
for (i in data_range) {
  if (data[[10]][[i]] == 1) {
    data[[10]][[i]] = 'yes'
  } else {
    data[[10]][[i]] = 'no'
  }
}

# modifying types of data
for (i in data_range) {
  # gas and CO
  if (data[[27]][[i]] == 'CO') {
    data[[27]][[i]] = 'gas'
  }
  
  # stars
  if (data[[27]][[i]] == 'star') {
    data[[27]][[i]] = 'stars'
  }
  
  # omitted
  if (data[[3]][[i]] != 1) {
    data[[27]][[i]] = 'omitted'
  }
}


methods = c('reverb' = 'black', 'gas' = 'blue', 'stars' = 'red', 'maser' = 'green', 'omitted' = 'grey')
upplims = c('yes' = 6, 'no' = 20)
sizes = c(2, 1)

ggplot(data, aes(SIG, MBH)) +
  geom_point(aes(colour = TYPE, shape = UPPERLIMIT, size = UPPERLIMIT)) +
  scale_color_manual(values = methods) +
  scale_shape_manual(values = upplims) +
  scale_size_manual(values = sizes) + 
  labs(x = 'velocity dispersion (log km/s)', y = TeX(r'($M_{BH}$ log($M_\odot$) )')) +
  geom_smooth(method = lm, se = F) +
  xlim(1.1, 2.8) +
  ylim(-1, 11)+
  theme_bw()


for (i in data_range) {
  if (data[[11]][[i]] < 0) {
    print(data[[3]][[i]])
  }
}


                                         
                                         
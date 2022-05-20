library(brms)
library(dplyr)

data <- read.csv('C:\\Users\\Owner\\Desktop\\Stage_2022\\Project\\Black-Hole-Mass-compilation\\Data\\BHcompilation_updated.csv')


data %>%
  filter(SELECTED == 1) %>%
  linreg <- brm(MBH ~ SIG, data)
  conditional_effects(linreg)

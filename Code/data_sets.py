import matplotlib.pyplot as plt
import numpy as np
from matplotlib.markers import MarkerStyle
from astropy.io import fits

## Data

# file to acquire data
file = '../Data/BHcompilation_updated.fits'

# creating data lists
hdu = fits.open(file)
data = hdu[1].data

mass = data.field('MBH')
mass_err = data.field('DMBH')
sigma = data.field('SIG')
sigma_err = data.field('DSIG')
upplims = data.field('UPPERLIMIT')
selected = data.field('SELECTED')
method = data.field('TYPE')

# Constants
N = len(sigma)
data_range = range(0, N)

# linear data
x = np.linspace(0, 3, num=100)
y = -4 + 5.35*x

## All data is stored in a list of 4 lists indexed as such: 0 --> sigma  1 --> mass  2 --> sigma error  3 --> mass error
# upper limits
ul_reverb = [[sigma[i] for i in data_range if (method[i] == 'reverb' and selected[i] == 1 and upplims[i] == 1)], [mass[i] for i in data_range if (method[i] == 'reverb' and selected[i] == 1 and upplims[i] == 1)], [sigma_err[i] for i in data_range if (method[i] == 'reverb' and selected[i] == 1 and upplims[i] == 1)], [mass_err[i] for i in data_range if (method[i] == 'reverb' and selected[i] == 1 and upplims[i] == 1)]]
ul_gas = [[sigma[i] for i in data_range if ((method[i] == 'gas' or method[i] == 'CO') and selected[i] == 1 and upplims[i] == 1)], [mass[i] for i in data_range if ((method[i] == 'gas' or method[i] == 'CO') and selected[i] == 1 and upplims[i] == 1)], [sigma_err[i] for i in data_range if (method[i] == 'gas' and selected[i] == 1 and upplims[i] == 1)], [mass_err[i] for i in data_range if (method[i] == 'gas' and selected[i] == 1 and upplims[i] == 1)]]
ul_stars = [[sigma[i] for i in data_range if ((method[i] == 'stars' or method[i] == 'star') and selected[i] == 1 and upplims[i] == 1)], [mass[i] for i in data_range if ((method[i] == 'stars' or method[i] == 'star') and selected[i] == 1 and upplims[i] == 1)], [sigma_err[i] for i in data_range if ((method[i] == 'stars' or method[i] == 'star') and selected[i] == 1 and upplims[i] == 1)], [mass_err[i] for i in data_range if ((method[i] == 'stars' or method[i] == 'star') and selected[i] == 1 and upplims[i] == 1)]]
ul_maser = [[sigma[i] for i in data_range if (method[i] == 'maser' and selected[i] == 1 and upplims[i] == 1)], [mass[i] for i in data_range if (method[i] == 'maser' and selected[i] == 1 and upplims[i] == 1)], [sigma_err[i] for i in data_range if (method[i] == 'maser' and selected[i] == 1 and upplims[i] == 1)], [mass_err[i] for i in data_range if (method[i] == 'maser' and selected[i] == 1 and upplims[i] == 1)]]
ul_omitted = [[sigma[i] for i in data_range if (selected[i] != 1 and upplims[i] == 1)], [mass[i] for i in data_range if (selected[i] != 1 and upplims[i] == 1)], [sigma_err[i] for i in data_range if (selected[i] != 1 and upplims[i] == 1)], [mass_err[i] for i in data_range if (selected[i] != 1 and upplims[i] == 1)]]

# precise masses
t_reverb = [[sigma[i] for i in data_range if (method[i] == 'reverb' and selected[i] == 1 and upplims[i] == 0)], [mass[i] for i in data_range if (method[i] == 'reverb' and selected[i] == 1 and upplims[i] == 0)], [sigma_err[i] for i in data_range if (method[i] == 'reverb' and selected[i] == 1 and upplims[i] == 0)], [mass_err[i] for i in data_range if (method[i] == 'reverb' and selected[i] == 1 and upplims[i] == 0)]]
t_gas = [[sigma[i] for i in data_range if ((method[i] == 'gas' or method[i] == 'CO') and selected[i] == 1 and upplims[i] == 0)], [mass[i] for i in data_range if ((method[i] == 'gas' or method[i] == 'CO') and selected[i] == 1 and upplims[i] == 0)], [sigma_err[i] for i in data_range if ((method[i] == 'gas' or method[i] == 'CO') and selected[i] == 1 and upplims[i] == 0)], [mass_err[i] for i in data_range if ((method[i] == 'gas' or method[i] == 'CO') and selected[i] == 1 and upplims[i] == 0)]]
t_stars = [[sigma[i] for i in data_range if ((method[i] == 'stars' or method[i] == 'star') and selected[i] == 1 and upplims[i] == 0)], [mass[i] for i in data_range if ((method[i] == 'stars' or method[i] == 'star') and selected[i] == 1 and upplims[i] == 0)], [sigma_err[i] for i in data_range if ((method[i] == 'stars' or method[i] == 'star') and selected[i] == 1 and upplims[i] == 0)], [mass_err[i] for i in data_range if ((method[i] == 'stars' or method[i] == 'star') and selected[i] == 1 and upplims[i] == 0)]]
t_maser = [[sigma[i] for i in data_range if (method[i] == 'maser' and selected[i] == 1 and upplims[i] == 0)], [mass[i] for i in data_range if (method[i] == 'maser' and selected[i] == 1 and upplims[i] == 0)], [sigma_err[i] for i in data_range if (method[i] == 'maser' and selected[i] == 1 and upplims[i] == 0)], [mass_err[i] for i in data_range if (method[i] == 'maser' and selected[i] == 1 and upplims[i] == 0)]]
t_omitted = [[sigma[i] for i in data_range if (selected[i] != 1 and upplims[i] == 0)], [mass[i] for i in data_range if (selected[i] != 1 and upplims[i] == 0)], [sigma_err[i] for i in data_range if (selected[i] != 1 and upplims[i] == 0)], [mass_err[i] for i in data_range if (selected[i] != 1 and upplims[i] == 0)]]

# plotting upper limits
plt.scatter(ul_reverb[0], ul_reverb[1], s=10, marker=MarkerStyle(marker='v', fillstyle='none'), color='black', linewidths=0.75)
plt.scatter(ul_gas[0], ul_gas[1], s=10, marker=MarkerStyle(marker='v', fillstyle='none'), color='blue', linewidths=0.75)
plt.scatter(ul_stars[0], ul_stars[1], s=10, marker=MarkerStyle(marker='v', fillstyle='none'), color='red', linewidths=0.75)
plt.scatter(ul_maser[0], ul_maser[1], s=10, marker=MarkerStyle(marker='v', fillstyle='none'), color='green', linewidths=0.75)
plt.scatter(ul_omitted[0], ul_omitted[1], s=10, marker=MarkerStyle(marker='v', fillstyle='none'), color='grey', linewidths=0.75)
plt.scatter(100,1000, s=10, marker=MarkerStyle(marker='v', fillstyle='none'), color='black', linewidths=0.75, label='upper limit')

# plotting true masses
plt.scatter(t_reverb[0], t_reverb[1], marker='.', color='black', label='reverberation')
plt.scatter(t_gas[0], t_gas[1], marker='.', color='blue', label='gas')
plt.scatter(t_stars[0], t_stars[1], marker='.', color='red', label='stars')
plt.scatter(t_maser[0], t_maser[1], marker='.', color='green', label='maser')
plt.scatter(t_omitted[0], t_omitted[1], marker='.', color='grey', label='omitted')

plt.plot(x,y, color='black')
plt.xlabel(r'velocity dispersion (log km/s)')
plt.ylabel(r'BH mass (log $M_{\odot}$)')

plt.xlim(1.1, 2.8)
plt.ylim(-1, 11)
plt.legend()

plt.savefig('../Figures/raw_data_comparison.png', dpi=150)
hdu.close()
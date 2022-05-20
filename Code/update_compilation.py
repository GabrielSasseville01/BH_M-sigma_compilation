import numpy as np
from astropy.io import fits
from astropy.io import ascii

## Adding new data from 2016-2022 to preexisting compilation from Remco Van Den Bosch 2016

# 2016 compilation
file = '../Data/BHcompilation.fits'

hdu = fits.open(file)
data = hdu[1].data

# from https://arxiv.org/pdf/1812.01231.pdf
graham18 = [('NGC4434', 'NGC4434', 1, np.NaN, np.NaN, np.NaN, np.NaN, 7.85, 0.18, 0, 1.99, 1.04, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, 'star', 'graham18' , np.NaN, np.NaN),
('NGC4434', 'NGC4434', 1, np.NaN, np.NaN, np.NaN, np.NaN, 7.28, 0.41, 0, 2.03, 0.95, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, 'star', 'graham18' , np.NaN, np.NaN),
('NGC4434', 'NGC4434', 1, np.NaN, np.NaN, np.NaN, np.NaN, 7.36, 0.18, 0, 2.13, 0.95, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, 'star', 'graham18' , np.NaN, np.NaN)]

# from https://arxiv.org/pdf/2006.15150.pdf
baldassare20 = [('NSA62996', 'NSA62996', 1, np.NaN, np.NaN, np.NaN, np.NaN, 5.80, np.NaN, 0, 1.82, 0.48, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, 'reverb', 'baldassare20' ,np.NaN, np.NaN),
('NSA10779', 'NSA10779', 1, np.NaN, np.NaN, np.NaN, np.NaN, 5.44, np.NaN, 0, 1.53, 0.78, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, 'reverb', 'baldassare20' , np.NaN, np.NaN),
('NSA125318', 'NSA125318', 1, np.NaN, np.NaN, np.NaN, np.NaN, 5.00, np.NaN, 0, 1.61, 0.78, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, 'reverb', 'baldassare20' , np.NaN, np.NaN),
('NSA52675', 'NSA52675', 1, np.NaN, np.NaN, np.NaN, np.NaN, 6.10, np.NaN, 0, 1.72, 0.70, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, 'reverb', 'baldassare20' , np.NaN, np.NaN),
('NSA15235', 'NSA15235', 1, np.NaN, np.NaN, np.NaN, np.NaN, 5.29, np.NaN, 0, 1.62, 1.15, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, 'reverb', 'baldassare20' , np.NaN, np.NaN),
('NSA47066', 'NSA47066', 1, np.NaN, np.NaN, np.NaN, np.NaN, 5.42, np.NaN, 0, 1.51, 0.70, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, 'reverb', 'baldassare20' , np.NaN, np.NaN),
('NSA18913', 'NSA18913', 1, np.NaN, np.NaN, np.NaN, np.NaN, 5.18, np.NaN, 0, 1.52, 1.15, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, 'reverb', 'baldassare20' , np.NaN, np.NaN),
('NSA99052', 'NSA99052', 1, np.NaN, np.NaN, np.NaN, np.NaN, 5.21, np.NaN, 0, 1.72, 0.70, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, 'reverb', 'baldassare20' , np.NaN, np.NaN)]

# from https://arxiv.org/pdf/2006.15150.pdf again, but old data from baldassare 2015/2016
baldassare15 = [('NSA166155', 'NSA166155', 1, np.NaN, np.NaN, np.NaN, np.NaN, 4.70, np.NaN, 0, 1.45, 1.05, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, 'reverb', 'baldassare15' ,np.NaN, np.NaN)]
baldassare16 = [('NSA79874', 'NSA79874', 1, np.NaN, np.NaN, np.NaN, np.NaN, 5.46, np.NaN, 0, 1.45, 0.85, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, 'reverb', 'baldassare16' ,np.NaN, np.NaN)]

# from https://arxiv.org/pdf/2012.04471.pdf but older data from Thater et al 2019
thater19 = [('NGC0584', 'NGC0584', 1, np.NaN, np.NaN, np.NaN, np.NaN, 8.15, 0.19, 0, 2.28, 0.70, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, np.NaN, 'star', 'thater19' ,np.NaN, np.NaN)]

# concatenating all new data
newdata = graham18 + baldassare20 + baldassare15 + baldassare16 + thater19

# appending new data to old
data = np.append(data, np.array(newdata, dtype=data.dtype))

# 2022 compilation
fits.writeto('../Data/BHcompilation_updated.fits', data)
ascii.write(data, '../Data/BHcompilation_updated.csv', format='csv')

hdu.close()


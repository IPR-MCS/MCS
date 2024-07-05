import matplotlib.pyplot as plt
import scipy.io
import numpy as np
from scipy.interpolate import interp2d


"""
Load data from Matlab .mat output file to use in Python
"""

matfile = list()
matfile.append(scipy.io.loadmat("Example.mat"))
results = matfile[0]['results']
simulation = results['simulation'][0][0]

# Save items; must be the same as the ones saved in the Matlab script in 'results' structure
temperature = results['temperature'][0][0]
nodes = results['nodes'][0][0]
tlist = results['tlist'][0][0].flatten()
tempBar = results['tempBar'][0][0].flatten()
bar = results['bar'][0][0].flatten()
time = results['time'][0][0].item()
nbr_cavities = results['nbr_cavities'][0][0].item()
volume = results['volume'][0][0].item()
porous_volume = results['porous_volume'][0][0].item()
porosity_fraction = results['porosity_fraction'][0][0].item()
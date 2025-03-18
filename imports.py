import os, re, itertools, h5py as h5, numpy as np, pandas as pd, matplotlib, scipy, scienceplots
from mpl_toolkits.axes_grid1 import make_axes_locatable
from pathlib import Path
matplotlib.use("pgf")
from matplotlib import pyplot as plt
from matplotlib.collections import LineCollection
from functools import reduce
from scipy.ndimage import gaussian_filter
from cycler import cycler

my_cmap = matplotlib.colors.ListedColormap(["#456990", "#902737", "#214e34", "#e79142", "#76a12b"], name="my_cmap")
matplotlib.colormaps.register(cmap=my_cmap)
my_cmap2 = matplotlib.colors.ListedColormap(["#76a12b", # "#5fad56",
                                             "#b4436c", "#f78154", "#f2c14e", "#4d9078", "#2075BA"], name="my_cmap2")
matplotlib.colormaps.register(cmap=my_cmap2)
my_cmap3 = matplotlib.colors.LinearSegmentedColormap.from_list("my_cmap3", ["#9DDDF4", "#F0EBC0", "#E93A28"])
matplotlib.colormaps.register(cmap=my_cmap3)
my_cmap4 = matplotlib.colors.LinearSegmentedColormap.from_list("my_cmap4", ["#F0EBC0", "#E93A28"])
matplotlib.colormaps.register(cmap=my_cmap4)

style = {
    "text.usetex": True,
    "figure.figsize": (4.921259842519685, 3.690944881889764),
    "font.family" : "serif",
    "font.size": 8,
    # "font.serif" : [],
    "mathtext.fontset" : "custom",
    # "savefig.bbox": None,
    # "legend.loc": "best",
    "grid.linestyle": (0, (6, 4)), # "--",
    "grid.linewidth": 0.25,
    "axes.axisbelow": True,
    "legend.frameon": True,
    "image.cmap": "my_cmap3",
    "axes.prop_cycle": cycler(color=my_cmap2.colors),
}

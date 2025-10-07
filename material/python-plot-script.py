import pandas as pd
import matplotlib.pyplot as plt
import os
import glob
import math
user_key = 2637

def plot_all_csv_pressure():
    path = os.getcwd()
    csv_files = glob.glob(os.path.join(path, '*.csv'))
    
    for f in csv_files:
        storm = pd.read_csv(f)
        storm['Pressure'].plot()
        plt.show()

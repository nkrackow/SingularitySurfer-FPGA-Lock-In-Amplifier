#!/usr/bin/env python3
# -*- coding: utf-8 -*-


# IIR testing 

# model for multiplier less IIR filters with feedback close to 1
# second order is just two first order concatinated
# you can multiply with (1-2**-l) easily by bitshifting and subtracting in hardware

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
from dsp_fpga_lib import zplane




f_s=900E3        # sample freq

max=24

fc=np.empty(max)    # -6 dB cutoff freqs
TC=np.empty(max)    # time constants

# go through all the powers of two
for l in range(max):
    
    # H(z)=B/A=2**-l/(z-(1-2**l)) # first order
    #b=[2**-l,0]            # first order
    #a=[1,-(1-(2**-l))]     # first order
    b=[2**-(2*l),0,0]           # second order
    a=[1,-2*(1-2**-l),(1-2**-l)**2]         # second order
    
   
    
    plt.figure(0)
    flog=np.logspace(-8,1,1000)
    [f,Hf]=signal.freqz(b,a,flog)
    Hf=20*np.log10(abs(Hf))
    fHz=(f/(2*np.pi))*f_s
    plt.plot(fHz,Hf)
    plt.figure(1)
    zplane(b,a)
    
    fc[l]=fHz[np.argmin(abs(Hf+6))]
    TC[l]=1/(2*np.pi*fc[l])
    print(f"2^{l}:   fc= {fc[l]}Hz    TC={TC[l]} sec ")

plt.figure(0)
plt.minorticks_on() 
plt.grid(b=True,which='both',axis='both')
plt.xscale('log')
plt.xlim(10E-4,450E3)   

plt.show()
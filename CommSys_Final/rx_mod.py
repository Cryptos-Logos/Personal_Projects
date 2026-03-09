from filter_sinc import filter_sinc
from scipy.signal import convolve
import numpy as np

def rx_mod(Recv_struct,x_t,fs):
    if Recv_struct=='Matched-rect':
        p=np.ones(len(filter_sinc(fs/4,fs)))
        q=np.ones(len(filter_sinc(fs/4,fs)))*-1
        f=p-q
        f_x_conv=convolve(x_t,f,mode='same')
        return f_x_conv

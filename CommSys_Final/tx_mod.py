import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import cumulative_trapezoid
from filter_sinc import filter_sinc
from scipy.signal import hilbert, convolve

def tx_mod(mod_type, m_t, fc, kf,fs,t):
    if mod_type == "DSB-SC":
        amplitude = 1
        c_t = amplitude * np.cos(2 * np.pi * fc * t)
        x_t = m_t * c_t
    elif mod_type == "AM":
        c_t = np.cos(2 * np.pi * fc * t)
        A=1
        m_P=26720
        x_t = (A + (m_t/m_P)) * c_t
    elif mod_type == "FM":
        integrated_m_t = cumulative_trapezoid(m_t,initial=0)
        x_t = np.cos(2 * np.pi * fc * t + 2 * np.pi * kf * integrated_m_t)
    elif mod_type == 'LSSB' or mod_type == 'USSB':
        m_hat_t = np.imag(hilbert(m_t))
        carrier_cos = np.cos(2 * np.pi * fc * t)
        carrier_sin = np.sin(2 * np.pi * fc * t)
        if mod_type == 'LSSB':
            x_t = m_t * carrier_cos + m_hat_t * carrier_sin
        else:
            x_t = m_t * carrier_cos - m_hat_t * carrier_sin
            
    elif mod_type=='Polar-sinc':
        x_t=0
        if m_t=='0':
            x_t=-filter_sinc(fs/4,fs)
        elif m_t=='1':
            x_t=filter_sinc(fs/4,fs)
    elif mod_type=='Polar-rect':
        x_t=0
        if m_t=='0':
            x_t=np.ones(len(filter_sinc(fs/4,fs)))*-1
        elif m_t=='1':
            x_t=np.ones(len(filter_sinc(fs/4,fs)))
    elif mod_type=='2-PAM':
        basis1=np.ones(len(filter_sinc(fs/4,fs)))
        const1=5
        const2=-5
        x_t=0
        if m_t=='0': x_t=const2*basis1
        else : x_t=const1*basis1
        return x_t
    elif mod_type=='4-PAM':
        basis1=np.ones(len(filter_sinc(fs/4,fs)))
        const00=-3
        const01=-1
        const10=1
        const11=3
        x_t=0
        if m_t=='00': x_t=const00*basis1
        elif m_t=='01': x_t=const01*basis1
        elif m_t=='10': x_t=const10*basis1
        elif m_t=='11': x_t=const11*basis1
        return x_t
    else:
        raise ValueError("Unsupported modulation type: choose 'DSB-SC' or 'AM' or 'FM'")

    return x_t


print(range(0,56))
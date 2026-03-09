import numpy as np
import matplotlib.pyplot as plt
import random
from scipy.io import wavfile
import sounddevice as sd

def infosource(signal_type,f,fs,amp,T):
    """Generate a signal based on `signal_type` ('sine' or 'sinc').
    Returns only the time-domain signal m_t.
    """
    if signal_type == "sine":
        start_time = 0
        stop_time = 1
        t = np.linspace((start_time+T), (stop_time+T), int(fs * (stop_time - start_time)) + 1)
        m_t = amp * np.sin(2 * np.pi * f * t)
             

    elif signal_type == 'multitone':
        f_1=f
        f_2 = 2 * f_1
        f_max = max(f_1, f_2)
        fs = 10 * f_max
        start_time = 0
        stop_time = 1
        A_1 = 1
        A_2 = 1
        t = np.linspace(start_time+T, stop_time+T, int(fs * (stop_time - start_time)) + 1)

        m_t = A_1 * np.sin(2 * np.pi * f_1 * t) + A_2 * np.sin(2 * np.pi * f_2 * t)
       
    elif signal_type == "sinc":
        
        start_time = 0
        stop_time = 1
        t = np.linspace(start_time+T, stop_time+T, int(fs * (stop_time - start_time)) + 1)
        m_t =np.sinc(2 * f* (t-T))
        
    elif signal_type == "real_time_song":
        # Write your code to extract samples from .wav
        fs, m_T = wavfile.read(r"C:\Users\konaa\Documents\VScode2025\CommSys_Final\waving.wav")
        if m_T.ndim > 1:
            m_T = m_T[:, 0]
        start = T *fs
        end = (T + 1) * fs
        m_t = m_T[start:end]  # your per-second segment
        t = np.arange(len(m_t)) /fs + T
    
    elif signal_type == 'charname':
        start_time = 0
        stop_time = 1

        name='Konaark'
        name_bin=''
        for i in range(len(name)):
            name_append=bin(ord(name[i]))[2:]
            if len(name_append) !=9:
                name_append=('0'*(8-len(name_append)))+name_append
            name_bin+=name_append
        m_t=name_bin
        t = np.linspace(start_time+T, stop_time+T, int(fs * (stop_time - start_time)) + 1)
    
    elif signal_type=='idle':
        t = np.linspace(0+T, 1+T, int(fs * (1 - 0)) + 1)
        m_t=np.zeros(len(t))
       
    else:
        raise ValueError("Unsupported signal type: choose 'sine' or 'sinc'.")

    return m_t, t

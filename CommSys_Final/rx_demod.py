import numpy as np
from scipy.signal import hilbert, convolve
from filter_sinc import filter_sinc
def rx_demod(demod_type, x_t, fc, fs,kf, t):
    if demod_type == "SD":
        amplitude = 1
        c_t = amplitude * np.cos(2 * np.pi * fc * t)
        y_t = x_t * c_t
        B = 5000 #should be less than 11025, around 4000 is human voice, if kept higher lots of noise comes
        g_t = filter_sinc(B, fs)
        m_hat_t = convolve(y_t, g_t, mode='same') * 2 # Multiply by 2 to restore amplitude
        m_hat_t=m_hat_t/fs

    elif demod_type == "ED": # Envelope Detection
        # Hilbert transform gives the analytic signal, np.abs gives the envelope
        m_hat_t = np.abs(hilbert(x_t)) - np.mean(x_t) # Subtract 1 to remove DC offset from AM

    elif demod_type == "EDFM": # Envelope Detection for FM
        diff_sig=np.diff(x_t)
        diff_sig=np.append(diff_sig,diff_sig[-1])
        m_hat_t=np.abs(hilbert(diff_sig))
        m_hat_t=m_hat_t-np.mean(m_hat_t)
        # instantaneous_phase = np.unwrap(np.angle(analytic_signal))
        # dt = 1.0 / fs
        # instantaneous_angular_frequency = np.gradient(instantaneous_phase, dt)
        # instantaneous_frequency = instantaneous_angular_frequency / (2.0 * np.pi)
        # m_hat_t = (instantaneous_frequency - fc) / kf
    elif demod_type=='th detection-sinc':
        abs_max_index = np.argmax(np.abs(x_t)) 
        if x_t[abs_max_index]<0:
            m_hat_t=0
        elif x_t[abs_max_index]>0:
            m_hat_t=1
    elif demod_type=='th detection-rect':
        abs_max_index = np.argmax(np.abs(x_t)) 
        if x_t[abs_max_index]<0:
            m_hat_t=0
        elif x_t[abs_max_index]>0:
            m_hat_t=1
    else:
        raise ValueError("Unsupported demodulation type: choose 'SD' or 'ED'")

    return m_hat_t

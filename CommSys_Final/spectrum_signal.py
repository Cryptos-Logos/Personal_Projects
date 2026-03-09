import numpy as np
import matplotlib.pyplot as plt

def spectrum_signal(m_t, fs):
    
    M_f = np.fft.fft(m_t)
    M_f_arrange=np.fft.fftshift(M_f)
    freq_axis =np.linspace(-fs/2, fs/2, len(M_f))
    plt.plot(freq_axis, np.abs(M_f_arrange))
    plt.title("Spectrum")
    plt.xlabel("Frequency (Hz)")
    plt.ylabel("|M(f)|")
    plt.grid(True)
    plt.tight_layout()
    #plt.show()
    #plt.show(block=False)
    return freq_axis, M_f
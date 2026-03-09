from plot_time import plot_time
from infosource import infosource
from spectrum_signal import spectrum_signal
from filter_sinc import filter_sinc
import matplotlib.pyplot as plt
from tx_mod import tx_mod
from rx_demod import rx_demod
from channel import channel
import numpy as np
import sounddevice as sd
from addawgn import awgn
from rx_mod import rx_mod

def main():
    amp=1
    f=10
    fs=10*f
    fc=12000
    kf=0.4
    m=2
    n=2
    window_index=1
    rec_song=[]
    max_sec=[]
    # m_t,t = infosource("charname",f,fs,amp,0)
    T=0
    plt.close()
    plt.figure(1)
    sigma_sqaure_list=[0,0.3]
    print_1=1
    for sigma_index in range(len(sigma_sqaure_list)):
        plt.clf()
        for T in range(0,56,2):
            window_index=1
            m_t,t = infosource("charname",f,fs,amp,T)
            x_t=tx_mod('4-PAM',m_t[T:T+2],0,0,fs,t)
            x_n_t=awgn(x_t,0,sigma_sqaure_list[sigma_index])
            plt.subplot(2,1,1)
            plt.plot(t,x_n_t)
            plt.xlabel("Time (s)")
            plt.ylabel("Amplitude (norm.)")
            plt.title(f"Noise Variance {sigma_sqaure_list[sigma_index]}")
            plt.tight_layout()

            #m_recv_t=rx_mod('Matched-rect',x_n_t,fs)
            plt.subplot(2,1,2)
            plt.scatter(x_n_t,0*x_n_t)
            plt.show(block=0)
            plt.pause(0.05)
        # rec_song=np.ndarray.flatten(np.array(rec_song))
        # print(f"the maximum amplitude is {max(max_sec)}")
        # sd.play(rec_song/26270, fs)
        # sd.wait()
        # byte_chunks = [recon[i:i+8] for i in range(0, len(m_t), 8)]
        # ascii_text = ''.join([chr(int(byte, 2)) for byte in byte_chunks])
        # print("Reconstructed name is",ascii_text)
        #26270


if __name__ == "__main__":
    main()

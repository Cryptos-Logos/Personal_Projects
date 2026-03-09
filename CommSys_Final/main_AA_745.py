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
    recon=''
    T=0
    plt.close()
    plt.figure(1)
    sigma_sqaure_list=[0,0.8,1,3,7,15]
    print_1=1
    for sigma_index in range(len(sigma_sqaure_list)):
        recon=''
        plt.clf()
        for T in range(0,56):
            window_index=1
            m_t,t = infosource("charname",f,fs,amp,T)
            #print(m_n_t[0:50],len(m_t),len(t))
            #fs=1/(t[1]-t[0])
            x_t=tx_mod('Polar-rect',m_t[T],0,0,fs,t)
            x_t=x_t/(np.max(np.abs(np.array(x_t))))
            x_n_t=awgn(x_t,0,sigma_sqaure_list[sigma_index])
            # plt.figure(2)
            plt.subplot(2,1,1)
            plt.plot(t,x_n_t)
            plt.xlabel("Time (s)")
            plt.ylabel("Amplitude (norm.)")
            plt.title(f"Noise Variance {sigma_sqaure_list[sigma_index]}")
            plt.tight_layout()
            
            # plt.subplot(m,n,window_index)
            # window_index+=1
            # spectrum_signal(m_t,fs)

            # x_t=tx_mod('FM',m_t,fc,kf,fs,t)
            # plt.subplot(m,n,window_index)
            # window_index+=1
            # plt.plot(t,x_t)

            # plt.subplot(m,n,window_index)
            # window_index+=1
            # spectrum_signal(x_t,fs)

            # m_hat_t=rx_demod('EDFM',x_t,fc,fs,kf,t)
            # plt.subplot(m,n,window_index)
            # window_index+=1n
            # plt.plot(t,m_hat_t)

            # plt.subplot(m,n,window_index)
            # window_index+=1
            # spectrum_signal(m_hat_t,fs)
            # rec_song=rec_song+[m_hat_t]
            # plt.show(block=0)
            # plt.pause(0.2)
            m_recv_t=rx_mod('Matched-rect',x_n_t,fs)
            m_hat_t=rx_demod('th detection-rect',m_recv_t,0,fs,0,t)
            recon=recon+str(m_hat_t)
            plt.subplot(2,1,2)
            m_hat_t=np.full(len(t), m_recv_t)
            plt.plot(t,m_hat_t, linewidth=0.8)
            plt.show(block=False)
            plt.pause(0.005)
        # rec_song=np.ndarray.flatten(np.array(rec_song))
        # print(f"the maximum amplitude is {max(max_sec)}")
        # sd.play(rec_song/26270, fs)
        # sd.wait()
        if(print_1):
            print("The message signal is :",m_t)
            print("Name sent is Konaark")
            print_1=0
        print("The reconstructed signal is :",recon)
        print(f"Current Variance is {sigma_sqaure_list[sigma_index]}")
        BER=0
        for i in range(len(m_t)):
            if m_t[i]!=recon[i]:
                BER+=1
        print("Bit error rate is ",BER/len(m_t))
        # byte_chunks = [recon[i:i+8] for i in range(0, len(m_t), 8)]
        # ascii_text = ''.join([chr(int(byte, 2)) for byte in byte_chunks])
        # print("Reconstructed name is",ascii_text)
        #26270


if __name__ == "__main__":
    main()

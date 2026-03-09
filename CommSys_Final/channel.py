from convo_out import convo_out
from filter_sinc import filter_sinc
import matplotlib.pyplot as plt

def channel(type,fs,x,B):
    if type=="DSTless":
        h=x
    elif type=="Blim":
        ht=filter_sinc(B,fs)
        # plt.figure(2)
        # plt.plot(range(0,len(ht)),ht)
        # plt.show()
        h=convo_out(ht,x)
        # h=h[0:len(x)]

    return h
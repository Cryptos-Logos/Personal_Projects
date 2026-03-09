import matplotlib.pyplot as plt


def plot_time(t, m_t):
    plt.figure(1)
    plt.plot(t, m_t)
    plt.title("Time-Domain")
    plt.xlabel("Time")
    plt.ylabel("Signal Amplitude")
    plt.grid(True)
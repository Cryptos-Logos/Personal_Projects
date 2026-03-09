import numpy as np

def awgn(m_t,mean,sigma_square):
    sigma=sigma_square**0.5
    noise=(sigma*np.random.randn(len(m_t)))+mean
    m_n_t=m_t+noise
    return m_n_t

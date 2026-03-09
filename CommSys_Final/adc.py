import numpy as np

def adc(signal_type,m_t,fs,N,delta):
    if signal_type == "PCM":
      m_normalised = m_t / np.max(np.abs(m_t))
      L = 2**N
      a = np.floor((m_normalised + 1) / 2 * (L-1) + 0.5).astype(int) 
      bitstream = np.array([list(np.binary_repr(x, width=N)) for x in a]).astype(int)
      bitstream = bitstream.flatten()
      return bitstream

    elif signal_type == "DM":
      bitstream = []
      m_prev = 0  
      for x in m_t:
        if x >= m_prev:
            bitstream.append(1)
            m_prev += delta
        else:
            bitstream.append(0)
            m_prev -= delta
      return np.array(bitstream)


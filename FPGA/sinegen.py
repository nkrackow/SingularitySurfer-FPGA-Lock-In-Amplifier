

import numpy as np
phases = np.linspace(0,0.5*np.pi, 65536)
values = (((2**15))*np.sin(phases))

values=values.astype(np.int16)
values.tofile('sine_np2.bin')

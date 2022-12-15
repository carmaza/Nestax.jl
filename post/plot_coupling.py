# Distributed under the MIT License.
# See LICENSE for details.

import matplotlib.pyplot as plt
import numpy as np

from axion import Axion


def plot():

    axion = Axion()

    ma = np.geomspace(0.1, 1000.)
    fa = axion.mass_or_decay(ma)

    qcd_min = 5. / 3.
    qcd_max = 44. / 3.
    dfsz = 8. / 3.

    g_qcd_min = axion.photon_coupling(fa, qcd_min)
    g_qcd_max = axion.photon_coupling(fa, qcd_max)
    g_dfsz = axion.photon_coupling(fa, dfsz)

    plt.fill_between(ma, g_qcd_min, g_qcd_max, color='gold', alpha=0.7)
    plt.plot(ma, g_dfsz, label="DFSZ")

    plt.grid(which='both', alpha=0.2)
    plt.xscale('log')
    plt.yscale('log')
    plt.xlabel("$m_a$ [$\mu$eV]")
    plt.ylabel("$g_{a\gamma\gamma}$ [GeV$^-1$]")
    plt.legend()

    plt.show()


plot()

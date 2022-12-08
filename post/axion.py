# Distributed under the MIT License.
# See LICENSE for details.

import astropy.constants as astro
import numpy as np


class Axion:

    def mass_or_decay(self, md):
        """
        fa in GeV, mass in ueV.
        """
        return 5.7 * 1.e12 / md

    def photon_coupling(self, fa, e_over_n):
        """
        fa in GeV. Result given in inverse GeV.
        """
        return (0.5 * astro.alpha.value / np.pi) * np.absolute(e_over_n -
                                                               1.92) / fa

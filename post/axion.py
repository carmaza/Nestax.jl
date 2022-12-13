# Distributed under the MIT License.
# See LICENSE for details.

import astropy.constants as astro
import numpy as np


class Axion:
    """
    Functions related to the QCD axion.

    """

    def mass_or_decay_constant(self, f_or_m, lambda_sqrd=(5.7 * 1.e6)):
        """
        Assume a relation lambda_sqrd = mass * decay_constant to compute either
        the mass of the decay constant.

        The units are such that the decay constant is in GeV, and the mass in 
        eV.
 
        Parameters
        ----------
        `f_or_m`: array_like
        Either the decay constant or the mass

        `lambda_sqrd`: array_like (default: 5.7e12 GeV^2).
        The Lambda QCD parameter squared.
     
        Returns
        -------
        out : array_like
        If `f_or_m` is the mass (decay constant), return the decay constant
        (mass).
        
        """
        return lambda_sqrd / f_or_m

    def photon_coupling(self, fa, e_over_n):
        """
        The axion-photon coupling constant in QCD.

        Parameters
        ----------
        
        `fa` : array_like
        The decay constant.

        `e_over_n` : array_like
        The electromagnetic-to-color anomaly parameter of the particular model.


        Returns
        -------

        out : array_like
        The coupling constant, in units of inverse decay constant.
        """
        return (0.5 * astro.alpha.value / np.pi) * np.absolute(e_over_n -
                                                               1.92) / fa

# Distributed under the MIT License.
# See LICENSE for details.

import numpy as np


class Conversion:
    """
    The photon-axion conversion in the magnetosphere of a neutron star.

    Parameters
    ----------

    `axion_mass` : float
    The mass of the QCD axion.
    """

    def __init__(self, axion_mass, neutron_star):
        self._axion_mass = axion_mass
        self._neutron_star = neutron_star

        # 1 GHz = 0.413e-5 eV and 12.422 = 22.4 * 0.413**(2./3.)
        self._rc_scale = 12.422 * neutron_star.radius * (
            neutron_star.b_zero /
            (neutron_star.rotation_period * axion_mass**2.))**(1. / 3.)

    @property
    def rc_scale(self):
        return self._rc_scale

    @staticmethod
    def _rotate_about(v, k, a):
        result = v * np.cos(a) + np.cross(k, v) * np.sin(a) + k * np.dot(
            k, v) * (1. - np.cos(a))
        return result

    def radius(self, costheta, sintheta, cosphi, sinphi, time):
        """
        The radial coordinate of the conversion surface, parameterized by
        the spherical angles (theta, phi), at a given time.

        Arguments
        ---------

        `costheta, sintheta` : array_like, array_like
        The cosine and sine of the zenithal angle.

        `cosphi, sinphi` : array_like, array_like
        The cosine and sine of the azimuthal angle.

        `time` : obj
        The `Time` of observation.

        Returns
        -------

        out : array_like
        The radial coordinate of the conversion surface.

        """
        star = self._neutron_star

        phase = star.phase + star.angular_speed * time.value
        magnetic_axis = _rotate_about(star.magnetic_axis, star.rotation_axis,
                                      phase)

        cosinc = np.dot(star.rotation_axis, magnetic_axis)
        unit_radial = np.array(
            [sintheta * cosphi, sintheta * sinphi, costheta])

        xhatdotmhat = sum(
            [magnetic_axis[k] * unit_radial[k] for k in range(3)])

        return self._rc_scale * np.absolute(3. * costheta * xhatdotmhat -
                                            cosinc)**(1. / 3.)

1  # Distributed under the MIT License.
# See LICENSE for details.

import numpy as np


class NeutronStar:

    def __init__(self, mass, radius, rotation_period, rotation_axis, b_zero,
                 magnetic_axis):
        self._mass = mass
        self._radius = radius
        self._rotation_period = rotation_period
        self._rotation_axis = rotation_axis / np.linalg.norm(rotation_axis)
        self._b_zero = b_zero
        self._magnetic_axis = magnetic_axis / np.linalg.norm(magnetic_axis)

        self._angular_speed = 2. * np.pi / self._rotation_period
        self._angular_velocity = self._angular_speed * self._rotation_axis
        self._phase = np.arctan2(magnetic_axis[1], magnetic_axis[0])

    @property
    def mass(self):
        return self._mass

    @property
    def radius(self):
        return self._radius

    @property
    def rotation_period(self):
        return self._rotation_period

    @property
    def rotation_axis(self):
        return self._rotation_axis

    @property
    def angular_speed(self):
        return self._angular_speed

    @property
    def angular_velocity(self):
        return self._angular_velocity

    @property
    def phase(self):
        return self._phase

    @property
    def b_zero(self):
        return self._b_zero

    @property
    def magnetic_axis(self):
        return self._magnetic_axis

# Distributed under the MIT License.
# See LICENSE for details.


class Particle:
    """
    Dynamical properties of a particle.

    Parameters
    ----------

    `particle_id` : string
    A unique ID.

    `position_on_convsurf` : array_like
    The position of the particle on the conversion surface.

    `distance_to_origin` : float
    The Euclidean distance to the coordinate origin.
    """

    def __init__(self, particle_id, position_on_convsurf, distance_to_origin):
        self._id = particle_id
        self._position_on_convsurf = position_on_convsurf
        self._distance_to_origin = distance_to_origin

    @property
    def id(self):
        return self._id

    @property
    def position_on_convsurf(self):
        return self._position_on_convsurf

    @property
    def distance_to_origin(self):
        return self._distance_to_origin

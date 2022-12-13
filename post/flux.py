# Distributed under the MIT License.
# See LICENSE for details.

from particle import Particle
from tempo import Interval


class Flux:

    def __init__(self, time_interval):
        self._time_interval = time_interval
        self._particles = []

    def add_particle(self, particle):
        self._particles.append(particle)

    @property
    def particles(self):
        return self._particles

    @property
    def particle_number(self):
        return len(self._particles)

    @property
    def time_interval(self):
        return self._time_interval

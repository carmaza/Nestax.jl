# Distributed under the MIT License.
# See LICENSE for details.


class Time:

    def __init__(self, time_id, value):
        self._time_id = time_id
        self._value = value

    @property
    def id(self):
        return self._time_id

    @property
    def value(self):
        return self._value


class Interval:

    def __init__(self, extents):
        self._extents = extents

    def within_extents(self, time):
        return time.value >= self._extents[0] and time.value < self._extents[1]

    @property
    def extents(self):
        return self._extents

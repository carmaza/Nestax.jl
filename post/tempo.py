# Distributed under the MIT License.
# See LICENSE for details.


class Time:
    """
    A time instant.

    Parameters
    ---------
    
    `time_id` : string
    A unique ID.

    `value` : float
    The numeric value of the time instant.

    """

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
    """
    A time interval.

    Parameters
    ----------

    `extents` : tuple
    A 2-tuple containing the initial and final `Time` defining the interval.
    """

    def __init__(self, extents):
        self._extents = extents

    @property
    def extents(self):
        return self._extents

    def within_extents(self, time):
        """
        Whether the given `time` value is contained in this interval.

        Parameters
        ----------

        `time` : obj
        The `Time` object whose value is being tested.

        Returns
        -------

        out : bool
        Whether the value of `time` lies in this time interval.

        """
        return time.value >= self._extents[0] and time.value < self._extents[1]

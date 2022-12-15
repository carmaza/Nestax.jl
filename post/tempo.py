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

    def within_interval(self, interval):
        """
        Whether self `value` is contained in the given interval.

        Parameters
        ----------

        `interval` : obj
        The `Interval` object whose extents are tested.

        Returns
        -------

        out : bool
        Whether the self value lies in the given interval.

        """
        return self._value >= interval.extents[
            0] and self._value <= interval.extents[1]


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

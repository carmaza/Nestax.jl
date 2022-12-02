import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as axes3d
import numpy as np

from chrono import Time


def rc(costheta, sintheta, cosphi, sinphi, cosalpha, mhat):
    rhat = np.array([sintheta * cosphi, sintheta * sinphi, costheta])
    rhatdotmhat = sum([rhat[k] * mhat[k] for k in range(3)])

    #norm = 22.4 * star.radius * (star.bzero / star.period / axion_mass)**(1. / 3.)
    return 12.5 * np.absolute(3. * costheta * rhatdotmhat - cosalpha)**(1. /
                                                                        3.)


def plot_rc():
    omega = 0.01
    psi = 0.2
    phase_0 = 0.
    t = 0.

    # Normalized magnetic moment.
    phase = phase_0 - omega * t
    mhat = np.array([
        np.sin(psi) * np.cos(phase),
        np.sin(psi) * np.sin(phase),
        np.cos(psi)
    ])

    # Normalized angular velocity.
    omegahat = np.array([0., 0., 1.])

    # Cosine of angle between magnetic moment and angular velocity.
    cosalpha = np.dot(mhat, omegahat)

    # Make spherical grid.
    theta = np.linspace(0., np.pi, 100)
    phi = np.linspace(0., 2. * np.pi, 300)
    th, ph = np.meshgrid(theta, phi)

    costheta = np.cos(th)
    sintheta = np.sin(th)
    cosphi = np.cos(ph)
    sinphi = np.sin(ph)
    R = rc(costheta, sintheta, cosphi, sinphi, cosalpha, mhat)

    dec = 0.5 * np.pi - th
    ra = ph - np.pi

    plt.figure()
    plt.subplot(projection="mollweide")

    contours = plt.contourf(ra, dec, R, levels=100)
    for c in contours.collections:
        c.set_rasterized(True)

    plt.grid()
    plt.savefig("ConvSurf.pdf", bbox_inches="tight")


class NeutronStar:

    def __init__(self, angular_speed, magnetic_inclination, initial_phase):
        self._angular_speed = angular_speed
        self._initial_phase = initial_phase
        self._magnetic_inclination = magnetic_inclination

    @property
    def angular_speed(self):
        return self._angular_speed

    @property
    def initial_phase(self):
        return self._initial_phase

    @property
    def magnetic_inclination(self):
        return self._magnetic_inclination


def plot_3d(star, time):

    inc = star.magnetic_inclination
    phase = star.initial_phase - star.angular_speed * time.value

    # Normalized magnetic moment.
    mhat = np.array([
        np.sin(inc) * np.cos(phase),
        np.sin(inc) * np.sin(phase),
        np.cos(inc)
    ])

    # Normalized angular velocity.
    omegahat = np.array([0., 0., 1.])

    # Cosine of angle between magnetic moment and angular velocity.
    cosalpha = np.dot(mhat, omegahat)
    theta = np.linspace(0., np.pi, 100)
    phi = np.linspace(0., 2. * np.pi, 300)
    th, ph = np.meshgrid(theta, phi)

    costheta = np.cos(th)
    sintheta = np.sin(th)
    cosphi = np.cos(ph)
    sinphi = np.sin(ph)
    R = rc(costheta, sintheta, cosphi, sinphi, cosalpha, mhat)

    # Plot NS.
    x_sphere = sintheta * cosphi
    y_sphere = sintheta * sinphi
    z_sphere = costheta

    # Plot conversion surface.
    x_convsurf = R * sintheta * cosphi
    y_convsurf = R * sintheta * sinphi
    z_convsurf = R * costheta

    fig = plt.figure()
    ax = fig.add_subplot(1, 1, 1, projection='3d')

    ax.plot_surface(x_convsurf,
                    y_convsurf,
                    z_convsurf,
                    color='palegreen',
                    alpha=0.5,
                    rcount=1000,
                    ccount=3000)
    ax.plot_surface(x_sphere, y_sphere, z_sphere, color='blue')

    limits = [-20., 20.]
    ax.set_xlim(limits)
    ax.set_ylim(limits)
    ax.set_zlim(limits)
    ax.set_aspect('equal')

    ax.xaxis.set_pane_color((1.0, 1.0, 1.0, 0.0))
    ax.yaxis.set_pane_color((1.0, 1.0, 1.0, 0.0))
    ax.zaxis.set_pane_color((1.0, 1.0, 1.0, 0.0))

    cset = ax.contour(x_convsurf, y_convsurf, z_convsurf, zdir='z', offset=-15)
    cset = ax.contour(x_convsurf, y_convsurf, z_convsurf, zdir='x', offset=-20)
    cset = ax.contour(x_convsurf, y_convsurf, z_convsurf, zdir='y', offset=20)

    plt.savefig("img/convsurf/{}.png".format(time.id),
                dpi=600,
                bbox_inches="tight")
    plt.close()


if __name__ == "__main__":
    star = NeutronStar(0.1, 0.2, 0.)

    P = 2. * np.pi / star.angular_speed
    Nt = 50
    dt = P / Nt
    for i in range(Nt):
        time = Time(str(i).zfill(6), dt * i)
        plot_3d(star, time)

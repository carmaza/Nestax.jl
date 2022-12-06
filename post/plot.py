# Distributed under the MIT License.
# See LICENSE for details.

import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as axes3d
import numpy as np

from chrono import Time
from conversion import Conversion
from neutron_star import NeutronStar


def plot(axion_mass,
         neutron_star,
         total_time,
         Nt,
         plot_proj=True,
         plot_star=True,
         write_time=True):

    conversion = Conversion(axion_mass, neutron_star)

    theta = np.linspace(0., np.pi, 100)
    phi = np.linspace(0., 2. * np.pi, 300)
    th, ph = np.meshgrid(theta, phi)

    # Precompute trig functions because they're _expensive_ !
    costheta = np.cos(th)
    sintheta = np.sin(th)
    cosphi = np.cos(ph)
    sinphi = np.sin(ph)

    # Neutron star surface.
    x_star = neutron_star.radius * sintheta * cosphi
    y_star = neutron_star.radius * sintheta * sinphi
    z_star = neutron_star.radius * costheta

    # Figure holding volume plot.
    figvol = plt.figure(figsize=(6, 5))
    axvol = figvol.add_subplot(projection='3d')

    # Figure holding 2d projections.
    figproj, axproj = plt.subplots(1, 3, sharey=True, figsize=(10, 3))

    dt = total_time / Nt
    for i in range(Nt):

        time = Time(str(i).zfill(6), dt * i)
        rc_scale = conversion.radius(costheta, sintheta, cosphi, sinphi, time)
        x_convsurf = rc_scale * sintheta * cosphi
        y_convsurf = rc_scale * sintheta * sinphi
        z_convsurf = rc_scale * costheta

        axvol.plot_surface(x_convsurf,
                           y_convsurf,
                           z_convsurf,
                           color='palegreen',
                           alpha=1.,
                           rcount=100,
                           ccount=100)

        if plot_star:
            axvol.plot_surface(x_star, y_star, z_star, color='blue')

        limits = [-1.5 * conversion.rc_scale, 1.5 * conversion.rc_scale]
        axvol.set_xlim(limits)
        axvol.set_ylim(limits)
        axvol.set_zlim(limits)

        white = (1.0, 1.0, 1.0, 0.0)
        axvol.xaxis.set_pane_color(white)
        axvol.yaxis.set_pane_color(white)
        axvol.zaxis.set_pane_color(white)

        axvol.xaxis._axinfo["grid"].update({"linewidth": 0.3})
        axvol.yaxis._axinfo["grid"].update({"linewidth": 0.3})
        axvol.zaxis._axinfo["grid"].update({"linewidth": 0.3})

        axvol.set_xlabel("[km]")
        axvol.set_aspect('equal')
        if write_time:
            axvol.set_title("t = {:2.2f} s".format(time.value))

        plt.figure(figvol)
        plt.savefig("img/convsurf/vol{}.png".format(time.id),
                    bbox_inches='tight',
                    dpi=600)

        axvol.clear()

        if plot_proj:

            axproj[0].contourf(x_convsurf, y_convsurf, z_convsurf, levels=60)
            axproj[1].contourf(y_convsurf, z_convsurf, x_convsurf, levels=60)
            axproj[2].contourf(x_convsurf, z_convsurf, y_convsurf, levels=60)

            axproj[0].set_xlabel("x [km]")
            axproj[0].set_ylabel("y [km]")
            axproj[1].set_xlabel("y [km]")
            axproj[1].set_ylabel("z [km]")
            axproj[2].set_xlabel("x [km]")
            axproj[2].set_ylabel("z [km]")

            for ax in axproj:
                ax.grid(linewidth=0.3, zorder=0)
                ax.set_xlim(limits)
                ax.set_ylim(limits)
                ax.set_aspect('equal')
                ax.set_axisbelow(True)

            # So surface rotates in the x-z plane with the correct helicity.
            axproj[2].invert_xaxis()

            if write_time:
                figproj.suptitle("t = {:2.2f} s".format(time.value))

            plt.figure(figproj)
            plt.savefig("img/convsurf/proj{}.png".format(time.id),
                        bbox_inches='tight',
                        dpi=600)

            for ax in axproj:
                ax.clear()

    plt.close(figvol)
    plt.close(figproj)


if __name__ == "__main__":
    axion_mass = 1.

    inc = 0.2
    neutron_star = NeutronStar(1.4, 10., 1., (0., 0., 1.), 1.,
                               (np.sin(inc), 0., np.cos(inc)))

    Nt = 500
    total_time = 10. * neutron_star.rotation_period

    plot(axion_mass, neutron_star, total_time, Nt)

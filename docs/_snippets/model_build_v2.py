#!/usr/bin/env python3
"""Project-backed static modelling now crosses library boundaries explicitly.

petekSim can still provide the synthetic asset helper, but project loading is a
petekIO concern and static grid/property modelling is a petekStatic concern.
"""

from __future__ import annotations

import sys
import tempfile

import petekio as pio
import peteksim as ps
import petekstatic as pst


def main(root: str | None = None) -> int:
    root = root or tempfile.mkdtemp(prefix="model-v2-")
    man = ps.synth_asset(root)
    print(f"synthetic asset: {man['root']}")

    project = pio.Project.load(
        man["root"],
        settings=pio.LoadSettings(crs=man["crs"], aliases=man["aliases"]),
    )
    print("Project.load", project.inventory())

    logs = project.wells.logs
    grid = (
        pst.Grid.from_project(project)
        .geometry(cell=(50.0, 50.0), orient=0.0, outline="ModelEdge")
        .horizons(
            [
                {
                    "name": man["horizons"][0],
                    "surface": man["horizons"][0],
                    "well top": f"well tops/{man['horizons'][0]}",
                    "zone": {
                        "name": "Reservoir",
                        "sub-zones": [
                            {"zone": "Top Reservoir", "type": "constant"},
                            {"name": "Intra Shale", "well top": "Top Lower Reservoir"},
                            {"name": "Lower Reservoir", "type": "isochore"},
                        ],
                    },
                },
                man["horizons"][-1],
            ],
            well_tie={"influence_radius": 800},
        )
        .layers({"Top Reservoir": pst.Layering(n=4), "Lower Reservoir": pst.Layering(n=4)})
    )

    vgm = pst.Var("spherical", major=1500, minor=700, vertical=20, azimuth=35)
    grid.properties.por = pst.upscale(logs.PORO(logs.NTG > 0.50)).sgs(
        variogram=vgm,
        distribution=pst.distributions.from_logs(),
        seed=12,
    )

    recipe = grid.properties.pipelines("por")
    print("POR recipe", recipe["kind"], recipe["property"])
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1] if len(sys.argv) > 1 else None))

#!/usr/bin/env python3
"""Current suite modelling shape: petekIO imports the project, petekStatic owns
the static grid/properties/volumes workflow, and petekSim supplies appraisal
helpers such as synthetic assets and box-model smoke checks.

No confidential data is used or produced.
"""

from __future__ import annotations

import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import petekio as pio  # noqa: E402
import petekstatic as pst  # noqa: E402
import peteksim as ps  # noqa: E402


def main(root: str | None = None) -> int:
    root = root or tempfile.mkdtemp(prefix="model-v2-")
    man = ps.synth_asset(root)
    print(f"peteksim {ps.version()} — suite workflow over {man['root']}\n")

    # INGEST — petekIO owns raw exports and project persistence.
    project = pio.Project.import_data(
        man["root"],
        settings=pio.ImportSettings(crs=man["crs"], aliases=man["aliases"]),
    )
    print("Project.import_data  ", project.inventory())

    # STRUCTURE — petekStatic consumes the petekIO project.
    grid = (
        pst.Grid.from_project(project)
        .geometry(cell=(50.0, 50.0), orient=0.0)
        .horizons(
            [
                {
                    "name": "Top reservoir",
                    "surface": man["horizons"][0],
                    "zone": "Reservoir",
                },
                man["horizons"][-1],
            ],
            well_tie={"influence_radius": 800},
        )
        .layers({"Reservoir": pst.Layering(n=8)})
    )

    # PROPERTIES — constants, formulas, or log-upscale recipes.
    logs = project.wells.logs
    vgm = pst.Var("spherical", major=1500, minor=700, vertical=20, azimuth=35)
    p = grid.properties
    p.ntg = pst.upscale(logs.NetSand).sgs(variogram=vgm, seed=11)
    p.por = pst.upscale(logs.PHIE(logs.NetSand > 0.50)).sgs(
        distribution=pst.distributions.from_logs(),
        variogram=vgm,
        seed=12,
    )
    p.sw = 0.20

    # VOLUMES — deterministic simple volumes on the current workflow facade.
    result = grid.volumes(ntg="ntg", por="por", sw="sw", fluid="oil", fvf=1.30).run()
    print("static volume summary:", result.summary())

    # petekSim remains available for appraisal-level helpers.
    box = ps.run_box_model(
        area_km2=(0.32, 0.40, 0.52),
        gross_height_m={"normal": [15.0, 1.5]},
        porosity=0.25,
        net_to_gross=0.8,
        water_saturation=0.3,
        fvf=1.25,
        fluid="oil",
        contact_m=2743.0,
        seed=42,
    )
    print("box P90/P50/P10:", box.summary_msm3)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1] if len(sys.argv) > 1 else None))

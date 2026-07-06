"""petekSuite — the umbrella meta-package for the petek subsurface-modelling family.

Installing ``peteksuite`` pulls the whole stack:

- ``petekio`` — the DATA layer (ingest, normalize, validate → model-ready inputs)
- ``petekstatic`` — the GEOMODEL layer (framework, grid, properties, volumetrics, MC)
- ``peteksim`` — the SIMULATION layer and the appraisal facade (start here)
- ``petektools`` — the horizontal toolkit (kernels, units, viewer)

The product entry point is ``import peteksim as ps`` — see
https://peteksuite.readthedocs.io/ for the tutorials and the full reference.
"""

from importlib.metadata import PackageNotFoundError, version as _version

__version__ = "0.1.0"

_FAMILY = ("petektools", "petekio", "petekstatic", "peteksim")


def versions() -> dict[str, str]:
    """Installed versions of every family package (plus this meta-package)."""
    out = {"peteksuite": __version__}
    for name in _FAMILY:
        try:
            out[name] = _version(name)
        except PackageNotFoundError:  # pragma: no cover — deps guarantee presence
            out[name] = "not installed"
    return out

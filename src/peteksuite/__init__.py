"""petekSuite — the umbrella meta-package for the petek subsurface-modelling family.

Installing ``peteksuite`` pulls the whole stack:

- ``petekio`` — the DATA layer (ingest, normalize, validate → model-ready inputs)
- ``petekstatic`` — the GEOMODEL layer (framework, grid, properties, volumetrics, MC)
- ``peteksim`` — the SIMULATION layer and the appraisal facade (start here)
- ``petektools`` — the horizontal toolkit (kernels, units, viewer)

Notebook-friendly shorthand is available as ``from peteksuite import pio, pto, pst, ps``:

- ``pio`` → ``petekio``
- ``pto`` → ``petektools``
- ``pst`` → ``petekstatic``
- ``ps`` → ``peteksim``

See
https://peteksuite.readthedocs.io/ for the tutorials and the full reference.
"""

from importlib import import_module
from importlib.metadata import PackageNotFoundError, version as _version

__version__ = "0.1.3"
__all__ = ["__version__", "versions", "pio", "pto", "pst", "ps"]

_FAMILY = ("petektools", "petekio", "petekstatic", "peteksim")
_ALIASES = {
    "pio": "petekio",
    "pto": "petektools",
    "pst": "petekstatic",
    "ps": "peteksim",
}


def versions() -> dict[str, str]:
    """Installed versions of every family package (plus this meta-package)."""
    out = {"peteksuite": __version__}
    for name in _FAMILY:
        try:
            out[name] = _version(name)
        except PackageNotFoundError:  # pragma: no cover — deps guarantee presence
            out[name] = "not installed"
    return out


def __getattr__(name: str):
    if name not in _ALIASES:
        raise AttributeError(f"module 'peteksuite' has no attribute {name!r}")
    module = import_module(_ALIASES[name])
    globals()[name] = module
    return module


def __dir__() -> list[str]:
    return sorted(set(globals()) | set(__all__))

# Repository workflow boundaries

| Repository | CI endpoint | Release endpoint | Registry/security boundary |
|---|---|---|---|
| petekTools | `.github/workflows/ci.yml` | `.github/workflows/release.yml` | crates.io token, PyPI `pypi` environment, repo tag/release |
| petekIO | `.github/workflows/ci.yml` | `.github/workflows/release.yml` | crates.io token, PyPI `pypi` environment, repo tag/release |
| petekStatic | `.github/workflows/ci.yml` | `.github/workflows/release.yml` | crates.io token, PyPI `pypi` environment, repo tag/release |
| petekSim | `.github/workflows/ci.yml` | `.github/workflows/release.yml` | crates.io token, PyPI `pypi` environment, repo tag/release |
| petekSuite | `.github/workflows/docs.yml` | `.github/workflows/release.yml` | PyPI `pypi` environment, suite tag/release |

GitHub discovers triggers in the repository containing the workflow. Keep local
entrypoints unless a separately approved credential/publisher migration changes
the trusted identity and required checks. The central skills own policy,
dispatch, monitoring, release waves, and coherence—not the caller's token.

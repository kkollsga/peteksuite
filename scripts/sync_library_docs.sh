#!/usr/bin/env bash
# Sync per-library documentation into the umbrella docs/ tree.
#
# Each library owns its own guide page + example notebooks in its own repo:
#     <lib>/docs/guide.md
#     <lib>/examples/notebooks/*.ipynb
# This script copies them into the umbrella site so `mkdocs build` is
# self-contained. It is the "simple copy step" alternative to a multirepo plugin
# (chosen for simplicity; see .github/workflows/docs.yml).
#
# The libraries live as siblings of this repo (locally, and as checked-out repos
# in CI). Sources that are missing are skipped with a warning, so the umbrella
# still builds from its committed copies when a sibling isn't present.
#
# Usage:  scripts/sync_library_docs.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# repo-folder  ->  site-slug
LIBS=(
  "petekTools:petektools"
  "petekIO:petekio"
  "petekStatic:petekstatic"
  "petekSim:peteksim"
)

sync_one() {
  local repo="$1" slug="$2" src
  # A sibling repo may sit beside the umbrella, or (in CI) be checked out into
  # _libs/<repo>. Try both.
  for base in "$ROOT/$repo" "$ROOT/_libs/$repo"; do
    if [ -d "$base" ]; then src="$base"; fi
  done
  if [ -z "${src:-}" ]; then
    echo "  ! $repo not found (keeping committed copy)"; return 0
  fi

  # 1. the guide page — rewrite repo-relative links to their in-site equivalents
  #    so `mkdocs build --strict` resolves them.
  if [ -f "$src/docs/guide.md" ]; then
    mkdir -p docs/libraries
    sed -E \
      -e "s#\]\(\.\./examples/notebooks/\)#](../notebooks/index.md)#g" \
      -e "s#\.\./examples/notebooks/([A-Za-z0-9_]+\.ipynb)#../notebooks/$slug/\1#g" \
      -e "s#\.\./examples/notebooks/#../notebooks/$slug/#g" \
      -e "s#\]\(\.\./python/[^)]*SCHEMA\.md\)#](../tutorials/visualization.md)#g" \
      -e "s#\]\((\.\./)+(API|SPEC)\.md\)#](../reference/$slug.md)#g" \
      -e "s#\]\((\.\./)+VIEWER\.md\)#](../tutorials/visualization.md)#g" \
      "$src/docs/guide.md" > "docs/libraries/$slug.md"
    echo "  + docs/libraries/$slug.md"
  else
    echo "  ! $repo/docs/guide.md missing (keeping committed copy)"
  fi

  # 2. the executed notebooks
  if compgen -G "$src/examples/notebooks/*.ipynb" >/dev/null; then
    mkdir -p "docs/notebooks/$slug"
    cp "$src"/examples/notebooks/*.ipynb "docs/notebooks/$slug/"
    # any sidecar images the notebooks reference
    if [ -d "$src/examples/notebooks/img" ]; then
      mkdir -p "docs/notebooks/$slug/img"
      cp -R "$src/examples/notebooks/img/." "docs/notebooks/$slug/img/"
    fi
    echo "  + docs/notebooks/$slug/*.ipynb"
  else
    echo "  ! $repo/examples/notebooks/*.ipynb missing (keeping committed copy)"
  fi
}

echo "Syncing library docs into the umbrella site:"
for entry in "${LIBS[@]}"; do
  sync_one "${entry%%:*}" "${entry##*:}"
  src=""
done

# 3. the CI-tested snippet source for the flagship tutorial
if [ -f "$ROOT/petekSim/examples/model_build_v2.py" ]; then
  cp "$ROOT/petekSim/examples/model_build_v2.py" docs/_snippets/model_build_v2.py
  echo "  + docs/_snippets/model_build_v2.py"
fi

echo "Done."

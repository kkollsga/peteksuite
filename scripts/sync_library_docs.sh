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
# Clone mode (for hosts with no local siblings — e.g. Read the Docs):
#   PETEK_DOCS_CLONE=1 scripts/sync_library_docs.sh
# clones each library's suite-pinned release tag from GitHub into _libs/<repo>
# (a build-local dir, gitignored) before syncing. The tag version is derived
# from the corresponding lower bound in the umbrella pyproject.toml. Override
# the source owner/host or the clone dir:
#   PETEK_DOCS_GIT_BASE=https://github.com/kkollsga   (default)
#   PETEK_DOCS_LIBS_DIR=_libs                          (default, relative to ROOT)
# Set PETEK_DOCS_CLONE_ONLY=1 when the clones are needed only as build/install
# fallbacks; this preserves the reviewed guide/notebook copies committed here.
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

CLONE="${PETEK_DOCS_CLONE:-0}"
CLONE_ONLY="${PETEK_DOCS_CLONE_ONLY:-0}"
GIT_BASE="${PETEK_DOCS_GIT_BASE:-https://github.com/kkollsga}"
LIBS_DIR="${PETEK_DOCS_LIBS_DIR:-_libs}"

# Clone-mode: fetch each library fresh (shallow) into $LIBS_DIR/<repo> unless a
# local sibling or a prior clone is already present. Best-effort — a repo that
# fails to clone is skipped, and sync_one falls back to the committed copy.
floor_version() {
  local package="$1"
  python - "$package" <<'PY'
import re
import sys
import tomllib

package = sys.argv[1]
dependencies = tomllib.load(open("pyproject.toml", "rb"))["project"]["dependencies"]
for dependency in dependencies:
    match = re.fullmatch(rf"{re.escape(package)}>=([^,; ]+)", dependency)
    if match:
        print(match.group(1))
        break
else:
    raise SystemExit(f"no exact lower bound found for {package}")
PY
}

clone_one() {
  local repo="$1" package="$2" version tag
  local dest="$ROOT/$LIBS_DIR/$repo"
  version="$(floor_version "$package")"
  tag="v$version"
  if [ -d "$ROOT/$repo" ]; then
    echo "  = $repo local sibling present (no clone)"; return 0
  fi
  if [ -d "$dest/.git" ] || [ -d "$dest" ]; then
    echo "  = $repo already at $LIBS_DIR/$repo (no clone)"; return 0
  fi
  mkdir -p "$ROOT/$LIBS_DIR"
  if git clone --depth 1 --branch "$tag" "$GIT_BASE/$repo.git" "$dest" 2>/dev/null; then
    echo "  + cloned $repo $tag -> $LIBS_DIR/$repo"
  else
    echo "  ! clone of $GIT_BASE/$repo.git at $tag failed (keeping committed copy)"
  fi
}

sync_one() {
  local repo="$1" slug="$2" src
  # A sibling repo may sit beside the umbrella, or (in CI / clone mode) be
  # checked out into $LIBS_DIR/<repo>. Try both.
  for base in "$ROOT/$repo" "$ROOT/$LIBS_DIR/$repo"; do
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

if [ "$CLONE" = "1" ]; then
  echo "Clone mode: fetching libraries from $GIT_BASE into $LIBS_DIR/"
  for entry in "${LIBS[@]}"; do
    clone_one "${entry%%:*}" "${entry##*:}"
  done
  if [ "$CLONE_ONLY" = "1" ]; then
    echo "Clone-only mode: preserving committed suite documentation."
    exit 0
  fi
fi

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

#!/usr/bin/env bash
# Confidentiality tripwire over the documentation site content.
# Exit 1 on any hit — no confidential identifiers, real-dataset paths, or
# internal-methodology terms may appear in tracked docs (including executed
# notebook outputs, which embed base64 images + printed text).
#
# The hunted patterns are NOT hard-coded here (naming them would itself leak the
# identifiers into a tracked file — cf. the gitignored root scrub-check.sh).
# They are injected via $SCRUB_PATTERNS: locally, export it before running; in
# CI, it comes from the `SCRUB_PATTERNS` repository secret. Absent that, a benign
# default still guards against the most common leak (a local home-path token).
#
# Usage:  SCRUB_PATTERNS='pat1|pat2|...' scripts/scrub_docs.sh
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# The benign default only catches generic machine-path leaks (an absolute
# /Volumes or /Users path accidentally printed into a doc). The real identifier
# set is injected via $SCRUB_PATTERNS and never tracked.
PATTERN="${SCRUB_PATTERNS:-/Volumes/|/Users/}"

hits="$(grep -rniE "$PATTERN" docs mkdocs.yml requirements-docs.txt 2>/dev/null || true)"

if [ -n "$hits" ]; then
  echo "scrub-check: FAIL — confidential-pattern hits in docs content:"
  echo "$hits" | head -40
  exit 1
fi
echo "scrub-check: clean"
exit 0

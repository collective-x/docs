#!/usr/bin/env bash
# Sync openapi.yaml from the canonical spec in the cx-new repo.
#
# Canonical source of truth:  cx-new: openapi/v1-chat.yaml
# Generated copy (this repo): openapi.yaml
#
# Mintlify renders the API Reference tab from this repo's openapi.yaml and
# auto-deploys docs.collectivex.health on push to main. Never edit
# openapi.yaml here by hand — change the spec in cx-new (where it is
# reviewed and linted), then run this script and push.
#
# Usage:            ./scripts/sync-openapi.sh [path-to-cx-new]
# Check-only (CI):  ./scripts/sync-openapi.sh [path-to-cx-new] --check
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cx_new="${1:-$repo_root/../cx-new}"
src="$cx_new/openapi/v1-chat.yaml"
dst="$repo_root/openapi.yaml"

[[ -f "$src" ]] || { echo "canonical spec not found at $src (pass the cx-new path as arg 1)" >&2; exit 1; }

if [[ "${2:-}" == "--check" ]]; then
  cmp -s "$src" "$dst" && echo "openapi.yaml is in sync." || { echo "openapi.yaml is OUT OF SYNC with cx-new — run $0" >&2; exit 1; }
else
  cp "$src" "$dst"
  echo "Synced $(grep -m1 "version:" "$dst" | tr -d " '") from cx-new. Commit and push to deploy."
fi

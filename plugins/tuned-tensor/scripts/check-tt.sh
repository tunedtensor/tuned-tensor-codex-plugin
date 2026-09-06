#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  ""|--cloud) ;;
  *) echo "Usage: $0 [--cloud]" >&2; exit 2 ;;
esac

if ! command -v tt >/dev/null 2>&1; then
  echo "tt CLI is not installed."
  echo "Install it with: npm install -g @tuned-tensor/cli"
  exit 1
fi

echo "tt CLI: $(command -v tt)"
tt --version || true
tt status || true

# Local work does not need an account or an account-backed network request.
if [[ "${1:-}" == "--cloud" ]]; then
  tt auth status || true
  tt balance || true
  tt usage || true
fi

#!/usr/bin/env bash
set -euo pipefail

if ! command -v tt >/dev/null 2>&1; then
  echo "tt CLI is not installed."
  echo "Install it with: npm install -g @tuned-tensor/cli"
  exit 1
fi

echo "tt CLI: $(command -v tt)"
tt --version || true
tt auth status || true
tt balance || true

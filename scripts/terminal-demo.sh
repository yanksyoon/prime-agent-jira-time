#!/usr/bin/env bash
set -euo pipefail
# Safe, non-networked fallback: print the commands covered by the cast.
cat "$(dirname "$0")/../docs/terminal-demo.txt"

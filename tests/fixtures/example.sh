#!/usr/bin/env bash
# Quoting and substitution
set -euo pipefail
name="Platinum"
for file in *.lua; do
  printf '%s: %s\n' "$name" "$file"
done

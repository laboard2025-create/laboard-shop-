#!/bin/bash
set -e

git add .

if git diff --cached --quiet; then
  echo "Nothing to commit."
  exit 0
fi

msg="${1:-save: $(date '+%Y-%m-%d %H:%M:%S')}"
git commit -m "$msg"
git push

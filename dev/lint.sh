#!/usr/bin/env bash
# Lint all shell scripts: syntax check under bash (and zsh if installed), then shellcheck.
set -eu
# shellcheck source=_common.sh
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"
require shellcheck

files=()
while IFS= read -r f; do files+=("$f"); done < <(shell_files)

fail=0

echo "== syntax (bash)"
for f in "${files[@]}"; do bash -n "$f" || fail=1; done

# The scripts under scripts/ are meant to be sourced from zsh too.
if command -v zsh >/dev/null 2>&1; then
  echo "== syntax (zsh)"
  for f in "$ROOT"/scripts/*.sh "$ROOT"/tests/*.sh; do zsh -n "$f" || fail=1; done
fi

echo "== shellcheck"
shellcheck -x -P SCRIPTDIR -s bash "${files[@]}" || fail=1

[ "$fail" -eq 0 ] && echo "lint ok"
exit "$fail"

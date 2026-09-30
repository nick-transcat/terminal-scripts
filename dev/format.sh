#!/usr/bin/env bash
# Format all shell scripts with shfmt (flags below mirror .editorconfig).
#   dev/format.sh           rewrite files in place
#   dev/format.sh --check   report files that need formatting, change nothing (exit 1 if any)
set -eu
# shellcheck source=_common.sh
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"
require shfmt

# Explicit flags (2-space indent, indented case bodies) so results match on every machine.
SHFMT_OPTS=(-ln bash -i 2 -ci)

files=()
while IFS= read -r f; do files+=("$f"); done < <(shell_files)

case "${1:-}" in
  --check | -c) exec shfmt "${SHFMT_OPTS[@]}" -d "${files[@]}" ;;
  "") shfmt "${SHFMT_OPTS[@]}" -l -w "${files[@]}" ;;
  *)
    echo "Usage: dev/format.sh [--check]" >&2
    exit 2
    ;;
esac

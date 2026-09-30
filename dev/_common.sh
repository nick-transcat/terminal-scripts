# shellcheck shell=bash
# Shared helpers for dev/format.sh and dev/lint.sh. Sourced, not executed.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Print every shell file in the repo (find, not git ls-files, so untracked new files count too).
shell_files() {
  find "$ROOT/scripts" "$ROOT/tests" "$ROOT/dev" -type f \( -name '*.sh' -o -name '*.bash' \) | sort
}

# require <tool> — exit with per-platform install hints if it's missing.
require() {
  command -v "$1" >/dev/null 2>&1 && return 0
  {
    echo "Missing required tool: $1"
    echo "  macOS:   brew install $1"
    echo "  Linux:   sudo apt install $1   (or your distro's package manager)"
    echo "  Windows: scoop install $1   (or: choco install $1 / winget install $1)"
  } >&2
  exit 127
}

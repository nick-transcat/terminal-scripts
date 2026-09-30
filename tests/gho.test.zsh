#!/usr/bin/env zsh
# Minimal tests for _gho_repo_url. Run: zsh tests/gho.test.zsh
source "${0:A:h}/../scripts/gho.zsh"

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
git -C "$tmp" init -q
fail=0

check() {  # <remote> <expected>
  git -C "$tmp" remote remove origin 2>/dev/null
  git -C "$tmp" remote add origin "$1"
  got="$(cd "$tmp" && _gho_repo_url)"
  if [[ "$got" == "$2" ]]; then echo "ok   $1"
  else echo "FAIL $1 -> $got (want $2)"; fail=1; fi
}

check git@github.com:org/repo.git                 https://github.com/org/repo
check https://github.com/org/repo.git             https://github.com/org/repo
check https://github.com/org/repo                 https://github.com/org/repo
check https://user:tok@github.com/org/repo.git    https://github.com/org/repo
check ssh://git@github.com/org/repo.git           https://github.com/org/repo
check ssh://git@ghe.example.com:2222/org/repo.git https://ghe.example.com/org/repo
exit $fail

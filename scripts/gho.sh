# shellcheck shell=bash
# gho — open the GitHub page for the repo in the current directory.
#
#   gho         open the repo home page
#   gho -b      open the current branch
#   gho -p      open the pull requests list
#   gho -h      show usage
#
# Works with SSH (git@host:org/repo.git, ssh://git@host/org/repo.git) and
# HTTPS remotes, including GitHub Enterprise hosts.
#
# Portable: source it from bash or zsh (macOS, Linux, WSL, Git Bash).

# Print the https URL for the origin remote, or fail.
_gho_repo_url() {
  local url
  url="$(git config --get remote.origin.url 2>/dev/null)"
  if [[ -z "$url" ]]; then
    echo "Not inside a git repository (or no 'origin' remote)" >&2
    return 1
  fi

  url="${url%.git}"
  url="${url%/}"
  local rest hostpart host
  case "$url" in
    ssh://*)
      rest="${url#ssh://}"
      hostpart="${rest%%/*}"
      hostpart="${hostpart#*@}"
      host="${hostpart%%:*}" # drop :port
      url="https://${host}/${rest#*/}"
      ;;
    git@*:* | *@*:*)
      host="${url#*@}"
      host="${host%%:*}"
      url="https://${host}/${url#*:}"
      ;;
    http://* | https://*)
      rest="${url#*://}"
      hostpart="${rest%%/*}"
      case "$hostpart" in # strip credentials
        *@*) url="${url%%://*}://${hostpart#*@}${rest#"$hostpart"}" ;;
      esac
      ;;
  esac
  printf '%s\n' "$url"
}

# Open a URL with the platform's opener (macOS, Linux, WSL, Git Bash).
_gho_open() {
  if command -v open >/dev/null 2>&1; then
    open "$1"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$1"
  elif command -v wslview >/dev/null 2>&1; then
    wslview "$1"
  elif command -v cmd.exe >/dev/null 2>&1; then
    cmd.exe /c start "" "$1"
  else echo "$1"; fi
}

gho() {
  local repo_url target
  case "$1" in
    -h | --help)
      echo "Usage: gho [-b | -p]"
      echo "  (none)  open the repo home page"
      echo "  -b      open the current branch"
      echo "  -p      open the pull requests list"
      return 0
      ;;
  esac

  repo_url="$(_gho_repo_url)" || return 1
  target="$repo_url"

  case "$1" in
    "") ;;
    -b)
      local branch
      branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null)"
      if [[ -z "$branch" ]]; then
        echo "Detached HEAD — no branch to open" >&2
        return 1
      fi
      target="$repo_url/tree/$branch"
      ;;
    -p) target="$repo_url/pulls" ;;
    *)
      echo "Unknown option: $1 (try gho -h)" >&2
      return 1
      ;;
  esac

  _gho_open "$target"
}

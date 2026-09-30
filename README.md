# terminal-scripts

A small collection of shell functions that make day-to-day terminal work faster. Each script is a
self-contained file in [`scripts/`](scripts) that you `source` from your `~/.zshrc` or `~/.bashrc`.
They're written to work in both bash and zsh, on macOS, Linux, WSL and Git Bash.

## Scripts

| Command | What it does |
| ------- | ------------ |
| [`gho`](scripts/gho.sh) | Open the GitHub page for the repo you're standing in |

### `gho`

```console
$ gho        # open the repo home page
$ gho -b     # open the current branch
$ gho -p     # open the pull requests list
$ gho -h     # usage
```

- Reads the `origin` remote, so it works from any subdirectory of a repo.
- Handles SSH (`git@host:org/repo.git`, `ssh://git@host:port/org/repo.git`) and HTTPS remotes,
  including GitHub Enterprise hosts. Credentials embedded in an HTTPS remote are stripped.
- Cross-platform opener: `open` (macOS), `xdg-open` (Linux), `wslview` / `cmd.exe` (WSL). If none
  is available it prints the URL instead.

## Install

Clone the repo, then source what you want from `~/.zshrc` (zsh) or `~/.bashrc` (bash / Git Bash):

```sh
git clone <this-repo-url> ~/code/terminal-scripts

# in ~/.zshrc — load everything:
for f in ~/code/terminal-scripts/scripts/*.sh; do source "$f"; done

# ...or just one script:
source ~/code/terminal-scripts/scripts/gho.sh
```

Reload with `source ~/.zshrc` / `source ~/.bashrc` (or open a new terminal).

**Requirements:** bash 3.2+ or zsh, and git. On Windows use WSL or Git Bash.

## Tests

```sh
bash tests/gho.test.sh
zsh tests/gho.test.sh
```

## Format and lint

Dev tooling lives in [`dev/`](dev) (kept out of `scripts/` so the install loop doesn't source it).
It needs [`shfmt`](https://github.com/mvdan/sh) and [`shellcheck`](https://www.shellcheck.net)
(`brew install shfmt shellcheck`, `scoop install shfmt shellcheck`, or your distro's package manager).

```sh
dev/format.sh           # rewrite files in place
dev/format.sh --check   # report files needing formatting, change nothing (exit 1 if any)
dev/lint.sh             # bash/zsh syntax check + shellcheck
```

Run `dev/format.sh --check && dev/lint.sh && bash tests/gho.test.sh` before pushing. On Windows, run
these from Git Bash or WSL.

## Adding a script

1. Drop a `scripts/<name>.sh` file defining one public function (prefix helpers with `_<name>_`).
   Stay bash/zsh-portable: no `match[]`/`print`/`${0:A:h}`, no bash-only `BASH_REMATCH` or arrays,
   use `printf` instead of `echo -e`, and prefer `case`/parameter expansion over regex.
2. Put a comment header at the top of the file showing usage.
3. Add a row to the table above and, if it has options, a short section.
4. Add a test under `tests/` for any non-trivial logic.

## License

[MIT](LICENSE)

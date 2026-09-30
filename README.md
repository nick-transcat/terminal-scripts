# terminal-scripts

A small collection of zsh functions that make day-to-day terminal work faster. Each script is a
self-contained file in [`scripts/`](scripts) that you `source` from your `~/.zshrc`.

## Scripts

| Command | What it does |
| ------- | ------------ |
| [`gho`](scripts/gho.zsh) | Open the GitHub page for the repo you're standing in |

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

Clone the repo, then source what you want from `~/.zshrc`:

```zsh
git clone <this-repo-url> ~/code/terminal-scripts

# in ~/.zshrc — load everything:
for f in ~/code/terminal-scripts/scripts/*.zsh; do source "$f"; done

# ...or just one script:
source ~/code/terminal-scripts/scripts/gho.zsh
```

Reload with `source ~/.zshrc` (or open a new terminal).

**Requirements:** zsh and git. Windows users can run these under WSL or Git Bash with zsh installed.

## Tests

```zsh
zsh tests/gho.test.zsh
```

## Adding a script

1. Drop a `scripts/<name>.zsh` file defining one public function (prefix helpers with `_<name>_`).
2. Put a comment header at the top of the file showing usage.
3. Add a row to the table above and, if it has options, a short section.
4. Add a test under `tests/` for any non-trivial logic.

## License

[MIT](LICENSE)

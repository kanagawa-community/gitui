# Contributing to Kanagawa for gitui

Thanks for helping. This port follows the
[Kanagawa community contributing guide](https://github.com/kanagawa-community/.github/blob/main/.github/CONTRIBUTING.md),
which explains conventional commits, the checks every pull request runs, and how
changes are reviewed. This page covers only what is specific to this port.

## Where to report what

- Problems with the theme in gitui, such as wrong colors, poor
  contrast, or a missing variant, belong in this repository's
  [issue tracker](https://github.com/kanagawa-community/gitui/issues).
- Problems in gitui itself belong with its maintainers, not here. Start
  from the [application's page](https://github.com/gitui-org/gitui).
- Changes to the colors themselves belong in the
  [shared palette](https://github.com/kanagawa-community/.github/blob/main/docs/PALETTE.md),
  not in this port. Open an issue in the
  [.github repository](https://github.com/kanagawa-community/.github/issues)
  so every port stays in step.

## Colors

Take colors from the shared [palette](https://github.com/kanagawa-community/.github/blob/main/docs/PALETTE.md)
and follow the [style guide](https://github.com/kanagawa-community/.github/blob/main/docs/STYLE-GUIDE.md).
Do not sample colors from screenshots or add new ones. Every change must work in
Wave, Dragon, and Lotus.

To read the colors from a script, use the machine-readable
[palette.json](https://raw.githubusercontent.com/kanagawa-community/.github/main/palette.json).

## Working on this port

`scripts/generate.py` writes the themes in `themes/` from the shared palette by
role. Do not edit a color value in a theme file. To change a theme:

1. Change the role mapping in `scripts/generate.py`.
2. Run `scripts/generate.py`.
3. Commit its output.

CI fails if a committed theme differs from the generator output. To try a change,
run `./install.sh`, then `gitui -t kanagawa-wave.ron`.

The images in `assets/` are rendered, not captured by hand. After changing a
theme, run this from the repository root and commit the new images:

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/kanagawa-community/.github/main/scripts/render-previews.sh)
```

It fetches the shared preview scripts from the
[.github repository](https://github.com/kanagawa-community/.github).
`scripts/preview.sh` holds the port-specific part and needs `gitui`, `tmux`, `git`,
and Kanagawa for bat. See the
[preview standard](https://github.com/kanagawa-community/.github/blob/main/docs/PREVIEWS.md)
for the rest.

## Pull requests

- Keep each pull request to one change, and include a screenshot of each variant
  it affects.
- Update the README when installation or usage changes.

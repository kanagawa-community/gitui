# Preview hook for .github/scripts/render-previews.sh: gitui runs in a headless
# tmux pane with each theme, in a small repository with a few commits and
# unstaged edits, so the status list, the diff and its syntax colors show.
# Requires: gitui, tmux, git, and the Kanagawa bat port in ~/.config/bat/themes.
# shellcheck shell=bash
name=gitui

setup() {
  mkdir -p "$work/cfg/gitui" "$work/cache"
  cp "$root"/themes/*.ron "$work/cfg/gitui/"
  # The syntax themes come from the bat port, as install.sh does.
  cp "${XDG_CONFIG_HOME:-$HOME/.config}"/bat/themes/kanagawa-*.tmTheme "$work/cfg/gitui/"
  # gitui prints the repository path, so use one that names nobody.
  repo=/tmp/kanagawa-gitui/wave
  rm -rf "$repo"
  mkdir -p "$repo"
  git -C "$repo" init -q -b main
  git -C "$repo" config user.name "Hokusai"
  git -C "$repo" config user.email "hokusai@example.org"
  cat >"$repo/wave.py" <<'PY'
"""Draw a wave."""
import math


def wave(width, height):
    rows = []
    for y in range(height):
        row = "".join("~" if y == round(math.sin(x / 3) * 2) + 3 else " " for x in range(width))
        rows.append(row.rstrip())
    return "\n".join(rows)


if __name__ == "__main__":
    print(wave(40, 7))
PY
  printf '# Wave\n\nDraws a wave.\n' >"$repo/README.md"
  git -C "$repo" add .
  git -C "$repo" commit -q -m "feat: draw a wave"
  printf 'Prints a wave of any size.\n' >>"$repo/README.md"
  git -C "$repo" commit -q -am "docs: describe the size"
  # Unstaged edits for the status list and the diff.
  sed -i 's/"~"/"\\u223c"/; s/wave(40, 7)/wave(60, 9)  # wider/; s/height):/height, step=3):/; s/x \/ 3/x \/ step/' "$repo/wave.py"
  printf 'notes\n' >"$repo/NOTES.txt"
}

stop() { tmux -L kanagawa-preview kill-server 2>/dev/null || true; }

cleanup() {
  stop
  rm -rf /tmp/kanagawa-gitui
}

capture() {
  stop
  sleep 0.5
  tmux -L kanagawa-preview new-session -d -s s -x 100 -y 30 -c /tmp/kanagawa-gitui/wave \
    -e XDG_CONFIG_HOME="$work/cfg" -e XDG_CACHE_HOME="$work/cache" \
    -e COLORTERM=truecolor -e TERM=xterm-256color -e LC_ALL=C.UTF-8 \
    "$(command -v gitui) -t kanagawa-$1.ron"
  sleep 1.5
  # Select wave.py, the second file.
  tmux -L kanagawa-preview send-keys -t s Down
  sleep 0.7
  tmux -L kanagawa-preview capture-pane -p -e -t s >"$2"
}

#!/usr/bin/env python3
"""Write themes/kanagawa-<variant>.ron from the shared palette.

Every gitui theme field takes one palette role. The `syntax` field names the
.tmTheme file of the Kanagawa bat port, which install.sh copies next to the theme.

Usage: scripts/generate.py [path/to/palette.json]   (default: ../.github/palette.json)
"""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
VARIANTS = ["wave", "dragon", "lotus"]

# gitui theme field -> palette role.
FIELDS = {
    "selected_tab": "syn.fun",
    "command_fg": "ui.fg",
    "selection_bg": "ui.bg_visual",
    "selection_fg": "ui.fg",
    "cmdbar_bg": "ui.bg_m3",
    "disabled_fg": "syn.comment",
    "diff_line_add": "vcs.added",
    "diff_line_delete": "vcs.removed",
    "diff_file_added": "vcs.added",
    "diff_file_removed": "vcs.removed",
    "diff_file_moved": "syn.keyword",
    "diff_file_modified": "vcs.changed",
    "commit_hash": "syn.keyword",
    "commit_time": "syn.special1",
    "commit_author": "syn.string",
    "danger_fg": "diag.error",
    "push_gauge_bg": "ui.bg_visual",
    "push_gauge_fg": "syn.fun",
    "tag_fg": "syn.constant",
    "branch_fg": "syn.identifier",
    "block_title_focused": "syn.fun",
}


def roles(variant):
    """Map each role to its hex color; a role missing from the palette raises KeyError later."""
    return {role: c["hex"] for c in variant["colors"].values() for role in c["usage"]}


def theme(variant, colors):
    out = [f"// Kanagawa {variant.capitalize()}", "// https://github.com/kanagawa-community/gitui", "("]
    out += [f'    {field}: Some("{colors[role]}"),' for field, role in FIELDS.items()]
    # A selected line keeps its own color, so added and removed lines stay green and red.
    out += ["    use_selection_fg: Some(false),", f'    syntax: Some("kanagawa-{variant}"),', ")"]
    return "\n".join(out) + "\n"


def main():
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT.parent / ".github" / "palette.json"
    variants = json.loads(path.read_text())["variants"]
    for v in VARIANTS:
        out = ROOT / "themes" / f"kanagawa-{v}.ron"
        out.parent.mkdir(exist_ok=True)
        out.write_text(theme(v, roles(variants[v])))
        print(out.relative_to(ROOT))


if __name__ == "__main__":
    main()

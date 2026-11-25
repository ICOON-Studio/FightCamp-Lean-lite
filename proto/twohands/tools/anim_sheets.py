"""anim_sheets.py - RINGANIM1 (S552): the strips of anim_web.py stacked into a few sheets for the review board.

    python proto/twohands/tools/anim_sheets.py <strips_dir> <out_dir>

One sheet per punch (the player's lands / blocked / missed under each other), one of the other actions, one of the takes
that read wrong and are NOT in the page (the guard holds).
"""
from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image

PUNCHES = ["jab", "cross", "lead_hook", "rear_hook", "body_hook", "body_cross", "lead_uppercut", "rear_uppercut"]
OTHER = ["blue_step_in", "blue_back_off", "blue_feint", "push", "blue_clinch", "blue_knockdown"]
WRONG = ["blue_hold_high", "blue_hold_low"]
MAX_W = 2400


def stack(names: list[str], src: Path, out: Path) -> None:
    ims = [Image.open(src / (n + "_strip.png")) for n in names if (src / (n + "_strip.png")).exists()]
    if not ims:
        return
    ims = [im if im.width <= MAX_W else im.resize((MAX_W, round(im.height * MAX_W / im.width)), Image.LANCZOS) for im in ims]
    sheet = Image.new("RGB", (max(im.width for im in ims), sum(im.height for im in ims) + 6 * (len(ims) - 1)), (21, 18, 17))
    y = 0
    for im in ims:
        sheet.paste(im, (0, y))
        y += im.height + 6
    out.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(out)
    print("SHEET", out.name, len(ims))


def main(argv: list[str]) -> int:
    src, out = Path(argv[0]), Path(argv[1])
    for p in PUNCHES:
        stack(["blue_%s_%s" % (p, r) for r in ("landed", "blocked", "missed")], src, out / ("ringanim_%s.png" % p))
    stack(OTHER, src, out / "ringanim_other_actions.png")
    stack(WRONG, src, out / "ringanim_holds_read_wrong.png")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

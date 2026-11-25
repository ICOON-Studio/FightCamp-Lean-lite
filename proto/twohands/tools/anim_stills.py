"""anim_stills.py - S553: the page's STILLS made from its frame runs, so a still and its run always show the same men.

    python proto/twohands/tools/anim_stills.py

The page falls back to a still when a run is not loaded yet (img/<name>.webp). Until S553 the stills were an older render
(the player seen from behind); the runs are now rendered with both men facing the camera. Each still is one picture of
its run in img/anim/ (frames.json): a punch = its contact picture, guard = the first picture of a hold run (the plain
guard), clinch = the tie-up's last picture, knockdown_1..3 = three pictures of the fall.
"""
from __future__ import annotations

import json
import shutil
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
IMG = HERE.parent / "img"
ANIM = IMG / "anim"


def main() -> int:
    runs = json.loads((ANIM / "frames.json").read_text(encoding="utf-8"))["runs"]
    made = 0

    def put(still: str, run: str, k: int) -> None:
        nonlocal made
        row = runs.get(run)
        if not row:
            print("NO RUN for still %s (%s)" % (still, run))
            return
        files = row["files"]
        shutil.copyfile(ANIM / files[max(0, min(k, len(files) - 1))], IMG / (still + ".webp"))
        made += 1

    for name, row in runs.items():
        if name.rsplit("_", 1)[-1] in ("landed", "blocked", "missed") and not row.get("same_as"):
            put(name, name, max(row.get("contact", 0), 0))
    put("guard", "blue_both_high_high", 0)
    put("clinch", "blue_clinch", 99)
    for col in ("blue", "red"):
        n = len(runs.get(col + "_knockdown", {}).get("files", []))
        for i, k in enumerate((n // 4, n // 2, n - 1)):
            put("%s_knockdown_%d" % (col, i + 1), col + "_knockdown", k)
    print("ANIM_STILLS made=%d" % made)
    return 0


if __name__ == "__main__":
    sys.exit(main())

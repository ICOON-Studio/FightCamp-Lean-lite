"""MOVEPICS1 r4 (S383 skeptic: "3b-3@inside pixel-identical to 3b-3", "3b-3@opp_ropes the same frame as 3b-3@corner") -
no two boxing move cards may be near-identical. Mean absolute RGB difference (0-255) between every pair of the shipped
boxing cards in assets/ui/moves (BJJ cards and pending rows skipped); the closest pairs printed, and any pair at or under
the bound fails.

  python tools/move_pic_diff.py [--dir assets/ui/moves] [--min 3] [--top 12] [--only id,id,...]
      --only: check just the pairs that include one of these cards (the rest of the boxing cards still compared)
Exit code 1 when a pair is at or under --min.
"""
import argparse
import json
import sys
from pathlib import Path

from PIL import Image, ImageChops, ImageStat


def card_file(card_id: str) -> str:
    return card_id.replace(" ", "_").replace("@", "_at_") + ".png"


def mean_diff(a: Image.Image, b: Image.Image) -> float:
    st = ImageStat.Stat(ImageChops.difference(a, b))
    return sum(st.mean) / len(st.mean)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dir", default=str(Path(__file__).resolve().parent.parent / "assets" / "ui" / "moves"))
    ap.add_argument("--min", type=float, default=3.0)
    ap.add_argument("--top", type=int, default=12)
    ap.add_argument("--only", default="")
    a = ap.parse_args()
    d = Path(a.dir)
    rows = json.loads((d / "moves_rows.json").read_text(encoding="utf-8"))
    files = json.loads((d / "moves.json").read_text(encoding="utf-8"))
    ids = sorted(i for i, r in rows.items() if r.get("kind") != "bjj" and not r.get("pending") and i in files
                 and (d / card_file(i)).exists())
    only = [s for s in a.only.split(",") if s]
    imgs = {i: Image.open(d / card_file(i)).convert("RGB") for i in ids}
    pairs = []
    for x in range(len(ids)):
        for y in range(x + 1, len(ids)):
            p, q = ids[x], ids[y]
            if only and p not in only and q not in only:
                continue
            pairs.append((mean_diff(imgs[p], imgs[q]), p, q))
    pairs.sort()
    print(f"MOVE_PIC_DIFF {len(ids)} boxing cards, {len(pairs)} pairs, bound > {a.min}")
    for v, p, q in pairs[:a.top]:
        print(f"  {v:7.2f}  {p}  |  {q}{'   <= BOUND FAIL' if v <= a.min else ''}")
    bad = [t for t in pairs if t[0] <= a.min]
    print(f"MOVE_PIC_DIFF closest {pairs[0][0]:.2f} ({pairs[0][1]} | {pairs[0][2]}); {len(bad)} pair(s) at or under {a.min}"
          if pairs else "MOVE_PIC_DIFF no pairs")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())

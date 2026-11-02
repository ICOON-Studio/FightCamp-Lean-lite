"""Post stills/videos to the ops board's /review page (S192 operator: "i want to be able to see those on the opsboard
to make comments"). EVERY still or video sent to the operator is also posted here - SendUserFile alone is not enough.

    python Tools/review_add.py --title "Pulse fix: red pulse moves" --stage S192 file1.mp4 file2.png[="caption"]

Copies the files into E:/FightCamp/review/<YYYY-MM-DD_HHMM>_<slug>/ (outside git; FIGHTCAMP_REVIEW_DIR overrides) with a
manifest.json. A file argument may carry a caption after "=". Videos should already be silent, compressed .mp4.

S223 operator ("keep the latest versions on"): a post that REPLACES an earlier one names it -
    --supersedes 2026-10-13_1813 [--supersedes <another prefix>]   -> the old post shows "Older version" on /review and his
"Remove all older versions" button takes it off the board (moved to Removed, never deleted).
"""
from __future__ import annotations

import argparse
import json
import re
import shutil
import sys
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent / "opsboard"))
import media_review  # noqa: E402


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--title", required=True)
    ap.add_argument("--stage", default="")
    ap.add_argument("--supersedes", action="append", default=[], help="batch-name prefix of a post this one replaces (repeat)")
    ap.add_argument("files", nargs="+")
    a = ap.parse_args()
    now = datetime.now()
    slug = re.sub(r"[^a-z0-9]+", "_", a.title.lower()).strip("_")[:40] or "post"
    batch = media_review.review_root() / ("%s_%s" % (now.strftime("%Y-%m-%d_%H%M"), slug))
    batch.mkdir(parents=True, exist_ok=True)
    rows = []
    for arg in a.files:
        src_s, _, caption = arg.partition("=")
        src = Path(src_s)
        if not src.is_file() or src.suffix.lower() not in media_review.MEDIA_TYPES:
            print("SKIP (missing or not a still/video): %s" % src)
            continue
        dst = batch / src.name
        n = 1
        while dst.exists():
            dst = batch / ("%s_%d%s" % (src.stem, n, src.suffix))
            n += 1
        shutil.copy2(src, dst)
        rows.append({"name": dst.name, "caption": caption})
    if not rows:
        print("NOTHING POSTED")
        return 2
    (batch / "manifest.json").write_text(json.dumps({"title": a.title, "stage": a.stage, "at": now.strftime("%Y-%m-%dT%H:%M"),
                                                     "files": rows}, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print("POSTED %d file(s) -> http://127.0.0.1:8787/review  (%s)" % (len(rows), batch))
    if a.supersedes:
        hit = media_review.mark_superseded(a.supersedes, batch.name)
        print("OLDER VERSION marked on %d post(s): %s" % (len(hit), ", ".join(hit) or "-"))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

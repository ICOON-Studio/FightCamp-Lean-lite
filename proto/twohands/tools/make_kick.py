"""make_kick.py - kick.html: the kickboxing page, BUILT from order.html (S570, ONERULES1).

Owner S569: "shouldnt kicks and everything else get worked all at once ? because how it knows the current changes ?"
kick.html was a hand-kept copy of order.html (S559 KICKBOX1) and missed every rule fixed on order.html after it was copied
(the v0.568.12 feint fix, the S560 pull counter, STEPFIX1). Now it is order.html + the kick rules as text pairs
(ops/research/s558_balance/kick_page.json, taken from the S559 copy by diffing it against the order.html it came from),
so a rule fixed on order.html reaches the kicks page on the next build - like punch.html, wait.html, one.html, mmc.html.

    python proto/twohands/tools/make_kick.py [a measured tweak .json applied after the kick rules, e.g. kick_fix_f5.json]

Every anchor must be found exactly once: an edit to order.html that moves one stops the build and names it.
order.html is never written. Output is LF (git stores every page LF; the checkout may hand order.html over as CRLF).
"""
from __future__ import annotations

import io
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
SRC = HERE.parent / "order.html"


def build(page_json: Path, out: Path, tag: str, tweak: Path | None = None) -> None:
    s = io.open(SRC, encoding="utf-8", newline="").read().replace("\r\n", "\n")
    pg = json.load(io.open(page_json, encoding="utf-8"))
    names = pg.get("what", [])
    pairs = [(a, b, names[i] if i < len(names) else f"pair {i}") for i, (a, b) in enumerate(pg["src"])]
    if tweak:
        tw = json.load(io.open(tweak, encoding="utf-8"))
        pairs += [(a, b, f"{tweak.name} src {i}") for i, (a, b) in enumerate(tw.get("src", []))]
    for a, b, what in pairs:
        a, b = a.replace("\r\n", "\n"), b.replace("\r\n", "\n")
        if s.count(a) != 1:
            sys.exit(f"{tag} FAIL {what}: anchor found {s.count(a)} times in order.html: {a[:90]!r}")
        s = s.replace(a, b)
    if tweak and tw.get("N"):
        nums = ", ".join(f"{k}: {json.dumps(v)}" for k, v in tw["N"].items()).replace('"', "'")
        if s.count("const N = { ") != 1:
            sys.exit(f"{tag} FAIL the numbers: 'const N = {{ ' not found once")
        s = s.replace("const N = { ", "const N = { " + nums + ", ")
    io.open(out, "w", encoding="utf-8", newline="\n").write(s)
    print(f"{tag} wrote {out.name} from {SRC.name} + {page_json.name}" + (f" + {tweak.name}" if tweak else "") + f" ({len(pairs)} edits)")


if __name__ == "__main__":
    build(ROOT / "ops/research/s558_balance/kick_page.json", HERE.parent / "kick.html", "MAKE_KICK",
          Path(sys.argv[1]) if len(sys.argv) > 1 else None)

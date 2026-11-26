"""KDPIC1 (S566): the edge from a landed run to its knockdown. The page plays <col>_<fam>_landed[_r2|_r1] up to its contact
and then <col>_<fam>_ko (order.html: runOf(e).replace(/_landed$/, '_ko')). Where each man stands (the middle of his shorts,
proto/twohands/tools/edge_table.py edges()) on the landed run's contact picture against the knockdown's first picture (twice
as wide about the same middle: 240 web px in). jump = > 8 px.
    python tools/ko_edge_check.py"""
import json
import sys
from pathlib import Path

sys.argv = sys.argv[:1]
exec(open("proto/twohands/tools/edge_table.py").read().split("def rng")[0])   # D, edges()
runs = json.load(open(D / "frames.json"))["runs"]
out = ["| landed run (contact) | knockdown | red dx | blue dx | jump |", "|---|---|---|---|---|"]
bad = 0
for col in ["red", "blue"]:
    for k in sorted(runs):
        if not (k.startswith(col + "_") and k.endswith("_ko")) or "same_as" in runs[k]:
            continue
        ko = runs[k]
        fam = k[len(col) + 1:-3]
        r0, b0 = edges(ko["files"][0], -240.0)
        for sfx in ["", "_r2", "_r1"]:
            ln = "%s_%s_landed%s" % (col, fam, sfx)
            if ln not in runs or runs[ln].get("contact", -1) < 0:
                continue
            row = runs[ln]
            r1, b1 = edges(row["files"][row["contact"]])
            j = max(abs(r1 - r0), abs(b1 - b0))
            bad += j > 8
            out.append("| %s | %s | %.1f | %.1f | %s |" % (ln, k, r0 - r1, b0 - b1, "JUMP" if j > 8 else "ok"))
print("\n".join(out))
print("KO_EDGE jumps=%d" % bad)

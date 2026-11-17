"""clip_census_report.py - the clip census (assets/data/clip_db.json) as readable tables.

    python tools/clip_census_report.py            # prints markdown tables: punches by family, reactions, defence, drops

FIGHTPLAYER2 phase 1 (S512). The table is written by tools/clip_census.gd; this only reads it.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FAMILIES = ["jab", "cross", "lead_hook", "rear_hook", "lead_uppercut", "rear_uppercut", "body_hook"]


def main() -> int:
    db = json.load(open(os.path.join(ROOT, "assets", "data", "clip_db.json"), encoding="utf-8"))
    rows = db["rows"]
    out = []
    out.append("### Punches that may play (pro_ takes; gap = pelvis to pelvis at contact, m)")
    out.append("| punch | takes that may play | their contact gaps | gap range | hips travel at contact (cm) | hand home after contact (s) |")
    out.append("|---|---|---|---|---|---|")
    for fam in FAMILIES:
        got = sorted([(r["contact_gap_m"], n, r) for n, r in rows.items()
                      if r.get("family") == fam and not r["drop"] and n.startswith("pro_")])
        if not got:
            out.append("| %s | 0 | - | - | - | - |" % fam)
            continue
        gaps = ", ".join("%s %.2f%s" % (r["form"], g, "*" if r["flags"] else "") for g, n, r in got)
        trav = ", ".join("%+.0f" % (100 * r["hips_at_contact_m"]) for g, n, r in got)
        home = [r["home_s"] for g, n, r in got if r["home_s"] >= 0]
        out.append("| %s | %d | %s | %.2f-%.2f | %s | %s |" % (fam, len(got), gaps, got[0][0], got[-1][0], trav,
                                                             ("%.2f-%.2f" % (min(home), max(home))) if home else "-"))
    out.append("")
    out.append("(* = a posture flag for the eye check: lands low / face tips up / glove over the crown / pelvis turned.)")
    out.append("")
    out.append("### Reactions by size (head travel with the body's own travel)")
    out.append("| size | takes that may play | dropped |")
    out.append("|---|---|---|")
    for size in ["light", "medium", "heavy"]:
        ok = sorted(["%s %.0f cm%s" % (n.replace("pro_hit_by_", ""), 100 * r["head_peak_m"],
                                        " (hips %.0f)" % (100 * r["hips_max_m"]) if r["hips_max_m"] >= 0.15 else "")
                     for n, r in rows.items() if r["kind"] == "reaction" and r.get("size") == size and not r["drop"]
                     and n.startswith("pro_")])
        bad = sorted(["%s (%s)" % (n.replace("pro_hit_by_", ""), "; ".join(r["drop"])) for n, r in rows.items()
                      if r["kind"] == "reaction" and r.get("size") == size and r["drop"] and n.startswith("pro_")])
        out.append("| %s | %d: %s | %d: %s |" % (size, len(ok), ", ".join(ok), len(bad), ", ".join(bad)))
    out.append("")
    out.append("### Defence and blocks")
    out.append("| take | head travel (cm) | hips travel (cm) | direction (back, his left, up) | verdict |")
    out.append("|---|---|---|---|---|")
    for n, r in sorted(rows.items()):
        if r["kind"] in ("defence", "block") and n.startswith("pro_"):
            out.append("| %s | %.0f | %.0f | %s | %s |" % (n, 100 * r["head_peak_m"], 100 * r["hips_max_m"], r["head_dir"],
                                                       "; ".join(r["drop"]) or "may play"))
    out.append("")
    out.append("### Played today, dropped by the census")
    for n in db["played"]:
        if rows[n]["drop"]:
            out.append("- %s: %s" % (n, "; ".join(rows[n]["drop"])))
    out.append("")
    out.append("### Played today, flagged for the eye check")
    for n in db["played"]:
        r = rows[n]
        if r["flags"] and not r["drop"]:
            out.append("- %s: %s" % (n, "; ".join(r["flags"])))
    kinds = {}
    for r in rows.values():
        k = kinds.setdefault(r["kind"], [0, 0])
        k[0] += 1
        k[1] += 1 if r["drop"] else 0
    out.append("")
    out.append("Totals: %d takes measured, %d played today, %d dropped (%s)." % (
        len(rows), len(db["played"]), len(db["dropped"]),
        ", ".join("%s %d/%d" % (k, v[1], v[0]) for k, v in sorted(kinds.items()))))
    sys.stdout.reconfigure(encoding="utf-8")
    print("\n".join(out))
    return 0


if __name__ == "__main__":
    sys.exit(main())

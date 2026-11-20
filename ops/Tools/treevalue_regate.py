"""TREEVALUE gate review (S532): re-score a TREEVALUE result table against per-step legs taken from the game's OWN grading.

The old gate (TREEVALUE2: best 1.5..5, one wrong style < 0, every other style 0..+1) asks a step to be worth nothing
against every style but one. Real boxing does not work that way (stepping back answers every forward style). The
corrected legs come from the fight itself, never from the measured cells:

  fit(step, style) = sum over the style's games (Exchanges.STYLE_MODES share) of the step's grade in that game
                     (PlanFight.ANSWERS: best +1, ok +0.5, wrong -1, not listed 0).

  FOR    fit >= 0.40  -> the cell must be >= +1.0 (worth learning against that style)
  WRONG  fit <= -0.20 -> the cell must be <= +0.5 (the step must not pay off against a style it walks into)
  OTHER  in between   -> the cell must be in -1.0 .. +2.0 (no hidden answer, no hidden trap)
  CAP    every cell <= +6.0 (one step stays near StepValue.STACK_CAP 5, +1 for noise)
  WORTH  at least one cell >= +1.0 (a step worth nothing against anyone is not worth learning)
  A step passes when every one of its six cells passes and WORTH holds.

Usage: python ops/Tools/treevalue_regate.py docs/TREEVALUE9_RESULT.md
The tables below are copied from scripts/rules/Exchanges.gd STYLE_MODES and scripts/rules/PlanFight.gd ANSWERS
(press / range / counter / loadup only: a style's own games). Re-copy them if those change.
"""
import re
import sys

STYLE_MODES = {
    "Pressure fighter": {"press": 0.55, "loadup": 0.2, "range": 0.1, "counter": 0.15},
    "Slugger": {"loadup": 0.45, "press": 0.35, "counter": 0.1, "range": 0.1},
    "Out-boxer": {"range": 0.6, "counter": 0.25, "press": 0.05, "loadup": 0.1},
    "Counter-puncher": {"counter": 0.55, "range": 0.25, "press": 0.1, "loadup": 0.1},
    "Volume puncher": {"press": 0.45, "range": 0.35, "counter": 0.1, "loadup": 0.1},
    "Boxer-puncher": {"range": 0.35, "loadup": 0.25, "counter": 0.2, "press": 0.2},
}
ANSWERS = {
    "press": {"best": ["step_back", "pivot_out", "roll_out"], "ok": ["tie_up", "push_off"],
              "wrong": ["step_in", "cut_off", "herd"]},
    "range": {"best": ["step_in", "cut_off"], "ok": ["feint"], "wrong": ["step_out", "step_back"]},
    "counter": {"best": ["feint"], "ok": ["step_in", "step_out"], "wrong": []},
    "loadup": {"best": ["roll_out", "step_back", "tie_up"], "ok": ["pivot_out", "step_in"], "wrong": []},
}
STYLES = list(STYLE_MODES)
FOR_AT, WRONG_AT = 0.40, -0.20
FOR_MIN, WRONG_MAX, OTHER_LO, OTHER_HI, CAP = 1.0, 0.5, -1.0, 2.0, 6.0


def fit(step, style):
    total = 0.0
    for mode, share in STYLE_MODES[style].items():
        row = ANSWERS[mode]
        g = 1.0 if step in row["best"] else 0.5 if step in row["ok"] else -1.0 if step in row["wrong"] else 0.0
        total += share * g
    return total


def leg(f):
    return "FOR" if f >= FOR_AT else "WRONG" if f <= WRONG_AT else "OTHER"


def cell_ok(kind, v):
    if v > CAP:
        return False
    if kind == "FOR":
        return v >= FOR_MIN
    if kind == "WRONG":
        return v <= WRONG_MAX
    return OTHER_LO <= v <= OTHER_HI


def read_cells(path):
    text = open(path, encoding="utf-8").read()
    head = re.search(r"^\| Step \| (Pressure fighter.+) \|$", text, re.M)
    cols = [c.strip() for c in head.group(1).split("|")]
    cells = {}
    for m in re.finditer(r"^\| (\w+) \| (.+) \|$", text, re.M):
        step = m.group(1)
        parts = [p.strip() for p in m.group(2).split("|")]
        if len(parts) != len(cols) or not all(re.match(r"^[+-]\d+\.\d+ \(t", p) for p in parts):
            continue
        cells[step] = {cols[i]: float(re.match(r"^([+-]?\d+\.\d+)", parts[i]).group(1)) for i in range(len(cols))}
    return cells


def main(path):
    cells = read_cells(path)
    passed = 0
    print("| Step | " + " | ".join(STYLES) + " | verdict |")
    print("|------|" + "------|" * len(STYLES) + "---------|")
    fails = []
    for step, row in cells.items():
        out, bad = [], []
        for style in STYLES:
            f = fit(step, style)
            kind = leg(f)
            v = row[style]
            ok = cell_ok(kind, v)
            out.append("%+.1f %s %s (fit %+.2f)" % (v, kind, "ok" if ok else "FAIL", f))
            if not ok:
                bad.append("%s %s %+.1f" % (style, kind, v))
        if max(row[s] for s in STYLES) < FOR_MIN:
            bad.append("WORTH: best cell %+.1f, under +1.0 against every style" % max(row[s] for s in STYLES))
        verdict = "PASS" if not bad else "FAIL"
        passed += not bad
        print("| %s | %s | %s |" % (step, " | ".join(out), verdict))
        if bad:
            fails.append("- %s: %s" % (step, "; ".join(bad)))
    print()
    print("\n".join(fails))
    print()
    print("REGATE done pass=%d/%d" % (passed, len(cells)))


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "docs/TREEVALUE9_RESULT.md")

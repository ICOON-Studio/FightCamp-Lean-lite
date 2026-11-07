"""S397 money bites: aggregate career_harness.gd CAREERJSON lines across processes and check the money bounds.

One career per Godot process keeps each run short (the heat governor may suspend a long one). The harness runs the rules
only (Main.no_render); render=1 builds every screen and awaits a frame per stop (S398 Menus: without that, hundreds of
renders in one frame overflowed Godot's deferred-call queue - signal 11). Run, for k in 0..n-1:
  <godot> --headless --audio-driver Dummy --path . --script res://tools/career_harness.gd -- n=1 first=k weeks=104 money=1 pro=1 sign=1 > out_k.txt
then:  python tools/harness_sum.py out_*.txt          (exit 1 when a bound of ops/research/MONEY_BITES_S397.md 5 fails)
Bounds (sensible): closes none; median cash at each quarter from week 13 is 1-4 months of costs (never above 6);
(careless): can still close (at least 20 %); without the spender habit at most 25 % closed by week 26 (S327).
"""
import json
import statistics
import sys
from collections import defaultdict


def load(paths):
    rows = defaultdict(list)
    for p in paths:
        with open(p, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                if line.startswith("CAREERJSON "):
                    r = json.loads(line[len("CAREERJSON "):])
                    rows[r["policy"]].append(r)
    return rows


def summary(policy, rs):
    closed = [r for r in rs if r["closed"]]
    weeks = sorted(int(r["week"]) for r in closed)
    print("%s: n=%d closed=%d (%.0f%%) close weeks %s | bouts %.1f a career" % (
        policy, len(rs), len(closed), 100.0 * len(closed) / max(1, len(rs)), weeks,
        statistics.mean(r["bouts"] for r in rs) if rs else 0))
    q = defaultdict(list)
    for r in rs:
        for w, v in r["money"]["quarters"].items():
            q[int(w)].append(v)
    meds = {}
    for w in sorted(q):
        meds[w] = statistics.median(x["months"] for x in q[w])
    print("  cash in months of costs by quarter (median of careers still open): " + " | ".join(
        "w%d %.1f (n=%d, $%d)" % (w, meds[w], len(q[w]), statistics.median(x["cash"] for x in q[w])) for w in sorted(q)))
    owned = [r["money"].get("owned", {}) for r in rs]
    print("  owned at the end (mean): upgrades %.1f, premises tier %.1f, staff jobs %.1f" % (
        statistics.mean(o.get("upgrades", 0) for o in owned), statistics.mean(o.get("premises", 0) for o in owned),
        statistics.mean(o.get("staff", 0) for o in owned)))
    lines = defaultdict(int)
    for r in rs:
        for d in (r["money"]["weekly"], r["money"]["one_offs"]):
            for k, v in d.items():
                lines[k] += int(v)
    top = sorted(lines.items(), key=lambda kv: -abs(kv[1]))[:22]
    print("  money a career (mean): " + " | ".join("%s %+d" % (k, round(v / len(rs))) for k, v in top))
    return closed, weeks, meds


def main():
    rows = load(sys.argv[1:])
    ok = True
    for policy in ("careless", "sensible"):
        rs = rows.get(policy, [])
        if not rs:
            continue
        closed, weeks, meds = summary(policy, rs)
        if policy == "sensible":
            if closed:
                print("  BOUND FAIL: a sensible gym closed")
                ok = False
            bad = {w: m for w, m in meds.items() if w >= 13 and not (1.0 <= m <= 4.0)}
            if bad:
                print("  BOUND FAIL: quarters outside 1-4 months: %s" % bad)
                ok = False
        else:
            # Careless can still close (the task), but a player with the old habits only is not wiped out early
            # (operator Q-S294-45 "Money too harsh", S327: 5-25 % closed by week 26). The S397 `spender` habit (buys
            # everything at once) is allowed to close sooner: the Money page shows "leaves $X, about N weeks of costs".
            share = len(closed) / len(rs)
            if share < 0.2:
                print("  BOUND FAIL: careless closed only %.0f%% (it must still be able to close)" % (100 * share))
                ok = False
            old = [r for r in rs if "spender" not in r.get("habits", [])]
            early = [r for r in old if r["closed"] and int(r["week"]) <= 26]
            if old and len(early) / len(old) > 0.25:
                print("  BOUND FAIL: %d of %d careless gyms without the spender habit closed by week 26 (S327: at most 25%%)" % (len(early), len(old)))
                ok = False
            print("  careless without the spender habit: %d careers, %d closed by week 26, %d by the end" % (
                len(old), len(early), len([r for r in old if r["closed"]])))
    print("BOUNDS " + ("OK" if ok else "FAIL"))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())

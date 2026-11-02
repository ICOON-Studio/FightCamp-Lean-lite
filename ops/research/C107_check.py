"""C107 gate (Claude's): the knockdown clock J15 measured, priced against the engine's own bouts.

Exit 0 only when the population is the room's legal, differentiated pair over 60 seeds, every derived figure is
reproduced from the bout rows by THIS script, the `continues` flags agree with each bout's method and stoppage
time, and the markdown opens with DECISIONS.
"""
import json
import math
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
JSON_PATH = os.path.join(HERE, "C107_knockdown_clock.json")
MD_PATH = os.path.join(HERE, "C107_KNOCKDOWN_CLOCK.md")
CLOCKS = {"shortest": 11.0, "typical": 15.0, "longest": 22.5}
TOL = 0.01
fails = []


def fail(msg):
    fails.append(msg)


def main():
    if not os.path.isfile(JSON_PATH):
        print("C107_CHECK FAIL: no JSON")
        return 1
    data = json.load(open(JSON_PATH, encoding="utf-8"))
    pop = data.get("population", {})
    seeds = pop.get("seeds", [])
    if seeds != list(range(810000, 810060)):
        fail("seeds must be 810000..810059")
    if pop.get("ruleset") != "boxing" or int(pop.get("rounds", 0)) != 3:
        fail("population must be boxing over 3 rounds")
    fighters = pop.get("fighters", [])
    if len(fighters) != 2:
        fail("population needs two fighters")
    else:
        a, b = fighters
        if a.get("stats") == b.get("stats") or not a.get("stats"):
            fail("the two men carry identical or empty stats")
        if a.get("height_cm") == b.get("height_cm"):
            fail("the two men share a frame (height)")
        for f in fighters:
            if float(f.get("competition_weight_kg", 0)) > 66.7:
                fail("%s is over welterweight (66.7 kg)" % f.get("name"))

    bouts = data.get("bouts", [])
    if len(bouts) != 60:
        fail("expected 60 bouts, got %d" % len(bouts))
    total_kd = 0
    total_cont = 0
    with_kd = 0
    fight_s = 0.0
    for bout in bouts:
        kds = bout.get("knockdowns", [])
        method = str(bout.get("method", ""))
        stop = float(bout.get("stoppage_s", 0.0))
        cont = 0
        for kd in kds:
            t_s, _round, _target, continues = kd
            ended_here = method in ("KO", "TKO") and stop <= float(t_s) + 0.05
            if bool(continues) == ended_here:
                fail("seed %s: knockdown at %.2f s continues=%s but method %s stoppage %.2f" % (
                    bout.get("seed"), float(t_s), continues, method, stop))
            cont += 1 if continues else 0
        if int(bout.get("continuing_knockdowns", -1)) != cont:
            fail("seed %s: continuing_knockdowns %s, rows give %d" % (bout.get("seed"), bout.get("continuing_knockdowns"), cont))
        total_kd += len(kds)
        total_cont += cont
        with_kd += 1 if kds else 0
        fs = float(bout.get("fight_seconds", 0.0))
        if not (0.0 < fs <= 3 * 180.0 + 0.5):
            fail("seed %s: fight_seconds %.1f outside (0, 540] - a 3-round boxing bout is 3 x 180 s; pass the ruleset's round_seconds and rest_seconds in begin() options (the engine defaults to 300 s rounds) - see TASK_C107" % (bout.get("seed"), fs))
        fight_s += fs
        # SENT BACK 2026-09-13: the first delivery reported every bout at 1-51 s - 1,020 s (five-minute
        # rounds) divided by the tick rate twice - and the (0, 540] bound let it through. Physics bounds now:
        # a bout that went the distance fought exactly 3 x 180 s; a stoppage cannot end after the fight did.
        # FightRealtime METHOD_*: only DECISION goes the distance; KO, TKO and DOCTOR STOPPAGE end it early.
        if method == "DECISION" and abs(fs - 540.0) > 0.5:
            fail("seed %s: a DECISION bout fought %.2f s; three 180 s rounds are 540 s" % (bout.get("seed"), fs))
        if method != "DECISION" and not (0.0 < stop <= 660.0 + 0.5):
            fail("seed %s: stoppage_s %.2f outside the 660 s fight clock" % (bout.get("seed"), stop))

    tool = os.path.join(os.path.dirname(HERE), "tools", "measure_knockdown_clock.gd")
    if os.path.isfile(tool):
        src = open(tool, encoding="utf-8").read()
        if "round_seconds" not in src or "rest_seconds" not in src:
            fail("the tool never passes round_seconds/rest_seconds to begin() - the engine then books 300 s rounds")
    n = max(1, len(bouts))
    d = data.get("derived", {})
    want = {
        "bouts_with_knockdown_pct": 100.0 * with_kd / n,
        "knockdowns_per_bout": total_kd / n,
        "continuing_per_bout": total_cont / n,
    }
    for key, value in want.items():
        got = float(d.get(key, float("nan")))
        if not math.isfinite(got) or abs(got - value) > TOL:
            fail("derived %s %.4f, rows give %.4f" % (key, got, value))
    for clock, secs in CLOCKS.items():
        row = d.get(clock, {})
        per_bout = total_cont * secs / n
        share = 100.0 * total_cont * secs / fight_s if fight_s > 0 else 0.0
        if abs(float(row.get("count_seconds_per_bout", float("nan"))) - per_bout) > TOL:
            fail("%s count_seconds_per_bout wrong (rows give %.3f)" % (clock, per_bout))
        if abs(float(row.get("share_of_fight_pct", float("nan"))) - share) > TOL:
            fail("%s share_of_fight_pct wrong (rows give %.3f)" % (clock, share))

    if not os.path.isfile(MD_PATH):
        fail("no markdown")
    elif not open(MD_PATH, encoding="utf-8").read().lstrip().startswith("## DECISIONS"):
        fail("markdown does not open with ## DECISIONS")

    if fails:
        for f in fails:
            print("FAIL " + f)
        print("C107_CHECK FAIL (%d)" % len(fails))
        return 1
    print("C107_CHECK PASS bouts=%d knockdowns=%d continuing=%d" % (len(bouts), total_kd, total_cont))
    return 0


if __name__ == "__main__":
    sys.exit(main())

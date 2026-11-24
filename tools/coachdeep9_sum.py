"""COACHDEEP9 summary (S545): reads tools/coachdeep9.gd's JSON lines and prints the map's seven bars (DESIGN_COACHDEEP9 s10, = v7's),
v9's loop prints and stop rules (task "Feedback loops") and the one-rep trial's stop checks.
Usage: python tools/coachdeep9_sum.py <out.txt>"""
import json
import sys

HIRES = ["NOHIRE", "L", "M", "S", "F", "K"]
FORCED = {"fall": ["back_coach", "back_boxer", "split"], "raise": ["match", "refuse"], "push": ["allow", "refuse"]}


def load(path):
    arms, cells, run = {}, [], {}
    for line in open(path, encoding="utf-8", errors="replace"):
        if not line.startswith("{"):
            continue
        d = json.loads(line)
        if d.get("tag") == "arm":
            arms.setdefault(d["cell"], {})[d["arm"]] = d
        elif d.get("tag") == "cell":
            cells.append(d)
        elif d.get("tag") == "run":
            run = d
    return arms, cells, run


def main(path):
    arms, cells, run = load(path)
    cut = run.get("cut") or {}
    forced = {k: v for k, v in FORCED.items() if k not in cut}   # THE CUT: a cut moment has no forced arms
    print("RUN cut %s | wages v8 -> v9, pays at N members: %s" % (cut, run.get("wage_v8_v9_pays_at")))
    best_count, forced_count = {}, {k: {} for k in forced}
    gaps = {k: [] for k in forced}
    b2, b5c, b5k, b6r, b6w = [], 0, 0, 0, 0
    corner = {"differ": 0.0, "tac": 0.0, "bond": 0.0}
    runaway = []
    print("cell | best hire (score) | K-NOHIRE +-se | trial-blind +-se | careless lost / careful lost | forced bests")
    for c in cells:
        a = arms[c["cell"]]
        top = max(a[h]["score"] for h in HIRES)
        best = " = ".join(h for h in HIRES if a[h]["score"] > top - 0.01)   # a tie counts for every tied option (never loosens)
        for h in best.split(" = "):
            best_count[h] = best_count.get(h, 0) + 1
        kv, ks = c["k_v_nohire"]
        ok2 = kv > 2 * ks if c["pro"] else kv <= 2 * ks
        b2.append((c["cell"], ok2))
        tv, ts = c["trial_v_blind"]
        b6r += tv > 2 * ts
        b6w += tv < 0
        cl, cf = a["CARELESS"]["lost"], a[c["fav"]]["lost"]
        b5c += cl >= 0.5
        b5k += cf >= 0.5
        fb = {}
        for k, ans in forced.items():
            sc = [a["%s_%s" % (k, x)]["score"] for x in ans]
            gaps[k].append(max(sc) - min(sc))
            top = max(a["%s_%s" % (k, x)]["score"] for x in ans)
            ws = [x for x in ans if a["%s_%s" % (k, x)]["score"] > top - 0.01]   # ties count for each tied answer
            fb[k] = " = ".join(ws) + " " + "/".join("%.1f" % a["%s_%s" % (k, x)]["score"] for x in ans)
            for w in ws:
                forced_count[k][w] = forced_count[k].get(w, 0) + 1
        for h in HIRES:
            for k in corner:
                corner[k] += a[h]["corner"][k]
        for k, r in a.items():
            if r["members"] > r["catch"] + 0.01 or r["two_month"] > 0 or r["bond_max"] > 0.25 + 1e-6 or r["chem_max"] > 1.0:
                runaway.append((c["cell"], k))
        print("%s | %s (%s) | %.1f +- %.1f %s | %.1f +- %.1f | %.2f / %.2f | %s" % (c["cell"], best,
              " ".join("%s %.1f" % (h, a[h]["score"]) for h in HIRES), kv, ks, "ok" if ok2 else "BAD", tv, ts, cl, cf, fb))
        print("   fav %s alt %s list %s roster %s" % (c["fav"], c["alt"], c["list"], c["roster"]))
        for k in sorted(a):
            r = a[k]
            print("   %-16s score %7.1f se %4.1f | cash %6.1f rep %6.1f wl %5.1f mor %5.1f next %6.1f | lost %.2f (box %.2f coach %.2f) %s | mem %.0f/%.0f classes %.2f/%.2f | cash end %.0f min %.0f | fees %.0f mom %.1f warn %.1f run %.1f bond %.2f chem %.2f" % (
                k, r["score"], r.get("se", 0), r["cash"] / 1000, r["rep"] / 3, r["wl"] / 0.5, r["morale"] / 5, r["next"], r["lost"], r["lost_box"], r["lost_coach"],
                r["who"], r["members"], r["catch"], r["classes"], r["wanted"], r["cash_end"], r["cash_min"], r["fees"], r["moments"], r["warn"], r["loss_run"], r["bond_max"], r["chem_max"]))
            if "log" in r and r["log"]:
                print("      log:", "; ".join(r["log"]))
    n = len(cells)
    bars = {}
    bars["1 no hire best in >6"] = (max(best_count.values()) <= 6, best_count)
    bars["2 K pays with pro, not without"] = (all(ok for _, ok in b2), [x for x, ok in b2 if not ok])
    bars["3 no answer best in >6"] = (all(max(v.values()) <= 6 for v in forced_count.values()), forced_count if forced_count else "every moment cut")
    d = max(corner["differ"], 1e-9)
    bars["4 corner tac >=25%, bond >=25%"] = (corner["tac"] / d >= 0.25 and corner["bond"] / d >= 0.25,
                                             "tac %.2f bond %.2f of %.1f differing fights a career-set" % (corner["tac"] / d, corner["bond"] / d, corner["differ"]))
    bars["5 careless loses in >=2, careful <=1"] = (b5c >= 2 and b5k <= 1, "careless %d careful %d" % (b5c, b5k))
    bars["6 trial right >=2, wrong >=2"] = (b6r >= 2 and b6w >= 2, "right %d wrong %d" % (b6r, b6w))
    bars["7 nothing runs away"] = (not runaway, runaway[:10])
    # v9 loop prints and STOP rules (task "Feedback loops")
    print("\nLOOPS: cell | careless lost (warned) | careless_off | careful lost (warned) | careful_off | who carries the warnings (careful; careless) | careers 2+ warnings, one person > 80% (careful; careless)")
    worst_careless, worst_careful, cells80, cash_lo = 0.0, 0.0, 0, []
    for c in cells:
        a = arms[c["cell"]]
        f, cl, clo, cf = a[c["fav"]], a["CARELESS"], a["CARELESS_OFF"], a["CAREFUL_OFF"]
        worst_careless = max(worst_careless, cl["lost"])
        worst_careful = max(worst_careful, f["lost"])
        fired = f["warn2"] > 0 and f["warn80"] > 0.5 * f["warn2"]
        cells80 += fired
        print("  %s | %.2f (%.2f) | %.2f (%.2f) | %.2f (%.2f) | %.2f (%.2f) | %s; %s | %d of %d%s; %d of %d | card %s" % (c["cell"], cl["lost"], cl["warn_left"],
              clo["lost"], clo["warn_left"], f["lost"], f["warn_left"], cf["lost"], cf["warn_left"], f["warn_who"], cl["warn_who"],
              f["warn80"], f["warn2"], " FIRES" if fired else "", cl["warn80"], cl["warn2"], c.get("card")))
        for k, r in a.items():
            if r["cash_lo"] < -40000:
                cash_lo.append((c["cell"], k, round(r["cash_lo"])))
    print("STOP careless > 3 a career in a cell: %s (worst %.2f); careful > 1: %s (worst %.2f)" % (worst_careless > 3.0, worst_careless, worst_careful > 1.0, worst_careful))
    print("STOP one person carries > 80%% of a career's warnings in more than half the cells: %s (%d of %d cells)" % (cells80 > len(cells) / 2, cells80, len(cells)))
    print("CASH no arm under -$40k (lowest career): %s %s" % ("ok" if not cash_lo else "BAD", cash_lo[:10]))
    print("TRIAL CHECKS: best hires by cell %s (all the same: %s); moment spread under 0.5 lines in every cell: %s" % (best_count,
          len(best_count) == 1 and list(best_count.values())[0] == len(cells), {k: all(g < 0.5 for g in v) for k, v in gaps.items()}))
    print("\nBARS (%d cells)" % n)
    for k, (ok, why) in bars.items():
        print("  %s %s: %s" % ("PASS" if ok else "FAIL", k, why))
    print("VERDICT %s - %d of 7" % ("PASS" if all(ok for ok, _ in bars.values()) else "FAIL", sum(ok for ok, _ in bars.values())))


if __name__ == "__main__":
    main(sys.argv[1])

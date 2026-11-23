"""COACHDEEP7 summary (S542): reads tools/coachdeep7.gd's JSON lines and prints the map's seven bars (DESIGN_COACHDEEP7 s10).
Usage: python tools/coachdeep7_sum.py <out.txt>"""
import json
import sys

HIRES = ["NOHIRE", "L", "M", "S", "F", "K"]
FORCED = {"fall": ["back_coach", "back_boxer", "split"], "raise": ["match", "refuse"], "push": ["allow", "refuse"]}


def load(path):
    arms, cells = {}, []
    for line in open(path, encoding="utf-8", errors="replace"):
        if not line.startswith("{"):
            continue
        d = json.loads(line)
        if d.get("tag") == "arm":
            arms.setdefault(d["cell"], {})[d["arm"]] = d
        elif d.get("tag") == "cell":
            cells.append(d)
    return arms, cells


def main(path):
    arms, cells = load(path)
    res = {}
    best_count, forced_count = {}, {k: {} for k in FORCED}
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
        for k, ans in FORCED.items():
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
    bars["3 no answer best in >6"] = (all(max(v.values()) <= 6 for v in forced_count.values()), forced_count)
    d = max(corner["differ"], 1e-9)
    bars["4 corner tac >=25%, bond >=25%"] = (corner["tac"] / d >= 0.25 and corner["bond"] / d >= 0.25,
                                             "tac %.2f bond %.2f of %.1f differing fights a career-set" % (corner["tac"] / d, corner["bond"] / d, corner["differ"]))
    bars["5 careless loses in >=2, careful <=1"] = (b5c >= 2 and b5k <= 1, "careless %d careful %d" % (b5c, b5k))
    bars["6 trial right >=2, wrong >=2"] = (b6r >= 2 and b6w >= 2, "right %d wrong %d" % (b6r, b6w))
    bars["7 nothing runs away"] = (not runaway, runaway[:10])
    print("\nBARS (%d cells)" % n)
    for k, (ok, why) in bars.items():
        print("  %s %s: %s" % ("PASS" if ok else "FAIL", k, why))
    print("VERDICT %s - %d of 7" % ("PASS" if all(ok for ok, _ in bars.values()) else "FAIL", sum(ok for ok, _ in bars.values())))


if __name__ == "__main__":
    main(sys.argv[1])

"""COACHMAP2 summary (S551, ops/research/TASK_COACHMAP2.md; bars written before any run in ops/research/DESIGN_COACHMAP2.md s6).
Reads tools/coachmap2.gd's JSON lines.
  python tools/coachmap2_sum.py ctl <coachdeep9 full.txt> <ctrl outputs...>      season control: every arm line equal
  python tools/coachmap2_sum.py cornerctl <cornerbase1 full_L3.jsonl> [full_L6.jsonl] -- <corner outputs...>
  python tools/coachmap2_sum.py dtab <out.json> <corner outputs...>             the season's change-1 table (wins in 100)
  python tools/coachmap2_sum.py corner <corner outputs...>                     bars 4, 7a, 7b, 8 (why lines), the arms
  python tools/coachmap2_sum.py season <name> <season outputs...> [--base <BASE outputs...>]   bars 1-3, 5-8 of one arm"""
import json
import math
import sys
from collections import defaultdict

HIRES = ["NOHIRE", "L", "M", "S", "F", "K"]
COACHES = ["YOU", "REID", "L", "M", "S", "F", "K"]


def lines(paths):
    for p in paths:
        for ln in open(p, encoding="utf-8", errors="replace"):
            if ln.startswith("{"):
                yield json.loads(ln)


def ms(d):
    n = len(d)
    if n == 0:
        return 0.0, 0.0
    m = sum(d) / n
    v = sum((x - m) ** 2 for x in d) / max(1, n - 1)
    return m, math.sqrt(v / n)


# ---------------- season control ----------------
def ctl(cd9, ours):
    a = {(d["cell"], d["arm"]): d for d in lines([cd9]) if d.get("tag") == "arm"}
    b = {(d["cell"], d["arm"]): d for d in lines(ours) if d.get("tag") == "arm"}
    same, diff = 0, []
    for k, d in b.items():
        if k not in a:
            diff.append((k, "missing in COACHDEEP9"))
            continue
        x = dict(a[k]); y = dict(d)
        if x == y:
            same += 1
        else:
            keys = [kk for kk in set(x) | set(y) if x.get(kk) != y.get(kk)]
            diff.append((k, keys[:6]))
    print("CONTROL season: %d of %d arm lines identical to COACHDEEP9 (cells %s)" % (same, len(b), sorted({k[0] for k in b})))
    for k, why in diff[:20]:
        print("  DIFF", k, why)
    return same == len(b) and len(b) > 0


# ---------------- bouts ----------------
def bouts(paths):
    out = {}
    for d in lines(paths):
        if d.get("tag") == "bout":
            out[(d["L"], d["cell"], d["boxer"], d["arm"])] = d["agg"]
    return out


def cornerctl(cb1, ours):
    ref = {}
    for d in lines(cb1):
        if d.get("tag") == "full":
            ref[(d["L"], d["cell"], d["boxer"], d["pol"])] = d["agg"]["outs"]
    b = bouts(ours)
    ok = n = 0
    bad = []
    for (L, c, bx, arm), g in b.items():
        pol = {"reader": "reader_nr", "file": "file"}.get(arm)
        if pol is None:
            continue
        r = ref.get((L, c, bx, pol))
        if r is None:
            continue
        n += 1
        if r[: len(g["outs"])] == g["outs"]:
            ok += 1
        else:
            bad.append((L, c, bx, arm, g["outs"][:20], r[:20]))
    print("CONTROL bouts: %d of %d boxer x cell x length x arm rows identical bout for bout to CORNERBASE1 (reader_nr, file)" % (ok, n))
    for x in bad[:10]:
        print("  DIFF", x)
    return ok == n and n > 0


def win(ch):
    return 1.0 if ch == "2" else 0.0


def arm_w(b, L, arm):
    ws = []
    for (l, c, bx, a), g in b.items():
        if l == L and a == arm:
            ws += [win(ch) for ch in g["outs"]]
    return 100.0 * sum(ws) / max(1, len(ws)), len(ws)


def paired(b, L, a1, a2, by=None):
    """a1 - a2 over the same bouts (wins in 100, +- 2 SE); by = boxer to restrict."""
    d = []
    for (l, c, bx, a), g in b.items():
        if l != L or a != a1 or (by and bx != by):
            continue
        h = b.get((l, c, bx, a2))
        if h is None:
            continue
        d += [100.0 * (win(x) - win(y)) for x, y in zip(g["outs"], h["outs"])]
    m, se = ms(d)
    return m, 2 * se


def dtab(out, paths):
    b = bouts(paths)
    t = {}
    for L in sorted({k[0] for k in b}):
        row = {}
        for cid in COACHES:
            row[cid] = round(arm_w(b, L, "live:" + cid)[0], 2)
        for tag in ["b", "x", "w"]:
            row["REID:" + tag] = round(arm_w(b, L, "live:REID:" + tag)[0], 2)
        t["L%d" % L] = row
    json.dump(t, open(out, "w"), indent=1)
    print("DTAB", json.dumps(t))


def corner(paths):
    b = bouts(paths)
    Ls = sorted({k[0] for k in b})
    arms = sorted({k[3] for k in b})
    boxers = sorted({k[2] for k in b})
    res = {}
    for L in Ls:
        print("\n## %d rounds - wins in 100 per arm (all five boxers x ten cells)" % L)
        print("| arm | wins | bouts | clue wrong | hearing x | recover corners | rest / hands calls |")
        print("|---|---|---|---|---|---|---|")
        for a in arms:
            w, n = arm_w(b, L, a)
            ex = sum(g["ex"] for k, g in b.items() if k[0] == L and k[3] == a)
            cw = sum(g["clue_wrong"] for k, g in b.items() if k[0] == L and k[3] == a)
            hm = sum(g["hm"] for k, g in b.items() if k[0] == L and k[3] == a) / max(1, sum(g["n"] for k, g in b.items() if k[0] == L and k[3] == a))
            rc = sum(g["rec"] for k, g in b.items() if k[0] == L and k[3] == a)
            co = sum(g["corners"] for k, g in b.items() if k[0] == L and k[3] == a)
            rs = sum(g["rests"] for k, g in b.items() if k[0] == L and k[3] == a)
            hd = sum(g["hands"] for k, g in b.items() if k[0] == L and k[3] == a)
            print("| %s | %.1f | %d | %s | %.2f | %d | %s |" % (a, w, n, "%.0f%%" % (100.0 * cw / ex) if ex else "-", hm, rc,
                  "%.0f%% / %.0f%%" % (100.0 * rs / co, 100.0 * hd / co) if co else "-"))
        print("\nchange 1 against off (paired, +- 2 SE): live:<C> - reader; sim:<C> - file")
        for cid in COACHES:
            m1, s1 = paired(b, L, "live:" + cid, "reader")
            m2, s2 = paired(b, L, "sim:" + cid, "file")
            print("  %-4s live %+.1f +-%.1f | sim %+.1f +-%.1f" % (cid, m1, s1, m2, s2))
        # bar 7a: live over his own simmed corner
        print("\nBAR 7a live:<C> - sim:<C> (wins in 100, +- 2 SE; +6..+15 needed)")
        ok7a = True
        for cid in COACHES:
            m, s = paired(b, L, "live:" + cid, "sim:" + cid)
            ok = 6.0 <= m <= 15.0
            ok7a &= ok
            print("  %-4s %+.1f +-%.1f %s" % (cid, m, s, "ok" if ok else "OUT"))
        # bar 7b: simmed best - worst
        sw = {cid: arm_w(b, L, "sim:" + cid)[0] for cid in COACHES}
        hi = max(sw, key=sw.get); lo = min(sw, key=sw.get)
        m, s = paired(b, L, "sim:" + hi, "sim:" + lo)
        ok7b = 4.0 <= m <= 8.0
        print("BAR 7b simmed best %s - worst %s = %+.1f +-%.1f (4..8 needed) %s" % (hi, lo, m, s, "PASS" if ok7b else "FAIL"))
        # bar 4: tactician F (chem 0) v bonded Reid (+0.5), per boxer x cell
        units = [(c, bx) for (l, c, bx, a) in b if l == L and a == "live:F"]
        tac = bond = tac2 = bond2 = tie = 0
        for c, bx in units:
            g1 = b[(L, c, bx, "live:F")]["outs"]; g2 = b[(L, c, bx, "live:REID:b")]["outs"]
            d = [win(x) - win(y) for x, y in zip(g1, g2)]
            m4, se4 = ms(d)
            if m4 > 0:
                tac += 1; tac2 += m4 > 2 * se4
            elif m4 < 0:
                bond += 1; bond2 += -m4 > 2 * se4
            else:
                tie += 1
        n4 = max(1, len(units))
        print("BAR 4 (%d units) tactician F better %d (%.0f%%; past 2 SE %d), bonded Reid better %d (%.0f%%; past 2 SE %d), equal %d" % (
            len(units), tac, 100.0 * tac / n4, tac2, bond, 100.0 * bond / n4, bond2, tie))
        # bar 8: why lines - bouts whose result changes with change 1
        ch = tot = 0
        for (l, c, bx, a), g in b.items():
            if l != L or not (a.startswith("live:") or a.startswith("sim:")):
                continue
            ref = b.get((l, c, bx, "reader" if a.startswith("live:") else "file"))
            if ref is None:
                continue
            ch += sum(1 for x, y in zip(g["outs"], ref["outs"]) if x != y); tot += len(g["outs"])
        print("BAR 8 why lines: %.1f%% of bouts end differently with change 1 on (live and simmed arms, paired dice)" % (100.0 * ch / max(1, tot)))
        mh, sh = paired(b, L, "liveh:F", "reader"); mf, sf = paired(b, L, "live:F", "reader")
        mbh, _ = paired(b, L, "liveh:REID:b", "reader"); mb, _ = paired(b, L, "live:REID:b", "reader")
        print("HALF: live F %+.1f (half %+.1f); live Reid bond %+.1f (half %+.1f); sim YOU half %.1f v full %.1f; sim K half %.1f v full %.1f" % (
            mf, mh, mb, mbh, arm_w(b, L, "simh:YOU")[0], arm_w(b, L, "sim:YOU")[0], arm_w(b, L, "simh:K")[0], arm_w(b, L, "sim:K")[0]))
        print("per boxer, live:F - reader / sim:K - sim:YOU / live:F - live:REID:b:")
        for bx in boxers:
            print("  %s: %+.1f / %+.1f / %+.1f" % (bx, paired(b, L, "live:F", "reader", bx)[0], paired(b, L, "sim:K", "sim:YOU", bx)[0], paired(b, L, "live:F", "live:REID:b", bx)[0]))
        res[L] = {"7a": ok7a, "7b": ok7b, "4": tac / n4 >= 0.25 and bond / n4 >= 0.25}
    print("\nCORNER BARS", res)


# ---------------- seasons ----------------
def load_season(paths):
    arms = defaultdict(dict)
    gyms = {}
    for d in lines(paths):
        t = d.get("tag")
        if t == "arm":
            arms[(d["cell"], d.get("roster", 0))][d["arm"]] = d
        elif t == "gym":
            gyms[(d["cell"], d["roster"])] = d
        elif t == "cell":   # COACHDEEP9's format (CTRL): one roster, the careful pick = the hire arm named fav
            ros = d["roster"]
            gyms[(d["cell"], 0)] = {"cell": d["cell"], "roster": 0, "size": d["size"], "kind": d["kind"], "pro": d["pro"], "fav": d["fav"],
                                    "blind": d["fav"], "hot": any(r[4] > 60 for r in ros), "young": any(r[1] < 21 for r in ros)}
    for g, a in arms.items():
        if "PICK" not in a and g in gyms:
            a["PICK"] = a[gyms[g]["fav"]]
    return arms, gyms


def season(name, paths, base_paths):
    arms, gyms = load_season(paths)
    G = sorted(gyms)
    n = len(G)
    multi = n > 10
    rows = []
    print("\n# %s - %d gyms" % (name, n))
    # bar 1
    loss, cells1 = [], defaultdict(list)
    for g in G:
        a = arms[g]
        best = max(a[h]["score"] for h in HIRES)
        one = "K" if gyms[g]["pro"] else "F"
        loss.append(best - a[one]["score"])
        cells1[g[0]].append(best - a[one]["score"])
    n1 = sum(1 for x in loss if x >= 10.0)
    need1 = math.ceil(0.3 * n)
    b1 = n1 >= need1
    rows.append(("1 no one-fact hire", b1, "loses >= 10 lines in %d of %d gyms (need %d); per cell mean loss %s" % (
        n1, n, need1, {c: round(sum(v) / len(v), 1) for c, v in cells1.items()})))
    # bar 2
    pro_ok = [(g, a) for g, a in ((g, arms[g]["K"]["d_nohire"]) for g in G) if gyms[g]["pro"]]
    am_ok = [(g, a) for g, a in ((g, arms[g]["K"]["d_nohire"]) for g in G) if not gyms[g]["pro"]]
    p_ok = sum(1 for g, (m, s) in pro_ok if m > 2 * s)
    a_ok = sum(1 for g, (m, s) in am_ok if m <= 2 * s)
    need = 0.9 if multi else 1.0
    b2 = p_ok >= need * len(pro_ok) and a_ok >= need * len(am_ok)
    rows.append(("2 known name", b2, "pays with a pro in %d of %d, does not pay without in %d of %d; K-NOHIRE mean pro %+.1f, none %+.1f" % (
        p_ok, len(pro_ok), a_ok, len(am_ok), sum(m for g, (m, s) in pro_ok) / max(1, len(pro_ok)), sum(m for g, (m, s) in am_ok) / max(1, len(am_ok)))))
    # bar 3
    b3 = True; why3 = []
    for mom, ans in [("raise", ["match", "refuse"]), ("push", ["allow", "refuse"])]:
        best = {}
        for g in G:
            sc = {x: arms[g]["%s_%s" % (mom, x)]["score"] for x in ans}
            top = max(sc.values())
            best[g] = {x for x in ans if sc[x] > top - 0.01}
        outright = {x: sum(1 for g in G if best[g] == {x}) for x in ans}
        facts = {"pro": lambda g: gyms[g]["pro"], "size": lambda g: gyms[g]["size"], "hot": lambda g: gyms[g]["hot"],
                 "young": lambda g: gyms[g]["young"], "card": lambda g: gyms[g]["fav"]}
        if "push_word" in gyms[G[0]]:
            facts["word"] = (lambda g, m=mom: gyms[g]["%s_word" % m])
        acc = {}
        for fn, f in facts.items():
            grp = defaultdict(list)
            for g in G:
                grp[f(g)].append(g)
            acc[fn] = sum(max(sum(1 for g in gs if x in best[g]) for x in ans) for gs in grp.values()) / n
        top = max(acc, key=acc.get)
        ok = acc[top] <= 0.8
        b3 &= ok
        why3.append("%s: outright %s; best single fact %s predicts %.0f%% %s (all %s)" % (mom, outright, top, 100 * acc[top], "ok" if ok else "TOO HIGH",
                                                                                 {k: round(100 * v) for k, v in acc.items()}))
    rows.append(("3 no one-split moment", b3, " | ".join(why3)))
    # bar 4 (season count; the bout bar is in 'corner')
    cn = defaultdict(float)
    for g in G:
        for h in HIRES:
            for k in ["differ", "tac", "bond"]:
                cn[k] += arms[g][h]["corner"][k]
    d = max(cn["differ"], 1e-9)
    rows.append(("4 corner (season count; the bout bar is the verdict)", cn["tac"] / d >= 0.25 and cn["bond"] / d >= 0.25,
                 "tactician %.0f%%, bonded %.0f%% of %.0f differing fights" % (100 * cn["tac"] / d, 100 * cn["bond"] / d, cn["differ"])))
    # bar 5
    cl = sum(1 for g in G if arms[g]["CARELESS"]["lost"] >= 0.5)
    cf = sum(1 for g in G if arms[g]["PICK"]["lost"] >= 0.5)
    need_c, need_k = (math.ceil(0.2 * n), math.floor(0.1 * n))
    gap = defaultdict(list)
    for g in G:
        gap[g[0]].append(arms[g]["CARELESS"]["score"] - arms[g]["PICK"]["score"])
    rows.append(("5 careless loses, careful not", cl >= need_c and cf <= need_k, "careless loses a person in %d gyms (need %d), careful in %d (max %d); careless - careful lines by cell %s" % (
        cl, need_c, cf, need_k, {c: round(sum(v) / len(v), 1) for c, v in gap.items()})))
    # bar 6
    if "wdiff" in arms[G[0]]["PICK"] and any(arms[g]["PICK"]["wdiff"] > 0 for g in G):
        bite = sum(1 for g in G if arms[g]["PICK"]["wdiff"] >= 0.25)
        trap = []
        if base_paths:
            ba, _ = load_season(base_paths)
            for g in G:
                bg = (g[0], 0)
                if bg not in ba:
                    continue
                for h in HIRES[1:]:
                    m0, s0 = ba[bg][h]["d_nohire"]; m1, s1 = arms[g][h]["d_nohire"]
                    if m0 > 2 * s0 and m1 < -2 * s1:
                        trap.append((g, h, round(m0, 1), round(m1, 1)))
        rows.append(("6 the limit bites, no trap", bite >= n / 2 and not trap, "week plan differs in a quarter of weeks in %d of %d gyms (need %d); mean share %.0f%%; traps %s%s" % (
            bite, n, math.ceil(n / 2), 100 * sum(arms[g]["PICK"]["wdiff"] for g in G) / n, trap[:6], "" if base_paths else " (no BASE given)")))
    else:
        rows.append(("6 the limit bites, no trap", None, "limit off in this arm"))
    # bar 7 (season part)
    run, lostc, cash = [], [], []
    for g in G:
        for k, r in arms[g].items():
            if r["members"] > r["catch"] + 0.01 or r["two_month"] > 0 or r["bond_max"] > 0.25 + 1e-6 or r["chem_max"] > 1.0:
                run.append((g, k))
            if r.get("lost_coach_max", 0) > 2:
                lostc.append((g, k))
        ce = sorted(arms[g][h]["cash_end"] for h in HIRES)
        med = (ce[2] + ce[3]) / 2
        bh = max(HIRES, key=lambda h: arms[g][h]["score"])
        if med > 0 and arms[g][bh]["cash_end"] >= 2 * med:
            cash.append((g, bh))
    rows.append(("7 nothing runs away (season part; 7a/7b in 'corner')", not run and not lostc and not cash,
                 "runaway %s; >2 coaches lost %s; best-coach cash >= 2x median %s" % (run[:5], lostc[:5], cash[:5])))
    # bar 8
    mo = [arms[g]["PICK"]["moments"] / 2.0 for g in G]
    rows.append(("8 play: coach pop-ups a season", None, "careful owner mean %.1f, min %.1f, max %.1f a season (target 2-4); in range in %d of %d gyms" % (
        sum(mo) / n, min(mo), max(mo), sum(1 for x in mo if 2 <= x <= 4), n)))
    print("| Bar | Verdict | Numbers |")
    print("|---|---|---|")
    for k, ok, why in rows:
        print("| %s | %s | %s |" % (k, "-" if ok is None else ("PASS" if ok else "FAIL"), why))
    print("PER CELL (mean over rosters): cell | best hire | " + " ".join(HIRES) + " | PICK | CARELESS")
    for c in sorted({g[0] for g in G}):
        gs = [g for g in G if g[0] == c]
        mean = {h: sum(arms[g][h]["score"] for g in gs) / len(gs) for h in HIRES + ["PICK", "CARELESS"]}
        favs = defaultdict(int)
        for g in gs:
            favs[gyms[g]["fav"]] += 1
        print("  %s | %s | %s | %.1f | %.1f | picks %s" % (c, max(HIRES, key=lambda h: mean[h]), " ".join("%.1f" % mean[h] for h in HIRES), mean["PICK"], mean["CARELESS"], dict(favs)))


if __name__ == "__main__":
    cmd = sys.argv[1]
    if cmd == "ctl":
        ctl(sys.argv[2], sys.argv[3:])
    elif cmd == "cornerctl":
        i = sys.argv.index("--")
        cornerctl(sys.argv[2:i], sys.argv[i + 1:])
    elif cmd == "dtab":
        dtab(sys.argv[2], sys.argv[3:])
    elif cmd == "corner":
        corner(sys.argv[2:])
    elif cmd == "season":
        rest = sys.argv[3:]
        base = []
        if "--base" in rest:
            j = rest.index("--base"); base = rest[j + 1:]; rest = rest[:j]
        season(sys.argv[2], rest, base)

"""TELLPLAY1 tables (S543): reads E:/FightCamp/tmp/tellplay1/*.jsonl from tools/tellplay1_probe.gd, prints the bars.
python tools/tellplay1_sum.py [dir]   -> markdown tables on stdout (docs/TELLPLAY1_RESULT.md takes them)."""
import json, sys, statistics as S, math
from pathlib import Path

D = Path(sys.argv[1] if len(sys.argv) > 1 else "E:/FightCamp/tmp/tellplay1")
SITS = ["press", "range", "counter", "loadup", "tiring"]
LIVES = {  # Exchanges.STYLE_MODES weights 0.25 or more: the games a style lives on
    "Pressure fighter": ["press"], "Counter-puncher": ["counter", "range"], "Volume puncher": ["press", "range"],
    "Boxer-puncher": ["range", "loadup"], "Out-boxer": ["range", "counter"], "Slugger": ["loadup", "press"]}


def rows(name, tag):
    p = D / f"{name}.jsonl"
    if not p.exists():
        return []
    out = []
    for ln in p.read_text(encoding="utf-8").splitlines():
        try:
            d = json.loads(ln)
        except ValueError:
            continue
        if d.get("tag") == tag:
            out.append(d)
    return out


def med(xs):
    return S.median(xs) if xs else float("nan")


def bars_read(name):
    rs = rows(name, "read")
    if not rs:
        return None
    types = {}
    for r in rs:
        types.setdefault((r["ti"], r["type"]), []).append(r)
    res = {"types": {}, "max_gain": (0.0, None), "mix_stop": []}
    for (ti, nm), fs in sorted(types.items()):
        per = {s: [] for s in SITS}
        worst = []
        best_ids = {}
        gains = []
        for r in fs:
            ts = r["tsits"]
            for s in SITS:
                if s in ts:
                    g = [l[3] for l in r["lines"] if l[1] == s]
                    if g:
                        per[s].append(max(g))
            tl = [l[3] for l in r["lines"] if l[1] in ts]
            if tl:
                worst.append(min(tl))
            if r["lines"]:
                b = max(r["lines"], key=lambda l: l[3])
                gains.append(b[3])
                if b[3] > res["max_gain"][0]:
                    res["max_gain"] = (b[3], f"{nm} vs {r['style']} / {r['threat']} / {r['weak']}: {b[0]} when {b[1]}")
                if b[3] > 0:
                    k = f"{b[0]}@{b[1]}"
                    best_ids[k] = best_ids.get(k, 0) + 1
            on, off = r["mix"]["on"], r["mix"]["off"]
            for g in LIVES.get(r["style"], []):
                if on.get(g, 0) < 0.05:
                    res["mix_stop"].append((nm, r["style"], r["threat"], r["weak"], g, off.get(g), on.get(g)))
        sit_med = {s: (med(per[s]), len(per[s]), max(per[s]) if per[s] else float("nan")) for s in SITS}
        top = max(best_ids.items(), key=lambda kv: kv[1]) if best_ids else ("none", 0)
        res["types"][nm] = {"sit": sit_med, "pass_sits": sum(1 for s in SITS if sit_med[s][0] >= 3.0),
                            "worst_med": med(worst), "top_line": top, "files": len(fs), "gain_med": med(gains),
                            "usual_med": med([r["usual"] for r in fs])}
    t = res["types"]
    res["bar1"] = sum(1 for v in t.values() if v["pass_sits"] >= 4)
    res["bar2"] = res["max_gain"][0] <= 10.0
    res["bar3"] = sum(1 for v in t.values() if v["worst_med"] <= -2.0)
    res["bar4"] = all(v["top_line"][1] <= v["files"] / 2 for v in t.values())
    return res


def table_read(name, title):
    r = bars_read(name)
    if r is None:
        return f"(no {name})\n"
    o = [f"### {title} ({name})", "",
         "| Type | " + " | ".join(f"{s}: median / max (files)" for s in SITS) + " | sits >= 3 | worst line median | most-often best line (files of 180) | usual median |",
         "|---" * (len(SITS) + 5) + "|"]
    for nm, v in r["types"].items():
        cells = [f"{v['sit'][s][0]:.1f} / {v['sit'][s][2]:.1f} ({v['sit'][s][1]})" for s in SITS]
        o.append(f"| {nm} | " + " | ".join(cells) + f" | {v['pass_sits']} | {v['worst_med']:.1f} | {v['top_line'][0]} ({v['top_line'][1]}) | {v['usual_med']:.1f} |")
    o += ["", f"Bar 1 (4 of 5 situations at a median 3+): **{r['bar1']} of 10 types** (pass 6). "
          f"Bar 2 (no line over 10): max **{r['max_gain'][0]:.1f}** ({r['max_gain'][1]}) -> {'PASS' if r['bar2'] else 'FAIL'}. "
          f"Bar 3 (worst line median -2 or lower): **{r['bar3']} of 10** (pass 6). "
          f"Bar 4 (no line best on more than half the files): {'PASS' if r['bar4'] else 'FAIL'}. "
          f"Mix STOP cases (a lived-on game under 5%): {len(r['mix_stop'])}.", ""]
    if r["mix_stop"]:
        o.append("Mix stops: " + "; ".join(str(x) for x in r["mix_stop"][:10]))
    return "\n".join(o) + "\n"


def mix_table(name):
    rs = rows(name, "read")
    seen = {}
    for r in rs:
        if r["ti"] != 0:
            continue
        key = (r["style"], r["threat"], r["weak"])
        if r["tsits"] and r["weak"] in ("Leaves the chin open", "Walks in straight", "Backs straight up"):
            seen[key] = r
    o = ["| Opponent file (style / weapon / weakness) | tell -> game | mix off: press / range / counter / loadup | mix on |", "|---|---|---|---|"]
    for k, r in list(seen.items())[:24]:
        f = lambda m: " / ".join(f"{100*m.get(s,0):.0f}" for s in ["press", "range", "counter", "loadup"])
        o.append(f"| {' / '.join(k)} | {', '.join(f'{v}: {s}' for s, v in r['tsits'].items())} | {f(r['mix']['off'])} | {f(r['mix']['on'])} |")
    return "\n".join(o) + "\n"


def bout_lines(name="bout_lines"):
    rs = rows(name, "bout_line")
    if not rs:
        return "(no bout_lines)\n"
    o = ["| Situation | files x bouts | read gain (rules on) | read gain (B off) | real-bout gain | 2 SE | read - bout | bar 5 |", "|---|---|---|---|---|---|---|---|"]
    allok = True
    for s in SITS:
        g = [r for r in rs if r["sit"] == s]
        if not g:
            continue
        n = sum(r["n"] for r in g)
        rd = S.mean(r["read_gain"] for r in g)
        rd0 = S.mean(r["read_gain_boff"] for r in g)
        bt = 100.0 * sum(r["win_line"] - r["win_usual"] for r in g) / n
        # paired: each bout's difference is -1, 0 or +1; variance from the discordant share
        disc = sum(r["disc"] for r in g) / n
        mean_d = bt / 100.0
        se = 100.0 * math.sqrt(max(disc - mean_d * mean_d, 1e-9) / n)
        ok = abs(rd - bt) <= 3.0
        allok &= ok
        o.append(f"| {s} | {len(g)} x {g[0]['n']} | {rd:.1f} | {rd0:.1f} | {bt:.1f} | {2*se:.1f} | {rd-bt:+.1f} | {'PASS' if ok else 'FAIL'} |")
    o.append("")
    o.append(f"Bar 5: {'PASS' if allok else 'FAIL'}")
    return "\n".join(o) + "\n"


def bout_base(name="bout_base"):
    rs = rows(name, "bout_base")
    if not rs:
        return "(no bout_base)\n"
    n = sum(r["n"] for r in rs)
    d = 100.0 * sum(r["win_on"] - r["win_off"] for r in rs) / n
    disc = sum(r["disc"] for r in rs) / n
    se = 100.0 * math.sqrt(max(disc - (d / 100) ** 2, 1e-9) / n)
    cells = {}
    for r in rs:
        c = cells.setdefault((r["tstyle"], r["style"]), [0, 0, 0, 0])
        c[0] += r["n"]; c[1] += r["win_off"]; c[2] += r["win_on"]; c[3] += r["disc"]
    worst = (0.0, None)
    o = ["| Boxer style \\ opponent style | " + " | ".join(sorted({k[1] for k in cells})) + " |", "|---" * (1 + len({k[1] for k in cells})) + "|"]
    for ts in sorted({k[0] for k in cells}):
        row = []
        for os_ in sorted({k[1] for k in cells}):
            c = cells.get((ts, os_))
            if not c:
                row.append("-"); continue
            dd = 100.0 * (c[2] - c[1]) / c[0]
            ss = 100.0 * math.sqrt(max(c[3] / c[0] - (dd / 100) ** 2, 1e-9) / c[0])
            row.append(f"{100*c[1]/c[0]:.0f} -> {100*c[2]/c[0]:.0f} ({dd:+.1f} +-{2*ss:.1f})")
            if abs(dd) > abs(worst[0]):
                worst = (dd, f"{ts} vs {os_}")
        o.append(f"| {ts} | " + " | ".join(row) + " |")
    rd = S.mean(r["read_on"] - r["read_off"] for r in rs)
    ok = abs(d) < 2.0 and abs(worst[0]) <= 6.0
    o += ["", f"Population: {n} paired bouts, win rate {100*sum(r['win_off'] for r in rs)/n:.1f}% -> {100*sum(r['win_on'] for r in rs)/n:.1f}% "
          f"(**{d:+.2f}** points, 2 SE {2*se:.2f}); the read moves {rd:+.2f}. Largest cell: {worst[0]:+.1f} ({worst[1]}). Bar 6: {'PASS' if ok else 'FAIL'}", ""]
    return "\n".join(o) + "\n"


if __name__ == "__main__":
    for nm, title in [("read_off", "Rules OFF (today, the control arm), coach 58"), ("read_on", "Rule A on, rule B off, coach 58"),
                      ("read_chain", "Rule A on, rule B = chain, coach 58"), ("read_c095", "Rule A on, rule B = carry 0.95, coach 58"),
                      ("read_c40", "Rules on (final), coach 40"), ("read_final", "Rules on (final), coach 58"), ("read_c75", "Rules on (final), coach 75")]:
        if (D / f"{nm}.jsonl").exists():
            print(table_read(nm, title))
    print("### The mix, rules off and on (Lucy Jackson's files with one tell)\n")
    print(mix_table("read_on"))
    print("### Bar 5: the read against the real bout\n")
    print(bout_lines())
    print("### Bar 6: the coach's plan, rule A off -> on, real bouts (win %)\n")
    print(bout_base())

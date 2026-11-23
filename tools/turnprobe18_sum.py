"""TURNPROBE18 (S543) summary: the measure-first jsonl of tools/turnprobe18.gd -> markdown tables for docs/TURNPROBE18_RESULT.md.
Usage: python tools/turnprobe18_sum.py <measure.jsonl> [<measure0.jsonl>]
The second file (optional) is the first measure, on the signing's own book (no drilled combination), printed as one table."""
import json
import sys


def load(path):
    with open(path, encoding="utf-8") as fh:
        return [json.loads(x) for x in fh if x.strip()]


def main():
    rows = load(sys.argv[1])
    run = next(r for r in rows if r.get("tag") == "run")
    meas = [r for r in rows if r.get("tag") == "measure"]
    verdict = next(r for r in rows if r.get("tag") == "measure_verdict")
    out = []
    out.append("## Measure first: the same-rated man (gap 0), 180 files, debut week (points of win chance)\n")
    out.append("| Type | Ambition | Usual plan: lowest / median / highest file | Best line over usual: median / 90th / max | Best - worst line: median / max | Files with best - worst >= 4 |")
    out.append("|---|---|---|---|---|---|")
    for m in meas:
        s = m["same_rated"]
        out.append(f"| {m['type']} | {m['ambition']} (pot {m['pot']}) | {s['usual_min']} / {s['usual_p50']} / {s['usual_max']} | "
                   f"{s['gain_median_pts']} / {s['gain_p90_pts']} / {s['gain_max_pts']} | {s['spread_median_pts']} / {s['spread_max_pts']} | "
                   f"{round(100 * s['share_spread_4plus'])}% |")
    out.append("")
    out.append(f"Verdict line: best - worst median under 4 points for **{verdict['types_under_4pts']} of {len(meas)}** types "
               f"(STOP when most); the largest gain a line gives over the usual plan **{verdict['max_plan_gain_pts']}** points "
               f"(cap 10: {'over' if verdict['cap_over_10'] else 'inside'}).\n")
    out.append("## Which tell a line can answer (same-rated man; points over the usual plan)\n")
    sits = ["press", "range", "counter", "loadup", "tiring"]
    out.append("| Type | " + " | ".join(f"{s}: best median / max, worst median" for s in sits) + " |")
    out.append("|---|" + "---|" * len(sits))
    for m in meas:
        by = m["same_rated"]["by_situation"]
        cells = []
        for s in sits:
            b = by.get(s)
            cells.append("-" if not b else f"{b['best_gain_median']} / {b['best_gain_max']}, {b['worst_median']}")
        out.append(f"| {m['type']} | " + " | ".join(cells) + " |")
    out.append("")
    out.append("## At the tune-up's aim (the rating where the usual plan reads 82% against a plain man)\n")
    out.append("| Type | Usual plan across files: 10th / median / 90th (lowest - highest) | Best line over usual: median / max | Fade line (tiring) best median / max | Plain man now -> four weeks on |")
    out.append("|---|---|---|---|---|")
    for m in meas:
        t = m["tune_aim"]
        tr = t["by_situation"].get("tiring")
        ny = m["not_yet_plain_tune"]
        out.append(f"| {m['type']} | {t['usual_p10']} / {t['usual_p50']} / {t['usual_p90']} ({t['usual_min']} - {t['usual_max']}) | "
                   f"{t['gain_median_pts']} / {t['gain_max_pts']} | {'-' if not tr else str(tr['best_gain_median']) + ' / ' + str(tr['best_gain_max'])} | "
                   f"{round(100 * ny[0], 1)} -> {round(100 * ny[1], 1)} |")
    out.append("")
    out.append("## The bars' card line and the name tiers (from tools/turnprobe18_rules.gd)\n")
    out.append("| Type | Trait -> KO hit | Club's cut | Card lines (conf 66 / hunger 70; 30 / 15; 90 / 95 ring ON; 90 / 95 ring OFF) | Tier 0 / 1 / 2: purse, points |")
    out.append("|---|---|---|---|---|")
    for m in meas:
        ti = m["tiers"]
        tiers = " / ".join(f"$" + f"{t['purse']} ({t['points']})" for t in ti)
        out.append(f"| {m['type']} | {m['conf_trait']:.0f} -> {m['ko_hit']} | {round(100 * m['share'])}% | {'; '.join(m['bar_lines'])} | {tiers} |")
    if len(sys.argv) > 2:
        old = [r for r in load(sys.argv[2]) if r.get("tag") == "measure"]
        out.append("\n## First measure, on the signing's own book (identical punches for all ten, no drilled combination)\n")
        out.append("| Type | Usual lowest - highest | Best line over usual: median / max | Best - worst: median / max |")
        out.append("|---|---|---|---|")
        for o in old:
            r = o["row"]
            out.append(f"| {r['type']} | {round(100 * r['usual_min'])} - {round(100 * r['usual_max'])} | {r['gain_median_pts']} / {r['gain_max_pts']} | "
                       f"{r['spread_median_pts']} / {r['spread_max_pts']} |")
    out.append(f"\nPopulation books (punches, drilled combinations, step bars): {json.dumps(run.get('books', []))[:4000]}")
    print("\n".join(out))


if __name__ == "__main__":
    main()

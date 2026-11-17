"""S505 TRUNKTAP report: which layer of the stack makes the head-from-hips jumps (tools/trunk_tap.gd lines).

    python tools/trunk_tap_report.py <godot.log> [--over 8] [--kind jab]

Reads every `TRUNKTAP s=.. who=.. clip=.. fin=.. in=.. <layer>=..` line (cm along that frame's jump; they sum to fin).
For the frames whose head-from-hips jump is over --over cm (optionally only clips containing --kind), prints how many
there are, and per layer: the summed cm, the share of the total, and on how many frames it gave the most.
"""
import re
import sys
from collections import defaultdict


def main():
    args = sys.argv[1:]
    path = args[0]
    over = float(args[args.index("--over") + 1]) if "--over" in args else 8.0
    kind = args[args.index("--kind") + 1] if "--kind" in args else ""
    sums = defaultdict(float)
    tops = defaultdict(int)
    n = 0
    worst = []
    for line in open(path, encoding="utf-8", errors="ignore"):
        if not line.startswith("TRUNKTAP"):
            continue
        parts = dict(p.split("=", 1) for p in line.split()[1:] if "=" in p)
        fin = float(parts.get("fin", 0))
        clip = parts.get("clip", "")
        if fin < over or (kind and kind not in clip):
            continue
        n += 1
        layers = {k: float(v) for k, v in parts.items() if k not in ("s", "who", "clip", "fin")}
        for k, v in layers.items():
            sums[k] += v
        if layers:
            tops[max(layers, key=layers.get)] += 1
        worst.append((fin, parts.get("s"), parts.get("who"), clip, layers))
    total = sum(sums.values()) or 1.0
    print("TRUNKTAP_REPORT frames=%d over=%.0fcm kind=%s" % (n, over, kind or "all"))
    for k, v in sorted(sums.items(), key=lambda kv: -kv[1]):
        print("  %-14s %7.1f cm  %5.1f%%  top on %d" % (k, v, 100.0 * v / total, tops.get(k, 0)))
    for fin, s, who, clip, layers in sorted(worst, key=lambda w: -w[0])[:8]:
        top = ", ".join("%s %.1f" % kv for kv in sorted(layers.items(), key=lambda kv: -kv[1])[:3])
        print("  worst %.1f cm s=%s who=%s %s: %s" % (fin, s, who, clip, top))


if __name__ == "__main__":
    main()

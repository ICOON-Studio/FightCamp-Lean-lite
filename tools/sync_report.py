"""S302 sync report (operator: "their movement is like synchronized", "robotic"): reads a fight film's frame log
(tools/fight3d_film.gd joins=<csv>) and prints how much the two boxers move as one.
  python tools/sync_report.py <joins.csv>
- hips bounce correlation while both stand in a guard clip (1.0 = lockstep; the S302 film read 0.92),
- the share of one boxer's clip changes that fall within 0.1 s of the other's (the S302 film: 51%),
- the share of the fight each boxer spends in the plain guard loop (the S302 film: 70%).
"""
import csv
import statistics as st
import sys

GUARDS = ("pro_idle", "pro_idle_fidget")


def corr(a, b):
    ma, mb = st.mean(a), st.mean(b)
    num = sum((p - ma) * (q - mb) for p, q in zip(a, b))
    den = (sum((p - ma) ** 2 for p in a) * sum((q - mb) ** 2 for q in b)) ** 0.5
    return num / den if den else 0.0


def main(path):
    by = {}
    for r in csv.DictReader(open(path)):
        by.setdefault(int(r["frame"]), {})[r["who"]] = r
    frames = sorted(f for f in by if len(by[f]) == 2)
    a, b = [], []
    for f in frames:
        x, y = by[f]["0"], by[f]["1"]
        if x["clip"].startswith(GUARDS) and y["clip"].startswith(GUARDS):
            a.append(float(x["Hips_y"]))
            b.append(float(y["Hips_y"]))
    print("frames both in guard: %d of %d" % (len(a), len(frames)))
    print("hips bounce correlation in guard: %.2f (1.0 = lockstep; S302 film 0.92)" % corr(a, b))
    changes = {"0": [], "1": []}
    prev = {}
    for f in frames:
        for w in "01":
            c = by[f][w]["clip"]
            if prev.get(w) != c:
                changes[w].append(f)
            prev[w] = c
    together = sum(1 for f in changes["0"] if any(abs(f - g) <= 3 for g in changes["1"]))
    print("clip changes A %d, B %d; A within 0.1 s of B: %.0f%% (S302 film 51%%)" % (
        len(changes["0"]), len(changes["1"]), 100.0 * together / max(1, len(changes["0"]))))
    for w in "01":
        plain = sum(1 for f in frames if by[f][w]["clip"] == "pro_idle")
        print("boxer %s in the plain guard loop: %.0f%% of the fight (S302 film 70%%)" % (w, 100.0 * plain / len(frames)))


if __name__ == "__main__":
    main(sys.argv[1])

"""S531 THE FOUR FAULTS THAT NEVER MOVED (films 6, 7, 9: in every critic's list). One line each, read off shown.csv
(tools/human_fight_film.gd), headless or filmed:
  python tools/fight_persist_rulers.py <dir with shown.csv> [list]
  1 ARM HOME    after a punch take's furthest reach the punching wrist is back within HOME_M of its own chin side in
                at most ARM_F frames (the critics: jab 4-6, cross / hook 6-8). Counted on EVERY punch take, a miss too.
  2 FREE HAND   while one hand punches the other wrist stays within FREE_M of the head bone (never over the crown,
                never at the hip).
  3 APART       hips never closer than HIPS_M; no ankle within BOOT_M of an ankle of the other man.
  4 STANCE      a man's own ankles never closer than ANKLE_M (knock-kneed, boots touching).
  5 REACH      (the owner, S531: "restrict the fighters to punch when they are too far from each other and there is no
                chance to reach the opponent") a thrown punch whose wrist never comes within REACH_M of the other man's
                head or chest; and a paw or a feint (a punch take shown under 8 frames) started with the hips over
                FAR_M apart.
`list` prints the worst cases (film s, who, clip)."""
import csv
import math
import sys
from collections import defaultdict

ARM_F = 8
HOME_M = 0.08    # over the wrist-to-head distance his own waiting guard holds (median, per hand)
FREE_M = 0.12    # the same for the free hand
HIPS_M = 0.30    # CHEST to chest (hips stay apart while the trunks lean through each other)
BOOT_M = 0.15
ANKLE_M = 0.30
REACH_M = 0.40   # wrist to the other man's head / chest bone at its nearest (the glove is 10-15 cm past the wrist)
FAR_M = 1.30
PUNCH_WORDS = ("jab", "cross", "hook", "uppercut", "body_shot", "kidney")
REACT = ("pro_hit", "react_", "mc_hit")


def v(r, b):
    return (float(r[b + "_x"]), float(r[b + "_y"]), float(r[b + "_z"]))


def is_punch(c):
    return any(w in c for w in PUNCH_WORDS) and not c.startswith(REACT)


def hand_of(c):
    return "RightHand" if ("right" in c or "cross" in c or "kidney" in c) else "LeftHand"


def measure(d):
    rows = [r for r in csv.DictReader(open(d + "/shown.csv")) if r["scene"] == "0"]
    by = defaultdict(list)
    for r in rows:
        by[r["who"]].append(r)
    out = {"arm": [], "free": [], "hips": [], "boot": [], "stance": [], "reach": [], "far_beat": [], "beats": 0}
    for who, rs in by.items():
        other = {r["frame"]: r for w2, rows2 in by.items() if w2 != who for r in rows2}
        guard = {}
        for h in ("LeftHand", "RightHand"):
            ds = sorted(math.dist(v(r, h), v(r, "Head")) for r in rs if "st_wait" in r["clip"] or r["clip"] == "pro_idle")
            guard[h] = ds[len(ds) // 2] if ds else 0.25
        # runs of one punch take
        i = 0
        while i < len(rs):
            c = rs[i]["clip"]
            if not is_punch(c):
                i += 1
                continue
            j = i
            while j + 1 < len(rs) and rs[j + 1]["clip"] == c and float(rs[j + 1]["clip_t"]) >= float(rs[j]["clip_t"]):
                j += 1
            hand = hand_of(c)
            free = "LeftHand" if hand == "RightHand" else "RightHand"
            reach = [math.dist(v(r, hand), v(r, "Head")) for r in rs[i:j + 1]]
            o0 = other.get(rs[i]["frame"])
            if j - i < 8 and o0 is not None:   # a paw or a feint
                out["beats"] += 1
                g0 = math.hypot(float(rs[i]["Hips_x"]) - float(o0["Hips_x"]), float(rs[i]["Hips_z"]) - float(o0["Hips_z"]))
                if g0 > FAR_M:
                    out["far_beat"].append((round(g0, 2), float(rs[i]["film_s"]), who, c))
            if j - i >= 8 and max(reach) > 0.45:   # a thrown punch, not a paw
                near = 9.0
                for r in rs[i:j + 1]:
                    o = other.get(r["frame"])
                    if o is not None:
                        near = min(near, math.dist(v(r, hand), v(o, "Head")), math.dist(v(r, hand), v(o, "Chest")))
                if near > REACH_M:
                    out["reach"].append((round(near, 2), float(rs[i]["film_s"]), who, c))
                k = reach.index(max(reach))
                # frames from the furthest reach until the wrist is home (the frames after the take count too)
                n = 0
                while i + k + n < len(rs) and math.dist(v(rs[i + k + n], hand), v(rs[i + k + n], "Head")) > guard[hand] + HOME_M and n < 40:
                    n += 1
                out["arm"].append((n, float(rs[i + k]["film_s"]), who, c))
                far = max(math.dist(v(r, free), v(r, "Head")) for r in rs[i:j + 1]) - guard[free]
                out["free"].append((round(far, 2), float(rs[i]["film_s"]), who, c))
            i = j + 1
        for r in rs:
            a = math.hypot(float(r["LeftFoot_x"]) - float(r["RightFoot_x"]), float(r["LeftFoot_z"]) - float(r["RightFoot_z"]))
            if a < ANKLE_M:
                out["stance"].append((round(a, 2), float(r["film_s"]), who, r["clip"]))
    a, b = by.get("0", []), by.get("1", [])
    for x, y in zip(a, b):
        g = min(math.dist(v(x, "Chest"), v(y, "Chest")), math.dist(v(x, "Head"), v(y, "Chest")), math.dist(v(x, "Chest"), v(y, "Head")))
        if g < HIPS_M:
            out["hips"].append((round(g, 2), float(x["film_s"]), "-", x["clip"] + " / " + y["clip"]))
        near = min(math.hypot(float(x[f + "_x"]) - float(y[h + "_x"]), float(x[f + "_z"]) - float(y[h + "_z"]))
                   for f in ("LeftFoot", "RightFoot") for h in ("LeftFoot", "RightFoot"))
        if near < BOOT_M:
            out["boot"].append((round(near, 2), float(x["film_s"]), "-", x["clip"] + " / " + y["clip"]))
    out["frames"] = len(a)
    return out


def main():
    d = sys.argv[1]
    m = measure(d)
    arm = sorted(m["arm"], reverse=True)
    late = [x for x in arm if x[0] > ARM_F]
    free = sorted(m["free"], reverse=True)
    off = [x for x in free if x[0] > FREE_M]
    n = max(m["frames"], 1)
    print("PERSIST RULERS  %s" % d)
    print("  1 ARM HOME   punches %d | wrist home later than %d frames: %d | median %s worst %s" % (
        len(arm), ARM_F, len(late), sorted(x[0] for x in arm)[len(arm) // 2] if arm else "-", arm[0][0] if arm else "-"))
    print("  2 FREE HAND  punches with the free wrist over %.2f m further from the head than his guard holds it: %d of %d | worst %.2f m" % (
        FREE_M, len(off), len(free), free[0][0] if free else 0.0))
    print("  3 APART      a chest or head within %.2f m of the other chest: %d frames (%.1f %%) | an ankle within %.2f m of the other man's: %d frames (%.1f %%)" % (
        HIPS_M, len(m["hips"]), 100.0 * len(m["hips"]) / n, BOOT_M, len(m["boot"]), 100.0 * len(m["boot"]) / n))
    print("  4 STANCE     own ankles under %.2f m apart: %d frames (%.1f %% of both men's)" % (
        ANKLE_M, len(m["stance"]), 50.0 * len(m["stance"]) / n))
    print("  5 REACH      punches that never come within %.2f m of the other man: %d of %d | paws / feints started over %.2f m apart: %d of %d" % (
        REACH_M, len(m["reach"]), len(arm), FAR_M, len(m["far_beat"]), m["beats"]))
    if "list" in sys.argv:
        print("  -- out of reach: %s" % sorted(m["reach"], reverse=True)[:12])
        print("  -- far paws / feints: %s" % sorted(m["far_beat"], reverse=True)[:8])
        for k, rowsk in (("arm", late[:12]), ("free", off[:12]), ("hips", sorted(m["hips"])[:6]), ("boot", sorted(m["boot"])[:6]),
                         ("stance", sorted(m["stance"])[:8])):
            print("  -- %s" % k)
            for x in rowsk:
                print("     %s" % (x,))
        by_clip = defaultdict(int)
        for x in m["stance"]:
            by_clip[x[3]] += 1
        print("  -- stance by clip: %s" % sorted(by_clip.items(), key=lambda kv: -kv[1])[:10])
        fc = defaultdict(list)
        for x in free:
            fc[x[3]].append(x[0])
        print("  -- free hand worst by take: %s" % sorted(((k, max(vs)) for k, vs in fc.items()), key=lambda kv: -kv[1])[:14])
        ac = defaultdict(list)
        for x in arm:
            ac[x[3]].append(x[0])
        print("  -- arm home worst by take: %s" % sorted(((k, max(vs)) for k, vs in ac.items()), key=lambda kv: -kv[1])[:14])


if __name__ == "__main__":
    main()

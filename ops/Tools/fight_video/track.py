"""Stage 2 - which of the people in each frame are the two boxers.  (Claude, S495)
usage: python track.py <pose.npz> <boxers.npz> [--fighters 1|2]

No training. The two boxers are the people who (1) hold their hands up, (2) keep moving and (3) each wear their own
colours:
  1. TRACKLETS: people are linked frame to frame by how far the middle of the trunk moved (in trunk lengths T), never
     across a camera cut (a spike in the pose file's cutdiff).
  2. FIGHTER-LIKE: a tracklet seeds a boxer when, on most frames, the hands are up (both above the waist, one chest
     high) and the trunk keeps moving. A referee walks with straight arms; a spectator sits. Once the two kits are
     known, a tracklet in a boxer's colours with a low guard (elbows bent now and then) is him too, but only next to
     the other boxer or where he just was.
  3. COLOURS: the vest and shorts colours of the candidates are split into two groups (k-means, k = 2): boxer A and
     boxer B (on vest + shorts, shorts only or vest only - whichever separates them best; bare chests need the shorts). Every frame, the candidates are handed to A and B by colour distance, with a bonus for staying on the
     same tracklet and a cost for jumping across the ring. A is the one seen on more frames.
  4. BOUTS: a file may hold several bouts cut together (files of the Olympic test set do), each with its own two
     kits. The stretches between cuts are grouped into bouts where the kit colours change (find_bouts), and steps 2-3 run
     per bout: each bout gets its own pair of kits, its own referee group left out and its own A and B.
Saved: kpt (F,2,17,3) x,y,score (0 where the boxer is not seen); seen (F,2) bool; colour (2,) names (the longest
bout's); cut (F,) bool; src (F,2) index of the person in the pose file (-1 = none); frame, t, fps, size copied from the
pose file; seg (F,) number of the stretch between cuts; bout (F,) number of the bout; kits (bouts,2) colour names.
Boxer A of one bout and boxer A of the next are different people."""
import sys

import numpy as np

L_SH, R_SH, L_EL, R_EL, L_WR, R_WR, L_HIP, R_HIP = 5, 6, 7, 8, 9, 10, 11, 12
GAP = 12           # frames a tracklet may go unseen and still be picked up again
LINK_GATE = 0.55   # trunk lengths a person may move between two frames (grows with the gap)
GUARD_MIN = 0.50   # share of frames with the hands up for a tracklet to seed a boxer
MOVE_MIN = 0.15    # trunk lengths per second the trunk must drift on average (seated people do not)
MIN_LEN_S = 0.4    # shorter tracklets are ignored
BOUT_ALPHA = 0.008  # a new bout must cut the colour spread by this much per unit of candidate weight (find_bouts)
OPPONENT_FALLBACK = True  # an empty slot takes the boxer candidate standing next to the placed boxer
OPPONENT_REACH = 3.0      # trunk lengths, centre to centre


def trunk(k):
    """(centre, T) of one pose; T = shoulder midpoint to hip midpoint, 0 when the trunk is not seen."""
    if k[[L_SH, R_SH, L_HIP, R_HIP], 2].mean() < 0.35:
        return np.zeros(2, np.float32), 0.0
    sh, hip = (k[L_SH, :2] + k[R_SH, :2]) / 2, (k[L_HIP, :2] + k[R_HIP, :2]) / 2
    return (sh + hip) / 2, float(np.linalg.norm(sh - hip))


def colour_vec(lab2):
    """Trunk + shorts median L,a,b -> 6 numbers: the two colour axes at full weight, lightness at half."""
    out = []
    for L, A, B in lab2:
        out += [(A - 128.0) / 64.0, (B - 128.0) / 64.0, 0.5 * L / 255.0]
    return np.array(out, np.float32)


def colour_name(vec):
    """Name of the kit colour: the vest, or the shorts when they carry more colour than the vest."""
    part = vec[:3] if np.hypot(vec[0], vec[1]) >= np.hypot(vec[3], vec[4]) else vec[3:]
    chroma = float(np.hypot(part[0], part[1]))
    light = float(vec[2]) * 2
    if chroma < 0.15:
        return "white" if light > 0.62 else "black" if light < 0.3 else "grey"
    h = np.degrees(np.arctan2(part[1], part[0])) % 360
    for lim, name in ((50, "red"), (75, "orange"), (110, "yellow"), (200, "green"), (250, "cyan"), (310, "blue"), (345, "purple"), (361, "red")):
        if h < lim:
            return name


def find_cuts(cutdiff):
    """A cut in the picture: one frame changes far more than the frames around it (a spike, not a camera move)."""
    if cutdiff is None or len(cutdiff) < 5:
        return np.zeros(0 if cutdiff is None else len(cutdiff), bool)
    c = np.asarray(cutdiff, np.float32)
    base = np.median(c) + 1e-6
    side = np.maximum(np.r_[c[0], c[:-1]], np.r_[c[1:], c[-1]])
    return (c > max(5.0, 10.0 * base)) & (c > 3.0 * side)


def build_tracklets(kpt, n, cuts, fps=50.0):
    """-> tid (F,P) tracklet number of each detection (-1 = unusable), list of tracklets as [(frame, person), ...].
    Also marks in cuts the jump cuts it finds (see below). The link gate is per 1/50 s, so it widens at lower frame
    rates; a camera pan (everybody shifts the same way) is taken out before the gate is applied."""
    F, P = kpt.shape[:2]
    gate = LINK_GATE * max(1.0, 50.0 / fps)
    tid = -np.ones((F, P), np.int32)
    tracks, live = [], {}  # live: track id -> (last frame, centre, T)
    for f in range(F):
        if len(cuts) and cuts[f]:
            live = {}
        people = []
        for p in range(int(n[f])):
            c, T = trunk(kpt[f, p])
            if T >= 10.0:
                people.append((p, c, T))
        shifts = []
        for t, (lf, lc, lT) in live.items():
            if lf == f - 1 and people:
                shifts.append(min((c - lc for p, c, T in people), key=lambda v: float(v @ v)))
        pan = np.median(np.stack(shifts), axis=0) if len(shifts) >= 3 else np.zeros(2, np.float32)
        pairs = []
        for t, (lf, lc, lT) in live.items():
            for p, c, T in people:
                if not 0.6 < T / lT < 1.6:
                    continue
                d = float(np.linalg.norm(c - pan - lc)) / ((T + lT) / 2)
                if d < gate + 0.12 * (f - lf - 1):
                    pairs.append((d, t, p))
        used_t, used_p = set(), set()
        for d, t, p in sorted(pairs):
            if t in used_t or p in used_p:
                continue
            used_t.add(t), used_p.add(p)
            tid[f, p] = t
            tracks[t].append((f, p))
        fresh = [t for t, v in live.items() if v[0] == f - 1]
        if len(fresh) >= 2 and len(people) >= 2 and not any(t in used_t for t in fresh):
            cuts[f] = True  # a jump cut a static camera hides: everybody seen in the last frame moved at once
            live = {}
        for p, c, T in people:
            if p not in used_p:
                tid[f, p] = len(tracks)
                tracks.append([(f, p)])
        for p, c, T in people:
            live[int(tid[f, p])] = (f, c, T)
        live = {t: v for t, v in live.items() if f - v[0] <= GAP}
    return tid, tracks


def tracklet_stats(tracks, kpt, hsv, fps):
    """Per tracklet: frames, guard share (both hands above the waist and one of them chest-high), bent share (both
    elbows bent under 120 degrees: a boxer with a low guard still does this, a referee's arms hang straight),
    drift speed (T/s), median colour vector, median T."""
    stats = []
    for tr in tracks:
        fr = np.array([f for f, _ in tr])
        ks = np.stack([kpt[f, p] for f, p in tr])
        cen = np.stack([trunk(k)[0] for k in ks])
        T = np.median([trunk(k)[1] for k in ks])
        arm_ok = (ks[:, [L_SH, R_SH, L_EL, R_EL, L_WR, R_WR, L_HIP, R_HIP], 2] > 0.3).all(1)
        hip_y, sh_y = (ks[:, L_HIP, 1] + ks[:, R_HIP, 1]) / 2, (ks[:, L_SH, 1] + ks[:, R_SH, 1]) / 2
        wl, wr = ks[:, L_WR, 1], ks[:, R_WR, 1]
        up = (wl < hip_y - 0.15 * T) & (wr < hip_y - 0.15 * T) & (np.minimum(wl, wr) < sh_y + 0.5 * T) & arm_ok
        guard = float(up.sum() / max(1, arm_ok.sum())) if arm_ok.sum() >= 5 else 0.0

        def elbow(a, b, c):
            u, v = ks[:, a, :2] - ks[:, b, :2], ks[:, c, :2] - ks[:, b, :2]
            return np.degrees(np.arccos(np.clip((u * v).sum(1) / np.maximum(np.linalg.norm(u, axis=1) * np.linalg.norm(v, axis=1), 1e-6), -1, 1)))
        both_bent = (elbow(L_SH, L_EL, L_WR) < 120) & (elbow(R_SH, R_EL, R_WR) < 120) & arm_ok
        bent = float(both_bent.sum() / max(1, arm_ok.sum())) if arm_ok.sum() >= 5 else 0.0
        span = (fr[-1] - fr[0] + 1) / fps
        step = max(1, int(round(fps * 0.2)))
        move = float(np.linalg.norm(cen[step:] - cen[:-step], axis=1).mean() / T / 0.2) if len(cen) > step else 0.0
        col = np.median(np.stack([colour_vec(hsv[f, p]) for f, p in tr]), axis=0)
        stats.append(dict(n=len(tr), span=span, guard=guard, bent=bent, fight=max(guard, bent), move=move, colour=col, T=float(T), start=int(fr[0]), end=int(fr[-1])))
    return stats


def colour_groups(vecs, weights, k=2):
    """Weighted k-means, started from the two most different candidates (then the one furthest from both).
    -> centres (k,6), labels."""
    d = np.linalg.norm(vecs[:, None] - vecs[None], axis=2)
    i, j = np.unravel_index(np.argmax(d), d.shape)
    start = [i, j]
    while len(start) < k:
        start.append(int(np.argmax(d[:, start].min(1))))
    cen = vecs[start].copy()
    lab = np.zeros(len(vecs), int)
    for _ in range(20):
        lab = np.argmin(np.linalg.norm(vecs[:, None] - cen[None], axis=2), axis=1)
        for c in range(k):
            if (lab == c).any():
                cen[c] = np.average(vecs[lab == c], axis=0, weights=weights[lab == c])
    return cen, lab


def split_kits(full, w):
    """Find the two boxers' colours among the candidates. Tried on vest + shorts, shorts only (bare-chested
    professionals) and vest only, each with two groups and with three (the third, lightest group = a referee whose
    arms were up); the split with the widest gap for its spread wins.
    -> W (6,) which numbers count, centres (2,6) in W-space, full_centres (2,6), other (6,) or None, sep, spread, name."""
    best = None
    for k in (2, 3):  # three groups only when two cannot tell the boxers apart
        if best is not None and best[0] >= 3.0:
            break
        for part, name in (((1, 1), "vest + shorts"), ((0, 1), "shorts"), ((1, 0), "vest")):
            W = np.repeat(np.array(part, np.float32), 3)
            v = full * W
            if len(v) < k + 1:
                continue
            cen, lab = colour_groups(v, w, k)
            mass = np.array([w[lab == c].sum() for c in range(k)])
            keep = np.argsort(-mass)[:2]
            if k == 3 and mass[np.argsort(-mass)[2]] > 0.3 * mass.sum():
                continue  # three groups of similar size: not two boxers and a referee
            in_two = np.isin(lab, keep)
            sep = float(np.linalg.norm(cen[keep[0]] - cen[keep[1]]))
            spread = max(0.06, float(np.sqrt(np.average(np.min(np.linalg.norm(v[in_two][:, None] - cen[keep][None], axis=2), axis=1) ** 2, weights=w[in_two]))))
            score = sep / spread
            if best is None or score > 1.15 * best[0]:
                fc = np.stack([np.average(full[lab == c], axis=0, weights=w[lab == c]) for c in keep])
                third = cen[[c for c in range(k) if c not in keep][0]] if k == 3 else None
                best = (score, W, cen[keep], fc, third, sep, spread, name + (", a third group left out" if k == 3 else ""))
    if best is None:
        one = np.average(full, axis=0, weights=w)
        return np.ones(6, np.float32), np.stack([one, one]), np.stack([one, one]), None, 0.0, 0.06, "vest + shorts"
    return best[1:]


def find_bouts(stats, cand, cuts, F):
    """Where one bout ends and the next begins, from the kit colours alone. -> [(first frame, end frame), ...].
    The stretches between cuts that hold boxer candidates are split into runs so that the candidates of each run fall
    into at most three colour groups (two boxers and a referee) as tightly as possible: the cost of a run is its
    weighted spread round three group centres, every extra bout costs BOUT_ALPHA x the total weight, and the cheapest
    split wins (dynamic programming over at most a few dozen stretches). One bout = no split."""
    bounds = np.r_[0, np.flatnonzero(cuts), F]
    segs = []
    for a, b in zip(bounds[:-1], bounds[1:]):
        cs = [i for i in cand if a <= stats[i]["start"] < b]
        if cs:
            segs.append((int(a), cs))
    m = len(segs)
    if m < 2:
        return [(0, F)]

    def spread(cs):
        if len(cs) <= 3:
            return 0.0
        v = np.stack([stats[i]["colour"] for i in cs])
        w = np.array([stats[i]["n"] * stats[i]["guard"] for i in cs], np.float32)
        cen, lab = colour_groups(v, w, 3)
        return float((w * ((v - cen[lab]) ** 2).sum(1)).sum())

    cost = np.zeros((m, m + 1))
    for i in range(m):
        cs = []
        for j in range(i + 1, m + 1):
            cs = cs + segs[j - 1][1]
            cost[i, j] = spread(cs)
    penalty = BOUT_ALPHA * float(sum(stats[i]["n"] * stats[i]["guard"] for i in cand))
    best, prev = [0.0] + [np.inf] * m, [0] * (m + 1)
    for j in range(1, m + 1):
        for i in range(j):
            c = best[i] + cost[i, j] + (penalty if i > 0 else 0.0)
            if c < best[j]:
                best[j], prev[j] = c, i
    starts, j = [], m
    while j > 0:
        starts.append(prev[j])
        j = prev[j]
    frames = [0] + [segs[i][0] for i in sorted(starts)[1:]] + [F]
    return list(zip(frames[:-1], frames[1:]))


def pick_boxers(pose, fighters=None, log=print):
    kpt, hsv, n = pose["kpt"], pose["col"], pose["n"]
    fps = float(pose["fps"])
    F = len(n)
    cuts = find_cuts(pose["cutdiff"] if "cutdiff" in pose else None)
    if not len(cuts):
        cuts = np.zeros(F, bool)
    tid, tracks = build_tracklets(kpt, n, cuts, fps)
    stats = tracklet_stats(tracks, kpt, hsv, fps)
    cand = [i for i, s in enumerate(stats) if s["span"] >= MIN_LEN_S and s["guard"] >= GUARD_MIN and s["move"] >= MOVE_MIN]
    out_k = np.zeros((F, 2, 17, 3), np.float32)
    seen = np.zeros((F, 2), bool)
    src = -np.ones((F, 2), np.int16)
    seg = np.cumsum(cuts).astype(np.int32)
    bout = np.zeros(F, np.int32)
    if not cand:
        log("track: no boxer found (nobody keeps a guard up and moves)")
        return dict(kpt=out_k, seen=seen, src=src, colour=np.array(["?", "?"]), cut=cuts, seg=seg, bout=bout, kits=np.array([["?", "?"]]))
    # the colour each detection is judged by: the median over +-15 frames of its own tracklet, so that a tracklet
    # which slid from one boxer onto the other in a clinch is re-read within a third of a second
    loc = np.zeros(tid.shape + (6,), np.float32)
    for t, tr in enumerate(tracks):
        if stats[t]["span"] < 0.2:
            continue
        cv = np.stack([colour_vec(hsv[f, p]) for f, p in tr])
        for i, (f, p) in enumerate(tr):
            loc[f, p] = np.median(cv[max(0, i - 15):i + 16], axis=0)
    bouts = find_bouts(stats, cand, cuts, F)
    if len(bouts) > 1:
        log("track: %d bouts in this file (the kits change at %s s)" % (len(bouts), ", ".join("%.0f" % (b[0] / fps) for b in bouts[1:])))
    kits = []
    for k, (f0, f1) in enumerate(bouts):
        bout[f0:f1] = k
        mine = [i for i in cand if f0 <= stats[i]["start"] < f1]
        kits.append(_pick_in(f0, f1, mine, kpt, n, tid, stats, loc, cuts, fighters, out_k, seen, src, log) if mine else ["?", "?"])
    longest = int(np.argmax([seen[f0:f1].any(1).sum() for f0, f1 in bouts]))
    return dict(kpt=out_k, seen=seen, src=src, colour=np.array(kits[longest]), cut=cuts, seg=seg, bout=bout, kits=np.array(kits))


def _pick_in(f0, f1, cand, kpt, n, tid, stats, loc, cuts, fighters, out_k, seen, src, log):
    """Steps 2-3 for the frames f0..f1 of one bout, with that bout's own candidates. Fills out_k, seen, src there and
    returns the two kit names (A first)."""
    full = np.stack([stats[i]["colour"] for i in cand])
    w = np.array([stats[i]["n"] * stats[i]["guard"] for i in cand], np.float32)
    W, centres, full_centres, third, sep, spread, kit_part = split_kits(full, w)
    # are two candidates ever on screen together? (one man on a bag or shadow boxing = one fighter)
    is_cand = np.isin(tid[f0:f1], cand)
    together = float((is_cand.sum(1) >= 2).mean() / max(1e-6, (is_cand.sum(1) >= 1).mean()))
    if fighters is None:
        fighters = 2 if together > 0.15 or sep > 0.5 else 1  # two clearly different kits = two boxers
    by_colour = fighters == 2 and sep > 3.0 * spread  # else the kits look alike: position decides
    if fighters == 1:
        centres = np.stack([np.average(full * W, axis=0, weights=w)] * 2)
        full_centres = np.stack([np.average(full, axis=0, weights=w)] * 2)
    log("track: frames %d-%d: %d boxer candidates, two on screen together %.0f%% of the time, colour gap %.2f (spread %.2f) -> %d fighter(s), told apart by %s" % (
        f0, f1, len(cand), 100 * together, sep, spread, fighters, ("the colour of the %s" % kit_part) if by_colour else "position"))
    # hand the candidates of every frame to the slots
    last = [None, None]  # (frame, centre, T, tracklet)
    cand_set = set(cand)
    loose = set(i for i, s in enumerate(stats) if s["span"] >= 0.2 and s["fight"] >= 0.3)  # may continue a slot, never start one
    # with two distinct kits, a shorter or lower-guard tracklet in a boxer's colours is that boxer too - but only
    # next to the other boxer or where this boxer just was (a coach in a dark tracksuit at ringside is neither)
    members = set(i for i, s in enumerate(stats) if s["span"] >= 0.2 and s["fight"] >= 0.15 and s["move"] >= MOVE_MIN) if by_colour else set()
    for f in range(f0, f1):
        if cuts[f]:
            last = [None, None]
        options = []
        for p in range(int(n[f])):
            t = int(tid[f, p])
            if not (t in cand_set or t in members or (t in loose and any(l is not None and l[3] == t for l in last))):
                continue
            c, T = trunk(kpt[f, p])
            dist = np.linalg.norm((loc[f, p] * W)[None] - centres, axis=1) / spread
            if by_colour and third is not None and float(np.linalg.norm(loc[f, p] * W - third)) / spread < dist.min():
                continue  # wears the third group's colours (the referee), not a boxer's
            for s in range(fighters):
                cost = 0.0
                if by_colour:
                    if dist[s] > 0.8 * dist[1 - s]:  # nearer the other boxer's colours: never this slot
                        continue
                    if dist[s] > (4.5 if t in cand_set else 3.5):  # must really wear the kit (a referee in a white shirt does not)
                        continue
                    cost = float(dist[s])
                l = last[s]
                if l is not None and f - l[0] <= 25:
                    if l[3] == t:
                        cost -= 1.0
                    cost += min(4.0, 1.5 * float(np.linalg.norm(c - l[1])) / max(T, l[2]))
                elif not by_colour:
                    cost += 1.0
                sure = t in cand_set or (l is not None and l[3] == t)
                options.append((cost, s, p, t, c, T, sure))
        used_s, used_p, placed = set(), set(), {}
        for want_sure in (True, False):
            for cost, s, p, t, c, T, sure in sorted(options, key=lambda o: o[0]):
                if sure != want_sure or s in used_s or p in used_p:
                    continue
                if not sure:
                    other, own = placed.get(1 - s), last[s]
                    near_other = other is not None and float(np.linalg.norm(c - other[0])) <= 3.5 * max(T, other[1])
                    near_own = own is not None and f - own[0] <= 25 and float(np.linalg.norm(c - own[1])) <= 1.5 * max(T, own[2])
                    if not (near_other or near_own):
                        continue
                used_s.add(s), used_p.add(p)
                placed[s] = (c, T)
                out_k[f, s], seen[f, s], src[f, s] = kpt[f, p], True, p
                last[s] = (f, c, T, t)
        # THE OPPONENT IS THE FIGHTER NEXT TO HIM: one boxer placed by his kit and the other slot empty (his kit read
        # wrongly in this light) - a boxer candidate (hands up, moving) right beside the placed one, of his size and not
        # in the referee's colours, is the other boxer.
        if OPPONENT_FALLBACK and by_colour and fighters == 2 and len(placed) == 1:
            s = 1 - next(iter(placed))
            oc, oT = placed[1 - s]
            best = None
            for p in range(int(n[f])):
                t = int(tid[f, p])
                if p in used_p or t not in cand_set:
                    continue
                c, T = trunk(kpt[f, p])
                if third is not None and float(np.linalg.norm(loc[f, p] * W - third)) < float(np.linalg.norm((loc[f, p] * W)[None] - centres, axis=1).min()):
                    continue
                d = float(np.linalg.norm(c - oc)) / max(T, oT)
                if d <= OPPONENT_REACH and 0.6 < T / oT < 1.6 and (best is None or d < best[0]):
                    best = (d, p, t, c, T)
            if best is not None:
                d, p, t, c, T = best
                out_k[f, s], seen[f, s], src[f, s] = kpt[f, p], True, p
                last[s] = (f, c, T, t)
    if fighters == 2 and seen[f0:f1, 1].sum() > seen[f0:f1, 0].sum():  # A = the boxer seen more
        out_k[f0:f1], seen[f0:f1], src[f0:f1], full_centres = out_k[f0:f1, ::-1].copy(), seen[f0:f1, ::-1].copy(), src[f0:f1, ::-1].copy(), full_centres[::-1]
    names = [colour_name(c if kit_part != "shorts" else np.r_[c[3:], c[3:]]) for c in full_centres]
    log("track: boxer A (%s kit) seen on %.0f%% of frames, boxer B (%s kit) on %.0f%%, both on %.0f%%" % (
        names[0], 100 * seen[f0:f1, 0].mean(), names[1], 100 * seen[f0:f1, 1].mean(), 100 * seen[f0:f1].all(1).mean()))
    return names


def run(pose_npz, out_npz, fighters=None, log=print):
    pose = np.load(pose_npz)
    res = pick_boxers(pose, fighters, log)
    np.savez_compressed(out_npz, frame=pose["frame"], t=pose["t"], fps=pose["fps"], size=pose["size"], **res)
    return out_npz


if __name__ == "__main__":
    a = sys.argv
    run(a[1], a[2], int(a[a.index("--fighters") + 1]) if "--fighters" in a else None)

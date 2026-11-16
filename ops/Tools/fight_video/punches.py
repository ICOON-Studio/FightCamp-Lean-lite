"""Stage 3 - punches from the two boxers' poses: when, who, which hand, which punch, where, what happened.  (Claude, S495)

Everything is measured in the boxer's own TRUNK LENGTHS (T = shoulder midpoint to hip midpoint in the picture), so the
numbers survive zoom and camera distance. No training in this file: the rules below are the v1 baseline. The trained
classifiers (classify.py) overwrite `type` and `result` when their model files exist.

1. GLOVE: the wrist pushed 40% of the forearm further out (the pose model marks the wrist, the glove is beyond it).
2. A PUNCH: the glove's speed relative to the boxer's own shoulders peaks above V_MIN, the glove travels at least D_MIN
   from where the burst began (onset) to where it stopped (end), and that travel takes it TOWARD the opponent (or, when
   the opponent is not seen, away from the boxer's own head). The pull-back is the same burst backwards and is dropped
   by that test. Impact = the frame near the end where the glove is nearest the opponent.
3. WHICH PUNCH: uppercut = the glove mostly rises with the elbow bent; straight = the elbow is open at impact (jab from
   the lead hand, cross from the rear); otherwise hook. Lead hand = the side whose foot is nearer the opponent on most
   frames.
4. WHERE: head when the glove ends above the opponent's shoulder line, else body.
5. WHAT HAPPENED (2D picture only, so this is the weakest call): missed when the glove ends further than MISS_R from
   the target; blocked when the opponent's own glove or forearm is at the glove and his head does not move; else landed.
"""
import numpy as np

NOSE, L_SH, R_SH, L_EL, R_EL, L_WR, R_WR, L_HIP, R_HIP, L_ANK, R_ANK = 0, 5, 6, 7, 8, 9, 10, 11, 12, 15, 16
ARM = {"left": (L_SH, L_EL, L_WR, L_ANK), "right": (R_SH, R_EL, R_WR, R_ANK)}
PARAMS = dict(
    V_MIN=4.0,        # T per second: peak glove speed relative to the shoulders
    D_MIN=0.40,       # T: glove travel from onset to end
    APPROACH_MIN=0.20,  # T: how much nearer the opponent the glove must end
    BURST=0.35,       # the burst lasts while the speed stays above this share of its peak
    REFRACTORY=0.12,  # s: two bursts of one arm closer than this are one punch
    STRAIGHT_ELBOW=135.0,  # degrees at impact: at or above = a straight punch
    UPPER_RISE=0.50,  # share of the travel that is upward for an uppercut
    HEAD_LINE=0.15,   # T below the opponent's shoulder line still counts as head
    MISS_R=0.60,      # T (opponent's): glove further than this from the target at impact = missed
    BLOCK_R=0.30,     # T: opponent's glove or forearm this near the glove = a block
    SNAP_MIN=0.10,    # T: the opponent's head moves this far against his shoulders within 0.1 s = it landed
    COMBO_GAP=0.70,   # s between punches of one boxer inside a combination
)


def _fill_and_smooth(xy, ok, max_gap):
    """Linear fill of gaps up to max_gap frames, then a 1-2-1 smoothing. xy (F,2), ok (F,) -> xy with NaN where unknown."""
    out = np.full(xy.shape, np.nan, np.float32)
    idx = np.flatnonzero(ok)
    if len(idx) == 0:
        return out
    out[idx] = xy[idx]
    for a, b in zip(idx[:-1], idx[1:]):
        if 1 < b - a <= max_gap + 1:
            w = (np.arange(a + 1, b) - a)[:, None] / float(b - a)
            out[a + 1:b] = xy[a] * (1 - w) + xy[b] * w
    sm = out.copy()
    mid = ~np.isnan(out[:-2, 0]) & ~np.isnan(out[1:-1, 0]) & ~np.isnan(out[2:, 0])
    sm[1:-1][mid] = 0.25 * out[:-2][mid] + 0.5 * out[1:-1][mid] + 0.25 * out[2:][mid]
    return sm


def _running_nanmedian(x, half):
    out = np.full(len(x), np.nan, np.float32)
    for i in range(len(x)):
        w = x[max(0, i - half):i + half + 1]
        w = w[~np.isnan(w)]
        if len(w):
            out[i] = np.median(w)
    return out


class Body:
    """One boxer's joints over time, filled, smoothed and with the derived points the rules use."""

    def __init__(self, kpt, seen, seg, fps):
        F = len(kpt)
        gap = max(2, int(round(0.08 * fps)))
        self.fps, self.F = fps, F
        self.conf = np.where(seen[:, None], kpt[:, :, 2], 0.0).astype(np.float32)  # the pose model's own confidence
        self.j = np.full((F, 17, 2), np.nan, np.float32)
        for k in range(17):
            ok = seen & (kpt[:, k, 2] >= 0.3)
            self.j[:, k] = _fill_and_smooth(kpt[:, k, :2], ok, gap)
        cutline = np.r_[False, seg[1:] != seg[:-1]]
        self.j[cutline] = np.nan  # never smooth or difference across a camera cut
        self.shm = (self.j[:, L_SH] + self.j[:, R_SH]) / 2
        self.hipm = (self.j[:, L_HIP] + self.j[:, R_HIP]) / 2
        raw_T = np.linalg.norm(self.shm - self.hipm, axis=1)
        self.T = _running_nanmedian(raw_T, int(round(0.5 * fps)))
        face = self.j[:, 0:5]
        with np.errstate(invalid="ignore"), __import__("warnings").catch_warnings():
            __import__("warnings").simplefilter("ignore")
            head = np.nanmean(face, axis=1)
        up = (self.shm - self.hipm) / np.maximum(raw_T, 1e-3)[:, None]
        guess = self.shm + 0.45 * self.T[:, None] * up
        self.head = np.where(np.isnan(head), guess, head)
        self.glove, self.rel, self.speed, self.elbow = {}, {}, {}, {}
        h = max(1, int(round(0.04 * fps)))
        for side, (s, e, w, _) in ARM.items():
            g = self.j[:, w] + 0.4 * (self.j[:, w] - self.j[:, e])
            rel = (g - self.shm) / self.T[:, None]
            v = np.full((F, 2), np.nan, np.float32)
            v[h:-h] = (rel[2 * h:] - rel[:-2 * h]) * (fps / (2.0 * h))
            a, b = self.j[:, s] - self.j[:, e], self.j[:, w] - self.j[:, e]
            cosang = (a * b).sum(1) / np.maximum(np.linalg.norm(a, axis=1) * np.linalg.norm(b, axis=1), 1e-6)
            self.glove[side], self.rel[side] = g, rel
            self.speed[side] = np.linalg.norm(v, axis=1)
            self.elbow[side] = np.degrees(np.arccos(np.clip(cosang, -1, 1)))

    def chest(self):
        return self.shm + 0.35 * (self.hipm - self.shm)


def lead_side(me, opp):
    """'left' or 'right': the side whose foot (else shoulder) is nearer the opponent on most frames; None if unknown."""
    fwd = opp.hipm - me.hipm
    votes = 0.0
    for pair in ((L_ANK, R_ANK), (L_SH, R_SH)):
        d = ((me.j[:, pair[0]] - me.j[:, pair[1]]) * fwd).sum(1) / np.maximum(np.linalg.norm(fwd, axis=1) * me.T, 1e-3)
        d = d[~np.isnan(d)]
        if len(d):
            votes += float(np.sign(d[np.abs(d) > 0.15]).sum()) * (2.0 if pair[0] == L_ANK else 1.0)
    return None if votes == 0 else "left" if votes > 0 else "right"


def _seg_dist(p, a, b):
    ab = b - a
    t = np.clip(((p - a) * ab).sum() / max(float((ab * ab).sum()), 1e-6), 0, 1)
    return float(np.linalg.norm(p - (a + t * ab)))


def _bursts(speed, fps, P):
    """Peaks of one arm's glove speed -> [(onset, peak, end)]."""
    out, F = [], len(speed)
    s = np.nan_to_num(speed, nan=0.0)
    lim = int(round(0.3 * fps))
    f = 1
    while f < F - 1:
        if s[f] >= P["V_MIN"] and s[f] >= s[f - 1] and s[f] >= s[f + 1]:
            o = f
            while o > 0 and f - o < lim and s[o - 1] > P["BURST"] * s[f]:
                o -= 1
            e = f
            while e < F - 1 and e - f < lim and s[e + 1] > P["BURST"] * s[f]:
                e += 1
            out.append((o, f, e))
            f = e + 1
        else:
            f += 1
    return out


def measure(me, opp, side, o, pk, e, P):
    """All the numbers of one burst (also the classifier's hand-made features). None when it is not an outgoing punch."""
    fps = me.fps
    g, rel = me.glove[side], me.rel[side]
    if np.isnan(rel[o]).any() or np.isnan(rel[e]).any():
        return None
    D = rel[e] - rel[o]
    travel = float(np.linalg.norm(D))
    if travel < P["D_MIN"]:
        return None
    have_opp = opp is not None and not np.isnan(opp.head[e]).any() and not np.isnan(opp.T[e])
    c = e
    if have_opp:
        To = float(opp.T[e])
        tgt = lambda f: (opp.head[f], opp.chest()[f])
        d0 = min(np.linalg.norm(g[o] - t) for t in tgt(o)) if not np.isnan(opp.head[o]).any() else np.nan
        d1 = min(np.linalg.norm(g[e] - t) for t in tgt(e))
        approach = float((d0 - d1) / me.T[e]) if not np.isnan(d0) else travel
        if approach < P["APPROACH_MIN"]:
            return None
        best = d1  # impact = nearest frame to a target around the end of the burst
        for f in range(max(o, e - 2), min(me.F - 1, e + int(round(0.06 * fps))) + 1):
            if np.isnan(g[f]).any() or np.isnan(opp.head[f]).any():
                continue
            d = min(np.linalg.norm(g[f] - t) for t in tgt(f))
            if d < best:
                best, c = d, f
    elif opp is not None:
        return None  # a two-boxer video: no call on a punch whose target the camera does not show
    else:
        away = (np.linalg.norm(g[e] - me.head[e]) - np.linalg.norm(g[o] - me.head[o])) / me.T[e]
        approach = float(away)
        if not away >= 0.3:
            return None
    s_i, e_i, w_i, _ = ARM[side]
    T = float(me.T[c])
    fwd_sign = 1.0
    if have_opp:
        fwd_sign = 1.0 if opp.shm[c][0] >= me.shm[c][0] else -1.0
    elif D[0] < 0:
        fwd_sign = -1.0
    path = rel[o:e + 1]
    chord = D / max(travel, 1e-6)
    dev = np.abs((path - rel[o])[:, 0] * chord[1] - (path - rel[o])[:, 1] * chord[0])
    forearm = me.j[c, w_i] - me.j[c, e_i]
    m = dict(
        onset=int(o), peak=int(pk), end=int(e), impact=int(c), travel=travel, approach=approach,
        peak_speed=float(np.nanmax(me.speed[side][o:e + 1])), dur=(e - o) / fps,
        d_fwd=float(D[0] * fwd_sign), d_up=float(-D[1]), curve=float(np.nanmax(dev)) / max(travel, 1e-6),
        elbow_on=float(me.elbow[side][o]), elbow_imp=float(me.elbow[side][c]),
        reach=float(np.linalg.norm(g[c] - me.j[c, s_i]) / T),
        elbow_lift=float((me.j[c, s_i][1] - me.j[c, e_i][1]) / T),  # + = elbow above the shoulder
        forearm_vert=float(np.degrees(np.arctan2(abs(forearm[0]), abs(forearm[1]) + 1e-6))),  # 0 = vertical forearm
        start_low=float((g[o][1] - me.j[o, s_i][1]) / T),  # + = the glove starts below the shoulder
        arm_conf=float(me.conf[o:e + 1][:, [s_i, e_i, w_i]].mean()),
        have_opp=bool(have_opp), glove=[float(g[c][0]), float(g[c][1])])
    if have_opp:
        To = float(opp.T[c])
        m["d_head"] = float(np.linalg.norm(g[c] - opp.head[c]) / To)
        m["d_body"] = _seg_dist(g[c], opp.shm[c], opp.hipm[c]) / To
        m["height"] = float((opp.shm[c][1] - g[c][1]) / To)  # + = above the opponent's shoulder line
        near = []
        for os_, (s2, e2, w2, _) in ARM.items():
            if not np.isnan(opp.glove[os_][c]).any():
                near.append(np.linalg.norm(g[c] - opp.glove[os_][c]) / To)
                if not np.isnan(opp.j[c, e2]).any():
                    near.append(_seg_dist(g[c], opp.j[c, e2], opp.glove[os_][c]) / To)
        m["d_guard"] = float(min(near)) if near else 9.0
        punch_dir = (g[c] - g[o]) / max(float(np.linalg.norm(g[c] - g[o])), 1e-6)
        snap, snap_along = 0.0, 0.0
        base = opp.head[c] - opp.shm[c]
        for f in range(c + 1, min(me.F - 1, c + int(round(0.1 * fps))) + 1):
            if np.isnan(opp.head[f]).any() or np.isnan(opp.shm[f]).any():
                continue
            mv = (opp.head[f] - opp.shm[f] - base) / To
            if np.linalg.norm(mv) > snap:
                snap, snap_along = float(np.linalg.norm(mv)), float((mv * punch_dir).sum())
        m["snap"], m["snap_along"] = snap, snap_along
        m["gap"] = float(np.linalg.norm(opp.hipm[c] - me.hipm[c]) / T) if not np.isnan(opp.hipm[c]).any() and not np.isnan(me.hipm[c]).any() else float("nan")
        m["opp_conf"] = float(opp.conf[o:e + 1][:, [0, 5, 6, 9, 10]].mean())
    return m


def rule_type(m, P):
    if m["d_up"] >= P["UPPER_RISE"] * m["travel"] and m["elbow_imp"] < 145 and m["start_low"] > 0.0:
        return "uppercut"
    if m["elbow_imp"] >= P["STRAIGHT_ELBOW"]:
        return "straight"
    return "hook"


def rule_target_result(m, P):
    if not m["have_opp"]:
        return "?", "?"
    target = "head" if m["height"] > -P["HEAD_LINE"] else "body"
    d = m["d_head"] if target == "head" else m["d_body"]
    if d > P["MISS_R"]:
        return target, "missed"
    snapped = target == "head" and m["snap"] >= P["SNAP_MIN"] and m["snap_along"] > 0
    if m["d_guard"] <= P["BLOCK_R"] and not snapped:
        return target, "blocked"
    return target, "landed"


def name_punch(family, lead):
    if family == "straight":
        return {"lead": "jab", "rear": "cross"}.get(lead, "straight")
    return ("%s %s" % (lead, family)) if lead in ("lead", "rear") else family


def number_combos(events, gap=PARAMS["COMBO_GAP"]):
    """Combinations: punches of one boxer that follow each other within `gap` seconds share a combo number."""
    combo, last = 0, {}
    for ev in events:
        prev = last.get(ev["boxer"])
        if prev is not None and ev["t"] - prev["t"] <= gap:
            ev["combo"] = prev["combo"]
        else:
            combo += 1
            ev["combo"] = combo
        last[ev["boxer"]] = ev


def detect(boxers, params=None, log=print):
    """boxers = the arrays track.py saves. -> (events sorted by time, info dict)."""
    P = dict(PARAMS, **(params or {}))
    fps = float(boxers["fps"])
    seen, seg, t = boxers["seen"], boxers["seg"], boxers["t"]
    bodies = [Body(boxers["kpt"][:, b], seen[:, b], seg, fps) for b in (0, 1)]
    two = bool(seen[:, 1].any())
    leads = [lead_side(bodies[b], bodies[1 - b]) if two else None for b in (0, 1)]
    events = []
    for b in ((0, 1) if two else (0,)):
        me, opp = bodies[b], (bodies[1 - b] if two else None)
        for side in ("left", "right"):
            found = []
            for o, pk, e in _bursts(me.speed[side], fps, P):
                if seg[o] != seg[e]:
                    continue
                m = measure(me, opp, side, o, pk, e, P)
                if m is None:
                    continue
                if found and (m["onset"] - found[-1]["end"]) / fps < P["REFRACTORY"]:
                    if m["travel"] > found[-1]["travel"]:
                        found[-1] = m
                    continue
                found.append(m)
            for m in found:
                lead = "?" if leads[b] is None else "lead" if side == leads[b] else "rear"
                family = rule_type(m, P)
                target, result = rule_target_result(m, P)
                c = m["impact"]
                events.append(dict(
                    t=round(float(t[c]), 3), frame=int(boxers["frame"][c]), index=c, boxer="AB"[b], hand=side, lead=lead,
                    family=family, type=name_punch(family, lead), target=target, result=result, m=m))
    events.sort(key=lambda ev: ev["t"])
    number_combos(events, P["COMBO_GAP"])
    info = dict(fps=fps, lead=leads, stance=[None if l is None else "orthodox" if l == "left" else "southpaw" for l in leads],
                colour=[str(c) for c in boxers["colour"]], seen=[float(seen[:, 0].mean()), float(seen[:, 1].mean())],
                both_seen=float(seen.all(1).mean()), duration=float(t[-1] - t[0]) if len(t) else 0.0)
    log("punches: %d found (A %d, B %d); stance A %s, B %s" % (
        len(events), sum(ev["boxer"] == "A" for ev in events), sum(ev["boxer"] == "B" for ev in events), info["stance"][0], info["stance"][1]))
    return events, info, bodies

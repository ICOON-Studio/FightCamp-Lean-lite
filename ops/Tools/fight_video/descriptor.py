"""The pose descriptor a trained classifier reads: one punch as a fixed list of numbers.  (Claude, S495)
(The operator's idea, S495: "build a descriptor from the pose parameters and a classifier on top of that".)

Input: the thrower's joints over the punch window (n frames, 17 COCO joints, x and y in pixels, NaN where unknown) and
which arm punches. Output: 250 numbers that do not depend on where the boxer stands, how big he is in the picture, how
many frames the punch lasted or which hand it was:
  - origin = the hip midpoint averaged over the window; unit = the trunk length (shoulder midpoint to hip midpoint);
  - time is resampled to K = 8 steps from the first to the last frame;
  - joints are ordered PUNCHING side first (shoulder, elbow, wrist), then the OTHER arm, hips, knees, ankles - so a
    left-hand and a right-hand punch give the same numbers, and "lead or rear" shows in which foot is in front;
  - then both elbow angles at each step and ten summary numbers (travel, rise, reach, forearm angle, ...).
Left/right mirroring of the picture is NOT removed here: training adds a mirrored copy of every example instead
(`mirror`), because a boxer filmed from the front has no left-to-right facing to normalise by.
With an opponent (`opp`), 60 more numbers describe where his head, shoulders, hips and gloves are relative to the
thrower's glove at impact and just after (used for landed / blocked / missed)."""
import numpy as np

K = 8
NOSE, L_SH, R_SH, L_EL, R_EL, L_WR, R_WR, L_HIP, R_HIP, L_KN, R_KN, L_ANK, R_ANK = 0, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
SIDE = {"left": dict(sh=L_SH, el=L_EL, wr=L_WR, hip=L_HIP, kn=L_KN, ank=L_ANK),
        "right": dict(sh=R_SH, el=R_EL, wr=R_WR, hip=R_HIP, kn=R_KN, ank=R_ANK)}


def _resample(x, k=K):
    """x (n, ...) -> (k, ...) by linear interpolation in time; NaN stays NaN."""
    n = len(x)
    if n == 1:
        return np.repeat(x, k, axis=0)
    pos = np.linspace(0, n - 1, k)
    lo = np.floor(pos).astype(int)
    hi = np.minimum(lo + 1, n - 1)
    w = (pos - lo).reshape((-1,) + (1,) * (x.ndim - 1))
    return x[lo] * (1 - w) + x[hi] * w


def _angle(a, b, c):
    """Angle at b (degrees) between b->a and b->c, per frame."""
    u, v = a - b, c - b
    cosang = (u * v).sum(-1) / np.maximum(np.linalg.norm(u, axis=-1) * np.linalg.norm(v, axis=-1), 1e-6)
    return np.degrees(np.arccos(np.clip(cosang, -1, 1)))


def glove_of(J, s):
    return J[:, s["wr"]] + 0.4 * (J[:, s["wr"]] - J[:, s["el"]])


def punching_side(J):
    """The arm whose glove travels further from where it started (for clips that do not say which hand)."""
    best, best_d = "left", -1.0
    sh = (J[:, L_SH] + J[:, R_SH]) / 2
    for name, s in SIDE.items():
        rel = glove_of(J, s) - sh
        d = np.linalg.norm(rel - rel[0], axis=1)
        d = np.nanmax(d) if np.isfinite(d).any() else -1.0
        if d > best_d:
            best, best_d = name, d
    return best


def punch_descriptor(J, side, seconds, mirror=False):
    """J (n,17,2) pixels, side 'left'/'right', seconds = the window's length. -> (250,) float32 with NaN for unknowns."""
    J = np.asarray(J, np.float32).copy()
    if mirror:
        J[..., 0] = -J[..., 0]
    P, O = SIDE[side], SIDE["right" if side == "left" else "left"]
    shm, hipm = (J[:, L_SH] + J[:, R_SH]) / 2, (J[:, L_HIP] + J[:, R_HIP]) / 2
    T = np.nanmedian(np.linalg.norm(shm - hipm, axis=1))
    if not np.isfinite(T) or T < 1e-6:
        return np.full(250, np.nan, np.float32)
    origin = np.nanmean(hipm, axis=0)
    order = [NOSE, P["sh"], P["el"], P["wr"], O["sh"], O["el"], O["wr"], P["hip"], O["hip"], P["kn"], O["kn"], P["ank"], O["ank"]]
    pose = _resample((J[:, order] - origin) / T)                    # (K,13,2) = 208
    ang_p = _resample(_angle(J[:, P["sh"]], J[:, P["el"]], J[:, P["wr"]])[:, None])[:, 0] / 180.0
    ang_o = _resample(_angle(J[:, O["sh"]], J[:, O["el"]], J[:, O["wr"]])[:, None])[:, 0] / 180.0
    g = (glove_of(J, P) - shm) / T                                   # glove against the shoulders
    d = np.linalg.norm(g - g[0], axis=1)
    top = int(np.nanargmax(d)) if np.isfinite(d).any() else len(g) - 1  # furthest point of the glove = "impact"
    D = g[top] - g[0]
    travel = float(np.linalg.norm(D))
    path = g[:top + 1] - g[0]
    chord = D / max(travel, 1e-6)
    curve = float(np.nanmax(np.abs(path[:, 0] * chord[1] - path[:, 1] * chord[0]))) / max(travel, 1e-6) if top > 0 else 0.0
    forearm = J[top, P["wr"]] - J[top, P["el"]]
    feet = (J[:, P["ank"]] - J[:, O["ank"]]) / T
    summary = np.array([
        travel, -D[1], abs(D[0]), curve,
        float(np.linalg.norm(glove_of(J, P)[top] - J[top, P["sh"]]) / T),              # reach at the furthest point
        float(np.degrees(np.arctan2(abs(forearm[0]), abs(forearm[1]) + 1e-6)) / 90.0),  # 0 = forearm vertical
        float((J[top, P["sh"]][1] - J[top, P["el"]][1]) / T),                           # + = elbow above shoulder
        float((glove_of(J, P)[0][1] - J[0, P["sh"]][1]) / T),                           # + = starts below the shoulder
        float(np.nanmean(feet[:, 0]) * np.sign(D[0]) if np.isfinite(feet[:, 0]).any() else np.nan),  # punching-side foot ahead of the other, along the punch
        seconds], np.float32)
    return np.concatenate([pose.reshape(-1), ang_p, ang_o, np.r_[top / max(1, len(g) - 1)], summary, np.zeros(15, np.float32)])[:250].astype(np.float32)


def contact_descriptor(J_me, J_opp, side, i_on, i_imp, fps, mirror=False):
    """What the opponent's body does around the glove: 60 numbers for landed / blocked / missed and head / body.
    J_me, J_opp (F,17,2) whole tracks; i_on, i_imp = onset and impact frame indices."""
    out = []
    P = SIDE[side]
    sgn = -1.0 if mirror else 1.0
    step = max(1, int(round(0.04 * fps)))
    shm_o, hipm_o = (J_opp[:, L_SH] + J_opp[:, R_SH]) / 2, (J_opp[:, L_HIP] + J_opp[:, R_HIP]) / 2
    To = np.nanmedian(np.linalg.norm(shm_o - hipm_o, axis=1)[max(0, i_on - 10):i_imp + 10])
    if not np.isfinite(To) or To < 1e-6:
        return np.full(60, np.nan, np.float32)
    with np.errstate(invalid="ignore"), __import__("warnings").catch_warnings():
        __import__("warnings").simplefilter("ignore")
        head_o = np.nanmean(J_opp[:, 0:5], axis=1)
    g_me = glove_of(J_me, P)
    ref = g_me[i_imp]
    punch = g_me[i_imp] - g_me[i_on]
    punch = punch / max(float(np.linalg.norm(punch)), 1e-6)
    side_dir = np.array([-punch[1], punch[0]], np.float32)

    def along(v):  # a vector in the glove's own frame: (along the punch, across it), in opponent trunk lengths
        return [float((v * punch).sum() / To), float((v * side_dir).sum() / To * sgn)]

    F = len(J_me)
    for dt in (-step, 0, step, 2 * step):  # 4 moments x 7 points x 2 = 56
        f = min(F - 1, max(0, i_imp + dt))
        g = g_me[f]
        pts = [head_o[f], shm_o[f], hipm_o[f], glove_of(J_opp, SIDE["left"])[f], glove_of(J_opp, SIDE["right"])[f], J_opp[f, L_EL], J_opp[f, R_EL]]
        for p in pts:
            out += along(p - g)
    base = head_o[i_imp] - shm_o[i_imp]
    snap = [np.nan, np.nan]
    f2 = min(F - 1, i_imp + int(round(0.1 * fps)))
    if np.isfinite(head_o[f2]).all() and np.isfinite(base).all():
        snap = along(head_o[f2] - shm_o[f2] - base)
    out += snap + along(shm_o[f2] - shm_o[i_imp])
    return np.array(out, np.float32)

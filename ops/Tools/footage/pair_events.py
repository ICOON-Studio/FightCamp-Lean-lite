"""Two men in one video: identities, the gap between them, and every punch one throws at the other.  (Claude, S4a, 2026-09-14)
usage: python pair_events.py <track.npz> <out.json> [label]

UNIT: T = a man's torso length in the image (shoulder midpoint to hip midpoint), the median over the segment. It survives
zoom and camera distance; it is ~0.53 m on our f01, which is the only reason ever to turn it into metres.

1. IDENTITY. MediaPipe returns up to two poses per frame in no stable order. Each frame's poses are matched to two tracks
   by hip-midpoint distance (the assignment with the smaller total move wins); a pose that would jump more than 1.0 T in
   one frame starts a new segment instead. A frame where either man is missing, or lacks shoulders, hips, wrists, ankles
   or nose (visibility > 0.5), breaks the segment; a punch also needs its wrist visible (> 0.3) at onset and peak.
2. SEGMENTS of at least 1.0 s with both men tracked. A camera CUT (both hip midpoints jump > 0.6 T in the same frame)
   also breaks a segment.
3. GAP (per frame, in T): the horizontal distance between the two hip midpoints / the mean of the two torso lengths;
   and FEET: the horizontal distance between the two men's nearest ankles, in T. Side-on footage only - a three-quarter
   camera shortens both.
4. PUNCH (per man): a wrist's reach from its own shoulder (in T) rises >= 0.35 T from its local minimum to a peak and
   the wrist moves toward the other man; onset = first frame over 20% of the rise, peak = the maximum, back = first frame
   under 50% after the peak (3-frame smoothing). Which hand: LEAD if its shoulder is nearer the other man.
5. PER PUNCH: gap and feet 0.2 s before onset, at peak, 0.3 s after back; the thrower's hip midpoint, nose, lead and rear
   ankle travel toward the other man, onset -> peak and peak -> back (T); the RECEIVER's nose, hip midpoint and both
   ankles: their displacement from their positions at the thrower's onset, sampled at the peak and 0.1 / 0.2 / 0.3 s
   after it, and the first frame (relative to the peak, in frames and seconds at the video's fps) the receiver's nose has
   moved >= 0.15 T. Wrist height at peak relative to the receiver's nose and shoulders (T, + = above).
"""
import json
import math
import sys

import numpy as np

track = np.load(sys.argv[1])
out_path = sys.argv[2]
label = sys.argv[3] if len(sys.argv) > 3 else ""
t_arr, img, n_arr = track["t"], track["img"], track["n"]
fps = float(track["fps"])
F = len(t_arr)
NOSE, L_SH, R_SH, L_WR, R_WR, L_HIP, R_HIP, L_KNEE, R_KNEE, L_ANK, R_ANK = 0, 11, 12, 15, 16, 23, 24, 25, 26, 27, 28
NEEDED = [NOSE, L_SH, R_SH, L_HIP, R_HIP, L_ANK, R_ANK]  # wrists are judged per punch (the far one is often hidden side-on)


def usable(pose):
    return bool(np.all(pose[NEEDED, 3] > 0.5))


def hipmid(pose):
    return (pose[L_HIP, :2] + pose[R_HIP, :2]) / 2.0


def shmid(pose):
    return (pose[L_SH, :2] + pose[R_SH, :2]) / 2.0


def torso(pose):
    return float(np.linalg.norm(shmid(pose) - hipmid(pose)))


# ---- 1. identity tracks --------------------------------------------------------------------------------------------
A = np.full((F, 33, 5), np.nan, dtype=np.float32)
B = np.full((F, 33, 5), np.nan, dtype=np.float32)
slotA = np.full(F, -1, dtype=np.int32)
slotB = np.full(F, -1, dtype=np.int32)
ok = np.zeros(F, dtype=bool)
prev = None
for i in range(F):
    slot_poses = [(p, img[i, p]) for p in range(int(n_arr[i]))]
    usable_sp = [(s, pose) for s, pose in slot_poses if usable(pose)]
    if len(usable_sp) != 2:
        prev = None
        continue
    (s0, p0), (s1, p1) = usable_sp
    if prev is None:
        # first frame of a run: left-most man in the image is A
        if hipmid(p0)[0] > hipmid(p1)[0]:
            p0, p1 = p1, p0
            s0, s1 = s1, s0
    else:
        keep = np.linalg.norm(hipmid(p0) - prev[0]) + np.linalg.norm(hipmid(p1) - prev[1])
        swap = np.linalg.norm(hipmid(p1) - prev[0]) + np.linalg.norm(hipmid(p0) - prev[1])
        if swap < keep:
            p0, p1 = p1, p0
            s0, s1 = s1, s0
        T_mean = max(1.0, (torso(p0) + torso(p1)) / 2.0)
        jump0 = np.linalg.norm(hipmid(p0) - prev[0]) / T_mean
        jump1 = np.linalg.norm(hipmid(p1) - prev[1]) / T_mean
        if jump0 > 1.0 or jump1 > 1.0 or (jump0 > 0.6 and jump1 > 0.6):
            prev = None
            continue
    A[i], B[i] = p0, p1
    slotA[i], slotB[i] = s0, s1
    ok[i] = True
    prev = (hipmid(p0), hipmid(p1))

segments = []
i = 0
while i < F:
    if not ok[i]:
        i += 1
        continue
    j = i
    while j + 1 < F and ok[j + 1]:
        j += 1
    if (j - i + 1) / fps >= 1.0:
        segments.append((i, j))
    i = j + 1


def vertical(P, onset, peak, end, T_):
    """6. (S4a, 2026-09-14, the operator: "the body of right is folding unnaturally") HOW FAR THE THROWER SINKS: the hip
    midpoint's and the nose's height above his own ankle midpoint (image y grows downward), in T, from the punch's onset
    through 0.3 s after its return. Measured against the man's own feet, so a camera pan or tilt cancels out and T cancels
    zoom. drop = the height at onset minus the lowest height in the window (+ = lower); drop_s_from_peak = when."""
    def height(q, joint_y):
        ankles = (P[q, L_ANK, 1] + P[q, R_ANK, 1]) / 2.0
        return float((ankles - joint_y) / T_)

    hips = [height(q, (P[q, L_HIP, 1] + P[q, R_HIP, 1]) / 2.0) for q in range(onset, end + 1)]
    nose = [height(q, P[q, NOSE, 1]) for q in range(onset, end + 1)]
    low = int(np.argmin(hips))
    return {"hips_drop_max": hips[0] - hips[low], "hips_drop_s_from_peak": (onset + low - peak) / fps,
            "nose_drop_max": nose[0] - min(nose)}


def smooth(a, k=3):
    if len(a) < k:
        return a
    pad = np.pad(a, (k // 2, k // 2), mode="edge")
    return np.convolve(pad, np.ones(k) / k, mode="valid")


result = {"label": label, "fps": fps, "frames": F, "segments": [], "punches": []}
for (s, e) in segments:
    idx = np.arange(s, e + 1)
    men = {"A": A[idx], "B": B[idx]}
    T = {m: float(np.median([torso(p) for p in men[m]])) for m in men}
    Tm = (T["A"] + T["B"]) / 2.0
    hip = {m: np.array([hipmid(p) for p in men[m]]) for m in men}
    nose = {m: men[m][:, NOSE, :2] for m in men}
    gap = np.abs(hip["A"][:, 0] - hip["B"][:, 0]) / Tm
    ank = {m: men[m][:, [L_ANK, R_ANK], :2] for m in men}
    feet = np.array([np.min(np.abs(ank["A"][k, :, 0][:, None] - ank["B"][k, :, 0][None, :])) for k in range(len(idx))]) / Tm
    seg = {"start_s": float(t_arr[s]), "end_s": float(t_arr[e]), "frames": int(e - s + 1), "T_px": T,
           "gap_T_p10_p50_p90": [float(np.percentile(gap, q)) for q in (10, 50, 90)],
           "feet_T_p10_p50_p90": [float(np.percentile(feet, q)) for q in (10, 50, 90)]}
    result["segments"].append(seg)
    for thrower, receiver in (("A", "B"), ("B", "A")):
        P = men[thrower]
        Q = men[receiver]
        toward = np.sign(np.median(hip[receiver][:, 0] - hip[thrower][:, 0])) or 1.0
        for hand, wr, sh in (("L", L_WR, L_SH), ("R", R_WR, R_SH)):
            reach = smooth(np.linalg.norm(P[:, wr, :2] - P[:, sh, :2], axis=1) / T[thrower])
            k = 1
            while k < len(reach) - 1:
                if not (reach[k] >= reach[k - 1] and reach[k] > reach[k + 1]):
                    k += 1
                    continue
                lo = k
                while lo > 0 and reach[lo - 1] <= reach[lo]:
                    lo -= 1
                rise = reach[k] - reach[lo]
                if rise < 0.35:
                    k += 1
                    continue
                onset = next(q for q in range(lo, k + 1) if reach[q] >= reach[lo] + 0.2 * rise)
                back = next((q for q in range(k + 1, len(reach)) if reach[q] < reach[lo] + 0.5 * rise), None)
                move = (P[k, wr, 0] - P[onset, wr, 0]) * toward
                if back is None or move <= 0.0 or P[k, wr, 3] < 0.3 or P[onset, wr, 3] < 0.3:
                    k += 1
                    continue
                lead_sh_x = (P[k, L_SH, 0] if hand == "L" else P[k, R_SH, 0]) * toward
                other_sh_x = (P[k, R_SH, 0] if hand == "L" else P[k, L_SH, 0]) * toward
                is_lead = lead_sh_x > other_sh_x

                def at(arr, q):
                    return arr[max(0, min(len(arr) - 1, q))]

                def travel(pts, a, b, T_):
                    return float((at(pts, b)[0] - at(pts, a)[0]) * toward / T_)

                pre = onset - int(round(0.2 * fps))
                post = back + int(round(0.3 * fps))
                lead_ank = L_ANK if (P[onset, L_ANK, 0] * toward > P[onset, R_ANK, 0] * toward) else R_ANK
                rear_ank = R_ANK if lead_ank == L_ANK else L_ANK
                # receiver response, from his position at the thrower's onset, in T, along "away from the thrower"
                away = toward
                def disp(pts, q):
                    return float(np.linalg.norm(at(pts, q) - at(pts, onset)) / T[receiver])
                nose_move = None
                for q in range(max(0, k - int(round(0.1 * fps))), min(len(idx), k + int(round(0.6 * fps)))):
                    if disp(Q[:, NOSE, :2], q) >= 0.15:
                        nose_move = q - k
                        break
                ev = {
                    "t_peak_s": float(t_arr[s + k]), "thrower": thrower, "hand": hand, "lead": bool(is_lead),
                    "extension_frames": int(k - onset), "return_frames": int(back - k),
                    "gap_T_before": float(at(gap, pre)), "gap_T_peak": float(gap[k]), "gap_T_after": float(at(gap, post)),
                    "feet_T_before": float(at(feet, pre)), "feet_T_peak": float(feet[k]), "feet_T_after": float(at(feet, post)),
                    "thrower_T": {"hips_out": travel(hip[thrower], onset, k, T[thrower]), "hips_back": travel(hip[thrower], k, back, T[thrower]),
                                  "nose_out": travel(nose[thrower], onset, k, T[thrower]),
                                  "lead_ankle_out": travel(P[:, lead_ank, :2], onset, k, T[thrower]),
                                  "rear_ankle_out": travel(P[:, rear_ank, :2], onset, k, T[thrower])},
                    "receiver_T_away": {tag: {"nose": float((at(Q[:, NOSE, :2], q)[0] - at(Q[:, NOSE, :2], onset)[0]) * away / T[receiver]),
                                              "hips": float((at(hip[receiver], q)[0] - at(hip[receiver], onset)[0]) * away / T[receiver]),
                                              "ankles": float(np.mean([(at(Q[:, a_, :2], q)[0] - at(Q[:, a_, :2], onset)[0]) * away for a_ in (L_ANK, R_ANK)]) / T[receiver])}
                                        for tag, q in (("peak", k), ("peak+0.1s", k + int(round(0.1 * fps))),
                                                       ("peak+0.2s", k + int(round(0.2 * fps))), ("peak+0.3s", k + int(round(0.3 * fps))))},
                    "receiver_nose_moves_frames_from_peak": nose_move,
                    "receiver_nose_moves_s_from_peak": (None if nose_move is None else nose_move / fps),
                    "wrist_vs_receiver_nose_T": float((Q[k, NOSE, 1] - P[k, wr, 1]) / T[receiver]),
                    "frame": int(s + k), "onset_frame": int(s + onset), "back_frame": int(s + back),
                    "thrower_T_vertical": vertical(P, onset, k, min(len(idx) - 1, post), T[thrower]),
                }
                # ---- POSTURE (Q109, the fold measured) ----
                _w0 = max(0, onset - int(round(0.2 * fps)))
                _w1 = min(len(idx) - 1, back + int(round(0.3 * fps)))
                _wlen = _w1 - _w0 + 1
                _t_slot = slotA if thrower == "A" else slotB
                _r_slot = slotB if thrower == "A" else slotA
                _t_slots = [int(_t_slot[s + _w0 + j]) for j in range(_wlen)]
                _r_slots = [int(_r_slot[s + _w0 + j]) for j in range(_wlen)]
                _pk = 3 if fps < 40 else 5
                _Tt, _Tr = T[thrower], T[receiver]
                _raw_hh, _raw_pt, _raw_pr, _raw_rhh = [], [], [], []
                for _j in range(_wlen):
                    _q = _w0 + _j
                    _ank_ty = (P[_q, L_ANK, 1] + P[_q, R_ANK, 1]) / 2.0
                    _hip_ty = (P[_q, L_HIP, 1] + P[_q, R_HIP, 1]) / 2.0
                    _raw_hh.append(float((_ank_ty - _hip_ty) / _Tt))
                    _sh_t = (P[_q, L_SH, :2] + P[_q, R_SH, :2]) / 2.0
                    _hp_t = (P[_q, L_HIP, :2] + P[_q, R_HIP, :2]) / 2.0
                    _raw_pt.append(math.degrees(math.atan2(float((_sh_t[0] - _hp_t[0]) * toward), float(_hp_t[1] - _sh_t[1]))))
                    _sh_r = (Q[_q, L_SH, :2] + Q[_q, R_SH, :2]) / 2.0
                    _hp_r = (Q[_q, L_HIP, :2] + Q[_q, R_HIP, :2]) / 2.0
                    _raw_pr.append(math.degrees(math.atan2(float((_sh_r[0] - _hp_r[0]) * (-toward)), float(_hp_r[1] - _sh_r[1]))))
                    _ank_ry = (Q[_q, L_ANK, 1] + Q[_q, R_ANK, 1]) / 2.0
                    _hip_ry = (Q[_q, L_HIP, 1] + Q[_q, R_HIP, 1]) / 2.0
                    _raw_rhh.append(float((_ank_ry - _hip_ry) / _Tr))
                _sm_hh = smooth(np.array(_raw_hh), _pk)
                _sm_pt = smooth(np.array(_raw_pt), _pk)
                _sm_pr = smooth(np.array(_raw_pr), _pk)
                _sm_rhh = smooth(np.array(_raw_rhh), _pk)
                _lead_left = bool(P[onset, L_ANK, 0] * toward > P[onset, R_ANK, 0] * toward)
                def _knee_series(hip_lm, knee_lm, ank_lm):
                    _vis = [float(P[_w0 + j, knee_lm, 3]) for j in range(_wlen)]
                    if any(v <= 0.5 for v in _vis):
                        return [None] * _wlen
                    _raw = []
                    for _j in range(_wlen):
                        _q = _w0 + _j
                        _a = P[_q, hip_lm, :2].astype(float)
                        _b = P[_q, knee_lm, :2].astype(float)
                        _c = P[_q, ank_lm, :2].astype(float)
                        _u, _v = _a - _b, _c - _b
                        _d = float(np.linalg.norm(_u) * np.linalg.norm(_v))
                        if _d == 0:
                            _raw.append(None)
                        else:
                            _raw.append(math.degrees(math.acos(max(-1.0, min(1.0, float(np.dot(_u, _v)) / _d)))))
                    if any(x is None for x in _raw):
                        return [None] * _wlen
                    return smooth(np.array(_raw), _pk).tolist()
                if _lead_left:
                    _lead_ks = _knee_series(L_HIP, L_KNEE, L_ANK)
                    _rear_ks = _knee_series(R_HIP, R_KNEE, R_ANK)
                else:
                    _lead_ks = _knee_series(R_HIP, R_KNEE, R_ANK)
                    _rear_ks = _knee_series(L_HIP, L_KNEE, L_ANK)
                def _count_dips(h, prom):
                    _cnt, _wh = 0, []
                    for _i in range(1, len(h) - 1):
                        if h[_i] < h[_i - 1] and h[_i] <= h[_i + 1]:
                            _lh = float('-inf')
                            for _j in range(_i - 1, -1, -1):
                                if h[_j] < h[_i]:
                                    break
                                _lh = max(_lh, h[_j])
                            _rh = float('-inf')
                            for _j in range(_i + 1, len(h)):
                                if h[_j] < h[_i]:
                                    break
                                _rh = max(_rh, h[_j])
                            if min(_lh, _rh) - h[_i] >= prom:
                                _cnt += 1
                                _wh.append(_i)
                    return _cnt, _wh
                _dips05, _dip_idx05 = _count_dips(_sm_hh, 0.05)
                _dips10, _ = _count_dips(_sm_hh, 0.10)
                _recv_dips05, _ = _count_dips(_sm_rhh, 0.05)
                _oi = onset - _w0
                _pi = k - _w0
                _w0f = s + _w0
                _w1f = s + _w1
                _pkf = s + k
                _pitch_onset = float(_sm_pt[_oi])
                _pitch_peak = float(_sm_pt[_pi])
                _pitch_max = float(np.max(_sm_pt))
                _pitch_min = float(np.min(_sm_pt))
                _pitch_max_i = int(np.argmax(_sm_pt))
                _pitch_max_s = (_pitch_max_i + _w0f - _pkf) / fps
                _pitch_fwd = float(np.max(_sm_pt[_pi:])) - _pitch_onset
                def _kv(series):
                    if series[0] is None:
                        return None, None, None
                    _o = float(series[_oi])
                    _m = float(np.min(series))
                    return _o, _m, _o - _m
                _lko, _lkm, _lkb = _kv(_lead_ks)
                _rko, _rkm, _rkb = _kv(_rear_ks)
                _rp_onset = float(_sm_pr[_oi])
                _rp_min_after = float(np.min(_sm_pr[_pi:]))
                _rp_back = _rp_onset - _rp_min_after
                ev["posture"] = {
                    "w0_frame": _w0f, "w1_frame": _w1f,
                    "thrower_slot": _t_slots, "receiver_slot": _r_slots,
                    "hips_dips_05T": _dips05, "hips_dips_10T": _dips10,
                    "dip_s_from_peak_05T": [round((i + _w0f - _pkf) / fps, 4) for i in _dip_idx05],
                    "pitch_onset_deg": round(_pitch_onset, 5),
                    "pitch_peak_deg": round(_pitch_peak, 5),
                    "pitch_max_deg": round(_pitch_max, 5),
                    "pitch_max_s_from_peak": round(_pitch_max_s, 4),
                    "pitch_min_deg": round(_pitch_min, 5),
                    "pitch_forward_change_deg": round(_pitch_fwd, 5),
                    "lead_knee_onset_deg": round(_lko, 5) if _lko is not None else None,
                    "lead_knee_min_deg": round(_lkm, 5) if _lkm is not None else None,
                    "lead_knee_bend_deg": round(_lkb, 5) if _lkb is not None else None,
                    "rear_knee_onset_deg": round(_rko, 5) if _rko is not None else None,
                    "rear_knee_min_deg": round(_rkm, 5) if _rkm is not None else None,
                    "rear_knee_bend_deg": round(_rkb, 5) if _rkb is not None else None,
                    "receiver_pitch_onset_deg": round(_rp_onset, 5),
                    "receiver_pitch_min_after_peak_deg": round(_rp_min_after, 5),
                    "receiver_pitch_back_change_deg": round(_rp_back, 5),
                    "receiver_hips_dips_05T": _recv_dips05,
                    "series": {
                        "thrower_hip_h": [round(v, 5) for v in _raw_hh],
                        "thrower_pitch": [round(v, 5) for v in _raw_pt],
                        "receiver_pitch": [round(v, 5) for v in _raw_pr],
                    },
                }
                result["punches"].append(ev)
                k = back
result["summary"] = {"segments": len(result["segments"]), "segment_seconds": float(sum((e - s + 1) / fps for s, e in segments)),
                     "punches": len(result["punches"])}
json.dump(result, open(out_path, "w"), indent=1)
print("%s: %d segments (%.1f s both men tracked), %d punches toward the other man" % (
    label, result["summary"]["segments"], result["summary"]["segment_seconds"], len(result["punches"])))

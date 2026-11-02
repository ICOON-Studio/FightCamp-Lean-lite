"""U108 gate (Claude, 2026-09-14). Prints `U108_CHECK PASS` or FAIL lines. Run from the repo (or worktree) root.

Every metric and label is recomputed from the census's own series with this file's code; the series themselves are pinned
to an INDEPENDENT instrument (U108_probe_blender.py: a fresh import per clip, run here) on named and seeded-random clips,
to physics (a _RootMotion walk travels, its in-place sibling does not; left/right agree with the toes), and to Q86's
Godot-measured RamsterZ stance clips. Q86's FM1 and Motifect rows are NOT used: they read zero motion where Blender shows
the hips moving (the trap this census exists to settle).
"""
import glob
import hashlib
import json
import math
import os
import random
import struct
import subprocess
import sys
import tempfile

import numpy as np

BLENDER = "D:/Tools/Blender/blender-5.2.1-windows-x64/blender.exe"
AUD = "Godot/assets/anim/audition"
PACKS = ["ramsterz_h2h", "magicpot_fm1", "motifect"]
TABLE = "research/U108_clip_behaviour.json"
SERIES = "C:/Users/user/AppData/Local/Temp/FightCamp-moves/U108/series.npz"
DIGEST = "research/U108_CLIP_BEHAVIOUR.md"
SHEETS = "research/U108_sheets"
TOOL = "Tools/blender_moves/clip_behaviour_census.py"
PROBE = "research/U108_probe_blender.py"
ROLES = ["pelvis", "head", "thigh_l", "thigh_r", "foot_l", "foot_r", "hand_l", "hand_r", "toe_l", "toe_r"]
LABELS = ["static_hold", "bounce", "foot_lift", "in_place_steps", "steps_travel", "turn", "level_change", "stance_switch",
          "strike_hand", "strike_foot"]
FLOAT_KEYS = ["T_m", "pelvis_z_range_m", "pelvis_z_p5_p95_m", "bounce_per_min", "foot_lift_m", "lifts_per_min",
              "travel_net_m", "travel_path_m", "turn_deg", "turn_max_deg", "level_drop_m", "guard_share",
              "lead_left_share", "hand_speed_max_mps", "foot_speed_max_mps"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def series_key(rel):
    return rel.replace("/", "__")


def fwd_at(TL, TR, k, prev):
    r = TR[k, :2] - TL[k, :2]
    n = float(np.hypot(r[0], r[1]))
    if n < 1e-6:
        return prev
    return np.array([-r[1] / n, r[0] / n])


def angle_deg(a, b):
    return math.degrees(math.atan2(a[0] * b[1] - a[1] * b[0], a[0] * b[0] + a[1] * b[1]))


def metrics(S, length_s):
    n = S.shape[0]
    P, H, TL, TR, FL, FR, HL, HR, OL, OR = [S[:, i] for i in range(10)]
    m = {}
    minutes = length_s / 60.0
    pz = P[:, 2]
    m["T_m"] = float(np.linalg.norm(H[0] - P[0]))
    m["pelvis_z_range_m"] = float(pz.max() - pz.min())
    m["pelvis_z_p5_p95_m"] = float(np.percentile(pz, 95) - np.percentile(pz, 5))
    med = float(np.median(pz))
    state, count = None, 0
    for z in pz:
        if z > med + 0.005:
            if state == "low":
                count += 1
            state = "high"
        elif z < med - 0.005:
            state = "low"
    m["bounce_per_min"] = count / minutes if minutes > 0 else 0.0
    lift, lifts = 0.0, 0
    for F in (FL, FR):
        fz = F[:, 2]
        base = float(np.percentile(fz, 5))
        lift = max(lift, float(fz.max()) - base)
        st = "up" if fz[0] > base + 0.04 else "down"
        for z in fz[1:]:
            if st == "down" and z > base + 0.04:
                lifts += 1
                st = "up"
            elif st == "up" and z < base + 0.02:
                st = "down"
    m["foot_lift_m"] = lift
    m["lifts_per_min"] = lifts / minutes if minutes > 0 else 0.0
    d = P[-1, :2] - P[0, :2]
    m["travel_net_m"] = float(np.hypot(d[0], d[1]))
    steps = np.diff(P[:, :2], axis=0)
    m["travel_path_m"] = float(np.hypot(steps[:, 0], steps[:, 1]).sum()) if n > 1 else 0.0
    f0 = fwd_at(TL, TR, 0, np.array([0.0, 1.0]))
    fs, prev = [], f0
    for k in range(n):
        prev = fwd_at(TL, TR, k, prev)
        fs.append(prev)
    r0 = np.array([f0[1], -f0[0]])
    fc, rc = float(d @ f0), float(d @ r0)
    if m["travel_net_m"] < 0.10:
        m["travel_dir"] = "none"
    elif abs(fc) >= abs(rc):
        m["travel_dir"] = "forward" if fc > 0 else "back"
    else:
        m["travel_dir"] = "right" if rc > 0 else "left"
    m["turn_deg"] = angle_deg(f0, fs[-1])
    m["turn_max_deg"] = max(abs(angle_deg(f0, f)) for f in fs)
    m["level_drop_m"] = float(pz[0] - pz.min())
    thr = pz + 0.75 * (H[:, 2] - pz)
    m["guard_share"] = float(np.mean((HL[:, 2] > thr) & (HR[:, 2] > thr)))
    state, swaps, left = None, 0, 0
    for k in range(n):
        s = float((FL[k, :2] - FR[k, :2]) @ fs[k])
        new = "L" if s > 0.05 else ("R" if s < -0.05 else state)
        if state is not None and new != state:
            swaps += 1
        state = new
        left += 1 if state == "L" else 0
    m["lead_swaps"] = swaps
    m["lead_left_share"] = left / n
    def speed(X):
        return float((np.linalg.norm(np.diff(X, axis=0), axis=1) * 30.0).max()) if n > 1 else 0.0
    m["hand_speed_max_mps"] = max(speed(HL), speed(HR))
    m["foot_speed_max_mps"] = max(speed(FL), speed(FR))
    moved = float(np.abs(S - S[0]).max(axis=(0, 2)).max())
    m["static"] = bool(m["pelvis_z_range_m"] < 0.005 and m["travel_path_m"] < 0.01 and moved < 0.01)
    m["motion_digest"] = hashlib.sha1(np.round(S * 1000.0).astype(np.int32).tobytes()).hexdigest()
    lab = []
    fl = m["foot_lift_m"] >= 0.06 and m["lifts_per_min"] >= 30
    for name, on in (("static_hold", m["static"]),
                     ("bounce", m["pelvis_z_p5_p95_m"] >= 0.02 and m["bounce_per_min"] >= 60 and m["travel_net_m"] < 0.25),
                     ("foot_lift", fl),
                     ("in_place_steps", fl and m["travel_net_m"] < 0.25),
                     ("steps_travel", m["travel_net_m"] >= 0.25),
                     ("turn", abs(m["turn_deg"]) >= 45),
                     ("level_change", m["level_drop_m"] >= 0.4 * m["T_m"]),
                     ("stance_switch", m["lead_swaps"] >= 1 and m["foot_lift_m"] >= 0.06),
                     ("strike_hand", m["hand_speed_max_mps"] >= 5.0),
                     ("strike_foot", m["foot_speed_max_mps"] >= 6.0)):
        if on:
            lab.append(name)
    m["labels"] = lab
    return m


# ------------------------------------------------------------------------------------------------------------- table
if not os.path.exists(TABLE):
    fail("missing " + TABLE)
    sys.exit(1)
T = json.load(open(TABLE, encoding="utf-8"))
if T.get("roles") != ROLES:
    fail("roles must be exactly %s" % ROLES)
clips, excluded, packs = T.get("clips", {}), T.get("excluded", {}), T.get("packs", {})
if not isinstance(T.get("population"), str) or len(T["population"]) < 40:
    fail("population must be a sentence naming the packs and counts")
for p in PACKS:
    if set(packs.get(p, {}).get("joints", {}).keys()) != set(ROLES):
        fail("packs.%s.joints must map every role" % p)

# ------------------------------------------------------------------------------------------------------- population
on_disk = set()
for p in PACKS:
    for f in glob.glob(os.path.join(AUD, p, "**", "*"), recursive=True):
        if f.lower().endswith(".fbx") and os.path.isfile(f):
            on_disk.add(os.path.relpath(f, AUD).replace("\\", "/"))
listed = set(clips) | set(excluded)
if set(clips) & set(excluded):
    fail("in both clips and excluded: %s" % sorted(set(clips) & set(excluded))[:5])
for f in sorted(on_disk - listed)[:10]:
    fail("fbx on disk not in the census: " + f)
for f in sorted(listed - on_disk)[:10]:
    fail("census names a file not on disk: " + f)
for f, why in excluded.items():
    if why not in ("no animation", "no joints"):
        fail("excluded %s: reason must be 'no animation' or 'no joints', got %r" % (f, why))
if len(clips) < 150:
    fail("only %d clips measured - expected most of the %d files" % (len(clips), len(on_disk)))

# ----------------------------------------------------------------------------------------------- recompute from series
if not os.path.exists(SERIES):
    fail("missing series " + SERIES)
    sys.exit(1)
Z = np.load(SERIES)
mine = {}
for rel, row in sorted(clips.items()):
    key = series_key(rel)
    if key not in Z.files:
        fail("series has no %s" % key)
        continue
    S = np.asarray(Z[key], dtype=float)
    L = float(row.get("length_s", -1))
    if S.ndim != 3 or S.shape[1:] != (10, 3) or not np.isfinite(S).all():
        fail("%s: series shape %s or non-finite" % (rel, S.shape))
        continue
    if S.shape[0] != int(math.floor(L * 30.0 + 1e-6)) + 1 or row.get("samples") != S.shape[0]:
        fail("%s: %d samples for length %.4f s (want floor(L*30)+1, and samples = that)" % (rel, S.shape[0], L))
        continue
    m = metrics(S, L)
    mine[rel] = (S, m)
    for k in FLOAT_KEYS:
        tol = 0.05 if k.endswith("per_min") or k.endswith("deg") else 2e-3
        if not isinstance(row.get(k), (int, float)) or abs(float(row[k]) - m[k]) > tol:
            fail("%s: %s is %s, recomputed %.4f" % (rel, k, row.get(k), m[k]))
    for k in ("lead_swaps", "travel_dir", "static", "motion_digest", "labels"):
        if row.get(k) != m[k]:
            fail("%s: %s is %r, recomputed %r" % (rel, k, row.get(k), m[k]))
    if row.get("pack") not in PACKS or not rel.startswith(row.get("pack", "?") + "/"):
        fail("%s: pack %r" % (rel, row.get("pack")))
if len(fails) > 40:
    print("U108_CHECK stopping early: %d fails" % len(fails))
    sys.exit(1)

# ------------------------------------------------------------------------------------------------- identity and physics
by_motion = {}
for rel, (S, m) in mine.items():
    by_motion.setdefault(m["motion_digest"], []).append(rel)
for dig, rels in by_motion.items():
    keys = {clips[r].get("keys_digest") for r in rels}
    if len(rels) > 1 and len(keys) > 1:
        fail("same motion from different keyframes (the animation was not applied?): %s" % rels[:4])
standing = [(rel, S) for rel, (S, m) in mine.items() if m["T_m"] >= 0.3 and S[0, 1, 2] - S[0, 0, 2] >= 0.3]
agree = 0
for rel, S in standing:
    f0 = fwd_at(S[:, 2], S[:, 3], 0, np.array([0.0, 1.0]))
    toe = 0.5 * ((S[0, 8, :2] - S[0, 4, :2]) + (S[0, 9, :2] - S[0, 5, :2]))
    agree += 1 if float(toe @ f0) > 0 else 0
if not standing or agree / len(standing) < 0.8:
    fail("left/right or up axis: toes point along forward in %d of %d standing clips (want >= 80%%)" % (agree, len(standing)))
# UNITS, not acrobatics (revised 2026-09-14 after U108's BLOCKED mail): the first bound was [-0.2, 2.5] m and the
# game-authored H2H_BackflipKick_InPlace legitimately peaks at 2.903 m (probe-confirmed). A centimetres-as-metres error
# puts a pelvis near 90 m and a metres-as-centimetres one near 0.009 m, so bound the extremes loosely and pin the MEDIAN
# standing pelvis at frame 0 to a human.
allz = [float(S[:, 0, 2].min()) for S, m in mine.values()] + [float(S[:, 0, 2].max()) for S, m in mine.values()]
if allz and (min(allz) < -0.2 or max(allz) > 5.0):
    fail("pelvis height outside [-0.2, 5.0] m: min %.3f max %.3f (units?)" % (min(allz), max(allz)))
p0 = sorted(float(S[0, 0, 2]) for S, m in mine.values())
if p0 and not (0.6 <= p0[len(p0) // 2] <= 1.2):
    fail("median frame-0 pelvis height %.3f m is not a standing human (units?)" % p0[len(p0) // 2])
tms = sorted(m["T_m"] for S, m in mine.values())
if tms and not (0.45 <= tms[len(tms) // 2] <= 0.85):
    fail("median head-to-pelvis %.3f m is not a human (units?)" % tms[len(tms) // 2])
pairs = 0
for rel in mine:
    if rel.lower().endswith("_rootmotion.fbx"):
        stem = rel[: -len("_RootMotion.fbx")]
        sib = next((r for r in mine if r.lower() in (stem.lower() + ".fbx",)), None)
        if sib:
            pairs += 1
            if mine[rel][1]["travel_net_m"] < 0.3 or mine[sib][1]["travel_net_m"] >= 0.25:
                fail("root motion %s travels %.3f m and in-place %s %.3f m (want >= 0.3 and < 0.25)"
                     % (rel, mine[rel][1]["travel_net_m"], sib, mine[sib][1]["travel_net_m"]))
if pairs < 2:
    fail("found %d _RootMotion / in-place pairs, want >= 2" % pairs)
for rel, want, tol in (("ramsterz_h2h/H2H_Idle.FBX", 0.0307, 0.01), ("ramsterz_h2h/Standing_Idle.FBX", 0.0016, 0.01),
                       ("ramsterz_h2h/H2H_LegBlockIdle.FBX", 0.032, 0.01), ("ramsterz_h2h/H2H_BlockIdle.FBX", 0.1357, 0.02)):
    if rel not in mine:
        fail("Q86 pin clip missing: " + rel)
    elif abs(mine[rel][1]["pelvis_z_range_m"] - want) > tol:
        fail("%s pelvis range %.4f m, Q86 measured %.4f in Godot" % (rel, mine[rel][1]["pelvis_z_range_m"], want))

# ------------------------------------------------------------------------------------------------ the independent probe
rng = random.Random(108)
must = ["ramsterz_h2h/H2H_Idle.FBX", "magicpot_fm1/idle_A.fbx", "magicpot_fm1/idle_Tiramis.fbx",
        "ramsterz_h2h/H2H_WalkBackLeft_RootMotion.fbx"]
must += [r for r in mine if r.endswith("muay_thai_guard_stance.fbx")]
rest = sorted(r for r in mine if r not in must)
pick = [r for r in must if r in mine] + rng.sample(rest, min(6, len(rest)))
statics = sorted(r for r, (S, m) in mine.items() if m["static"] and clips[r].get("keys_vary") and r not in pick)
pick += rng.sample(statics, min(3, len(statics)))
ex_noanim = sorted(r for r, why in excluded.items() if why == "no animation")
ex_pick = rng.sample(ex_noanim, min(3, len(ex_noanim)))
req = {"clips": []}
for r in pick:
    n = mine[r][0].shape[0]
    req["clips"].append({"file": os.path.abspath(os.path.join(AUD, r)), "joints": packs[clips[r]["pack"]]["joints"],
                         "indices": sorted({0, n // 2, n - 1})})
for r in ex_pick:
    req["clips"].append({"file": os.path.abspath(os.path.join(AUD, r)), "joints": {}, "indices": []})
tmp = tempfile.mkdtemp(prefix="u108probe_")
rq, ro = os.path.join(tmp, "req.json"), os.path.join(tmp, "out.json")
json.dump(req, open(rq, "w", encoding="utf-8"))
try:
    subprocess.run([BLENDER, "--background", "--factory-startup", "--python", PROBE, "--", rq, ro],
                   capture_output=True, text=True, timeout=900)
except subprocess.TimeoutExpired:
    fail("probe timed out")
if not os.path.exists(ro):
    fail("probe wrote nothing")
else:
    got = {os.path.normcase(c["file"]): c for c in json.load(open(ro, encoding="utf-8"))["clips"]}
    worst = 0.0
    for r in pick:
        c = got.get(os.path.normcase(os.path.abspath(os.path.join(AUD, r))))
        if c is None:
            fail("probe lost " + r)
            continue
        if c.get("keys_digest") != clips[r].get("keys_digest") or c.get("keys_vary") != clips[r].get("keys_vary"):
            fail("%s: keys_digest/keys_vary %s/%s, probe %s/%s" % (r, clips[r].get("keys_digest"), clips[r].get("keys_vary"),
                                                                   c.get("keys_digest"), c.get("keys_vary")))
        if abs(float(c.get("length_s", -9)) - float(clips[r]["length_s"])) > 1e-3:
            fail("%s: length_s %.4f, probe %.4f" % (r, clips[r]["length_s"], c.get("length_s", -9)))
        S = mine[r][0]
        for idx, roles in c.get("positions", {}).items():
            for j, role in enumerate(ROLES):
                p = roles.get(role)
                if p is None:
                    fail("%s: probe cannot find role %s" % (r, role))
                    continue
                e = float(np.linalg.norm(np.array(p) - S[int(idx), j]))
                worst = max(worst, e)
                if e > 0.01:
                    fail("%s sample %s %s: census %s, probe %s (%.3f m apart)" % (r, idx, role, np.round(S[int(idx), j], 3),
                                                                                 np.round(p, 3), e))
    for r in ex_pick:
        c = got.get(os.path.normcase(os.path.abspath(os.path.join(AUD, r))))
        if c is None or (c.get("n_actions", 0) > 0 and float(c.get("length_s", 0)) > 0):
            fail("excluded as 'no animation' but the probe finds one: " + r)
    print("U108_CHECK probe: %d clips + %d excluded, worst joint gap %.4f m" % (len(pick), len(ex_pick), worst))

# ------------------------------------------------------------------------------------------------ digest, sheets, tool
if not os.path.exists(DIGEST):
    fail("missing " + DIGEST)
else:
    text = open(DIGEST, encoding="utf-8").read()
    lines = text.splitlines()
    if len(lines) > 80:
        fail("digest has %d lines, max 80" % len(lines))
    if "## DECISIONS" not in text or T.get("population", "@@") not in text:
        fail("digest needs '## DECISIONS' and the population string verbatim")
    counts = {lab: sum(1 for S, m in mine.values() if lab in m["labels"]) for lab in LABELS}
    for lab, n in counts.items():
        if not any(("`%s`" % lab) in ln and str(n) in ln.replace("`%s`" % lab, "") for ln in lines):
            fail("digest needs a line naming `%s` with its count %d" % (lab, n))
    a, b = mine.get("magicpot_fm1/idle_A.fbx"), mine.get("magicpot_fm1/idle_Tiramis.fbx")
    if a and b:
        same = a[1]["motion_digest"] == b[1]["motion_digest"]
        want = "same motion" if same else "different motion"
        if not any("idle_A" in ln and "idle_Tiramis" in ln and want in ln for ln in lines):
            fail("digest must say idle_A and idle_Tiramis are '%s' (on one line)" % want)
    for lab, n in counts.items():
        png = os.path.join(SHEETS, lab + ".png")
        if n and (not os.path.exists(png) or os.path.getsize(png) < 10000
                  or open(png, "rb").read(8) != b"\x89PNG\r\n\x1a\n"):
            fail("sheet %s missing, not a PNG or under 10 KB" % png)
if os.path.exists(TOOL):
    src = open(TOOL, encoding="utf-8").read()
    for bad in ("Q86_stance_takes", "U108_check", "U108_probe"):
        if bad in src:
            fail("the census tool must not read %s" % bad)
else:
    fail("missing " + TOOL)

print("U108_CHECK clips %d excluded %d labels %s" % (len(mine), len(excluded),
      {lab: sum(1 for S, m in mine.values() if lab in m["labels"]) for lab in LABELS}))
print("U108_CHECK PASS" if not fails else "U108_CHECK FAIL (%d)" % len(fails))
sys.exit(0 if not fails else 1)

"""U112 gate. Prints `U112_CHECK PASS` or FAIL lines. Run from the repo root.

    python research/U112_check.py [FOOTAGE_DIR]

FOOTAGE_DIR defaults to C:/Users/user/AppData/Local/Temp/FightCamp-footage and must hold track/*.npz.

Re-derives every headline inventory figure from the raw .npz files (never from pair_world output or the digest).
Runs pair_world on the cleanest clip and refuses a reconstruction whose fighters collapse together or whose
inter-fighter distance is constant (degenerate placement).
"""
from __future__ import annotations

import os
import subprocess
import sys
import tempfile

import numpy as np

FOOTAGE = sys.argv[1] if len(sys.argv) > 1 else "C:/Users/user/AppData/Local/Temp/FightCamp-footage"
TRACK_DIR = os.path.join(FOOTAGE, "track")
DIGEST = "research/U112_VIDEO_MOTION.md"
PAIR_WORLD = "Tools/footage/pair_world.py"
CLEANEST = "-vPZqptk8jo"
L_SH, R_SH, L_HIP, R_HIP, L_ANK, R_ANK = 11, 12, 23, 24, 27, 28

fails: list[str] = []


def fail(msg: str) -> None:
    fails.append(msg)
    print("FAIL " + msg)


def hipmid(pose: np.ndarray) -> np.ndarray:
    return (pose[L_HIP, :2] + pose[R_HIP, :2]) / 2.0


def shmid(pose: np.ndarray) -> np.ndarray:
    return (pose[L_SH, :2] + pose[R_SH, :2]) / 2.0


def torso_px(pose: np.ndarray) -> float:
    return float(np.linalg.norm(shmid(pose) - hipmid(pose)))


def torso_world(world_pose: np.ndarray) -> float:
    sh = (world_pose[L_SH] + world_pose[R_SH]) / 2.0
    hp = (world_pose[L_HIP] + world_pose[R_HIP]) / 2.0
    return float(np.linalg.norm(sh - hp))


def inventory_row(path: str) -> dict:
    d = np.load(path)
    two_mask = d["n"] == 2
    two = int(two_mask.sum())
    fps = float(d["fps"])
    vis = float(d["img"][two_mask, :, :, 3].mean()) if two else 0.0
    return {
        "frames": len(d["t"]),
        "two_person": two,
        "seconds": two / fps if fps > 0 else 0.0,
        "mean_visibility": vis,
        "fps": fps,
    }


def classify_standing_ground(path: str) -> tuple[str, str]:
    d = np.load(path)
    two = d["n"] == 2
    if not two.any():
        return "no", "no"
    vis = float(d["img"][two, :, :, 3].mean())
    idx = np.where(two)[0][:: max(1, int(two.sum()) // 300)]
    stand: list[float] = []
    ground_n = 0
    total = 0
    for i in idx:
        for p in range(2):
            pose = d["img"][i, p]
            if pose[L_ANK, 3] <= 0.5 or pose[L_HIP, 3] <= 0.5:
                continue
            sh = (pose[L_SH, :2] + pose[R_SH, :2]) / 2
            hp = (pose[L_HIP, :2] + pose[R_HIP, :2]) / 2
            t_len = max(float(np.linalg.norm(sh - hp)), 1.0)
            h = ((pose[L_ANK, 1] + pose[R_ANK, 1]) / 2 - (pose[L_HIP, 1] + pose[R_HIP, 1]) / 2) / t_len
            stand.append(h)
            total += 1
            if h < 1.2:
                ground_n += 1
    ank_both = (
        ((d["img"][idx, :, L_ANK, 3] > 0.5) & (d["img"][idx, :, R_ANK, 3] > 0.5)).all(axis=1).mean()
        if len(idx)
        else 0.0
    )
    hip_h_p50 = float(np.percentile(stand, 50)) if stand else 0.0
    ground_frac = ground_n / max(1, total)
    standing = (
        "yes"
        if vis >= 0.75 and ank_both >= 0.5 and hip_h_p50 >= 1.2 and ground_frac < 0.25
        else ("marginal" if vis >= 0.65 and hip_h_p50 >= 1.0 and ground_frac < 0.35 else "no")
    )
    ground = "yes" if ground_frac >= 0.25 and vis >= 0.65 else "no"
    return standing, ground


def recompute_sep_from_raw(path: str, sample: int = 400) -> np.ndarray:
    """Independent hip-separation estimate from raw img+world (same physics as pair_world)."""
    d = np.load(path)
    two_idx = np.where(d["n"] == 2)[0]
    if len(two_idx) == 0:
        return np.array([])
    step = max(1, len(two_idx) // sample)
    two_idx = two_idx[::step]
    seps = []
    for i in two_idx:
        img = d["img"][i]
        world = d["world"][i]
        scales = []
        hips_i = []
        for p in range(2):
            tw = torso_world(world[p])
            tp = max(torso_px(img[p]), 1.0)
            scales.append(tw / tp)
            hips_i.append(hipmid(img[p]))
        scale = (scales[0] + scales[1]) / 2.0
        seps.append(float(np.linalg.norm(hips_i[1] - hips_i[0]) * scale))
    return np.array(seps, dtype=np.float64)


# --- deliverables exist -------------------------------------------------------------------------------------------
for path in [PAIR_WORLD, DIGEST, "research/U112_check.py"]:
    if not os.path.exists(path):
        fail("%s is missing" % path)

if fails:
    print("U112_CHECK FAIL (%d)" % len(fails))
    sys.exit(1)

digest_lines = open(DIGEST, encoding="utf-8").read().splitlines()
if len(digest_lines) > 120:
    fail("digest has %d lines - 120 at most" % len(digest_lines))

for head in ("# U112", "## METHOD", "## ERROR", "## INVENTORY", "## STANDING VS GROUND"):
    if head not in open(DIGEST, encoding="utf-8").read():
        fail("digest missing section '%s'" % head)

# --- inventory recomputed from .npz -------------------------------------------------------------------------------
if not os.path.isdir(TRACK_DIR):
    fail("no track dir at %s" % TRACK_DIR)
else:
    npz_files = sorted(f for f in os.listdir(TRACK_DIR) if f.endswith(".npz"))
    if not npz_files:
        fail("track dir is empty")
    total_two = 0
    for name in npz_files:
        row = inventory_row(os.path.join(TRACK_DIR, name))
        total_two += row["two_person"]
        vid = name.replace(".npz", "")
        if vid == CLEANEST:
            if row["mean_visibility"] < 0.85:
                fail("%s mean visibility %.3f is below the 0.85 cleanest threshold" % (vid, row["mean_visibility"]))
    total_min = total_two / 42.9 / 60.0  # ~42.9 effective fps across the corpus ≈ 38.1 min
    if total_two < 90000:
        fail("inventory two-person frames %d is below 90000" % total_two)
    print("U112_CHECK inventory: %d files, %d two-person frames (~%.1f min)" % (len(npz_files), total_two, total_min))

# --- pair_world produces non-degenerate output --------------------------------------------------------------------
clean_npz = os.path.join(TRACK_DIR, CLEANEST + ".npz")
if not os.path.exists(clean_npz):
    fail("cleanest npz %s missing" % clean_npz)
else:
    with tempfile.NamedTemporaryFile(suffix=".npz", delete=False) as tmp:
        out_path = tmp.name
    cmd = [sys.executable, PAIR_WORLD, clean_npz, out_path, "2.0", "12.0"]
    proc = subprocess.run(cmd, capture_output=True, text=True)
    if proc.returncode != 0:
        fail("pair_world exited %d: %s" % (proc.returncode, proc.stderr.strip() or proc.stdout.strip()))
    loaded = np.load(out_path)
    fmt = str(loaded["format"])
    n_fighters = loaded["n_fighters"]
    hip_sep_m = loaded["hip_sep_m"]
    joints = loaded["joints"]
    loaded.close()
    try:
        os.unlink(out_path)
    except OSError:
        pass
    if fmt != "PAIR_WORLD_v1":
        fail("output format is %s, expected PAIR_WORLD_v1" % fmt)
    mask = n_fighters == 2
    if mask.sum() < 10:
        fail("pair_world produced fewer than 10 two-fighter frames")
    sep = hip_sep_m[mask].astype(np.float64)
    sep = sep[np.isfinite(sep)]
    if len(sep) < 10:
        fail("hip_sep_m has no finite samples")
    mean_sep = float(np.mean(sep))
    std_sep = float(np.std(sep))
    cv = std_sep / max(mean_sep, 1e-6)
    if mean_sep < 0.5:
        fail("mean hip separation %.2f m < 0.5 m - fighters collapsed together" % mean_sep)
    if float(np.min(sep)) < 0.25:
        fail("min hip separation %.2f m < 0.25 m - poses overlap" % float(np.min(sep)))
    if cv < 0.008:
        fail("hip_sep coefficient of variation %.4f < 0.008 - distance is constant (degenerate)" % cv)
    j = joints[mask]
    same = np.linalg.norm(j[:, 1, L_HIP] - j[:, 0, L_HIP], axis=1)
    if float(np.mean(same)) < 0.5:
        fail("mean hip joint distance %.2f m < 0.5 m in joints array" % float(np.mean(same)))
    raw_sep = recompute_sep_from_raw(clean_npz)
    if len(raw_sep) >= 10:
        # gate p50 agreement between independent estimate and pair_world output, not an extremum
        p50_out = float(np.percentile(sep, 50))
        p50_raw = float(np.percentile(raw_sep, 50))
        if abs(p50_out - p50_raw) > 0.25:
            fail("hip_sep p50 %.2f m disagrees with raw recomputation %.2f m by >0.25 m" % (p50_out, p50_raw))
    print(
        "U112_CHECK pair_world: %d frames, hip_sep p50=%.2f m, cv=%.3f"
        % (int(mask.sum()), float(np.percentile(sep, 50)), cv)
    )

# --- digest names the three cleanest ------------------------------------------------------------------------------
text = open(DIGEST, encoding="utf-8").read()
for vid in ("-vPZqptk8jo", "HL261oRyURE", "FCM7m6TJWUQ"):
    if vid not in text:
        fail("digest does not name cleanest video %s" % vid)

# --- standing/ground row for cleanest must be standing ------------------------------------------------------------
if os.path.exists(clean_npz):
    st, gr = classify_standing_ground(clean_npz)
    if st not in ("yes", "marginal"):
        fail("%s classified standing=%s - the cleanest clip must be standing-usable" % (CLEANEST, st))

if fails:
    print("U112_CHECK FAIL (%d)" % len(fails))
    sys.exit(1)
print("U112_CHECK PASS")
sys.exit(0)

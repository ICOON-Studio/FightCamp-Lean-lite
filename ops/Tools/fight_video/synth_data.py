"""Our own synthetic punch clips (tools/fight_video_synth.gd) as data for the analyzer.  (Claude, S495)

usage: python synth_data.py pose <synth_dir> <work_dir>      the pose pass over every clip (GPU, one clip at a time)
       python synth_data.py counts <synth_dir>               the first counts: clips, minutes, punches per type / result / camera

A clip is <synth_dir>/clip_NNNN.mp4 + clip_NNNN.json (exact labels); manifest.json lists them with their split.
  label_rows(L)   the clip's punches in the shape evaluate_olympic.match reads (start, end, centre, diag, hand, target,
                  result) + type, lead, boxer. The box is drawn the way the Olympic referees' labels are: six frames
                  round the contact, centred on the glove, a diagonal of 1.5 trunk lengths (theirs: 1.3 - 2.0).
  gt_boxers(L)    the two boxers from the EXACT joints, in the shape track.py saves: what the analyzer would see with
                  a perfect pose model and a perfect picker (the ceiling; also the cheapest training data).
  boxer_of(...)   which labelled boxer (0 / 1) the analyzer's boxer A or B is at a frame, by where the hips are."""
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

TYPES = ["jab", "cross", "lead hook", "rear hook", "lead uppercut", "rear uppercut"]
FAMILY = {"jab": "straight", "cross": "straight", "lead hook": "hook", "rear hook": "hook", "lead uppercut": "uppercut", "rear uppercut": "uppercut"}
LABEL_HALF = (2, 3)   # frames before / after the contact a label covers
DIAG_T = 1.5


def manifest(synth_dir, split=None):
    rows = json.load(open(os.path.join(synth_dir, "manifest.json"), encoding="utf-8"))["clips"]
    return [r for r in rows if split is None or r["split"] == split]


def load_labels(synth_dir, clip):
    return json.load(open(os.path.join(synth_dir, clip + ".json"), encoding="utf-8"))


def _trunk(J):
    return float(np.linalg.norm((J[5] + J[6]) / 2 - (J[11] + J[12]) / 2))


def label_rows(L, only_shown=True):
    J = np.asarray(L["joints"], np.float32)[..., :2]
    G = np.asarray(L["gloves"], np.float32)
    out = []
    for p in L["punches"]:
        if only_shown and not p["shown"]:
            continue
        c = min(max(int(p["contact"]), 0), L["frames"] - 1)
        g = G[c, p["boxer"], 0 if p["hand"] == "left" else 1]
        out.append(dict(start=max(0, c - LABEL_HALF[0]), end=min(L["frames"] - 1, c + LABEL_HALF[1]), contact=c,
                        centre=[float(g[0]), float(g[1])], diag=DIAG_T * _trunk(J[c, p["boxer"]]), hand=p["hand"],
                        target=p["target"], result=p["result"], type=p["type"], lead=p["lead"], boxer=p["boxer"],
                        graze=bool(p.get("graze", False)), onset=int(p["start"]), back=int(p["end"])))
    return sorted(out, key=lambda g: g["start"])


def gt_boxers(L):
    J = np.asarray(L["joints"], np.float32)                       # (F,2,17,3) x, y, v
    F = len(J)
    kpt = J.copy()
    kpt[..., 2] = (J[..., 2] > 0).astype(np.float32)
    cut = np.zeros(F, bool)
    cut[[c for c in L["camera"]["cuts"] if 0 <= c < F]] = True
    fr = np.arange(F, dtype=np.int32)
    return dict(kpt=kpt, seen=np.ones((F, 2), bool), src=np.zeros((F, 2), np.int16), colour=np.array([b["kit"]["name"] for b in L["boxers"]]),
                cut=cut, seg=np.cumsum(cut).astype(np.int32), bout=np.zeros(F, np.int32), frame=fr, t=fr / float(L["fps"]),
                fps=float(L["fps"]), size=np.array(L["size"]))


def boxer_of(L, bodies, slot, index):
    """0 or 1: the labelled boxer whose hips are nearer the analyzer's boxer `slot` at frame `index` (-1 = unknown)."""
    h = bodies[slot].hipm[index]
    if np.isnan(h).any():
        return -1
    J = np.asarray(L["joints"][index], np.float32)[..., :2]
    d = [np.linalg.norm((J[b, 11] + J[b, 12]) / 2 - h) for b in (0, 1)]
    return int(np.argmin(d))


def pose_pass(synth_dir, work_dir, log=print):
    import analyze
    import pose
    os.makedirs(work_dir, exist_ok=True)
    rows = manifest(synth_dir)
    todo = [r for r in rows if not os.path.exists(os.path.join(work_dir, r["clip"] + ".npz"))]
    log("synth pose pass: %d clips to do, %d already done" % (len(todo), len(rows) - len(todo)))
    for i, r in enumerate(todo):
        if i % 10 == 0:
            waited = 0
            while analyze.pc_is_red():   # a RED PC is waited out a minute at a time, never worked on
                waited += 1
                if waited > 30:
                    sys.exit("the PC watchdog stayed RED for 30 minutes: stopped before %s (run again to carry on)" % r["clip"])
                __import__("time").sleep(60)
        tmp = os.path.join(work_dir, r["clip"] + ".tmp.npz")
        pose.run(os.path.join(synth_dir, r["clip"] + ".mp4"), tmp, log=lambda *a: None)
        os.replace(tmp, os.path.join(work_dir, r["clip"] + ".npz"))
        if i % 10 == 9:
            log("  %d of %d clips" % (i + 1, len(todo)))
    log("synth pose pass: done")


def counts(synth_dir):
    rows = manifest(synth_dir)
    add = lambda d, k, n=1: d.__setitem__(k, d.get(k, 0) + n)
    out = dict(clips=len(rows), minutes=round(sum(r["frames"] / r["fps"] for r in rows) / 60.0, 1), frames=sum(r["frames"] for r in rows),
               punches=0, not_shown=sum(r["not_shown"] for r in rows), grazes=sum(r["grazes"] for r in rows),
               by_split={}, by_type={}, by_result={}, by_target={}, by_camera={}, by_room={}, by_sex={}, by_hand={}, southpaw_boxers=0, bodies=set())
    for r in rows:
        out["punches"] += r["punches"]
        add(out["by_split"], r["split"] + " clips")
        add(out["by_split"], r["split"] + " punches", r["punches"])
        add(out["by_camera"], r["camera"] + " clips")
        add(out["by_camera"], r["camera"] + " punches", r["punches"])
        add(out["by_room"], r["room"])
        add(out["by_sex"], r["sex"])
        out["southpaw_boxers"] += sum(s == "southpaw" for s in r["stance"])
        out["bodies"] |= set(r["bodies"])
        for key in ("by_type", "by_result", "by_target"):
            for k, v in r[key].items():
                add(out[key], k, v)
        for p in load_labels(synth_dir, r["clip"])["punches"]:
            if p["shown"]:
                add(out["by_hand"], p["hand"])
    out["bodies"] = len(out["bodies"])
    return out


if __name__ == "__main__":
    a = sys.argv
    if len(a) >= 4 and a[1] == "pose":
        pose_pass(a[2], a[3])
    elif len(a) >= 3 and a[1] == "counts":
        print(json.dumps(counts(a[2]), indent=1))
    else:
        print(__doc__)

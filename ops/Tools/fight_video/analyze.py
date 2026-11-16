"""Analyze a boxing video: a strike log per boxer with totals.  (Claude, S495; research tool, not part of the game)

usage: python analyze.py <video> --out <dir> [--start S] [--end S] [--stride N] [--fighters 1|2] [--stills N]
                         [--models DIR] [--no-models] [--cpu] [--force]

  <dir>/strikes.txt    the readable log: time, boxer, hand, punch, target, result, then totals per boxer
  <dir>/strikes.json   the same as data (one record per punch + totals + how sure each call is)
  <dir>/stills_*.jpg   with --stills N: picture strips of N punches spread over the video, to check by eye
  <dir>/pose.npz, boxers.npz   the cached pose pass (delete them to redo it)

Stages: pose.py (every person's skeleton, on the graphics card when the venv's onnxruntime-directml is the Python
running this) -> track.py (which two are the boxers) -> punches.py (rules) -> classify.py (trained filter, result and
type models when their files exist). HOW GOOD IT IS and where it fails: ops/research/FIGHT_VIDEO_ANALYZER_S495.md.
Run it with E:/FightCamp/fight_video_data/venv/Scripts/python for the GPU and the trained models; plain python
works on the CPU with the rules only (slower, more false punches).
PC rules: the watchdog is asked first and a RED PC is not started on (--force overrides); nothing opens a window."""
import json
import os
import subprocess
import sys
import time

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import classify  # noqa: E402
import pose  # noqa: E402
import punches  # noqa: E402
import stills  # noqa: E402
import track  # noqa: E402


def pc_is_red():
    script = os.path.normpath(os.path.join(HERE, "..", "pc_watchdog.ps1"))
    if os.name != "nt" or not os.path.exists(script):
        return False
    try:
        r = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", script, "-Once"],
                           capture_output=True, text=True, timeout=120, creationflags=0x08000000)  # no console window
        line = (r.stdout.strip().splitlines() or [""])[-1]
        print("watchdog: " + line[:150])
        return r.returncode == 1
    except Exception as e:
        print("watchdog not asked (%s)" % type(e).__name__)
        return False


def totals(events, info):
    out = {}
    minutes = max(info["duration"], 1e-6) / 60.0
    for b in "AB":
        mine = [e for e in events if e["boxer"] == b]
        if not mine and b == "B":
            continue
        landed = [e for e in mine if e["result"] == "landed"]
        t = dict(thrown=len(mine), landed=len(landed), blocked=sum(e["result"] == "blocked" for e in mine),
                 missed=sum(e["result"] == "missed" for e in mine),
                 accuracy=round(len(landed) / max(1, len(mine)), 3), per_minute=round(len(mine) / minutes, 1),
                 head_landed=sum(e["target"] == "head" for e in landed), body_landed=sum(e["target"] == "body" for e in landed),
                 by_type={}, by_hand={}, combos={})
        for e in mine:
            for key, val in (("by_type", e["type"]), ("by_hand", e["lead"] if e["lead"] != "?" else e["hand"])):
                d = t[key].setdefault(val, dict(thrown=0, landed=0))
                d["thrown"] += 1
                d["landed"] += e["result"] == "landed"
        by_combo = {}
        for e in mine:
            by_combo.setdefault(e["combo"], []).append(e["type"])
        for seq in by_combo.values():
            if len(seq) > 1:
                k = " - ".join(seq)
                t["combos"][k] = t["combos"].get(k, 0) + 1
        t["longest_combo"] = max([len(s) for s in by_combo.values()] or [0])
        # hit right after throwing: the opponent lands within 0.6 s of this boxer's punch
        t["countered_after"] = {}
        for e in mine:
            if any(o["boxer"] != b and o["result"] == "landed" and 0 < o["t"] - e["t"] <= 0.6 for o in events):
                t["countered_after"][e["type"]] = t["countered_after"].get(e["type"], 0) + 1
        out[b] = t
    return out


def write_text(path, video, events, info, tot, models, notes):
    L = []
    L.append("STRIKE LOG - %s" % os.path.basename(video))
    L.append("%.1f s analyzed at %.0f frames a second. Boxer A = %s kit (%s), boxer B = %s kit (%s)." % (
        info["duration"], info["fps"], info["colour"][0], info["stance"][0] or "stance unknown", info["colour"][1], info["stance"][1] or "stance unknown"))
    L.append("Seen by the pose model: A %.0f%% of the time, B %.0f%%, both %.0f%%. Punches thrown while a boxer is hidden are NOT in this log." % (
        100 * info["seen"][0], 100 * info["seen"][1], 100 * info["both_seen"]))
    L.append("Calls made by: %s." % ("the trained models (" + ", ".join(sorted(models)) + ") on top of the rules" if models else "the hand-written rules only (no trained models found)"))
    for n in notes:
        L.append(n)
    L.append("")
    L.append("  time    boxer  hand   punch            target  result    sure   combo")
    for e in events:
        L.append("%7.2f   %s     %-5s  %-15s  %-6s  %-8s  %4s   %s" % (
            e["t"], e["boxer"], e["hand"], e["type"], e["target"], e["result"],
            ("%.0f%%" % (100 * e["confidence"])) if "confidence" in e else "-", "#%d" % e["combo"]))
    L.append("")
    for b, t in tot.items():
        L.append("BOXER %s (%s kit): %d thrown, %d landed (%.0f%%), %d blocked, %d missed; %.1f punches a minute; landed to head %d, to body %d" % (
            b, info["colour"]["AB".index(b)], t["thrown"], t["landed"], 100 * t["accuracy"], t["blocked"], t["missed"], t["per_minute"], t["head_landed"], t["body_landed"]))
        L.append("   by punch: " + ", ".join("%s %d/%d" % (k, v["landed"], v["thrown"]) for k, v in sorted(t["by_type"].items(), key=lambda kv: -kv[1]["thrown"])) + "   (landed/thrown)")
        L.append("   by hand:  " + ", ".join("%s %d/%d" % (k, v["landed"], v["thrown"]) for k, v in sorted(t["by_hand"].items())))
        if t["combos"]:
            L.append("   combinations: " + "; ".join("%s x%d" % (k, v) for k, v in sorted(t["combos"].items(), key=lambda kv: -kv[1])[:6]))
        if t["countered_after"]:
            L.append("   hit within 0.6 s of throwing: " + ", ".join("%s x%d" % (k, v) for k, v in sorted(t["countered_after"].items(), key=lambda kv: -kv[1])))
    open(path, "w", encoding="utf-8").write("\n".join(L) + "\n")
    return L


def main():
    a = sys.argv
    if len(a) < 2 or "--help" in a or "-h" in a:
        print(__doc__)
        return
    opt = lambda k, d: type(d)(a[a.index(k) + 1]) if k in a else d
    video, out = a[1], opt("--out", "fight_video_out")
    os.makedirs(out, exist_ok=True)
    pose_npz, box_npz = os.path.join(out, "pose.npz"), os.path.join(out, "boxers.npz")
    began = time.time()
    if not os.path.exists(pose_npz):
        if "--force" not in a and pc_is_red():
            sys.exit("the PC watchdog reads RED: not starting the pose pass (close something, or --force)")
        pose.run(video, pose_npz, opt("--start", 0.0), opt("--end", 1e9), opt("--stride", 1), "--cpu" not in a)
    else:
        print("pose: using the cached %s" % pose_npz)
    track.run(pose_npz, box_npz, opt("--fighters", 0) or None)
    boxers = np.load(box_npz)
    models = {} if "--no-models" in a else classify.load_models(opt("--models", "") or None)
    events, info, bodies = punches.detect(boxers, classify.LOOSE if "punch_filter" in models else None)
    events = classify.apply(events, bodies, models)
    punches.number_combos(events)
    tot = totals(events, info)
    notes = []
    if info["both_seen"] < 0.5 and boxers["seen"][:, 1].any():
        notes.append("WARNING: both boxers were seen together on under half of the frames - many punches will be missing.")
    lines = write_text(os.path.join(out, "strikes.txt"), video, events, info, tot, models, notes)
    record = lambda e: {k: e[k] for k in ("t", "frame", "boxer", "hand", "lead", "type", "family", "target", "result", "combo",
                                         "confidence", "result_confidence", "type_confidence", "model_type", "rule_type", "rule_result", "rule_target") if k in e} | {
        "glove_xy": [round(v, 1) for v in e["m"]["glove"]], "onset_t": round(float(boxers["t"][e["m"]["onset"]]), 3)}
    json.dump(dict(video=os.path.abspath(video), info=info, models=sorted(models), totals=tot, strikes=[record(e) for e in events],
                   limits="See ops/research/FIGHT_VIDEO_ANALYZER_S495.md for measured accuracy. Punch type and landed/blocked/missed are the weakest calls."),
              open(os.path.join(out, "strikes.json"), "w", encoding="utf-8"), indent=1)
    n_stills = opt("--stills", 0)
    if n_stills and events:
        pick = events[::max(1, len(events) // n_stills)][:n_stills]
        files = stills.sheet(video, boxers, pick, os.path.join(out, "stills_1.jpg").replace("_1.jpg", ".jpg"))
        print("stills: " + ", ".join(files))
    print("\n".join(lines[-(3 + 5 * len(tot)):]))
    print("done in %.0f s -> %s" % (time.time() - began, os.path.join(out, "strikes.txt")))


if __name__ == "__main__":
    main()

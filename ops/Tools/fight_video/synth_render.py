"""Render the synthetic part of our own labelled punch set from the game's 3D ring.  (Claude, S495)
usage: python synth_render.py <out_dir> [--runs 32] [--clips 4] [--secs 13] [--seed 1] [--from-run 0] [--fps 50]

Each RUN is one Godot process (tools/fight_video_synth.gd) on the never-shown desktop: one pair of MetaHuman bodies,
`--clips` clips, each with its own camera, light, room, canvas, kits and exchanges. Runs are queued through
ops/Tools/godot_slot.py (one render at a time; a RED PC is waited out, never started on).
After each run the frames of every clip are packed into <out_dir>/clip_NNNN.mp4 and deleted; the labels are moved to
<out_dir>/clip_NNNN.json. <out_dir>/manifest.json lists every clip with its split, bodies, camera and punch counts.

SPLIT BY BODY: a test clip never shows a body that a training clip shows (TEST_M, TEST_F below).
Women box women and men box men (the game's rule). Everything rendered is ours: put <out_dir> OUTSIDE the repository.
Needs opencv (the venv's Python) or ffmpeg on the PATH for the packing."""
import glob
import json
import os
import random
import shutil
import subprocess
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.normpath(os.path.join(HERE, "..", "..", ".."))
GODOT = os.path.join(os.environ.get("LOCALAPPDATA", ""), "Programs", "Godot", "Godot_v4.7.2-stable_win64.exe")
MEN = ["mh_boxer_01", "mh_boxer_02", "mh_boxer_03", "mh_boxer_07", "mh_boxer_08"]
WOMEN = ["mh_boxer_%02d" % i for i in range(10, 24)]
TEST_M = ["mh_boxer_03", "mh_boxer_08"]
TEST_F = ["mh_boxer_12", "mh_boxer_16", "mh_boxer_17", "mh_boxer_21"]
TEST_EVERY = 5      # every fifth run is a test run (test bodies only)
MEN_EVERY = 3       # every third run is a men's pair
SOUTHPAW = 0.2


def plan_run(r, seed):
    rng = random.Random(seed * 100003 + r)
    test = r % TEST_EVERY == TEST_EVERY - 1
    men = r % MEN_EVERY == MEN_EVERY - 1
    pool = [b for b in (MEN if men else WOMEN) if (b in TEST_M + TEST_F) == test]
    pair = rng.sample(pool, 2)
    stance = "".join("s" if rng.random() < SOUTHPAW else "o" for _ in range(2))
    scale = ",".join("%.3f" % rng.uniform(0.96, 1.04) for _ in range(2))
    return dict(run=r, split="test" if test else "train", sex="M" if men else "F", pair=pair, stance=stance, scale=scale)


def watchdog_red():
    script = os.path.join(REPO, "ops", "Tools", "pc_watchdog.ps1")
    r = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", script, "-Once"],
                       capture_output=True, text=True, timeout=180, creationflags=0x08000000)
    line = (r.stdout.strip().splitlines() or [""])[0]
    print("watchdog: " + line[:160], flush=True)
    return r.returncode == 1


def pack(clip_dir, fps):
    """frames + labels.json in clip_dir -> clip.mp4 + clip.json beside it; the frames are deleted."""
    out = clip_dir + ".mp4"
    frames = sorted(glob.glob(os.path.join(clip_dir, "*.jpg")))
    if not frames:
        return False
    ok = False
    if shutil.which("ffmpeg"):
        r = subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-framerate", str(fps), "-i", os.path.join(clip_dir, "%06d.jpg"),
                            "-vf", "crop=trunc(iw/2)*2:trunc(ih/2)*2", "-c:v", "libx264", "-crf", "20", "-pix_fmt", "yuv420p", out],
                           capture_output=True, text=True, creationflags=0x08000000)
        ok = r.returncode == 0 and os.path.exists(out)
        if not ok:
            print("ffmpeg failed: " + r.stderr[-300:])
    if not ok:
        import cv2
        first = cv2.imread(frames[0])
        h, w = first.shape[:2]
        vw = cv2.VideoWriter(out, cv2.VideoWriter_fourcc(*"mp4v"), fps, (w, h))
        for f in frames:
            vw.write(cv2.imread(f))
        vw.release()
        ok = os.path.exists(out)
    if ok:
        shutil.move(os.path.join(clip_dir, "labels.json"), clip_dir + ".json")
        remove_dir(clip_dir)
    return ok


def remove_dir(path):
    """Delete a clip's frame folder; a frame another program still holds (a virus scan) is retried, never fatal."""
    for attempt in range(6):
        shutil.rmtree(path, ignore_errors=True)
        if not os.path.exists(path):
            return
        time.sleep(2)
    print("could not delete %s (still in use): delete it by hand" % path)


def summarise(label_path, plan):
    L = json.load(open(label_path, encoding="utf-8"))
    shown = [p for p in L["punches"] if p["shown"]]
    by = lambda key: {k: sum(1 for p in shown if p[key] == k) for k in sorted(set(p[key] for p in shown))}
    return dict(clip=L["clip"], run=plan["run"], split=plan["split"], sex=plan["sex"], bodies=[b["glb"] for b in L["boxers"]],
                stance=[b["stance"] for b in L["boxers"]], camera=L["plan"]["camera"]["mode"], room=L["plan"]["room"],
                frames=L["frames"], fps=L["fps"], size=L["size"], punches=len(shown), not_shown=len(L["punches"]) - len(shown),
                by_type=by("type"), by_result=by("result"), by_target=by("target"), grazes=sum(1 for p in shown if p.get("graze")))


def main():
    a = sys.argv
    if len(a) < 2 or "--help" in a:
        print(__doc__)
        return
    opt = lambda k, d: type(d)(a[a.index(k) + 1]) if k in a else d
    out = os.path.abspath(a[1])
    runs, clips, secs, seed, start, fps = opt("--runs", 32), opt("--clips", 4), opt("--secs", 13.0), opt("--seed", 1), opt("--from-run", 0), opt("--fps", 50)
    os.makedirs(out, exist_ok=True)
    man_path = os.path.join(out, "manifest.json")
    manifest = json.load(open(man_path, encoding="utf-8")) if os.path.exists(man_path) else dict(clips=[])
    # a clip that is on disk but not in the manifest (a batch that stopped between packing and listing) is listed first
    listed = set(c["clip"] for c in manifest["clips"])
    for r in range(start, start + runs):
        for k in range(r * clips, (r + 1) * clips):
            name = "clip_%04d" % k
            if name not in listed and os.path.exists(os.path.join(out, name + ".mp4")) and os.path.exists(os.path.join(out, name + ".json")):
                manifest["clips"].append(summarise(os.path.join(out, name + ".json"), plan_run(r, seed)))
            leftover = os.path.join(out, name)
            if os.path.isdir(leftover) and os.path.exists(os.path.join(out, name + ".mp4")):
                remove_dir(leftover)
    manifest["clips"].sort(key=lambda c: c["clip"])
    for r in range(start, start + runs):
        plan = plan_run(r, seed)
        first = r * clips
        missing = [k for k in range(clips) if not os.path.exists(os.path.join(out, "clip_%04d.mp4" % (first + k)))]
        if not missing:
            print("run %d: already rendered" % r)
            continue
        # the whole run in one process, or (a run with some clips deleted for a re-render) each missing clip on its own
        jobs = [(first, clips)] if len(missing) == clips else [(first + k, 1) for k in missing]
        for job_first, job_n in jobs:
            waited = 0
            while watchdog_red():
                waited += 1
                if waited > 30:
                    sys.exit("the PC watchdog stayed RED for 30 minutes: stopped before run %d" % r)
                time.sleep(60)
            log = os.path.join(out, "run_%03d.log" % r)
            cmd = [sys.executable, os.path.join(REPO, "ops", "Tools", "godot_slot.py"), "run", "--who", "fightvideo", "--",
                   sys.executable, os.path.join(REPO, "tools", "hidden_desktop.py"), "run", "--timeout=%d" % int(120 + job_n * (secs * 4 + 30)), "--log=" + log,
                   GODOT, "--path", ".", "--windowed", "--resolution", "1280x720", "--fixed-fps", str(fps), "--audio-driver", "Dummy",
                   "--script", "res://tools/fight_video_synth.gd", "--", out.replace("\\", "/"),
                   "pair=" + ",".join(plan["pair"]), "clips=%d" % job_n, "secs=%g" % secs, "seed=%d" % seed, "first=%d" % job_first,
                   "stance=" + plan["stance"], "scale=" + plan["scale"], "fps=%d" % fps]
            began = time.time()
            rc = subprocess.run(cmd, cwd=REPO, creationflags=0x08000000).returncode
            text = open(log, encoding="utf-8", errors="replace").read() if os.path.exists(log) else ""
            errors = [l for l in text.splitlines() if "SCRIPT ERROR" in l or "FVSYNTH:" in l]
            print("run %d clips %d-%d (%s, %s %s): exit %d in %.0f s%s" % (r, job_first, job_first + job_n - 1, plan["split"], plan["sex"], "+".join(plan["pair"]), rc,
                                                                    time.time() - began, (" | " + errors[0][:150]) if errors else ""), flush=True)
            for k in range(job_first, job_first + job_n):
                d = os.path.join(out, "clip_%04d" % k)
                if os.path.isdir(d) and os.path.exists(os.path.join(d, "labels.json")) and pack(d, fps):
                    manifest["clips"] = [c for c in manifest["clips"] if c["clip"] != "clip_%04d" % k] + [summarise(d + ".json", plan)]
                elif os.path.isdir(d):
                    remove_dir(d)  # a clip the run did not finish
            manifest["clips"].sort(key=lambda c: c["clip"])
            manifest["made_by"] = "ops/Tools/fight_video/synth_render.py + tools/fight_video_synth.gd (FightCamp Lean, ICOON Studio); every pixel and label ours"
            json.dump(manifest, open(man_path, "w", encoding="utf-8"), indent=1)
    total = sum(c["punches"] for c in manifest["clips"])
    print("done: %d clips, %d punches, %.1f minutes of video in %s" % (len(manifest["clips"]), total, sum(c["frames"] / c["fps"] for c in manifest["clips"]) / 60.0, out))


if __name__ == "__main__":
    main()

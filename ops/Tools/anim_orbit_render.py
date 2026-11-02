"""anim_orbit_render.py - fill the ops board /animations page with MetaHuman orbit previews (S270).

Operator S270: "i want them to do the animation a drone camera rotates around them so i can see them from all angles doing the
move"; "dont render the whole room"; "i dont need the ring to see the animation". Each row of the page (Tools/anim_catalogue.py)
that has a clip is rendered by Godot/tools/anim_orbit_render.gd - the game's MetaHuman boxer alone on a grey grid floor, the
game's own clip library (FightStagePlayer.bind), a camera circling once - and encoded to previews/anim/<id>.mp4,
which the page plays.

    python Tools/anim_orbit_render.py                 # every row with a clip (watchdog first; windowed Godot, hidden desktop)
    python Tools/anim_orbit_render.py boxing_jab idle # only these ids
    python Tools/anim_orbit_render.py --encode-only   # re-encode frames already rendered
"""
from __future__ import annotations

import json
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GODOT = ROOT / "Godot"
ANIM = GODOT / "docs" / "previews" / "anim"
FRAMES = Path("E:/FightCamp/tmp/anim_orbit")
## page row id -> the FightStagePlayer role that plays it (the stance row is the game's idle)
ROLE_FOR = {"guard_idle": "idle"}


def _ffmpeg() -> str:
    import imageio_ffmpeg  # bundled binary (already used by the house tools)
    return imageio_ffmpeg.get_ffmpeg_exe()


def _rows() -> list[str]:
    out = subprocess.run([sys.executable, str(ROOT / "Tools" / "anim_catalogue.py"), "--json"], capture_output=True, text=True,
                         check=True, cwd=ROOT).stdout
    data = json.loads(out)
    ids = []
    for g in data["groups"]:
        if g["group"].startswith("Real fight"):
            continue
        for r in g["rows"]:
            if r["status"] in ("NO CLIP", "MISSING"):
                continue
            ids.append(r["id"])
    return ids


def _watchdog_ok() -> bool:
    rc = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                         str(ROOT / "Tools" / "pc_watchdog.ps1"), "-Once"], cwd=ROOT).returncode
    return rc == 0


def _render(roles: list[str]) -> None:
    cmd = ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", str(ROOT / "Tools" / "godot_hidden.ps1"),
           "--path", "Godot", "--resolution", "960x540", "--script", "tools/anim_orbit_render.gd", "--",
           "as_game", "pose_log=1", "seed=94301", f"out={FRAMES.as_posix()}", "roles=" + ",".join(roles)]
    proc = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True, errors="replace")
    for line in (proc.stdout + proc.stderr).splitlines():
        if line.startswith("ORBIT"):
            print(line)


def _encode(page_id: str, role: str) -> bool:
    src = FRAMES / role
    if not src.is_dir() or not any(src.glob("f*.jpg")):
        print(f"ENCODE SKIP {page_id}: no frames in {src}")
        return False
    ANIM.mkdir(parents=True, exist_ok=True)
    dst = ANIM / f"{page_id}.mp4"
    cmd = [_ffmpeg(), "-y", "-loglevel", "error", "-framerate", "30", "-i", str(src / "f%04d.jpg"),
           "-vf", "scale=960:-2", "-c:v", "libx264", "-preset", "slow", "-crf", "26", "-pix_fmt", "yuv420p",
           "-movflags", "+faststart", str(dst)]
    subprocess.run(cmd, check=True)
    print(f"ENCODE {page_id} -> {dst.relative_to(ROOT).as_posix()} ({dst.stat().st_size // 1024} KB)")
    return True


def main(argv: list[str]) -> int:
    encode_only = "--encode-only" in argv
    ids = [a for a in argv if not a.startswith("--")] or _rows()
    pairs = [(i, ROLE_FOR.get(i, i)) for i in ids]
    if not encode_only:
        if not _watchdog_ok():
            print("ANIM_ORBIT STOP: watchdog RED - nothing started")
            return 1
        for role in {r for _, r in pairs}:
            shutil.rmtree(FRAMES / role, ignore_errors=True)
        _render(sorted({r for _, r in pairs}))
    made = sum(1 for i, r in pairs if _encode(i, r))
    print(f"ANIM_ORBIT made {made}/{len(pairs)} previews")
    return 0 if made == len(pairs) else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

"""lean_anim_render.py - fill the ops board /animations page with orbit previews of the Lean game's clips (S365).

Operator S365: "can you update the boxer animations, to see what we have ingame". Each clip id from
Tools/lean_anim_catalogue.py is rendered by Lean/tools/clip_orbit.gd (the game's boxer alone on a grid floor, a camera
circling once) on the hidden desktop, then encoded to previews/lean_anim/<id>.mp4, which the page plays.
Batches of BATCH ids, the watchdog before each; ids already encoded are skipped (--force redoes them).

    python Tools/lean_anim_render.py                  # every clip on the page
    python Tools/lean_anim_render.py pro_left_jab     # only these ids
    python Tools/lean_anim_render.py --encode-only    # re-encode frames already rendered
"""
from __future__ import annotations

import os
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = Path("E:/FightCamp/Lean")
OUT = ROOT / "previews" / "lean_anim"
FRAMES = Path("E:/FightCamp/tmp/lean_orbit")
GODOT = Path(os.environ.get("LOCALAPPDATA", "")) / "Programs" / "Godot" / "Godot_v4.7.2-stable_win64.exe"
BATCH = 20


def _ffmpeg() -> str:
    import imageio_ffmpeg
    return imageio_ffmpeg.get_ffmpeg_exe()


def _ids() -> list[str]:
    out = subprocess.run([sys.executable, str(ROOT / "Tools" / "lean_anim_catalogue.py"), "--ids"], capture_output=True,
                         text=True, check=True, cwd=ROOT).stdout
    return [l.strip() for l in out.splitlines() if l.strip()]


def _watchdog_ok() -> bool:
    return subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                           str(ROOT / "Tools" / "pc_watchdog.ps1"), "-Once"], cwd=ROOT).returncode == 0


def _render(ids: list[str]) -> None:
    cmd = [sys.executable, str(LEAN / "tools" / "hidden_desktop.py"), "run", "--timeout=1800", str(GODOT), "--path", str(LEAN),
           "--windowed", "--resolution", "960x540", "--audio-driver", "Dummy", "--script", "res://tools/clip_orbit.gd", "--",
           f"out={FRAMES.as_posix()}", "ids=" + ",".join(ids)]
    proc = subprocess.run(cmd, cwd=LEAN, capture_output=True, text=True, errors="replace")
    for line in (proc.stdout + proc.stderr).splitlines():
        if line.startswith("ORBIT") or "ERROR" in line:
            print(line, flush=True)


def _encode(cid: str) -> bool:
    src = FRAMES / cid
    if not src.is_dir() or not any(src.glob("f*.jpg")):
        print(f"ENCODE SKIP {cid}: no frames", flush=True)
        return False
    OUT.mkdir(parents=True, exist_ok=True)
    dst = OUT / f"{cid}.mp4"
    subprocess.run([_ffmpeg(), "-y", "-loglevel", "error", "-framerate", "30", "-i", str(src / "f%04d.jpg"),
                    "-vf", "scale=960:-2", "-c:v", "libx264", "-preset", "slow", "-crf", "27", "-pix_fmt", "yuv420p",
                    "-movflags", "+faststart", str(dst)], check=True)
    shutil.rmtree(src, ignore_errors=True)
    return True


def main(argv: list[str]) -> int:
    force = "--force" in argv
    ids = [a for a in argv if not a.startswith("--")] or _ids()
    if "--encode-only" in argv:
        made = sum(1 for i in ids if _encode(i))
        print(f"LEAN_ANIM encoded {made}/{len(ids)}")
        return 0
    todo = [i for i in ids if force or not (OUT / f"{i}.mp4").is_file()]
    made = 0
    for k in range(0, len(todo), BATCH):
        batch = todo[k:k + BATCH]
        if not _watchdog_ok():
            print(f"LEAN_ANIM STOP: watchdog RED before batch {k // BATCH + 1} - {made} made, rerun to continue", flush=True)
            return 1
        _render(batch)
        made += sum(1 for i in batch if _encode(i))
        print(f"LEAN_ANIM batch {k // BATCH + 1}: {made}/{len(todo)} made", flush=True)
    print(f"LEAN_ANIM DONE {made}/{len(todo)} previews ({len(ids) - len(todo)} already there)")
    return 0 if made == len(todo) else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

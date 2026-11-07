"""lean_grapple_render.py - orbit previews of the belt match's GrappleMap moves for the board's Grappling page (S379).

Operator S379: "make a new one for the grappling animations". Each GrappleMap id from Tools/lean_grapple_catalogue.py is
filmed PURE by Lean/tools/grapple_orbit.gd (our two women, the recorded data and nothing on top, a camera circling once) on
the hidden desktop at 960x540, then encoded to previews/lean_grapple/<id>.mp4 with the numbers it measured beside it
(<id>.json: jerk p95, direction flips a second, worst one-frame pop, how deep a part sits inside the other body).
One windowed render at a time: waits while any Godot --write-movie / --windowed render runs, and the watchdog gates
each batch. Ids already encoded are skipped (--force redoes them). Frames are deleted once encoded (E: is near full).

    python Tools/lean_grapple_render.py              # the catalogue's first batch (20)
    python Tools/lean_grapple_render.py --first 30   # the first 30
    python Tools/lean_grapple_render.py 619 954      # only these ids
    python Tools/lean_grapple_render.py --game 619 1295r 1470l   # S399 GRAPPLEFIX1: AS THE GAME DRAWS IT (grapple_orbit.gd
        game=1: placement, limbs, holds, IK, grips, the match's pacing) into previews/lean_grapple_game/; an id may carry
        r (reversed) and l (a landing); with no ids, the catalogue's moves with their suffixes. Each Godot run goes
        through Tools/godot_slot.py.
"""
from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = Path("E:/FightCamp/Lean")
OUT = ROOT / "previews" / "lean_grapple"
OUT_GAME = ROOT / "previews" / "lean_grapple_game"
FRAMES = Path("E:/FightCamp/tmp/lean_grapple")
GODOT = Path(os.environ.get("LOCALAPPDATA", "")) / "Programs" / "Godot" / "Godot_v4.7.2-stable_win64.exe"
BATCH = 10
WAIT_MAX_S = 1800


def _ffmpeg() -> str:
    import imageio_ffmpeg
    return imageio_ffmpeg.get_ffmpeg_exe()


def _ids(first: int) -> list[str]:
    out = subprocess.run([sys.executable, str(ROOT / "Tools" / "lean_grapple_catalogue.py"), "--ids", str(first)],
                         capture_output=True, text=True, check=True, cwd=ROOT).stdout.strip()
    return [i for i in out.split(",") if i]


def _render_busy() -> str:
    """The command line of a windowed / movie Godot render running now, or ''."""
    ps = "Get-CimInstance Win32_Process | Where-Object { $_.Name -like 'Godot*' } | ForEach-Object { $_.CommandLine }"
    out = subprocess.run(["powershell", "-NoProfile", "-Command", ps], capture_output=True, text=True).stdout
    return next((l for l in out.splitlines() if "--write-movie" in l or "--windowed" in l), "")


def _wait_free() -> bool:
    t0 = time.time()
    while True:
        busy = _render_busy()
        if not busy:
            return True
        if time.time() - t0 > WAIT_MAX_S:
            print(f"LEAN_GRAPPLE STOP: a render still runs after {WAIT_MAX_S} s: {busy[:160]}", flush=True)
            return False
        print(f"LEAN_GRAPPLE waiting for a render to finish: {busy[:120]}", flush=True)
        time.sleep(30)


def _watchdog_ok() -> bool:
    return subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                           str(ROOT / "Tools" / "pc_watchdog.ps1"), "-Once"], cwd=ROOT).returncode == 0


def _render(ids: list[str], game: bool = False) -> dict:
    # hidden_desktop.py relays nothing of the program's own output: Godot's lines come back through --log.
    FRAMES.mkdir(parents=True, exist_ok=True)
    log = FRAMES / "render.log"
    log.unlink(missing_ok=True)
    slot = [sys.executable, str(ROOT / "Tools" / "godot_slot.py"), "run", "--who", "grapple", "--"] if game else []
    cmd = slot + [sys.executable, str(LEAN / "tools" / "hidden_desktop.py"), "run", "--timeout=1800", f"--log={log}", str(GODOT),
           "--path", str(LEAN),
           "--windowed", "--resolution", "960x540", "--audio-driver", "Dummy", "--script", "res://tools/grapple_orbit.gd", "--",
           f"out={FRAMES.as_posix()}", "ids=" + ",".join(ids)] + (["game=1"] if game else [])
    proc = subprocess.run(cmd, cwd=LEAN, capture_output=True, text=True, errors="replace")
    text = proc.stdout + proc.stderr + (log.read_text(encoding="utf-8", errors="replace") if log.is_file() else "")
    rows = {}
    for line in text.splitlines():
        if line.startswith("GORBIT_JSON "):
            row = json.loads(line[len("GORBIT_JSON "):])
            rows[str(row["id"])] = row
            print(f"GORBIT {row['id']} {row['title'][:40]} jerk {row['jerk_p95']} flips {row['flips_s']} "
                  f"pop {row['spike_m']} inside {row['overlap_peak_m']}", flush=True)
        elif line.startswith("GORBIT") or "ERROR" in line or "SCRIPT ERROR" in line:
            print(line, flush=True)
    return rows


def _encode(cid: str, row: dict | None, out: Path = OUT) -> bool:
    src = FRAMES / cid
    if not src.is_dir() or not any(src.glob("f*.jpg")):
        print(f"ENCODE SKIP {cid}: no frames", flush=True)
        return False
    out.mkdir(parents=True, exist_ok=True)
    subprocess.run([_ffmpeg(), "-y", "-loglevel", "error", "-framerate", "30", "-i", str(src / "f%04d.jpg"),
                    "-vf", "scale=960:-2", "-c:v", "libx264", "-preset", "slow", "-crf", "27", "-pix_fmt", "yuv420p",
                    "-movflags", "+faststart", str(out / f"{cid}.mp4")], check=True)
    if row:
        (out / f"{cid}.json").write_text(json.dumps(row, indent=1) + "\n", encoding="utf-8")
    shutil.rmtree(src, ignore_errors=True)
    return True


def main_game(argv: list[str]) -> int:
    toks = [a for a in argv if not a.startswith("--")]
    if not toks:
        sys.path.insert(0, str(ROOT / "Tools"))
        import lean_grapple_fix_table as table  # type: ignore
        toks = [m["tok"] for m in table.moves()]
    made = 0
    for k in range(0, len(toks), BATCH):
        batch = toks[k:k + BATCH]
        rows = _render(batch, game=True)
        for t in batch:
            cid = t.replace("l", "")
            made += 1 if _encode(cid, rows.get(cid), OUT_GAME) else 0
        print(f"LEAN_GRAPPLE game batch {k // BATCH + 1}: {made}/{len(toks)} made", flush=True)
    print(f"LEAN_GRAPPLE GAME DONE {made}/{len(toks)} previews in {OUT_GAME}")
    return 0 if made == len(toks) else 1


def main(argv: list[str]) -> int:
    if "--game" in argv:
        return main_game([a for a in argv if a != "--game"])
    force = "--force" in argv
    first = int(argv[argv.index("--first") + 1]) if "--first" in argv else 20
    ids = [a for a in argv if a.isdigit() and not (("--first" in argv) and a == str(first))] or _ids(first)
    todo = [i for i in ids if force or not (OUT / f"{i}.mp4").is_file()]
    made = 0
    for k in range(0, len(todo), BATCH):
        batch = todo[k:k + BATCH]
        if not _wait_free():
            return 1
        t0 = time.time()
        while not _watchdog_ok():
            if time.time() - t0 > WAIT_MAX_S:
                print(f"LEAN_GRAPPLE STOP: watchdog RED for {WAIT_MAX_S} s before batch {k // BATCH + 1} - {made} made, "
                      "rerun to continue", flush=True)
                return 1
            print("LEAN_GRAPPLE waiting: watchdog RED", flush=True)
            time.sleep(30)
        if not _wait_free():
            return 1
        rows = _render(batch)
        made += sum(1 for i in batch if _encode(i, rows.get(i)))
        print(f"LEAN_GRAPPLE batch {k // BATCH + 1}: {made}/{len(todo)} made", flush=True)
    print(f"LEAN_GRAPPLE DONE {made}/{len(todo)} previews ({len(ids) - len(todo)} already there)")
    return 0 if made == len(todo) else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

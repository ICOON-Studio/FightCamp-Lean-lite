"""c223_parallel.py - run a C223 gate one generated rig per process, then merge the reports (S127).

Operator, 2026-09-29, on the compute bottleneck: "ok do it". Measured before this: a C223 gate walked its four legal
rigs one after another in ONE Godot process, and the PC watchdog read CPU 4-12% the whole time - the machine was waiting,
not working. This starts one headless Godot per rig at IDLE priority (the same priority run_tests.py uses), waits for all,
and writes the SAME report file the serial run writes (rows in RIGS order, errors summed), so every consumer - the
sequence gate's `certificates=`, certified_palette_test, the digests - reads it unchanged.

    python Tools/c223_parallel.py production -- plant phase live_contact bound clips=boxing_lead_uppercut report=x.json
    python Tools/c223_parallel.py sequence --jobs 2 -- bound live_contact clips=boxing_one_two certificates=a.json report=y.json

Headless numbers only. Stills (`render`) stay a single windowed run through Tools/godot_hidden.ps1.
Refuses to start when the PC watchdog reads RED.
"""
from __future__ import annotations

import argparse
import json
import math
import os
import subprocess
import sys
import tempfile
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def _no_console(path: str) -> str:
    """S166 (operator 2026-10-05: "please no popups on my other monitor", the window was a black console):
    on Windows 11 the *_console.exe shim is handed to Windows Terminal, which opens on the operator's
    monitor whatever flags or desktop the caller gives it. Always run the GUI sibling; it still writes
    to redirected stdout/stderr (measured S166: --headless output reaches the pipes)."""
    if path.lower().endswith("_console.exe"):
        sibling = path[:-len("_console.exe")] + ".exe"
        if os.path.isfile(sibling):
            return sibling
    return path


def _find_godot() -> str:
    """S136: GODOT_EXE, then the cloud install (Tools/cloud_setup.sh -> /opt/godot/godot), then the Windows one - the
    same order as Godot/tools/run_tests.py. It read LOCALAPPDATA only, so a cloud session could not run a gate here."""
    explicit = os.environ.get("GODOT_EXE")
    if explicit:
        return _no_console(explicit)
    for candidate in ("/opt/godot/godot", "/usr/local/bin/godot"):
        if os.path.isfile(candidate) and os.access(candidate, os.X_OK):
            return candidate
    return os.path.join(os.environ.get("LOCALAPPDATA", ""), "Programs", "Godot", "Godot_v4.7.2-stable_win64.exe")


GODOT = _find_godot()
OUT = ROOT / "previews" / "c223"
RIGS = ["generator_welter_a", "generator_welter_b", "generator_heavy_c", "generator_heavy_d"]
SCRIPTS = {"production": "tools/c223_production_gate.gd", "sequence": "tools/c223_sequence_gate.gd"}
IDLE = 0x00000040  # IDLE_PRIORITY_CLASS
NO_WINDOW = 0x08000000  # CREATE_NO_WINDOW


def watchdog_red() -> bool:
    ps = ROOT / "Tools" / "pc_watchdog.ps1"
    if os.name != "nt" or not ps.exists():  # the watchdog is the PC's; a cloud box has no powershell
        return False
    r = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", str(ps), "-Once"],
                       capture_output=True, text=True)
    print((r.stdout or "").strip().splitlines()[-1] if r.stdout.strip() else "watchdog: no output")
    return r.returncode == 1


def _finite(value):
    """The report with every non-finite float replaced by None (JSON null), recursively."""
    if isinstance(value, float) and not math.isfinite(value):
        return None
    if isinstance(value, dict):
        return {k: _finite(v) for k, v in value.items()}
    if isinstance(value, list):
        return [_finite(v) for v in value]
    return value


def main() -> int:
    argv = sys.argv[1:]
    gate_args: list[str] = []
    if "--" in argv:
        cut = argv.index("--")
        argv, gate_args = argv[:cut], argv[cut + 1:]
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("gate", choices=sorted(SCRIPTS))
    ap.add_argument("--jobs", type=int, default=len(RIGS), help="processes at once (default: one per rig)")
    ap.add_argument("--rigs", default=",".join(RIGS))
    ap.add_argument("--timeout", type=int, default=3600)
    args = ap.parse_args(argv)
    reports = [a for a in gate_args if a.startswith("report=")]
    if len(reports) != 1:
        print("give exactly one report=<name>.json after --", file=sys.stderr)
        return 2
    if any(a.startswith(("rig=", "render", "stills_only")) or a in ("first_rig", "first_pair") for a in gate_args):
        print("rig=/first_rig/first_pair/render are set per process or not supported here", file=sys.stderr)
        return 2
    report = Path(reports[0][len("report="):]).name
    base_args = [a for a in gate_args if not a.startswith("report=")]
    rigs = [r for r in args.rigs.split(",") if r]
    if watchdog_red():
        print("PC watchdog is RED - not starting (CLAUDE.md section 4).", file=sys.stderr)
        return 3

    logs = Path(tempfile.mkdtemp(prefix="c223_parallel_"))
    pending = list(rigs)
    running: dict[str, tuple[subprocess.Popen, float, Path]] = {}
    done: dict[str, int] = {}
    t0 = time.time()
    while pending or running:
        while pending and len(running) < max(1, args.jobs):
            rig = pending.pop(0)
            part = f"{Path(report).stem}__{rig}.json"
            log = logs / f"{rig}.log"
            cmd = [str(GODOT), "--headless", "--path", str(ROOT / "Godot"), "--audio-driver", "Dummy",
                   "--script", SCRIPTS[args.gate], "--", *base_args, f"rig={rig}", f"report={part}"]
            with open(log, "w", encoding="utf-8") as fh:
                proc = subprocess.Popen(cmd, cwd=str(ROOT), stdout=fh, stderr=subprocess.STDOUT,
                                        **({"creationflags": IDLE | NO_WINDOW} if os.name == "nt" else {}))
            running[rig] = (proc, time.time(), log)
            print(f"  start {rig} pid={proc.pid}")
        time.sleep(2)
        for rig, (proc, started, log) in list(running.items()):
            rc = proc.poll()
            if rc is None and time.time() - started > args.timeout:
                proc.kill()  # by PID, never by image name
                rc = -9
            if rc is not None:
                done[rig] = rc
                del running[rig]
                print(f"  done  {rig} rc={rc} {time.time() - started:.0f}s  log {log}")
    wall = time.time() - t0

    rows: list = []
    errors = 0
    scope = ""
    missing = []
    for rig in rigs:
        part = OUT / f"{Path(report).stem}__{rig}.json"
        if not part.exists():
            missing.append(rig)
            continue
        data = json.loads(part.read_text(encoding="utf-8"))
        rows.extend(data.get("rows", []))
        errors += int(data.get("errors", 0))
        scope = scope or str(data.get("scope", ""))
        part.unlink()
    if missing:
        errors += len(missing)
        print(f"  NO REPORT from {missing} - see the logs in {logs}", file=sys.stderr)
    merged = {"rows": rows, "errors": errors, "scope": scope,
              "parallel": {"rigs": rigs, "jobs": args.jobs, "wall_s": round(wall, 1), "rc": done}}
    # S131: Python writes inf/nan as `Infinity`/`NaN`, which Godot's JSON parser rejects - the WHOLE certificate then
    # read as empty (six certified chains unproven because one probe chain had an infinite gap). Non-finite -> null.
    (OUT / report).write_text(json.dumps(_finite(merged), indent="\t", allow_nan=False), encoding="utf-8")
    print(f"C223_PARALLEL gate={args.gate} rigs={len(rigs)} jobs={args.jobs} wall={wall:.0f}s rows={len(rows)} "
          f"errors={errors} -> {OUT / report}")
    return 0 if errors == 0 and not missing and all(rc == 0 for rc in done.values()) else 1


if __name__ == "__main__":
    sys.exit(main())

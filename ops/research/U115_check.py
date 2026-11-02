#!/usr/bin/env python3
"""U115 gate: moving Cascadeur clip retarget + pair gap report. Must exit 0."""
from __future__ import annotations

import os
import re
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
GODOT = REPO / "Godot"
FIXTURE_SCRIPT = REPO / "Tools" / "cascadeur" / "make_moving_fixture.py"
PROBE = GODOT / "tools" / "u115_cascadeur_probe.gd"
PAIR_GAP = GODOT / "tools" / "pair_gap_report.gd"
MOVING_GLB = Path(
    r"C:\Users\user\AppData\Local\Temp\FightCamp-cascadeur-export\U115_MOVING_A.glb"
)

# Pinned from pair_gap_report.gd re-run on grapple_control (3 decimal places).
EXPECTED_CONTROL_MIN_GAP_M = 0.303
EXPECTED_CONTROL_MAX_GAP_M = 0.305
EXPECTED_STAND_UP_FRAMES = 76
EXPECTED_MOVING_FRAMES = 91

GODOT_EXE = Path(
    os.environ.get(
        "GODOT_EXE",
        Path(os.environ.get("LOCALAPPDATA", ""))
        / "Programs"
        / "Godot"
        / "Godot_v4.7.2-stable_win64_console.exe",
    )
)


def fail(msg: str) -> None:
    print(f"U115_CHECK FAIL {msg}")
    raise SystemExit(1)


def run_godot(script: Path, extra_args: list[str] | None = None) -> tuple[int, str]:
    cmd = [
        str(GODOT_EXE),
        "--headless",
        "--path",
        str(GODOT),
        "--script",
        str(script),
    ]
    if extra_args:
        cmd.extend(["--"])
        cmd.extend(extra_args)
    proc = subprocess.run(cmd, capture_output=True, text=True, cwd=str(REPO))
    return proc.returncode, proc.stdout + proc.stderr


def parse_probe_lines(text: str) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    for line in text.splitlines():
        if not line.startswith("U115_PROBE clip="):
            continue
        out: dict[str, str] = {}
        for part in line.split():
            if "=" in part:
                k, v = part.split("=", 1)
                out[k] = v
        rows.append(out)
    return rows


def parse_pairgap(text: str) -> dict[str, str]:
    for line in text.splitlines():
        if line.startswith("PAIRGAP key="):
            out: dict[str, str] = {}
            for part in line.split():
                if "=" in part:
                    k, v = part.split("=", 1)
                    out[k] = v
            return out
    return {}


def main() -> int:
    if not FIXTURE_SCRIPT.is_file():
        fail(f"missing {FIXTURE_SCRIPT}")
    if not PROBE.is_file():
        fail(f"missing {PROBE}")
    if not PAIR_GAP.is_file():
        fail(f"missing {PAIR_GAP}")
    if not GODOT_EXE.is_file():
        fail(f"Godot exe missing: {GODOT_EXE}")

    fx = subprocess.run(
        [sys.executable, str(FIXTURE_SCRIPT)],
        capture_output=True,
        text=True,
        cwd=str(REPO),
    )
    if fx.returncode != 0:
        fail(f"make_moving_fixture.py exited {fx.returncode}: {fx.stderr}")
    if not MOVING_GLB.is_file():
        fail(f"moving fixture not written: {MOVING_GLB}")
    print("U115_CHECK moving_fixture=ok")

    rc, out = run_godot(PROBE)
    for line in out.splitlines():
        if line.startswith("U115_PROBE"):
            print(line.replace("U115_PROBE", "U115_CHECK", 1))
    if rc != 0:
        fail(f"probe exited {rc}")

    moving_rows = [r for r in parse_probe_lines(out) if "U115_MOVING_A.glb" in r.get("clip", "")]
    if not moving_rows:
        fail("probe did not report moving clip")
    moving = moving_rows[0]
    frames = int(moving.get("frames", "-1"))
    if frames != EXPECTED_MOVING_FRAMES:
        fail(f"moving frames {frames} != {EXPECTED_MOVING_FRAMES}")
    if moving.get("error", "x") != "":
        fail(f"moving clip error={moving.get('error')}")
    print(f"U115_CHECK moving_frames={frames}")

    rc, out = run_godot(PAIR_GAP, ["grapple_control"])
    if rc != 0:
        fail(f"pair_gap_report grapple_control exited {rc}")
    gap = parse_pairgap(out)
    if not gap:
        fail("no PAIRGAP line from grapple_control")
    min_gap = round(float(gap["min_gap_m"]), 3)
    max_gap = round(float(gap["max_gap_m"]), 3)
    print(
        f"U115_CHECK grapple_control min_gap_m={min_gap:.3f} max_gap_m={max_gap:.3f}"
    )
    if min_gap != EXPECTED_CONTROL_MIN_GAP_M:
        fail(
            f"grapple_control min_gap_m {min_gap:.3f} != {EXPECTED_CONTROL_MIN_GAP_M:.3f}"
        )
    if max_gap != EXPECTED_CONTROL_MAX_GAP_M:
        fail(
            f"grapple_control max_gap_m {max_gap:.3f} != {EXPECTED_CONTROL_MAX_GAP_M:.3f}"
        )

    rc, out = run_godot(PAIR_GAP, ["grapple_stand_up"])
    if rc != 0:
        fail(f"pair_gap_report grapple_stand_up exited {rc}")
    stand = parse_pairgap(out)
    if not stand:
        fail("no PAIRGAP line from grapple_stand_up")
    stand_frames = int(stand["frames"])
    want = round(2.500 * 30)
    if abs(stand_frames - want) > 1:
        fail(f"grapple_stand_up frames {stand_frames} not within ±1 of {want}")
    if stand_frames != EXPECTED_STAND_UP_FRAMES:
        fail(f"grapple_stand_up frames {stand_frames} != {EXPECTED_STAND_UP_FRAMES}")
    print(f"U115_CHECK grapple_stand_up frames={stand_frames}")

    print("U115_CHECK PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env python3
"""U117 gate: Cascadeur 2→3 spine split — head lean + collar tie + control arms."""
from __future__ import annotations

import os
import re
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
GODOT = REPO / "Godot"
CONTACT = GODOT / "tools" / "s31_contact_probe.gd"
PAIR_GAP = GODOT / "tools" / "pair_gap_report.gd"
SPINE_PROBE = GODOT / "tools" / "u116_spine_probe.gd"

# Pinned from s31_contact_probe re-run (1 decimal place on drift).
HEAD_DRIFT_MAX_PCT = 10.0
ATT_LHAND_DRIFT_MAX_PCT = 390.0
VIC_RHAND_DRIFT_MAX_PCT = 783.0

EXPECTED_CONTROL_MIN_GAP_M = 0.302639
EXPECTED_CONTROL_MAX_GAP_M = 0.304671
EXPECTED_UE4_ROT_SUM = 1.666968

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
    print(f"U117_CHECK FAIL {msg}")
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


def parse_contact(text: str) -> dict[str, float]:
    rows: dict[str, float] = {}
    for line in text.splitlines():
        if not line.startswith("S31CONTACT ") or "measure" in line:
            continue
        parts = line.split()
        if len(parts) < 7:
            continue
        name = parts[1]
        drift_s = parts[-1].rstrip("%")
        try:
            rows[name] = float(drift_s)
        except ValueError:
            continue
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


def main() -> None:
    rc, out = run_godot(CONTACT, ["mma_dirty_boxing"])
    if rc != 0:
        fail(f"s31_contact_probe exited {rc}")
    rows = parse_contact(out)
    for key in (
        "att_lhand_to_vic_neck",
        "att_rhand_to_vic_neck",
        "vic_rhand_to_att_larm",
        "head_to_head",
        "hip_to_hip",
    ):
        if key not in rows:
            fail(f"missing contact row {key}")
    head = rows["head_to_head"]
    hand = rows["att_lhand_to_vic_neck"]
    vic = rows["vic_rhand_to_att_larm"]
    print(
        f"U117_CHECK contacts head={head:.1f}% hand={hand:.1f}% vic_arm={vic:.1f}%"
    )
    if head > HEAD_DRIFT_MAX_PCT:
        fail(f"head_to_head drift {head:.1f}% > {HEAD_DRIFT_MAX_PCT:.1f}%")
    if hand > ATT_LHAND_DRIFT_MAX_PCT:
        fail(f"att_lhand drift {hand:.1f}% > {ATT_LHAND_DRIFT_MAX_PCT:.1f}%")
    if vic > VIC_RHAND_DRIFT_MAX_PCT:
        fail(f"vic_rhand drift {vic:.1f}% > master {VIC_RHAND_DRIFT_MAX_PCT:.1f}%")

    rc, out = run_godot(PAIR_GAP, ["grapple_control"])
    if rc != 0:
        fail(f"pair_gap_report exited {rc}")
    gap = parse_pairgap(out)
    min_gap = float(gap.get("min_gap_m", "-1"))
    max_gap = float(gap.get("max_gap_m", "-1"))
    if abs(min_gap - EXPECTED_CONTROL_MIN_GAP_M) > 0.000001:
        fail(f"grapple_control min_gap_m {min_gap} != {EXPECTED_CONTROL_MIN_GAP_M}")
    if abs(max_gap - EXPECTED_CONTROL_MAX_GAP_M) > 0.000001:
        fail(f"grapple_control max_gap_m {max_gap} != {EXPECTED_CONTROL_MAX_GAP_M}")

    rc, out = run_godot(SPINE_PROBE)
    if rc != 0:
        fail(f"u116_spine_probe exited {rc}")
    m = re.search(r"rot_sum=([0-9.]+)", out)
    if not m:
        fail("no U117UE4 rot_sum line")
    rot_sum = float(m.group(1))
    if abs(rot_sum - EXPECTED_UE4_ROT_SUM) > 0.000001:
        fail(f"UE4 rot_sum {rot_sum} != {EXPECTED_UE4_ROT_SUM}")

    print("U117_CHECK PASS")


if __name__ == "__main__":
    main()

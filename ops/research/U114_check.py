#!/usr/bin/env python3
"""U114 gate: Cascadeur retarget repairs in FightClipRetarget. Must exit 0."""
from __future__ import annotations

import os
import re
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
GODOT = REPO / "Godot"
RETARGET = GODOT / "scripts" / "FightClipRetarget.gd"
PROBE = GODOT / "tools" / "u114_cascadeur_probe.gd"

# Pinned literal — not learned from the run under test.
EXPECTED_CASCY_MAP_ROWS = 21

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
    print(f"U114_CHECK FAIL {msg}")
    raise SystemExit(1)


def parse_cascy_map(text: str) -> dict[str, str]:
    block = text[text.find("const CASCY_TO_UE4") : text.find("const CASCY_REFERENCE")]
    pairs = re.findall(r'"([^"]+)":\s*"([^"]+)"', block)
    return dict(pairs)


def parse_ue4_map(text: str) -> dict[str, str]:
    start = text.find("const UE4_TO_OURS")
    end = text.find("const CASCY_TO_UE4")
    block = text[start:end]
    pairs = re.findall(r'"([^"]+)":\s*"([^"]+)"', block)
    return dict(pairs)


def main() -> int:
    if not RETARGET.is_file():
        fail(f"missing {RETARGET}")

    text = RETARGET.read_text(encoding="utf-8")
    cascy = parse_cascy_map(text)
    ue4 = parse_ue4_map(text)

    print(f"U114_CHECK cascy_map_rows={len(cascy)}")
    if len(cascy) != EXPECTED_CASCY_MAP_ROWS:
        fail(f"CASCY_TO_UE4 rows {len(cascy)} != {EXPECTED_CASCY_MAP_ROWS}")

    for cascy_bone, ue4_key in cascy.items():
        if ue4_key not in ue4:
            fail(f"CASCY_TO_UE4[{cascy_bone}] -> {ue4_key} not in UE4_TO_OURS")

    if "GLTFDocument" not in text or "FBXDocument" not in text:
        fail("_load_fbx must dispatch GLTFDocument and FBXDocument")
    if "is_cascadeur_clip" not in text:
        fail("missing is_cascadeur_clip helper")
    if "_inherit_upper_chest" not in text:
        fail("missing UpperChest inheritance helper")

    print("U114_CHECK loader_dispatches_glb_and_fbx=1")

    if not GODOT_EXE.is_file():
        fail(f"Godot exe missing: {GODOT_EXE}")
    if not PROBE.is_file():
        fail(f"missing probe script {PROBE}")

    proc = subprocess.run(
        [
            str(GODOT_EXE),
            "--headless",
            "--path",
            str(GODOT),
            "--script",
            str(PROBE),
        ],
        capture_output=True,
        text=True,
        cwd=str(REPO),
    )
    out = proc.stdout + proc.stderr
    for line in out.splitlines():
        if line.startswith("U114_PROBE"):
            print(line.replace("U114_PROBE", "U114_CHECK", 1))
    if proc.returncode != 0:
        fail(f"probe exited {proc.returncode}")

    print("U114_CHECK PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

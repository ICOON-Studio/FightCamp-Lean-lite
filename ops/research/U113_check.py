#!/usr/bin/env python3
"""U113 gate: re-derive Cascadeur export facts from disk. Must exit 0 on real files."""
from __future__ import annotations

import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO / "Tools" / "cascadeur"))

from u113_analyze import (  # noqa: E402
    CASCY_TO_UE4,
    FILES,
    FIGHTER_GLB,
    UE4_TO_OURS,
    direct_ue4_matches,
    load_glb,
    per_skin_joint_counts,
    rename_map_matches,
    sha256,
    unique_skin_joints,
)

# Pinned literals — not learned from the run under test.
EXPECTED_CASCY_JOINTS = 66
EXPECTED_PAIR_UNIQUE_JOINTS = 132
EXPECTED_F01_JOINTS = 22
EXPECTED_RENAME_MATCHES = 21
EXPECTED_UE4_DIRECT_MATCHES = 12


def fail(msg: str) -> None:
    print(f"U113_CHECK FAIL {msg}")
    raise SystemExit(1)


def main() -> int:
    for label, path in FILES.items():
        if not path.is_file() or path.stat().st_size == 0:
            fail(f"missing or empty export {label}: {path}")

    hash_a = sha256(FILES["A"])
    hash_b = sha256(FILES["B"])
    if hash_a == hash_b:
        fail("S30_CLINCH_A.glb and S30_CLINCH_B.glb are byte-identical")

    gltf_a, _ = load_glb(FILES["A"])
    gltf_b, _ = load_glb(FILES["B"])
    gltf_pair, _ = load_glb(FILES["pair"])
    gltf_f01, _ = load_glb(FIGHTER_GLB)

    joints_a = unique_skin_joints(gltf_a)
    joints_b = unique_skin_joints(gltf_b, strip_char_prefix=True)
    joints_pair = unique_skin_joints(gltf_pair)
    joints_f01 = unique_skin_joints(gltf_f01)

    if len(joints_a) != EXPECTED_CASCY_JOINTS:
        fail(f"A skin joint count {len(joints_a)} != {EXPECTED_CASCY_JOINTS}")
    if len(joints_b) != EXPECTED_CASCY_JOINTS:
        fail(f"B skin joint count {len(joints_b)} != {EXPECTED_CASCY_JOINTS}")
    if len(joints_pair) != EXPECTED_PAIR_UNIQUE_JOINTS:
        fail(f"pair unique skin joints {len(joints_pair)} != {EXPECTED_PAIR_UNIQUE_JOINTS}")
    if len(joints_f01) != EXPECTED_F01_JOINTS:
        fail(f"f01 skin joint count {len(joints_f01)} != {EXPECTED_F01_JOINTS}")

    set_a = set(joints_a)
    set_b = set(joints_b)
    if set_a != set_b:
        fail("A and B stripped bone name sets differ")

    direct = direct_ue4_matches(set_a)
    renamed, missing_ours = rename_map_matches(set_a)

    print(f"U113_CHECK A_skin_joints={len(joints_a)}")
    print(f"U113_CHECK B_skin_joints={len(joints_b)}")
    print(f"U113_CHECK pair_unique_skin_joints={len(joints_pair)}")
    print(f"U113_CHECK f01_skin_joints={len(joints_f01)}")
    print(f"U113_CHECK A_per_skin_counts={per_skin_joint_counts(gltf_a)}")
    print(f"U113_CHECK pair_per_skin_counts={per_skin_joint_counts(gltf_pair)}")
    print(f"U113_CHECK ue4_direct_matches={direct}")
    print(f"U113_CHECK rename_map_matches={renamed}")
    print(f"U113_CHECK cascy_rename_rows={len(CASCY_TO_UE4)}")
    print(f"U113_CHECK ue4_map_rows={len(UE4_TO_OURS)}")
    print(f"U113_CHECK our_bones_unmapped={missing_ours}")

    if direct != EXPECTED_UE4_DIRECT_MATCHES:
        fail(f"ue4 direct {direct} != {EXPECTED_UE4_DIRECT_MATCHES}")
    if renamed != EXPECTED_RENAME_MATCHES:
        fail(f"rename map matches {renamed} != {EXPECTED_RENAME_MATCHES}")
    if missing_ours != ["UpperChest"]:
        fail(f"expected only UpperChest unmapped, got {missing_ours}")

    print("U113_CHECK PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

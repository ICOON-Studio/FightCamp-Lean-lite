"""Q98 gate (written by Claude before launch). Run from the repo root: python research/Q98_check.py

Q98 reads which foot leads at the first and last frame of every take f01 holds. Nothing here trusts the tool:
- a mirror is a reflection: every mirrored take's first and last split and width equal its source take's within 1 cm,
  and its lead foot is the OTHER foot;
- `swap` is recomputed from the first-frame lead against idle's;
- every take the binding marks mirrored must appear with its source.
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GODOT = ROOT / "Godot"
TOOL = GODOT / "tools" / "measure_take_stance.gd"
JSON_PATH = GODOT / "research" / "Q98_take_stance.json"
MD_PATH = GODOT / "research" / "Q98_TAKE_STANCE.md"

failures = []


def fail(msg):
    failures.append(msg)
    print("FAIL:", msg)


def main():
    for p in (TOOL, JSON_PATH, MD_PATH):
        if not p.is_file():
            fail("missing %s" % p.relative_to(ROOT))
    if failures:
        return finish()
    tool = TOOL.read_text(encoding="utf-8")
    for needed in ("FightStagePlayer", "get_bone_pose", "Q98_take_stance.json"):
        if needed not in tool:
            fail("the tool does not contain %r" % needed)
    data = json.loads(JSON_PATH.read_text(encoding="utf-8"))
    ref = data.get("idle_reference", {})
    if ref.get("lead") not in ("LeftToes", "RightToes"):
        fail("idle_reference.lead must name a toe")
    takes = data.get("takes", [])
    if len(takes) < 8:
        fail("only %d takes" % len(takes))
    by_role = {}
    for t in takes:
        for end in ("first", "last"):
            e = t.get(end, {})
            if e.get("lead") not in ("LeftToes", "RightToes"):
                fail("%s.%s.lead must name a toe" % (t.get("take"), end))
            if float(e.get("width_m", -1)) < 0.0 or float(e.get("split_m", -1)) < 0.0:
                fail("%s.%s split and width are magnitudes, >= 0" % (t.get("take"), end))
        if bool(t.get("swap")) != (t.get("first", {}).get("lead") != ref.get("lead")):
            fail("%s.swap does not match its first-frame lead against idle's" % t.get("take"))
        by_role.setdefault(t.get("role"), []).append(t)
    binding = (GODOT / "scripts" / "FightClipBinding.gd").read_text(encoding="utf-8")
    mirrored_roles = set(re.findall(r'"([a-z_]+)"\s*:\s*\{[^{}]*?"mirror"\s*:\s*true', binding, re.S))
    for t in takes:
        if not t.get("mirrored"):
            continue
        if not str(t.get("source_role", "")):
            continue
        src = by_role.get(t.get("source_role"), [])
        if not src:
            fail("%s is mirrored from %r, which is not in the takes" % (t.get("take"), t.get("source_role")))
            continue
        s = src[0]
        for end in ("first", "last"):
            a, b = t[end], s[end]
            if abs(float(a["split_m"]) - float(b["split_m"])) > 0.01 or abs(float(a["width_m"]) - float(b["width_m"])) > 0.01:
                fail("REFLECTION: %s.%s split/width %.3f/%.3f v source %s %.3f/%.3f" % (
                    t["take"], end, float(a["split_m"]), float(a["width_m"]), s["take"], float(b["split_m"]), float(b["width_m"])))
            if a["lead"] == b["lead"]:
                fail("REFLECTION: %s.%s leads with %s, the same foot as its source" % (t["take"], end, a["lead"]))
    for role in mirrored_roles:
        if not any(t.get("role") == role and t.get("mirrored") for t in takes):
            fail("the binding mirrors %s but no mirrored take of it is reported" % role)
    hook_rear = [t for t in takes if t.get("role") == "hook_rear"]
    if not hook_rear or hook_rear[0].get("source_role") != "hook_lead":
        fail("hook_rear must be reported as mirrored from hook_lead (same path and window in the binding)")
    md = MD_PATH.read_text(encoding="utf-8").splitlines()
    if next((l for l in md if l.strip()), "").strip() != "## DECISIONS":
        fail("the digest does not open with ## DECISIONS")
    if len(md) > 25:
        fail("the digest is %d lines, 25 at most" % len(md))
    return finish()


def finish():
    if failures:
        print("Q98_check: %d failure(s)" % len(failures))
        sys.exit(1)
    print("Q98_check: PASS")
    sys.exit(0)


if __name__ == "__main__":
    main()

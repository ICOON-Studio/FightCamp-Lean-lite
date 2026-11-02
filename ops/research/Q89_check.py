"""Q89 gate (Claude's): the reactions' root sway, recomputed from the raw samples.

Exit 0 only when every take the binding names is present, every statistic is reproduced from its own
`samples` rows by THIS script's definition (TASK_Q89), the numbers obey physics, and the markdown opens
with DECISIONS and gives a verdict for every role the room measured. A number the rows cannot reproduce
is a failure.
"""
import json
import math
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
JSON_PATH = os.path.join(HERE, "Q89_reaction_sway.json")
MD_PATH = os.path.join(HERE, "Q89_REACTION_SWAY.md")
BINDING = os.path.join(ROOT, "scripts", "FightClipBinding.gd")
TOL = 0.002
LOW, HIGH = -0.0263, 0.05
ROOM = {"react_head": 0.74, "react_body": 0.88, "slip": 0.58, "hook_lead": 0.85, "idle": 0.04}
fails = []


def fail(msg):
    fails.append(msg)


def expected_takes():
    """Parse FightClipBinding.BINDINGS: FBX roles with retarget true -> take names."""
    src = open(BINDING, encoding="utf-8").read()
    body = src[src.index("const BINDINGS := {"):]
    body = body[:body.index("\n}\n")]
    starts = [(m.start(), m.group(1)) for m in re.finditer(r'^\t"([a-z_0-9]+)": \{', body, re.M)]
    takes = []
    for i, (pos, role) in enumerate(starts):
        end = starts[i + 1][0] if i + 1 < len(starts) else len(body)
        block = body[pos:end]
        head = block.split('"variants"')[0]
        path = re.search(r'"path": "([^"]+)"', head)
        if not path or not path.group(1).endswith(".FBX") or '"retarget": true' not in head:
            continue
        if '"variants"' in block:
            n = len(re.findall(r'\{"path": "', block.split('"variants"')[1]))
            if n == 0:
                n = len(re.findall(r'"path":', block.split('"variants"')[1]))
        else:
            n = 1
        for k in range(n):
            takes.append(role if k == 0 else "%s#%d" % (role, k))
    return takes


def planted_stats(samples):
    floor_y = min(samples[0][2][1], samples[0][3][1])
    source, pinned, hips_speed = [], [], []
    h0 = samples[0][1]
    for k in range(1, len(samples)):
        prev, now = samples[k - 1], samples[k]
        left_now = now[2][1] <= now[3][1]
        left_before = prev[2][1] <= prev[3][1]
        if left_now != left_before:
            continue
        idx = 2 if left_now else 3
        a, b = prev[idx], now[idx]
        ha, hb = a[1] - floor_y, b[1] - floor_y
        if not (LOW <= ha <= HIGH and LOW <= hb <= HIGH):
            continue
        source.append(math.hypot(b[0] - a[0], b[2] - a[2]) * 30.0)
        pa = (a[0] - (prev[1][0] - h0[0]), a[2] - (prev[1][2] - h0[2]))
        pb = (b[0] - (now[1][0] - h0[0]), b[2] - (now[1][2] - h0[2]))
        pinned.append(math.hypot(pb[0] - pa[0], pb[1] - pa[1]) * 30.0)
        hips_speed.append(math.hypot(now[1][0] - prev[1][0], now[1][2] - prev[1][2]) * 30.0)
    mean = lambda v: sum(v) / len(v) if v else 0.0
    travel = [math.hypot(s[1][0] - h0[0], s[1][2] - h0[2]) for s in samples]
    return {
        "floor_y": floor_y,
        "planted_steps": len(source),
        "source_skate_mps": mean(source),
        "pinned_skate_mps": mean(pinned),
        "hips_speed_planted_mps": mean(hips_speed),
        "hips_travel_end_m": travel[-1],
        "hips_travel_max_m": max(travel),
    }


def main():
    if not os.path.isfile(JSON_PATH):
        print("Q89_CHECK FAIL: no %s" % JSON_PATH)
        return 1
    data = json.load(open(JSON_PATH, encoding="utf-8"))
    takes = data.get("takes", [])
    by_name = {str(t.get("take")): t for t in takes}
    want = expected_takes()
    if len(want) < 10:
        fail("the binding parse found only %d takes - the instrument is wrong" % len(want))
    for name in want:
        if name not in by_name:
            fail("take missing: %s" % name)
    for name in by_name:
        if name not in want:
            fail("take not in the binding: %s" % name)

    for t in takes:
        name = str(t.get("take"))
        samples = t.get("samples", [])
        span = float(t.get("end_s", 0)) - float(t.get("start_s", 0))
        n_want = max(2, math.ceil(span * 30 - 1e-9) + 1)
        if abs(len(samples) - n_want) > 1:
            fail("%s: %d samples, the rule gives %d" % (name, len(samples), n_want))
        if len(samples) < 2:
            continue
        stats = planted_stats(samples)
        for key, value in stats.items():
            got = float(t.get(key, float("nan")))
            if key == "planted_steps":
                if int(got) != value:
                    fail("%s: planted_steps %s, raw rows give %d" % (name, t.get(key), value))
            elif not math.isfinite(got) or abs(got - value) > TOL:
                fail("%s: %s %.4f, raw rows give %.4f" % (name, key, got, value))
        # Physics bounds.
        # Only a REACTION is bounded: a "Forward" strike clip (H2H_KneeStrike_Forward, 1.98 m) travels by design.
        # The first form bounded every take and failed that knee - an invented bound, removed 2026-09-13.
        role = name.split("#")[0]
        if (role.startswith("react_") or role in ("slip", "block")) and stats["hips_travel_max_m"] > 1.5:
            fail("%s: hips travel %.2f m in one take - not a reaction, a walk" % (name, stats["hips_travel_max_m"]))
        for key in ("source_skate_mps", "pinned_skate_mps", "hips_speed_planted_mps"):
            if stats[key] > 6.0:
                fail("%s: %s %.2f m/s is faster than a sprint" % (name, key, stats[key]))
        heights = [s[1][1] for s in samples]
        if name.split("#")[0] != "knockdown" and min(heights) < 0.3:
            fail("%s: hips %.2f m above the source origin - wrong units or a wrong bone" % (name, min(heights)))

    # SENT BACK 2026-09-13. The first delivery subtracted the FBX root's horizontal origin from every
    # bone - the task's trap (1) says not to - so a stagger that travels 0.72 m read 0.000 and every
    # reaction's root sway was reported as the performer's own foot slide. A gate that recomputes from
    # the subject's raw rows cannot catch a wrong raw row, so this one is pinned to an INDEPENDENT
    # measurement: Claude's probe through the same production composition (FightClipRetarget._globals
    # over _local_at, no subtraction) read H2H_StaggerSmall01 over its whole 1.00 s at Hips XZ max
    # 0.722 m and LeftToes XZ max 0.698 m. react_body's first take is exactly that window.
    tool_path = os.path.join(ROOT, "tools", "measure_reaction_sway.gd")
    if os.path.isfile(tool_path):
        tool_src = open(tool_path, encoding="utf-8").read()
        if re.search(r'\[\s*"root"\s*\]', tool_src):
            fail("the tool still reads the FBX root node to subtract it - trap (1)")
    stagger = by_name.get("react_body")
    if stagger is not None:
        travel = float(stagger.get("hips_travel_max_m", 0.0))
        if abs(travel - 0.722) > 0.0722:
            fail("react_body (StaggerSmall01 0-1 s) hips_travel_max %.3f m; the independent probe reads 0.722 m" % travel)

    # Sibling tripwire: the room's idle skates 0.04 m/s. An idle whose PREDICTED skate is large means the
    # instrument, not the clip.
    idle = [t for t in takes if str(t.get("take", "")).split("#")[0] == "idle"]
    for t in idle:
        if float(t.get("pinned_skate_mps", 0)) > 0.25:
            fail("idle pinned skate %.2f m/s against the room's 0.04 - check the instrument" % float(t["pinned_skate_mps"]))

    if not os.path.isfile(MD_PATH):
        fail("no markdown")
    else:
        md = open(MD_PATH, encoding="utf-8").read()
        if not md.lstrip().startswith("## DECISIONS"):
            fail("the markdown does not open with ## DECISIONS")
        for role in ROOM:
            # The verdict is DERIVED here from the JSON (planted-step-weighted means, TASK_Q89's rules) and the
            # markdown must state that word on the role's line - a stale verdict no longer passes (2026-09-13).
            members = [t for t in takes if str(t.get("take", "")).split("#")[0] == role]
            steps = sum(int(t.get("planted_steps", 0)) for t in members)
            src = sum(float(t.get("source_skate_mps", 0.0)) * int(t.get("planted_steps", 0)) for t in members) / steps if steps else 0.0
            pin = sum(float(t.get("pinned_skate_mps", 0.0)) * int(t.get("planted_steps", 0)) for t in members) / steps if steps else 0.0
            want = "PERFORMANCE" if src >= 0.10 else ("SWAY" if pin >= 0.10 else "CLEAN")
            lines = [l for l in md.splitlines()
                     if re.search(r"\b%s\b" % re.escape(role), l) and re.search(r"\b(SWAY|PERFORMANCE|CLEAN)\b", l)]
            if not lines:
                fail("no verdict line for %s" % role)
            elif not any(re.search(r"\b%s\b" % want, l) for l in lines):
                fail("%s: the JSON gives %s (weighted source %.3f, pinned %.3f m/s) - the markdown says otherwise" % (
                    role, want, src, pin))

    if fails:
        for f in fails:
            print("FAIL " + f)
        print("Q89_CHECK FAIL (%d)" % len(fails))
        return 1
    print("Q89_CHECK PASS takes=%d" % len(takes))
    return 0


if __name__ == "__main__":
    sys.exit(main())

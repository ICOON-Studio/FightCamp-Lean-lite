#!/usr/bin/env python
"""U85's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/U85_check.py

Physics and sibling bounds only - never an expected verdict:
  - an extension is 0.15-0.95 m (an adult arm reaching from guard);
  - home comes after the peak and inside the window; retract_ms is exactly (home - peak) x 1000;
  - end_ratio and ends_in_guard agree (<= 0.25);
  - the jab slice on f01 agrees with the realism test (41b3c86), which saw it leave the screen with the
    hand still about half out (0.26 of 0.49 m): its f01 end_ratio sits in 0.30-0.80, or the markdown
    says why not in a line that names the realism test;
  - every bound punch role and every named candidate is present.
"""
import json
import math
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
R = lambda p: os.path.join(ROOT, p)  # noqa: E731
JSON_PATH = R("research/U85_guard_return.json")
MD_PATH = R("research/U85_GUARD_RETURN.md")
TOOL = R("Godot/tools/measure_guard_return.gd")
BINDING = R("Godot/scripts/FightClipBinding.gd")
CANDIDATES = ("H2H_JabInPlace.FBX", "H2H_StraightPunchInPlace.FBX", "H2H_HookPunch_InPlace.FBX",
              "H2H_LeadingUppercut_InPlace.FBX", "H2H_Haymaker_InPlace.FBX", "H2H_SnappingBackfist_InPlace.FBX")
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def finite(x):
    return isinstance(x, (int, float)) and not isinstance(x, bool) and math.isfinite(x)


def bound_punch_roles():
    """The roles punch_roles() lists AND BINDINGS carries - read from the binding source, not typed here."""
    text = open(BINDING, encoding="utf-8").read()
    block = re.search(r"static func punch_roles\(\).*?PackedStringArray\(\[(.*?)\]\)", text, re.S)
    listed = re.findall(r'"([a-z_]+)"', block.group(1)) if block else []
    return [r for r in listed if re.search(r'^\t"%s": \{' % re.escape(r), text, re.M)]


def side_ok(name, side, s, window_s):
    if not check(isinstance(s, dict), f"{name} {side}: missing"):
        return
    pk, ps, er = s.get("peak_m"), s.get("peak_s"), s.get("end_ratio")
    if not check(finite(pk) and finite(ps) and finite(er), f"{name} {side}: peak_m/peak_s/end_ratio missing"):
        return
    check(0.15 <= pk <= 0.95, f"{name} {side}: extension {pk:.3f} m is not an arm reaching from guard")
    check(-1e-6 <= ps <= window_s + 0.02, f"{name} {side}: peak at {ps:.3f} s outside the {window_s:.3f} s window")
    check(er >= 0.0, f"{name} {side}: negative end_ratio")
    check(bool(s.get("ends_in_guard")) == (er <= 0.25), f"{name} {side}: ends_in_guard disagrees with end_ratio {er:.3f}")
    hs, rm = s.get("home_s"), s.get("retract_ms")
    if hs is None:
        check(rm is None, f"{name} {side}: retract_ms without a home_s")
    elif check(finite(hs) and finite(rm), f"{name} {side}: home_s / retract_ms malformed"):
        check(ps < hs <= window_s + 0.02, f"{name} {side}: home at {hs:.3f} s is not after the peak and inside the window")
        check(abs(rm - (hs - ps) * 1000.0) <= 1.0, f"{name} {side}: retract_ms {rm:.1f} is not (home - peak) x 1000")


def main():
    roles = bound_punch_roles()
    check(len(roles) >= 3, f"the gate found only {roles} in punch_roles() - the gate itself is broken")
    check(os.path.isfile(TOOL), "Godot/tools/measure_guard_return.gd does not exist")
    if not check(os.path.isfile(JSON_PATH), "U85_guard_return.json does not exist"):
        return
    try:
        data = json.load(open(JSON_PATH, encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        check(False, f"the JSON does not parse: {exc}")
        return

    clips = {c.get("role"): c for c in data.get("clips", [])}
    for role in roles:
        check(role in clips, f"bound punch role {role} was not measured")
    for role, c in clips.items():
        s, e = c.get("start_s"), c.get("end_s")
        window = (e - s) if finite(s) and finite(e) and s >= 0 and e > s else None
        if not check(window is not None, f"{role}: start_s/end_s missing"):
            continue
        for side in ("source", "f01"):
            side_ok(role, side, c.get(side), window)

    cands = {c.get("file"): c for c in data.get("candidates", [])}
    for name in CANDIDATES:
        if check(name in cands, f"candidate {name} was not measured"):
            for side in ("source", "f01"):
                length = cands[name].get("length_s")
                if check(finite(length) and length > 0, f"{name}: length_s missing"):
                    side_ok(name, side, cands[name].get(side), length)

    jab = clips.get("jab", {}).get("f01", {})
    text = open(MD_PATH, encoding="utf-8").read() if os.path.isfile(MD_PATH) else ""
    check(bool(text), "U85_GUARD_RETURN.md does not exist")
    if finite(jab.get("end_ratio")) and not (0.30 <= jab["end_ratio"] <= 0.80):
        check("realism test" in text.lower(),
              f"jab on f01 ends at {jab['end_ratio']:.2f} of its extension, but the realism test saw about 0.5 - explain it in the markdown")
    if text:
        check(any("DECISIONS" in h for h in text.lstrip().splitlines()[:6]), "the markdown does not open with DECISIONS")
        check("Menzel" in text, "the markdown does not set retract times beside Menzel's LAB numbers")


if __name__ == "__main__":
    main()
    if failures:
        for f in failures:
            print("FAIL", f)
        print(f"U85_CHECK FAIL ({len(failures)})")
        sys.exit(1)
    print("U85_CHECK PASS")

#!/usr/bin/env python
"""Q84's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/Q84_check.py

The gate never trusts a sentence. Each claim in `answers` is re-derived from the probe's own
series with thresholds computed from the scenario's own endpoints, and a claim that disagrees
with its series fails - the Q83 defect (a stated cause contradicted in the same file) cannot pass.
"""
import json
import math
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
JSON_PATH = os.path.join(ROOT, "research/Q84_blend_probe.json")
MD_PATH = os.path.join(ROOT, "research/Q84_HOW_GODOT_BLENDS.md")
TOOL = os.path.join(ROOT, "Godot/tools/probe_blend.gd")
SOURCE_RE = re.compile(r"^(scene|core|editor|servers|modules)/[\w/.-]+\.(cpp|h):\d+(-\d+)?$")
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def finite(x):
    return isinstance(x, (int, float)) and not isinstance(x, bool) and math.isfinite(x)


def series_of(scen, name, step):
    s = scen.get(name, {}).get("series", [])
    ok = (isinstance(s, list) and len(s) >= 30 and all(isinstance(p, list) and len(p) == 2 and finite(p[0]) and finite(p[1]) for p in s))
    if not check(ok, f"{name}: series missing, malformed or shorter than 30 samples"):
        return None
    check(s[0][0] < 0.0 <= s[1][0] + 1e-6, f"{name}: the series must start with one sample before the call (t<0)")
    check(s[-1][0] >= 0.6 - step, f"{name}: the series must run at least 0.6 s after the call (ends {s[-1][0]:.3f})")
    ts = [p[0] for p in s]
    check(all(b > a for a, b in zip(ts, ts[1:])), f"{name}: time does not increase")
    return s


def settle_time(s, target, tol=0.5):
    """First t >= 0 after which the angle stays within tol of target for the rest of the series."""
    last_bad = None
    for t, a in s:
        if t >= 0.0 and abs(a - target) > tol:
            last_bad = t
    if last_bad is None:
        return 0.0
    after = [t for t, _ in s if t > last_bad]
    return after[0] if after else None


def at(s, t_want):
    return min(s, key=lambda p: abs(p[0] - t_want))[1]


def main():
    check(os.path.isfile(TOOL), "Godot/tools/probe_blend.gd does not exist")
    if not check(os.path.isfile(JSON_PATH), "Q84_blend_probe.json does not exist"):
        return
    try:
        data = json.load(open(JSON_PATH, encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        check(False, f"the JSON does not parse: {exc}")
        return
    check(str(data.get("godot_version", "")).startswith("4.7.2"), f"godot_version is not 4.7.2: {data.get('godot_version')}")
    step = data.get("step_s")
    if not check(finite(step) and abs(step - 1.0 / 60.0) < 1e-4, "step_s must be 1/60"):
        return
    scen = data.get("scenarios", {})
    ans = data.get("answers", {})

    for q in ("q1", "q2", "q3", "q4", "q5", "q6", "q7"):
        a = ans.get(q, {})
        check(all(isinstance(a.get(k), str) and a.get(k).strip() for k in ("answer", "measured")), f"{q}: answer/measured missing")
        src = a.get("source", [])
        check(isinstance(src, list) and len(src) >= 1 and all(isinstance(x, str) and SOURCE_RE.match(x) for x in src),
              f"{q}: source must list engine path:line entries, got {src}")
        check(isinstance(a.get("claim"), dict) and a.get("claim"), f"{q}: claim missing")

    claim = lambda q: ans.get(q, {}).get("claim", {})  # noqa: E731

    # q1 - completion and linearity, derived from the series' own endpoints
    s1 = series_of(scen, "q1_weight_curve", step)
    if s1:
        start, blend = s1[0][1], float(scen["q1_weight_curve"].get("blend_s", 0.25))
        end = s1[-1][1]
        check(abs(start - 60.0) < 0.5 and abs(end + 60.0) < 0.5, f"q1: expected +60 -> -60, series runs {start:.2f} -> {end:.2f}")
        done = settle_time(s1, end)
        c = claim("q1")
        if check(done is not None and finite(c.get("completes_at_s")), "q1: completion not measurable or not claimed"):
            check(abs(done - c["completes_at_s"]) <= 2 * step + 1e-6,
                  f"q1: claims completion at {c['completes_at_s']:.3f} s, series settles at {done:.3f} s")
        mid = at(s1, blend / 2.0)
        linear_mid = (start + end) / 2.0
        is_linear = abs(mid - linear_mid) <= 3.0
        check(bool(c.get("linear_weight")) == is_linear,
              f"q1: claims linear_weight={c.get('linear_weight')}, but at {blend/2:.3f} s the angle is {mid:.2f} vs linear midpoint {linear_mid:.2f}")

    # q2 - does the outgoing clip advance? A frozen RAMP keeps the angle at H15's value.
    s2 = series_of(scen, "q2_outgoing_moving", step)
    if s2:
        held = s2[0][1]
        check(abs(held - 15.0) < 1.0, f"q2: the call must land at +15 deg, series starts at {held:.2f}")
        dev = max(abs(a - held) for t, a in s2 if 0.0 <= t <= 0.3)
        advances = dev > 2.0
        check(bool(claim("q2").get("outgoing_advances")) == advances,
              f"q2: claims outgoing_advances={claim('q2').get('outgoing_advances')}, series deviates {dev:.2f} deg from +15 during the blend")

    # q3 - a second play mid-blend: snap iff a step after it exceeds twice the largest step before it
    s3 = series_of(scen, "q3_second_play_mid", step)
    if s3:
        call = float(scen["q3_second_play_mid"].get("second_call_at_s", 0.10))
        pts = [p for p in s3 if p[0] >= 0.0]
        steps = [(b[0], abs(b[1] - a[1])) for a, b in zip(pts, pts[1:])]
        before = [d for t, d in steps if t <= call + 1e-6]
        after = [d for t, d in steps if call + 1e-6 < t <= call + 3 * step + 1e-6]
        if check(before and after, "q3: not enough samples around the second call"):
            snaps = max(after) > 2.0 * max(before)
            check(bool(claim("q3").get("snaps")) == snaps,
                  f"q3: claims snaps={claim('q3').get('snaps')}, largest step after the call {max(after):.2f} vs before {max(before):.2f}")

    # q4 - seek straight after play: snapped iff the first sample after is nearer RAMP(0.5)=45 than P60=60
    s4 = series_of(scen, "q4_seek_after_play", step)
    if s4:
        first_after = next(a for t, a in s4 if t > 0.0)
        snaps = abs(first_after - 60.0) > 7.5
        check(bool(claim("q4").get("snaps")) == snaps,
              f"q4: claims snaps={claim('q4').get('snaps')}, first sample after the seek is {first_after:.2f} deg")

    # q5 - speed_scale and the blend: scaled iff completion is well past blend_s
    s5 = series_of(scen, "q5_speed_scale", step)
    if s5:
        blend = float(scen["q5_speed_scale"].get("blend_s", 0.25))
        done = settle_time(s5, s5[-1][1])
        if check(done is not None, "q5: the blend never settles"):
            scaled = done > 1.5 * blend
            check(bool(claim("q5").get("blend_scaled_by_speed")) == scaled,
                  f"q5: claims blend_scaled_by_speed={claim('q5').get('blend_scaled_by_speed')}, series settles at {done:.3f} s for a {blend} s blend")

    if claim("q6").get("applies_to_bone_rotation"):
        series_of(scen, "q6_capture", step)
    check(isinstance(claim("q7").get("inertialization_present"), bool), "q7: claim.inertialization_present must be true or false")

    if check(os.path.isfile(MD_PATH), "Q84_HOW_GODOT_BLENDS.md does not exist"):
        text = open(MD_PATH, encoding="utf-8").read()
        check(any("DECISIONS" in h for h in text.lstrip().splitlines()[:6]), "the markdown does not open with DECISIONS")
        check("FightStagePlayer" in text, "the markdown does not say what this means for FightStagePlayer")


if __name__ == "__main__":
    main()
    if failures:
        for f in failures:
            print("FAIL", f)
        print(f"Q84_CHECK FAIL ({len(failures)})")
        sys.exit(1)
    print("Q84_CHECK PASS")

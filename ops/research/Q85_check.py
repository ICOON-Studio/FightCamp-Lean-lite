#!/usr/bin/env python
"""Q85's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/Q85_check.py

As Q84's gate: every claim is re-derived from the probe's own series. New: the scenario parameters
must be the TASK's (0.25 s blends, 0.30 s short clip, 0.10 default / 0.40 pair, custom speed 0.5) -
Q84 ran 0.50 s where 0.25 was asked, and a probe run at other numbers answers another question.
"""
import json
import math
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
JSON_PATH = os.path.join(ROOT, "research/Q85_playback_probe.json")
MD_PATH = os.path.join(ROOT, "research/Q85_PLAYBACK_MECHANICS.md")
TOOL = os.path.join(ROOT, "Godot/tools/probe_playback.gd")
SOURCE_RE = re.compile(r"^(scene|core|editor|servers|modules)/[\w/.-]+\.(cpp|h):\d+(-\d+)?$")
CONTRACT = {
    "q8_custom_speed": {"blend_s": 0.25, "custom_speed": 0.5},
    "q9_queue": {"blend_s": 0.25, "short_len_s": 0.30},
    "q10_pair_blend": {"default_blend_s": 0.10, "pair_blend_s": 0.40},
    "q11_outgoing_ends": {"blend_s": 0.25, "outgoing_left_s": 0.10},
    "q12_finished_signal": {"short_len_s": 0.30},
}
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def finite(x):
    return isinstance(x, (int, float)) and not isinstance(x, bool) and math.isfinite(x)


def series_of(scen, name, step):
    s = scen.get(name, {}).get("series", [])
    ok = isinstance(s, list) and len(s) >= 30 and all(isinstance(p, list) and len(p) == 2 and finite(p[0]) and finite(p[1]) for p in s)
    if not check(ok, f"{name}: series missing, malformed or shorter than 30 samples"):
        return None
    check(s[0][0] < 0.0 <= s[1][0] + 1e-6, f"{name}: the series must start with one sample before the call")
    check(s[-1][0] >= 0.6 - step, f"{name}: the series must run at least 0.6 s after the call")
    return s


def settle_time(s, target, tol=0.5):
    last_bad = None
    for t, a in s:
        if t >= 0.0 and abs(a - target) > tol:
            last_bad = t
    if last_bad is None:
        return 0.0
    after = [t for t, _ in s if t > last_bad]
    return after[0] if after else None


def main():
    check(os.path.isfile(TOOL), "Godot/tools/probe_playback.gd does not exist")
    if not check(os.path.isfile(JSON_PATH), "Q85_playback_probe.json does not exist"):
        return
    try:
        data = json.load(open(JSON_PATH, encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        check(False, f"the JSON does not parse: {exc}")
        return
    check(str(data.get("godot_version", "")).startswith("4.7.2"), "godot_version is not 4.7.2")
    step = data.get("step_s")
    if not check(finite(step) and abs(step - 1.0 / 60.0) < 1e-4, "step_s must be 1/60"):
        return
    scen, ans = data.get("scenarios", {}), data.get("answers", {})

    for name, params in CONTRACT.items():
        for k, v in params.items():
            got = scen.get(name, {}).get(k)
            check(finite(got) and abs(got - v) < 1e-6, f"{name}.{k} = {got}, the task says {v} - run the task's experiment")
    for q in ("q8", "q9", "q10", "q11", "q12"):
        a = ans.get(q, {})
        check(all(isinstance(a.get(k), str) and a.get(k).strip() for k in ("answer", "measured")), f"{q}: answer/measured missing")
        src = a.get("source", [])
        check(isinstance(src, list) and src and all(isinstance(x, str) and SOURCE_RE.match(x) for x in src), f"{q}: source must list engine path:line")
        check(isinstance(a.get("claim"), dict) and a.get("claim"), f"{q}: claim missing")
    claim = lambda q: ans.get(q, {}).get("claim", {})  # noqa: E731

    s8 = series_of(scen, "q8_custom_speed", step)
    if s8:
        done = settle_time(s8, -60.0)
        c = claim("q8")
        if check(done is not None and finite(c.get("completes_at_s")), "q8: not settled or not claimed"):
            check(abs(done - c["completes_at_s"]) <= 2 * step + 1e-6, f"q8: claims {c['completes_at_s']} s, series settles at {done:.3f} s")
            check(bool(c.get("blend_scaled_by_custom_speed")) == (done > 0.25 * 1.5),
                  f"q8: claims blend_scaled_by_custom_speed={c.get('blend_scaled_by_custom_speed')}, series settles at {done:.3f} s for a 0.25 s blend")

    s9 = series_of(scen, "q9_queue", step)
    if s9:
        frozen = sum(1 for t, a in s9 if 0.30 + step + 1e-6 < t <= 0.30 + 0.25 and abs(a - 60.0) < 0.05)
        c = claim("q9")
        check(isinstance(c.get("freeze_frames"), int) and c["freeze_frames"] == frozen,
              f"q9: claims freeze_frames={c.get('freeze_frames')}, the series holds +60 on {frozen} steps after the clip's end")
        reach = settle_time(s9, 0.0)
        if check(reach is not None, "q9: the queued loop never arrives at 0"):
            blends = reach - 0.30 > 3 * step
            check(bool(c.get("blends_in")) == blends, f"q9: claims blends_in={c.get('blends_in')}, 0 reached {reach - 0.30:.3f} s after the end")

    s10 = series_of(scen, "q10_pair_blend", step)
    if s10:
        done = settle_time(s10, -60.0)
        c = claim("q10")
        if check(done is not None and finite(c.get("completes_at_s")), "q10: not settled or not claimed"):
            check(abs(done - c["completes_at_s"]) <= 2 * step + 1e-6, f"q10: claims {c['completes_at_s']} s, series settles at {done:.3f} s")

    s11 = series_of(scen, "q11_outgoing_ends", step)
    if s11:
        pts = [p for p in s11 if p[0] >= 0.0]
        steps = [(b[0], abs(b[1] - a[1])) for a, b in zip(pts, pts[1:])]
        before = [d for t, d in steps if t <= 0.10 + 1e-6]
        during = [d for t, d in steps if 0.10 + 1e-6 < t <= 0.25 + 1e-6]
        if check(before and during, "q11: not enough samples"):
            jumps = max(during) > 2.0 * max(before)
            check(bool(claim("q11").get("jumps_when_outgoing_ends")) == jumps,
                  f"q11: claims jumps={claim('q11').get('jumps_when_outgoing_ends')}, largest step {max(during):.2f} vs before {max(before):.2f}")

    fired = scen.get("q12_finished_signal", {}).get("fired_at_s")
    c12 = claim("q12")
    check(bool(c12.get("fires")) == (fired is not None), f"q12: claims fires={c12.get('fires')} but fired_at_s is {fired}")
    if fired is not None:
        check(finite(fired) and 0.30 - step <= fired <= 0.30 + 2 * step, f"q12: fired at {fired} s for a 0.30 s clip")

    if check(os.path.isfile(MD_PATH), "Q85_PLAYBACK_MECHANICS.md does not exist"):
        text = open(MD_PATH, encoding="utf-8").read()
        check(any("DECISIONS" in h for h in text.lstrip().splitlines()[:6]), "the markdown does not open with DECISIONS")
        check("FightStagePlayer" in text, "the markdown does not say what this means for FightStagePlayer")


if __name__ == "__main__":
    main()
    if failures:
        for f in failures:
            print("FAIL", f)
        print(f"Q85_CHECK FAIL ({len(failures)})")
        sys.exit(1)
    print("Q85_CHECK PASS")

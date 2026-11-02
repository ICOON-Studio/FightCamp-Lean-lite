"""U101 gate (written by Claude, 2026-09-14). Run from the repo root: python research/U101_check.py

Pins Cursor's strike retime (TASK_U101.md, contract research/S4A_SMOOTH/RETIME_CONTRACT.md):
- wiring: FightTakeRetime.gd is a pure module (no class_name, no preload) with the contract's four static functions;
  FightStagePlayer has set_retime_options and retime_report; the room reads options["retime"]; both probes and the
  realism test accept retime_cap=;
- R0 (off) reproduces Claude's run on master: probe_spikes seed 94301 total 351, LeftHand 256, RightHand 48, take_jab
  158; realism R4 1008 of 1070, R8 123 of 551, R7 1693 / 1672 / 1359 and the same verdicts; every take's new == old;
- every variant carries the task's knobs, and every reported take's `new` is what the CONTRACT gives for its own `old` and
  `travel` (a Python reference below), starts where `old` starts, never moves a key earlier, and never goes backwards;
- travel is physical (0 <= travel < 1.5 m an interval) and f01's jab really carries its extension in one interval
  (its largest travel 0.30-0.48 m); every capped variant stretches the jab;
- recommended is the variant the task's rule picks, recomputed here;
- the digest opens with DECISIONS and is at most 20 lines.
Never edit this file to pass. If it cannot pass: no commit, send BLOCKED."""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
G = os.path.join(ROOT, "Godot")
R = os.path.join(G, "research")
SEEDS = ["94301", "51227", "77003"]
KNOBS = {"R0": (0.0, 2.5), "R1": (7.0, 2.5), "R2": (5.0, 2.5), "R3": (3.5, 2.5), "R4": (5.0, 0.0)}
FIXED = {"hold_mps": 1.5, "min_scale": 0.5, "absorb_s": 0.30}
R0_SPIKES = {"total": 351, "LeftHand": 256, "RightHand": 48, "take_jab": 158}
R0_R7 = {"94301": 1693, "51227": 1672, "77003": 1359}
R0_VERDICTS = {"R1": "FAIL", "R2": "FAIL", "R2b": "PASS", "R3": "FAIL", "R3b": "PASS", "R4": "PASS", "R5": "FAIL",
               "R5b": "FAIL", "R7": "FAIL", "R8": "FAIL"}
TAKES = ["jab", "cross", "hook_lead"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def read(rel):
    try:
        with open(os.path.join(ROOT, rel), encoding="utf-8", errors="replace") as f:
            return f.read()
    except FileNotFoundError:
        fail("%s missing" % rel)
        return ""


# ---- the contract, in Python ------------------------------------------------------------------------------------
def stretched(key_times, travel, cap_mps, spike_ratio):
    n = len(key_times) - 1
    if cap_mps <= 0.0 or n < 1 or len(travel) != n:
        return []
    out = []
    for k in range(n):
        h = key_times[k + 1] - key_times[k]
        if not (h > 0.0 and travel[k] / h > cap_mps):
            continue
        if spike_ratio > 0.0:
            neigh = []
            if k > 0:
                neigh.append(travel[k - 1])
            if k < n - 1:
                neigh.append(travel[k + 1])
            if neigh and not (travel[k] > spike_ratio * min(neigh)):
                continue
        out.append(k)
    return out


def remap(key_times, travel, cap_mps, spike_ratio, hold_mps, min_scale, absorb_s):
    st = stretched(key_times, travel, cap_mps, spike_ratio)
    if not st:
        return list(key_times)
    n = len(key_times) - 1
    s = min(max(min_scale, 0.05), 1.0)
    h = [key_times[k + 1] - key_times[k] for k in range(n)]
    d = list(h)
    for k in st:
        d[k] = travel[k] / cap_mps
    sset = set(st)
    for k in st:
        extra = d[k] - h[k]
        j = k + 1
        while extra > 0.0 and j < n and key_times[j] < key_times[k + 1] + absorb_s:
            if j not in sset and h[j] > 0.0 and travel[j] / h[j] < hold_mps:
                take = min(extra, d[j] - s * h[j])
                if take > 0.0:
                    d[j] -= take
                    extra -= take
            j += 1
    out = [key_times[0]]
    for k in range(n):
        out.append(out[-1] + d[k])
    return out


# ---- wiring -----------------------------------------------------------------------------------------------------
module = read("Godot/scripts/FightTakeRetime.gd")
if module:
    if re.search(r"^\s*class_name\b", module, re.M):
        fail("FightTakeRetime.gd declares a class_name (the contract says none)")
    if "preload(" in module:
        fail("FightTakeRetime.gd preloads something (the contract says zero preloads)")
    for sig in ("static func stretched(", "static func remap(", "static func map_time(", "static func apply("):
        if sig not in module:
            fail("FightTakeRetime.gd lacks `%s`" % sig)
player = read("Godot/scripts/FightStagePlayer.gd")
for sig in ("func set_retime_options(", "func retime_report("):
    if sig not in player:
        fail("FightStagePlayer.gd lacks `%s`" % sig)
room = read("Godot/scripts/FightWorldLiveScreen.gd")
if not re.search(r'options\.get\(\s*"retime"', room):
    fail("FightWorldLiveScreen.configure does not read options[\"retime\"]")
for rel in ("Godot/tools/probe_spikes.gd", "Godot/tools/probe_clip_keys.gd", "Godot/tests/fight_stage_realism_test.gd"):
    if "retime_cap=" not in read(rel):
        fail("%s does not accept `retime_cap=`" % rel)

# ---- the record -------------------------------------------------------------------------------------------------
try:
    data = json.load(open(os.path.join(R, "U101_retime.json"), encoding="utf-8"))
except Exception as exc:  # noqa: BLE001
    fail("U101_retime.json unreadable: %s" % exc)
    print("U101_CHECK FAIL %d" % len(fails))
    sys.exit(1)

pop = data.get("population", {})
if [str(s) for s in pop.get("seeds", [])] != SEEDS or int(pop.get("rounds", 0)) != 3 or str(pop.get("spikes_seed")) != "94301":
    fail("population must be seeds %s, 3 rounds, spikes_seed 94301: %s" % (SEEDS, pop))
fixed = data.get("fixed", {})
for key, value in FIXED.items():
    if abs(float(fixed.get(key, -1)) - value) > 1e-9:
        fail("fixed.%s must be %s: %s" % (key, value, fixed.get(key)))

variants = {str(v.get("name")): v for v in data.get("variants", [])}
if sorted(variants) != sorted(KNOBS):
    fail("variants must be exactly %s, got %s" % (sorted(KNOBS), sorted(variants)))

complete = True
for name, (cap, ratio) in KNOBS.items():
    v = variants.get(name)
    if v is None:
        complete = False
        continue
    if abs(float(v.get("cap_mps", -1)) - cap) > 1e-9 or abs(float(v.get("spike_ratio", -1)) - ratio) > 1e-9:
        fail("%s must be cap %.1f ratio %.1f: %s / %s" % (name, cap, ratio, v.get("cap_mps"), v.get("spike_ratio")))
    try:
        for key in ("total", "LeftHand", "RightHand", "take_jab", "take_cross", "take_hook_lead"):
            if int(v["spikes"][key]) < 0:
                fail("%s spikes.%s is negative" % (name, key))
        for take in TAKES:
            row = v["takes_f01"][take]
            old = [float(x) for x in row["old"]]
            new = [float(x) for x in row["new"]]
            travel = [float(x) for x in row["travel"]]
            if len(old) < 2 or len(new) != len(old) or len(travel) != len(old) - 1:
                fail("%s %s: sizes old %d new %d travel %d" % (name, take, len(old), len(new), len(travel)))
                continue
            if any(not (0.0 <= t < 1.5) for t in travel):
                fail("%s %s: a travel outside [0, 1.5) m: %s" % (name, take, max(travel)))
            want = remap(old, travel, cap, ratio, FIXED["hold_mps"], FIXED["min_scale"], FIXED["absorb_s"])
            worst = max(abs(a - b) for a, b in zip(new, want))
            if worst > 1e-4:
                fail("%s %s: new differs from the contract by %.6f s (first keys %s vs %s)" % (
                    name, take, worst, [round(x, 4) for x in new[:8]], [round(x, 4) for x in want[:8]]))
            if abs(new[0] - old[0]) > 1e-9 or any(b < a - 1e-6 for a, b in zip(old, new)) or any(
                    new[i + 1] < new[i] - 1e-9 for i in range(len(new) - 1)):
                fail("%s %s: new starts elsewhere, moves a key earlier, or goes backwards" % (name, take))
            length = float(row["length_s"])
            contact = float(row["contact_s"])
            if not (0.0 <= contact <= length + 1e-6):
                fail("%s %s: contact_s %.3f outside [0, length %.3f]" % (name, take, contact, length))
            if take == "jab":
                if not (0.30 <= max(travel) <= 0.48):
                    fail("%s f01 jab's largest interval travel %.3f m is not the one-interval extension (0.30-0.48)" % (name, max(travel)))
                if cap > 0.0 and max(abs(a - b) for a, b in zip(old, new)) < 1e-4:
                    fail("%s (cap %.1f) did not stretch the jab" % (name, cap))
            if cap <= 0.0 and max(abs(a - b) for a, b in zip(old, new)) > 1e-9:
                fail("R0 (off) moved %s's keys" % take)
        real = v["realism"]
        for key in ("R4_pass", "R4_exits", "R8_reached", "R8_landed"):
            int(real[key])
        float(real["R3_mean_mps"])
        for s in SEEDS:
            int(real["R7_violating_frames"][s])
        for rule in R0_VERDICTS:
            if str(real["verdicts"].get(rule, "")) not in ("PASS", "FAIL"):
                fail("%s verdicts lack %s" % (name, rule))
    except (KeyError, TypeError, ValueError) as exc:
        complete = False
        fail("%s row incomplete: %r" % (name, exc))

if complete and "R0" in variants:
    r0 = variants["R0"]
    for key, value in R0_SPIKES.items():
        if int(r0["spikes"][key]) != value:
            fail("R0 spikes.%s %s != %d (Claude's probe_spikes run on master)" % (key, r0["spikes"][key], value))
    real0 = r0["realism"]
    if (int(real0["R4_pass"]), int(real0["R4_exits"])) != (1008, 1070):
        fail("R0 R4 %s of %s != 1008 of 1070" % (real0["R4_pass"], real0["R4_exits"]))
    if (int(real0["R8_reached"]), int(real0["R8_landed"])) != (123, 551):
        fail("R0 R8 %s of %s != 123 of 551" % (real0["R8_reached"], real0["R8_landed"]))
    for s in SEEDS:
        if int(real0["R7_violating_frames"][s]) != R0_R7[s]:
            fail("R0 R7[%s] %s != %d" % (s, real0["R7_violating_frames"][s], R0_R7[s]))
    for rule, verdict in R0_VERDICTS.items():
        if str(real0["verdicts"].get(rule)) != verdict:
            fail("R0 %s verdict %s != %s" % (rule, real0["verdicts"].get(rule), verdict))
    floor = 0.9 * int(real0["R8_reached"])
    eligible = [n for n, v in variants.items()
                if str(v["realism"]["verdicts"].get("R4")) == "PASS" and int(v["realism"]["R8_reached"]) >= floor]
    want_name = min(eligible, key=lambda n: (int(variants[n]["spikes"]["total"]), n)) if eligible else None
    if str(data.get("recommended")) != str(want_name):
        fail("recommended %s, the task's rule picks %s (eligible %s)" % (data.get("recommended"), want_name, eligible))
    print("INFO spikes total: " + ", ".join("%s %d" % (n, int(variants[n]["spikes"]["total"])) for n in sorted(variants)))
    print("INFO jab spikes: " + ", ".join("%s %d" % (n, int(variants[n]["spikes"]["take_jab"])) for n in sorted(variants)))

try:
    lines = open(os.path.join(R, "U101_RETIME.md"), encoding="utf-8").read().splitlines()
    body = [l for l in lines if l.strip()]
    if not body or body[0].strip() != "## DECISIONS":
        fail("U101_RETIME.md must open with ## DECISIONS")
    if len(lines) > 20:
        fail("U101_RETIME.md is %d lines (20 at most)" % len(lines))
except FileNotFoundError:
    fail("U101_RETIME.md missing")

if fails:
    print("U101_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("U101_CHECK PASS recommended=%s" % data.get("recommended"))

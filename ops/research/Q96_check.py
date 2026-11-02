"""Q96 gate (written by Claude before launch). Run from the repo root: python research/Q96_check.py

Q94B found the engine throws footwork and range reads as actions and 1,480 of the out-boxer's 2,655 of them LAND
(U79's defect, never fixed). Q96 measures what that does to a bout: the same 30 bouts with every non-blow removed from
both men's arsenals after `begin`, against the unchanged engine. Nothing here trusts Qwen's numbers:
- the baseline must equal Q94B's merged figures EXACTLY (same engine, same fixture) - the tool may not read them;
- which techniques are non-blows is read from U79's census here, not typed;
- the no_setups variant may contain no non-blow technique and no setup at all;
- decision bouts count exactly rounds x round_seconds; methods and winners each sum to the 30 bouts.
"""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GODOT = ROOT / "Godot"
TOOL = GODOT / "tools" / "measure_phantom_landings.gd"
JSON_PATH = GODOT / "research" / "Q96_phantom_landings.json"
MD_PATH = GODOT / "research" / "Q96_PHANTOM_LANDINGS.md"
Q94 = GODOT / "research" / "Q94_engine_pace.json"
CENSUS = GODOT / "research" / "U79_admitted_strikes.json"
SIDE_KEYS = ["actions", "strikes_thrown", "strikes_landed", "setups", "setups_landed"]

failures = []


def fail(msg):
    failures.append(msg)
    print("FAIL:", msg)


def near(a, b, rel=0.005, absolute=1e-6):
    return abs(float(a) - float(b)) <= max(absolute, rel * max(abs(float(a)), abs(float(b))))


def main():
    for p in (TOOL, JSON_PATH, MD_PATH, Q94, CENSUS):
        if not p.is_file():
            fail("missing %s" % p.relative_to(ROOT))
    if failures:
        return finish()
    tool = TOOL.read_text(encoding="utf-8")
    for banned in ("Q94_engine_pace", "Q94_ENGINE_PACE", "Q88_engine_rhythm"):
        if banned in tool:
            fail("the tool names %s - it must measure, not copy" % banned)
    for needed in ("run_to_completion", "demo_fighter", "U79_admitted_strikes.json", "arsenal", "Q96_phantom_landings.json"):
        if needed not in tool:
            fail("the tool does not contain %r" % needed)
    census = {str(r.get("id")): bool(r.get("delivers_blow")) for r in
              json.loads(CENSUS.read_text(encoding="utf-8")).get("rows", []) if r.get("id")}
    q94 = json.loads(Q94.read_text(encoding="utf-8"))["pooled"]
    data = json.loads(JSON_PATH.read_text(encoding="utf-8"))
    pop = data.get("population", {})
    if pop.get("ruleset") != "boxing" or sorted(int(s) for s in pop.get("seeds", [])) != list(range(900, 930)):
        fail("population must be boxing, seeds 900..929 (Q94B's fixture)")
    styles = [str(f.get("style", "")) for f in pop.get("fighters", [])]
    if len(styles) != 2 or not all(styles) or styles[0] == styles[1]:
        fail("population.fighters must be two men with two named, different styles")
    full = int(pop.get("rounds", 0)) * float(pop.get("round_seconds", 0.0))
    variants = data.get("variants", {})
    if set(variants.keys()) != {"baseline", "no_setups"}:
        fail("variants must be exactly baseline and no_setups")
        return finish()
    bouts = data.get("bouts", [])
    for name, v in variants.items():
        rows = [b for b in bouts if b.get("variant") == name]
        if len(rows) != 30:
            fail("%s has %d bout rows, 30 expected" % (name, len(rows)))
        counted = 0.0
        for b in rows:
            secs = float(b.get("round_seconds_counted", -1))
            counted += secs
            if str(b.get("method", "")).lower() in ("decision", "draw") and abs(secs - full) > 0.11:
                fail("%s seed %s went the distance but counts %.2f s, not %.0f" % (name, b.get("seed"), secs, full))
        if not near(v.get("round_minutes", -1), counted / 60.0, rel=0.0005, absolute=0.01):
            fail("%s.round_minutes != the bouts' counted round time" % name)
        if sum(int(x) for x in v.get("methods", {}).values()) != 30:
            fail("%s.methods do not sum to 30" % name)
        if sum(int(x) for x in v.get("winners", {}).values()) != 30:
            fail("%s.winners do not sum to 30" % name)
        rm = float(v.get("round_minutes", 0.0))
        for side in ("a", "b"):
            s = v.get(side, {})
            for key in SIDE_KEYS + ["strikes_thrown_per_min", "strikes_landed_per_min"]:
                if key not in s:
                    fail("%s.%s lacks %s" % (name, side, key))
            if failures:
                return finish()
            if rm > 0 and not near(s["strikes_thrown_per_min"], int(s["strikes_thrown"]) / rm):
                fail("%s.%s.strikes_thrown_per_min != strikes_thrown / round_minutes" % (name, side))
            if rm > 0 and not near(s["strikes_landed_per_min"], int(s["strikes_landed"]) / rm):
                fail("%s.%s.strikes_landed_per_min != strikes_landed / round_minutes" % (name, side))
            by_kind = v.get("by_kind", {}).get(side, {})
            if sum(int(x) for x in by_kind.values()) != int(s["actions"]):
                fail("%s.by_kind.%s does not sum to actions" % (name, side))
            for tech in by_kind:
                if tech not in census:
                    fail("%s: %r is not in U79's census" % (name, tech))
                elif name == "no_setups" and not census[tech]:
                    fail("no_setups still throws the non-blow %r" % tech)
            if name == "no_setups" and (int(s["setups"]) != 0 or int(s["setups_landed"]) != 0):
                fail("no_setups.%s still has setups (%s, landed %s)" % (side, s["setups"], s["setups_landed"]))
            if name == "baseline":
                for key in SIDE_KEYS:
                    if int(s[key]) != int(q94[side][key]):
                        fail("baseline.%s.%s %s != Q94B's %s on the unchanged engine - STOP and report, do not adjust"
                             % (side, key, s[key], q94[side][key]))
    md = MD_PATH.read_text(encoding="utf-8").splitlines()
    if next((l for l in md if l.strip()), "").strip() != "## DECISIONS":
        fail("the digest does not open with ## DECISIONS")
    if len(md) > 30:
        fail("the digest is %d lines, 30 at most" % len(md))
    text = "\n".join(md)
    for style in styles:
        if style and style.lower() not in text.lower():
            fail("the digest does not name the population style %r" % style)
    figure = "%.1f" % float(variants["no_setups"]["a"]["strikes_thrown_per_min"])
    if figure not in text:
        fail("the digest does not print the out-boxer's no_setups strikes thrown a minute (%s)" % figure)
    return finish()


def finish():
    if failures:
        print("Q96_check: %d failure(s)" % len(failures))
        sys.exit(1)
    print("Q96_check: PASS")
    sys.exit(0)


if __name__ == "__main__":
    main()

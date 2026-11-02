"""Q94 gate (written by Claude before launch). Run from the repo root: python research/Q94_check.py [--q88 APM]

Q94 splits the realtime engine's boxing pace (Q88: 90.05 actions a minute for the pair) by what the actions are,
and maps what spaces them. Nothing here trusts Qwen's totals:
- a decision bout must count exactly rounds * round_seconds of round time (physics of the clock, not the tool);
- the per-bout counts, the per-kind counts and the per-fighter totals must all agree with each other;
- every cadence quote must really sit within 3 lines of its cited line, and every const must be declared there
  with the cited value;
- the tool may not read Q88's files, and must run the engine itself;
- at collection Claude passes --q88 with the figure Q88's own tool prints on the same tree: pair actions_per_min
  must match it within 1%. Without --q88 that pin is reported PENDING and does not fail.
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GODOT = ROOT / "Godot"
JSON_PATH = GODOT / "research" / "Q94_engine_pace.json"
MD_PATH = GODOT / "research" / "Q94_ENGINE_PACE.md"
TOOL = GODOT / "tools" / "measure_engine_pace.gd"

failures = []


def fail(msg):
    failures.append(msg)
    print("FAIL:", msg)


def near(a, b, rel=0.005, absolute=1e-6):
    return abs(float(a) - float(b)) <= max(absolute, rel * max(abs(float(a)), abs(float(b))))


def check_side(name, side, round_minutes, is_pair):
    keys = ["actions", "actions_per_min", "by_kind", "intervals_s"]
    if not is_pair:
        keys += ["strikes_thrown", "strikes_landed", "strikes_thrown_per_min", "strikes_landed_per_min"]
    for key in keys:
        if key not in side:
            fail("pooled.%s lacks %s" % (name, key))
            return
    actions = int(side["actions"])
    if actions <= 0:
        fail("pooled.%s.actions is %d" % (name, actions))
    by_kind = side["by_kind"]
    if not isinstance(by_kind, dict) or not by_kind:
        fail("pooled.%s.by_kind is empty" % name)
    elif sum(int(v) for v in by_kind.values()) != actions:
        fail("pooled.%s.by_kind sums to %d, actions is %d" % (name, sum(int(v) for v in by_kind.values()), actions))
    if round_minutes > 0 and not near(side["actions_per_min"], actions / round_minutes):
        fail("pooled.%s.actions_per_min %.3f != actions / round_minutes %.3f"
             % (name, float(side["actions_per_min"]), actions / round_minutes))
    iv = side["intervals_s"]
    try:
        if not (0.0 < float(iv["p10"]) <= float(iv["p50"]) <= float(iv["p90"])) or float(iv["mean"]) <= 0.0:
            fail("pooled.%s.intervals_s is not ordered and positive: %s" % (name, iv))
    except (KeyError, TypeError, ValueError):
        fail("pooled.%s.intervals_s lacks p10/p50/p90/mean" % name)
    if not is_pair:
        thrown = int(side["strikes_thrown"])
        landed = int(side["strikes_landed"])
        if landed > thrown or thrown <= 0:
            fail("pooled.%s strikes: thrown %d, landed %d" % (name, thrown, landed))
        if round_minutes > 0 and not near(side["strikes_thrown_per_min"], thrown / round_minutes):
            fail("pooled.%s.strikes_thrown_per_min does not equal thrown / round_minutes" % name)
        if round_minutes > 0 and not near(side["strikes_landed_per_min"], landed / round_minutes):
            fail("pooled.%s.strikes_landed_per_min does not equal landed / round_minutes" % name)


def check_cadence(cadence):
    rows = cadence.get("rows", []) if isinstance(cadence, dict) else []
    if len(rows) < 3:
        fail("cadence.rows has %d rows; at least 3 expected" % len(rows))
    for i, row in enumerate(rows):
        for key in ("file", "line", "quote", "const", "value", "what"):
            if key not in row:
                fail("cadence row %d lacks %s" % (i, key))
                break
        else:
            path = ROOT / str(row["file"])
            if not path.is_file():
                fail("cadence row %d: no file %s" % (i, row["file"]))
                continue
            lines = path.read_text(encoding="utf-8").splitlines()
            line_no = int(row["line"])
            quote = str(row["quote"]).strip()
            window = lines[max(0, line_no - 4):line_no + 3]
            if not quote or not any(quote in w for w in window):
                fail("cadence row %d: quote %r is not within 3 lines of %s:%d" % (i, quote, row["file"], line_no))
            const = str(row["const"]).strip()
            if const:
                decl = [l for l in lines if re.match(r"\s*const\s+%s\b" % re.escape(const), l)]
                if not decl:
                    fail("cadence row %d: const %s is not declared in %s" % (i, const, row["file"]))
                elif str(row["value"]).strip() and str(row["value"]).strip() not in decl[0]:
                    fail("cadence row %d: const %s is declared as %r, not %r"
                         % (i, const, decl[0].strip(), row["value"]))
    drivers = cadence.get("drivers", []) if isinstance(cadence, dict) else []
    if not 1 <= len(drivers) <= 3:
        fail("cadence.drivers has %d entries; 1 to 3 expected" % len(drivers))
    for d in drivers:
        if not isinstance(d, dict) or not 0 <= int(d.get("row", -1)) < len(rows) or not str(d.get("why", "")).strip():
            fail("cadence driver %r does not name a row and a reason" % d)


def main():
    q88 = None
    if "--q88" in sys.argv:
        q88 = float(sys.argv[sys.argv.index("--q88") + 1])
    for p in (JSON_PATH, MD_PATH, TOOL):
        if not p.is_file():
            fail("missing %s" % p.relative_to(ROOT))
    if failures:
        return finish()
    tool = TOOL.read_text(encoding="utf-8")
    for banned in ("Q88_engine_rhythm", "Q88_ENGINE_RHYTHM"):
        if banned in tool:
            fail("the tool names %s - it must measure, not read Q88" % banned)
    for needed in ("run_to_completion", "demo_fighter", "Q94_engine_pace.json"):
        if needed not in tool:
            fail("the tool does not contain %r" % needed)

    data = json.loads(JSON_PATH.read_text(encoding="utf-8"))
    pop = data.get("population", {})
    if pop.get("ruleset") != "boxing":
        fail("population.ruleset is %r" % pop.get("ruleset"))
    seeds = pop.get("seeds", [])
    if sorted(int(s) for s in seeds) != list(range(900, 930)):
        fail("population.seeds are not the 30 seeds 900..929")
    fighters = pop.get("fighters", [])
    styles = [str(f.get("style", "")).strip() for f in fighters]
    if len(fighters) != 2 or not all(styles) or styles[0] == styles[1]:
        fail("population.fighters must be two men with two different, named styles: %s" % fighters)
    rounds = int(pop.get("rounds", 0))
    round_seconds = float(pop.get("round_seconds", 0.0))
    full = rounds * round_seconds
    if full <= 0:
        fail("population rounds/round_seconds missing")

    bouts = data.get("bouts", [])
    if len(bouts) != 30:
        fail("bouts has %d rows, 30 expected" % len(bouts))
    counted = 0.0
    sum_a = 0
    sum_b = 0
    for b in bouts:
        secs = float(b.get("round_seconds_counted", -1))
        counted += secs
        sum_a += int(b.get("actions_a", 0))
        sum_b += int(b.get("actions_b", 0))
        method = str(b.get("method", "")).lower()
        if method in ("decision", "draw"):
            if abs(secs - full) > 0.11:
                fail("seed %s went the distance (%s) but counts %.2f s of round time, not %.0f"
                     % (b.get("seed"), method, secs, full))
        elif not 0.0 < secs < full:
            fail("seed %s ended by %s but counts %.2f s of round time" % (b.get("seed"), method, secs))

    pooled = data.get("pooled", {})
    round_minutes = float(pooled.get("round_minutes", 0.0))
    if not near(round_minutes, counted / 60.0, rel=0.0005, absolute=0.01):
        fail("pooled.round_minutes %.3f != the bouts' counted round time %.3f min" % (round_minutes, counted / 60.0))
    for name in ("a", "b", "pair"):
        if name not in pooled:
            fail("pooled lacks %s" % name)
    if failures:
        return finish()
    check_side("a", pooled["a"], round_minutes, False)
    check_side("b", pooled["b"], round_minutes, False)
    check_side("pair", pooled["pair"], round_minutes, True)
    if int(pooled["a"]["actions"]) != sum_a or int(pooled["b"]["actions"]) != sum_b:
        fail("pooled a/b actions (%s, %s) != the bouts' sums (%d, %d)"
             % (pooled["a"]["actions"], pooled["b"]["actions"], sum_a, sum_b))
    pair = pooled["pair"]
    if int(pooled["a"]["actions"]) + int(pooled["b"]["actions"]) + int(pair.get("unattributed", -1)) \
            != int(pair["actions"]):
        fail("a + b + unattributed != pair actions")
    tops = pooled.get("top_techniques", [])
    if not 1 <= len(tops) <= 15:
        fail("top_techniques has %d rows" % len(tops))
    for t in tops:
        if int(t.get("landed", 0)) > int(t.get("thrown", 0)):
            fail("technique %s lands more than it throws" % t.get("technique"))
    spell = pooled.get("per_spell", {})
    if abs(float(spell.get("merge_s", -1)) - 0.3) > 1e-9 or int(spell.get("spells", 0)) <= 0 \
            or float(spell.get("actions_mean", 0)) < 1.0:
        fail("per_spell is missing, not at merge_s 0.3, or holds under one action a spell: %s" % spell)
    elif not 0.0 <= float(spell.get("share_a", -1)) <= 1.0:
        fail("per_spell.share_a is not a share")

    check_cadence(data.get("cadence", {}))

    md = MD_PATH.read_text(encoding="utf-8").splitlines()
    first = next((l for l in md if l.strip()), "")
    if first.strip() != "## DECISIONS":
        fail("the digest does not open with ## DECISIONS")
    if len(md) > 40:
        fail("the digest is %d lines, 40 at most" % len(md))
    text = "\n".join(md).lower()
    for style in styles:
        if style and style.lower() not in text:
            fail("the digest does not name the population style %r" % style)

    apm = float(pair["actions_per_min"])
    if q88 is None:
        print("PENDING: Claude re-runs tools/measure_engine_rhythm.gd at collection; pair actions_per_min = %.2f" % apm)
    elif not near(apm, q88, rel=0.01):
        fail("pair actions_per_min %.2f is not within 1%% of Q88's re-run %.2f" % (apm, q88))
    return finish()


def finish():
    if failures:
        print("Q94_check: %d failure(s)" % len(failures))
        sys.exit(1)
    print("Q94_check: PASS")
    sys.exit(0)


if __name__ == "__main__":
    main()

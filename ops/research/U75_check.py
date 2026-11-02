#!/usr/bin/env python
"""U75's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/U75_check.py

U75 answers, for each of the engine's eleven rulesets, which body regions a PUNCH and a
KICK may legally reach, from the sourced competition rules already on disk - and sets it
against what the engine allows today. This gate does not decide a verdict. It checks the
table covers every ruleset, quotes its evidence verbatim, recomputes the engine columns
from the code, holds the anchors the on-disk rules state outright, and derives the list
of adjudicated leg kicks that would land illegally.
"""
import json
import os
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:  # noqa: BLE001
    pass

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
GODOT = os.path.join(ROOT, "Godot")
RESEARCH = os.path.join(GODOT, "research")
DATA = os.path.join(GODOT, "assets", "data")
REGIONS = ("head_neck", "torso_core", "legs")
VERDICTS = ("legal", "legal_by_exclusion", "illegal", "not_applicable", "not_on_disk")
ENGINE_REGIONS = ("head_neck", "torso_core", "left_leg", "right_leg", "left_arm", "right_arm")
# Which competition-ruleset `discipline` values may stand behind each engine ruleset.
FAMILY = {"mma": "mma", "boxing": "boxing", "kickboxing": "kickboxing", "muay_thai": "muay_thai",
          "judo": "judo", "freestyle_wrestling": "wrestling", "greco_roman": "wrestling",
          "karate": "karate", "bjj": "bjj", "sambo": "sambo", "taekwondo": "taekwondo"}
LEGAL = ("legal", "legal_by_exclusion")

failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def gd_block(text, name):
    """The `{ ... }` literal of `const <name> := {`, brace-matched."""
    start = text.index("const %s := {" % name) + len("const %s := " % name)
    depth = 0
    for index in range(start, len(text)):
        if text[index] == "{":
            depth += 1
        elif text[index] == "}":
            depth -= 1
            if depth == 0:
                return text[start:index + 1]
    raise ValueError(name)


def number(expr):
    expr = expr.strip()
    if not re.fullmatch(r"[0-9.\s/*+-]+", expr):
        raise ValueError(expr)
    return float(eval(expr))  # noqa: S307 - digits and operators only, checked above


def weights(literal):
    return {k: round(number(v), 4) for k, v in re.findall(r'"(\w+)"\s*:\s*([0-9.\s/*+-]+?)\s*,?\s*(?:\n|$)', literal)}


def engine_realtime():
    text = open(os.path.join(GODOT, "scripts", "FightRealtime.gd"), encoding="utf-8").read()
    default = weights(gd_block(text, "TARGET_WEIGHTS"))
    by_ruleset = {}
    body = gd_block(text, "TARGET_WEIGHTS_BY_RULESET")[1:-1]
    for rid, rest in re.findall(r'"(\w+)"\s*:\s*(\{[^}]*\}|TARGET_WEIGHTS)', body):
        by_ruleset[rid] = default if rest == "TARGET_WEIGHTS" else weights(rest)
    return default, by_ruleset


def strings(value):
    if isinstance(value, str):
        yield value
    elif isinstance(value, list):
        for item in value:
            yield from strings(item)
    elif isinstance(value, dict):
        for item in value.values():
            yield from strings(item)


def main():
    combat = json.load(open(os.path.join(DATA, "combat_rulesets.json"), encoding="utf-8"))["rulesets"]
    engine_ids = [r["id"] for r in combat]
    competition = {r["id"]: r for r in json.load(open(os.path.join(DATA, "competition_rulesets_v2.json"), encoding="utf-8"))["rulesets"]}
    catalogue = json.load(open(os.path.join(DATA, "technique_catalog.json"), encoding="utf-8"))
    known = [d["id"] for d in catalogue["disciplines"]]
    moves = open(os.path.join(GODOT, "scripts", "FightMoves.gd"), encoding="utf-8").read()
    aliases = dict(re.findall(r'"(\w+)"\s*:\s*"(\w+)"', gd_block(moves, "DISCIPLINE_TAG_ALIASES")))
    default, by_ruleset = engine_realtime()

    json_path = os.path.join(RESEARCH, "U75_strike_target_legality.json")
    md_path = os.path.join(RESEARCH, "U75_STRIKE_TARGET_LEGALITY.md")
    check(os.path.exists(json_path), "U75_strike_target_legality.json exists")
    check(os.path.exists(md_path), "U75_STRIKE_TARGET_LEGALITY.md exists")
    if failures:
        return 1
    try:
        table = json.load(open(json_path, encoding="utf-8"))
        rows = table["rulesets"]
    except Exception as error:  # noqa: BLE001
        check(False, "the JSON loads and carries `rulesets` (%s)" % error)
        return 1
    report = open(md_path, encoding="utf-8").read()

    ids = [r.get("engine_ruleset") for r in rows]
    check(sorted(ids) == sorted(engine_ids) and len(ids) == len(set(ids)),
          "one row per engine ruleset in combat_rulesets.json (%s)" % ", ".join(engine_ids))
    fields = ("engine_ruleset", "disciplines", "competition_rulesets", "punch", "kick", "evidence",
              "engine_realtime", "engine_realtime_source", "mismatches")
    for field in fields:
        check(all(field in r for r in rows), "every row carries `%s`" % field)
    if failures:
        return 1
    by_id = {r["engine_ruleset"]: r for r in rows}

    for rid in engine_ids:
        row = by_id[rid]
        tags = next(r for r in combat if r["id"] == rid).get("discipline_tags", [])
        expected = []
        for tag in tags:
            resolved = aliases.get(tag, tag)
            if resolved in known and resolved not in expected:
                expected.append(resolved)
        check(row["disciplines"] == expected, "%s: disciplines are what FightMoves.disciplines_for resolves (%s)" % (rid, expected))

        comp = row["competition_rulesets"]
        check(bool(comp) and all(c in competition for c in comp), "%s: names at least one competition ruleset, all real" % rid)
        check(all(competition.get(c, {}).get("discipline") == FAMILY[rid] for c in comp),
              "%s: every competition ruleset is of the %s family" % (rid, FAMILY[rid]))

        for strike in ("punch", "kick"):
            verdicts = row[strike]
            check(isinstance(verdicts, dict) and sorted(verdicts) == sorted(REGIONS) and all(v in VERDICTS for v in verdicts.values()),
                  "%s: %s has a verdict in %s for each of %s" % (rid, strike, VERDICTS, REGIONS))

        evidence = row["evidence"]
        quoted = True
        for entry in evidence if isinstance(evidence, list) else []:
            source = competition.get(entry.get("competition_ruleset"), {})
            ok = (entry.get("competition_ruleset") in comp and entry.get("field") in source
                  and any(str(entry.get("quote", "@@")) in text for text in strings(source[entry["field"]])))
            quoted = quoted and ok and bool(str(entry.get("quote", "")).strip())
        check(isinstance(evidence, list) and quoted, "%s: every evidence quote is verbatim from a named field of one of its competition rulesets" % rid)
        decided = [v for s in ("punch", "kick") for v in row[s].values() if v in ("legal", "illegal", "legal_by_exclusion")]
        check(not decided or evidence, "%s: a legal / illegal verdict carries at least one evidence quote" % rid)

        real = by_ruleset.get(rid, default)
        source_name = "TARGET_WEIGHTS_BY_RULESET" if rid in by_ruleset else "TARGET_WEIGHTS default"
        given = {k: round(float(v), 4) for k, v in (row["engine_realtime"] or {}).items()}
        check(given == {k: real[k] for k in ENGINE_REGIONS}, "%s: engine_realtime equals FightRealtime.gd (%s)" % (rid, source_name))
        check(row["engine_realtime_source"] == source_name, "%s: engine_realtime_source is `%s`" % (rid, source_name))

    def verdict(rid, strike, region):
        return by_id.get(rid, {}).get(strike, {}).get(region)

    check(all(verdict("boxing", "kick", r) == "not_applicable" for r in REGIONS), "anchor: boxing has no kicks")
    check(verdict("boxing", "punch", "legs") == "illegal", "anchor: a boxing punch below the belt is illegal")
    check(verdict("muay_thai", "kick", "legs") in LEGAL, "anchor: a muay thai kick may reach the legs")
    check(verdict("mma", "kick", "legs") in LEGAL, "anchor: an MMA kick may reach the legs")
    check(verdict("taekwondo", "kick", "legs") == "illegal", "anchor: WT - kicking below the waist is a foul")
    check(verdict("taekwondo", "punch", "head_neck") == "illegal", "anchor: WT - a punch to the head is illegal")
    for rid in ("bjj", "judo"):
        check(all(verdict(rid, s, r) == "not_applicable" for s in ("punch", "kick") for r in REGIONS), "anchor: %s has no strikes" % rid)

    q70 = json.load(open(os.path.join(RESEARCH, "Q70_kick_targets.json"), encoding="utf-8"))
    expected_illegal = sorted({(row["id"], row["discipline"], rid)
                               for row in q70["rows"] if row.get("target") == "leg"
                               for rid in engine_ids
                               if row["discipline"] in by_id[rid]["disciplines"] and verdict(rid, "kick", "legs") == "illegal"})
    given_illegal = sorted({(e.get("id"), e.get("discipline"), e.get("engine_ruleset")) for e in table.get("illegal_leg_targets", [])})
    check(given_illegal == expected_illegal, "illegal_leg_targets is every Q70 leg kick under a ruleset whose kicks may not reach the legs (%d)" % len(expected_illegal))
    check(str(table.get("recommend", "")) in ("a", "b", "c"), "`recommend` is a, b or c")

    upper = report.upper()
    for section in ("KICKBOXING", "THE ENGINE TODAY", "OPTIONS"):
        check(section in upper, "the report has a %s section" % section)
    check("FightSimulation" in report, "the report says what FightSimulation's resolver enforces")

    print("U75_CHECK rulesets=%d illegal_leg_targets=%d failures=%d" % (len(rows), len(expected_illegal), len(failures)))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())

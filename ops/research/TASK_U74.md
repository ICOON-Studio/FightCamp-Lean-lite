# TASK U74 - CURSOR - A LANDED JUDO THROW IS NEARLY ALWAYS A SCORE

Model: Composer, **medium effort**. Owner: cursor. Launched `-p --force --trust`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Claude is running the full
suite in this checkout. Your gate is a Python script that MUST exit 0.

## Owned files

- `research/U74_judo_throw_scores.json` - **NEW, yours alone.**
- `research/U74_JUDO_THROWS_OVERSCORE.md` - **NEW, yours alone.**

Nothing else. Do NOT edit any script, test, catalogue, `combat_rulesets.json`,
`U74_check.py`, `HANDOFF.md` or `AgentComms/roadmap.json`.

## Why this exists - measured in S1e

S1e built judo's osaekomi and matte and measured judo with its ground seated (see
`unseated_debt.judo` in `Godot/assets/data/technique_vocabulary.json`). Once the ground is
real and matte returns the fight to its feet, **27 of 40 bouts end in ippon against the
46.2% senior-Worlds anchor** (`research/J26_IJF_MATTE_AND_ENDINGS.md:58-62`). One
of the two reasons: a throw that lands nearly always scores.

How a throw scores: `FightSimulation._apply_landed_effect`, the `"takedown"` arm (find it
with `grep -n '"takedown":' Godot/scripts/FightSimulation.gd`; the file is ~3,500 lines,
never open it whole) passes `magnitude * execution_quality` to
`RoundScoring.throw_class` (`Godot/scripts/RoundScoring.gd`, `grep -n 'static func throw_class'`):
ippon at or above judo's `ippon_threshold`, and the points of the highest `throw_bands`
entry it clears (judo: one band, `min` 14, 1 point = a waza-ari). Judo's profile is the
`"id": "judo"` block of `Godot/assets/data/combat_rulesets.json`. `magnitude` is
`_technique_magnitude` - the sum of the absolute effect values. `execution_quality` is
`0.6 + 0.4 * combined_mastery` (`grep -n 'var execution_quality' ...`), so it runs 0.6-1.0
and a trained judoka sits near 0.9.

## Scope

1. **The census.** Every `judo` node with `match.role == "takedown"` in
   `Godot/assets/data/technique_catalog.json`: `magnitude`; the execution quality at which
   it first scores a waza-ari (`waza_ari_at` = band min / magnitude) and an ippon
   (`ippon_at` = threshold / magnitude) - write `null` when that is above 1.0 (it never
   can); and its class (`none`, `waza_ari`, `ippon`) at execution quality 0.7, 0.8, 0.9
   and 1.0.
2. **The summary.** Of all judo takedowns, the share scoring none / waza-ari / ippon at each
   of those four qualities.
3. **The memo** `U74_JUDO_THROWS_OVERSCORE.md`: why judo over-scores; what the J26
   endings imply a landed throw should usually be worth; any per-technique or per-throw
   effectiveness figure ON DISK (search `research/` - quote it with file and line, or
   say it is not on disk); and at least three options - (a) U69's re-authoring
   (`research/U69_IPPON_LINE.md`, section 4a: foundation 14-17, core 22-25,
   counters/sacrifice 24-26), (b) a higher waza-ari band or a yuko band below it (the
   2025-28 IJF cycle brought yuko back, J26), (c) a landed throw scores by a roll that
   rises with quality instead of by a hard line - each with the share of judo takedowns it
   leaves at none / yuko / waza-ari / ippon at quality 0.9. Recommend one. Do NOT build it.

JSON shape:

    {"profile": {"ippon_threshold": 22.0, "waza_ari_min": 14.0},
     "throws": [{"id": "judo_uchimata", "magnitude": 19.0, "waza_ari_at": 0.737,
                 "ippon_at": null, "class": {"0.7": "none", "0.8": "waza_ari", "0.9": "waza_ari", "1.0": "waza_ari"}}],
     "summary": {"0.9": {"none": 0.05, "waza_ari": 0.25, "ippon": 0.70}, ...},
     "recommend": "a"}

Round `waza_ari_at` / `ippon_at` to 3 decimals and summary shares to 3 decimals.

## THE TRAP

**Read the line from the ruleset, never from U69.** U69 wrote 22 and 14 on 2026-09-12;
the checker reads `combat_rulesets.json` at run time, and so must you - if the profile
changed, your census must follow it.

## The gate

    python research/U74_check.py

It recomputes every throw and summary cell from disk. It fails now because your files do
not exist. Fix YOUR FILES, never the checker.

## Done

- Stay on `master`; no branch. **Never** `git checkout`, `switch`, `branch`, `stash`,
  `reset`, `clean`, `add -A`, `pull` or `push`.
- `git status -s` first. Commit exactly your two paths, ON the commit line:
  `git commit -m "U74: ..." -- research/U74_judo_throw_scores.json research/U74_JUDO_THROWS_OVERSCORE.md`
  (after `git add -- <the same two paths>`), ending `Co-Authored-By: Cursor <noreply@cursor.com>`.
  Then `git show --stat HEAD` must list exactly those two files. **Do not push.**
- Mail: `python Tools/agent_comms.py send --from cursor --to claude --topic U74-done --body "<hash> takedowns=<n> scoring_at_0.9=<share> ippon_at_0.9=<share> recommend=<a|b|c> check=exit0"`
- Do NOT edit `HANDOFF.md`.

# TASK Q76 - QWEN - A JUDO BOUT AT TIME IS DECIDED BY THINGS JUDO DOES NOT SCORE

Model: qwen3-coder, **medium effort**. Owner: qwen. Launched `--yolo`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Claude is running the full
suite in this checkout. Your gate is a Python script that MUST exit 0.

## Owned files

- `research/Q76_judo_decisions.json` - **NEW, yours alone.**
- `research/Q76_JUDO_AT_TIME.md` - **NEW, yours alone.**

Nothing else. Do NOT edit any script, test, catalogue, `combat_rulesets.json`,
`Q76_check.py`, `HANDOFF.md` or `AgentComms/roadmap.json`.

## Why this exists

S1e held judo's ground again (read `unseated_debt.judo` in
`Godot/assets/data/technique_vocabulary.json`). Its measurement - thrower vs newaza
specialist, both knowing ukemi, 40 bouts on the current tree - ended **16 IPPON and 24
DECISION**. Real senior judo does not have a "decision" in that sense. J26
(`research/J26_IJF_MATTE_AND_ENDINGS.md`, the table at lines 58-62) gives the real
endings: ippon 46.2%, a single waza-ari at time 22.6%, waza-ari-awasete-ippon 17.7%, third
shido 13.5%, golden score ~21% of contests. A contest level at time goes to golden score;
three shido lose it.

What the engine does instead is the question. Judo's scoring profile (the `"id": "judo"`
block of `Godot/assets/data/combat_rulesets.json`) weights `positions`, `submissions` and
`throws` at 1.0, and `position_points` gives 1.0 per landed control, pass or sweep.
`RoundScoring.round_points` (`Godot/scripts/RoundScoring.gd`, `grep -n 'static func round_points'`)
turns counters into points: every landed control from the top, and every landed submission
attempt, is a point beside a waza-ari.

## Scope

1. **The mechanism.** Trace how a judo bout that reaches time is decided: `_close_round`
   and `_finish_fight` in `Godot/scripts/FightSimulation.gd` (~3,500 lines, never open it
   whole - `grep -n 'static func _close_round'` / `'static func _finish_fight'` and read
   those functions only), `RoundScoring.round_points` and `RoundScoring.card`. Answer:
   what are the counters that decide it, what happens when points are level, and does the
   engine have golden score or any penalty (shido) at all? Check with
   `grep -n -i 'golden\|shido\|penalt' Godot/scripts/FightSimulation.gd Godot/scripts/RoundScoring.gd`.
   `Godot/scripts/JudoBoard.gd` exists - say what it is and whether FightSimulation uses it.
2. **The anchors.** The J26 endings, each quoted with `file`, `line` and the exact `quote`.
3. **Options, at least three, each a rule a person could build**, e.g. (a) judo's decision
   counts only scores (waza-ari, and yuko if added), positions and submission attempts
   weighted 0; (b) (a) plus golden score - a level contest continues until the first score;
   (c) (b) plus shido for passivity, three losing the contest. For each, the functions or
   data it touches and the predicted DIRECTION of the four ending shares the engine can
   produce (`ippon`, `waza_ari_at_time`, `golden_score`, `shido`): `up`, `down`, `same`.
   Recommend one. Do NOT build it.

JSON shape:

    {"mechanism": {"decides_at_time": ["..."], "level_points": "...", "golden_score": false, "shido": false,
                   "judo_board": "..."},
     "anchors": [{"metric": "ippon", "file": "research/J26_IJF_MATTE_AND_ENDINGS.md", "line": 58, "quote": "..."}],
     "options": [{"id": "a", "rule": "...", "touches": ["round_points"],
                  "predict": {"ippon": "same", "waza_ari_at_time": "up", "golden_score": "same", "shido": "same"}}],
     "recommend": "b"}

## THE TRAP

**A judo "DECISION" in this engine is not a judo decision.** Do not map the engine's
DECISION count onto J26's "single waza-ari at time" - read what the engine's points are
MADE OF before comparing them to anything.

## The gate

    python research/Q76_check.py

It checks that `golden_score` and `shido` match what the code really contains, that each
function you name exists, that each anchor quote is on its line, and the option shape. It
fails now because your files do not exist. Fix YOUR FILES, never the checker.

## Done

- Stay on `master`. **Never** `git checkout`, `switch`, `branch`, `stash`, `reset`, `clean`,
  `add -A`, `pull` or `push`.
- `git status -s` first. Commit exactly your two paths, ON the commit line:
  `git commit -m "Q76: ..." -- research/Q76_judo_decisions.json research/Q76_JUDO_AT_TIME.md`
  (after `git add -- <the same two paths>`), ending `Co-Authored-By: Qwen <noreply@qwen.ai>`.
  Then `git show --stat HEAD` must list exactly those two files. **Do not push.**
- Mail: `python Tools/agent_comms.py send --from qwen --to claude --topic Q76-done --body "<hash> golden_score=<true|false> shido=<true|false> options=<n> recommend=<id> check=exit0"`
- Do NOT edit `HANDOFF.md`.

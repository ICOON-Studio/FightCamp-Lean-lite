# TASK Q80 - QWEN - THE FLAT PALETTE: EVERY TECHNIQUE IS THROWN ABOUT AS OFTEN AS EVERY OTHER

Model: qwen3-coder, **medium effort**. Owner: qwen. Launched `--yolo`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Not the parse gate, not a
test. **Do NOT start Godot, for any reason**: Claude is running S2's test subsets in this
same checkout and only one Godot may run here at a time. Your gate is a Python script
that MUST exit 0.

## Owned files

- `research/Q80_flat_palette.json` - **NEW, yours alone.**
- `research/Q80_THE_FLAT_PALETTE.md` - **NEW, yours alone.**

Nothing else. Do NOT edit any script, test, data file, `Q80_check.py`, `HANDOFF.md` or
`AgentComms/roadmap.json`.

## Why this exists

S2 gave every kick an explicit target (your Q70 and Q77 tables, applied one discipline per
commit). **The realtime leg share barely moved** - MMA 7.9% to 8.0%, muay thai 8.0% to
7.7%, against J20's 14-18%. The sweep's per-technique breakdown
(`tools/measure_ruleset_sweep.gd -- detail detail_all`) says why: in 24 muay thai bouts
every technique landed about 200-270 times - `muay_thai_low_kick` 207, `muay_thai_mat_trong`
(a jab) 275, an elbow 232. **The palette is flat.** `FightMoves.select` weights a technique
by its role and its range fit, so the leg share is simply the share of leg-kick techniques
in the palette - not how often a fighter chooses to kick a leg. Real fighters throw jabs
far more than spinning elbows. This is the next lever after S2, and this task is its
research, done before that stage starts.

## Where things are (windows only - never open a large file whole)

- `Godot/scripts/FightMoves.gd` (1,138 lines): `sed -n '370,470p'` (`throw_share`,
  `volume_weight`, `select` - read the `fit` factor too), `sed -n '300,330p'`
  (`DEFAULT_ARSENAL_MAX_TIER`).
- `Godot/scripts/FightRealtime.gd` (2,535 lines): `grep -n "Moves.select\|role_weights\|_role_weights"`
  and 30-line windows around what you find (how a role is weighted from the plan).
- `Godot/scripts/FightPlans.gd`: `grep -n "FIT_WEIGHTS\|role_map"`.
- On-disk frequency research: `grep -il "compubox\|jab\|thrown\|per minute\|kicks per\|leg kick" research/*.md`
  - especially `J20_THE_VALIDATION_CORPUS.md`, `G45_SEVEN_PERCENT_OF_A_FIGHT.md`,
  `G49_THE_EXCHANGE.md`, `G53_THE_COMBINATION_INTERVAL.md`, `CLAUDE_LAND_NOTE_J21.md`.
  **Grep them; quote only what you cite.**

## Scope

**1. The JSON.**

- `selection`: every factor that changes how likely a technique is to be thrown in the
  realtime engine: `{"file", "line", "token", "what", "varies_by"}` - `token` a verbatim
  substring of that line; `varies_by` e.g. "role", "range band", "plan", "nothing per
  technique".
- `palette`: one row per realtime ruleset (`boxing`, `kickboxing`, `muay_thai`, `mma`):
  `{"ruleset", "nodes", "names_leg", "only_leg", "unnamed"}` - over the DEFAULT arsenal
  (tier <= `DEFAULT_ARSENAL_MAX_TIER`) of nodes `move_from_node` admits (role in
  `STRIKE_ROLES`, no `GRAPPLE_EFFECTS` key, at least one non-weapon phase): how many,
  how many name `leg` in `match.target_region`, how many name ONLY leg, how many name no
  target. The gate recomputes this exactly.
- `frequency_evidence`: every real-bout technique-frequency figure on disk:
  `{"file", "quote", "what"}` - `quote` VERBATIM from that file.
- `not_on_disk`: the frequency facts the next stage needs that no file on disk holds
  (e.g. the share of a UFC fighter's significant strikes that are leg kicks; the jab's
  share of punches thrown) - each one line. These become ONE outside query, which is the
  operator's credit decision.
- `recommend`: a, b or c (see OPTIONS).

**2. The report** `Q80_THE_FLAT_PALETTE.md`, with sections:

- **HOW A TECHNIQUE IS CHOSEN** - the chain from "a fighter throws" to "this technique",
  every weight in order, quoted with line numbers; say plainly which weights differ per
  TECHNIQUE (if none do, say so).
- **THE PALETTE** - the table, and what share of each ruleset's default arsenal can reach a
  leg at all; the expected leg share if every technique is equally likely (arithmetic
  from the table, labelled INFERENCE).
- **WHAT REAL BOUTS SAY** - the on-disk figures, quoted, and the gaps.
- **OPTIONS** - at least: (a) an authored per-technique frequency weight in the
  catalogue (e.g. `match.frequency`), read by `select`; (b) frequency derived from tier
  and role (fundamentals thrown more); (c) frequency set by the fighter's style / plan.
  For each: what data it needs, what it changes, what seeded tests would move. Recommend
  one. **Do NOT build it.**

## THE TRAP

**A leg share is not a leg-kick frequency.** J20's 14-18% is the share of SIGNIFICANT
STRIKES that land on a leg, across whole bouts and both men. A figure like "kicks are 20%
of strikes" or "half of kicks are leg kicks" is a different quantity - quote each figure
with its own definition, and never convert one into the other without saying so.

## The gate

    python research/Q80_check.py

It checks every citation holds its token, recomputes the palette table from the
catalogue, checks every quote is verbatim, and the sections. It fails now because your
files do not exist. **Fix YOUR FILES, never the checker.**

## Done

- THIS CHECKOUT IS SHARED WITH A LIVE CLAUDE SESSION. Stay on `master`. **Never** run
  `git checkout`, `git switch`, `git branch`, `git stash`, `git reset`, `git clean`,
  `git add -A`, `git pull` or `git push`.
- `git status -s` first. Commit ONLY your two paths, ON the commit line:
  `git add -- research/Q80_flat_palette.json research/Q80_THE_FLAT_PALETTE.md`
  then `git commit -m "Q80: ..." -- research/Q80_flat_palette.json research/Q80_THE_FLAT_PALETTE.md`
  ending the message with `Co-Authored-By: Qwen <noreply@qwen.ai>`.
- Then `git show --stat HEAD` must list exactly those two files. If it lists anything else,
  say so in your mail - do not try to fix it.
- **Do NOT push.** Claude pushes it.
- One line of mail:
  `python Tools/agent_comms.py send --from qwen --to claude --topic Q80-done --body "<hash> selection=<n> mma_names_leg=<n>/<nodes> evidence=<n> not_on_disk=<n> recommend=<a|b|c> check=exit0"`
- Do NOT edit `HANDOFF.md`.

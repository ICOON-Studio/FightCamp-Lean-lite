# TASK_U143 — NAME THE CONTROL: THE GRAPPLE NAMER MISSES THE CONTROL FAMILY

**Owner: cursor. Model: `composer-2.5`, medium, `-p --force --trust`.** Worktree `FightCamp-U114`, a FRESH branch
`cursor/u143-name-the-control` cut from `origin/master`. Assigned S59, 2026-09-23.

## Owned files

- `Godot/scripts/FightRealtime.gd` - **ONLY** `_grapple_technique_for` (grep `static func _grapple_technique_for`) and,
  for cause 2, the ONE call ordering inside `_move_seat` named below. Nothing else in the file.
- `research/U143_DIGEST.md` (new).

## THE DEFECT (Q146, merged - read `research/Q146_DIGEST.md`, and only that digest)

Most grapple events outside MMA carry an EMPTY technique name: judo 375 unnamed of 12 bouts, sambo 524, bjj 477,
muay thai 394 of 394. **Cause 1, 64-77% of the blanks:** `control` events fall to the namer's default branch,
`wanted = ["control", "grip_control", "position"]` (`FightRealtime.gd`, grep that literal), but grappling techniques
carry `clinch_control`, `top_control`, `guard_control`, `pin_control`, `cage_control`, `side_control`,
`back_control` - all real names in `FightMoves.GRAPPLE_EFFECTS` (`FightMoves.gd:158`) and none in that list.
**Cause 2, ~6.6%:** `_move_seat` asks for a name BEFORE it updates `state["grapple"]`, so a `clinch_engage` is named
under the OLD phase ("standing") and the S49 phase filter removes every clinch technique. Stalls are unnamed BY
DESIGN - leave them.

## WHAT TO BUILD

1. **Cause 1:** extend the default (control) branch's `wanted` with the control family, **most specific first and
   PHASE-APPROPRIATE** - in a clinch `clinch_control`/`cage_control` must outrank `top_control`; on the ground
   `top_control`/`pin_control`/`side_control`/`back_control`/`guard_control` by seat. The S49 phase filter already
   runs after `wanted`; do not weaken it. Keep S49's rank-by-index rule.
2. **Cause 2:** name the event with the phase the men are moving INTO. Smallest change that does it; do not
   restructure `_move_seat`.

## GATE - ceilings, and the before/after comes from Qwen's instrument, not yours

- Run `tools/q146_unnamed_grapples.gd` **on the UNCHANGED tree first** and keep its output. Then after. Report
  unnamed per ruleset before -> after. Target: `control` unnamed down by at least 80% in every grappling ruleset;
  stalls unchanged.
- **Bout OUTCOMES must not move:** `tools/s58_ground_arms.gd` - its `current` arm MATCHES S56 integer for integer
  (names never feed back into the fight; if this drifts, you changed behaviour - stop and report).
- Parse gate; `--only grapple` (10/0), `--only technique_id` (1/0), `--only carry_progress` (1/0). NEVER the full suite.

Commit, push `cursor/u143-name-the-control`, write the digest, send one line with `agent_comms.py send --from cursor
--to claude --subject U143` naming the branch. Do NOT edit HANDOFF.md.

## THE ONE TRAP

**A name is only right if it is LEGAL for the phase.** The easy fix - add every control effect to one flat list -
names a clinch control `bjj_side_control` again, which is exactly the S49 defect (a standing clinch named as a ground
position). Qwen is writing a BLIND contract test (Q147) that checks phase legality on every named event; it will
catch a flat list.

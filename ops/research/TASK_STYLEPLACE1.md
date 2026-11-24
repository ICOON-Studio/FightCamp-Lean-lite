# TASK STYLEPLACE1 - probe: opponents that fight in different places, so a written plan can be specific (S551)

Kind: probe (rules as switches that live in `tools/`; nothing under scripts/ or tests/ changes). Model: claude-opus-5-5.
Discipline: boxing (demo path). Seat: Claude worker in a console tab. Estimate: about 4-5 hours.
START ONLY when no other worker runs a Godot job (COACHMAP2 holds the slot from 20:05 on 2026-11-24).

## Why
Owner, board Q-335 (S551): "The written plan is worth 2 wins in 100. Make opponents fight differently so it matters?"
- **"Yes, scope it"**. The scope, the three levers, the eight bars and the feedback loops are
`ops/research/STYLEPLACE_SCOPE_S551.md`: read it whole first; it is the spec.

## METHOD (quote in your first message)
- MECHANICS NEED 8, PROBE FIRST (owner S534). Nothing lands in the game here.
- THE WRITTEN PLAN STAYS AND MUST MATTER (owner Q-328, Q-333). Never propose shrinking the plan screen.
- NO THIRD PLAN-RULE PROBE: this probe changes how OPPONENTS fight, not what the plan raises.
- ONE RULE IS NOT SOLD TWICE: the corner command grade belongs to COACHMAP2. Do not touch it.
- CONTROL FIRST: with every lever off, reproduce PLANIMPACT2's lever-off arms bout for bout (`tools/planimpact2_probe.gd`,
  `planimpact2_rules.gd`, `planimpact2_sum.py`, runs under `E:/FightCamp/tmp/planimpact2/`).
- A LEVER FOLLOWS REAL BOXING: each place a style gets, and each answer that is split, names its real-bout reason
  (`REALPLANS_S341.md`, `CARDBOX1_JOHN_BRIEF_JOHN.md`, `ops/research/topics/footwork.md`) on the design page BEFORE any run.
  No balancing number: full strength and one half-strength arm.
- NEVER TEST IDENTICAL FIGHTERS. Run the five women of PLANIMPACT2 (where the live corner lives) AND, with the corner
  off, the ten types of PLANIMPACT1 through the plain bout (`BoutNight`), so the result is not five boxers only.
- A one-bout trial before every table. Long output to a file; wait on the done line.

## Steps
1. Open the code lines the scope names (`Exchanges.STYLE_MODES` l.156, `PlanFight.GAME_CARD` l.25, `LOST_CARD` l.28,
   `ANSWERS` l.50, `CoachPlan.cards` l.37, `OppFile` l.112) and every reader in the scope's list. Write what each lever
   would have to switch, in `ops/research/DESIGN_STYLEPLACE1.md`. Commit it before any run.
2. Phase 0, paper, no bouts: for each lever alone and together, the share of the best plan's lines against style X
   that are also best lines against style Y (a 6 x 6 table). Today's table first (expected: nearly all shared).
   Stop and report if no lever moves the table: a bout run cannot pass bar 3 then.
3. The switches in `tools/styleplace1_rules.gd` (the probe swaps the tables it reads; the game's files are not edited).
4. Control, then the one-rep trial of the scope's "Feedback loops", then the full runs.
5. The eight bars of the scope, for: all off, lever 1, lever 2, lever 3 (the file line: measured with ModeTells' own
   rate, no bouts needed), 1+2, all on. Bar 5 decides first: a lever that fails it is dropped, not tuned.
6. `docs/STYLEPLACE1_RESULT.md`.

## Not allowed
No change under scripts/ or tests/. One Godot process at a time through
`python ops/Tools/godot_slot.py run --who STYLEPLACE1 -- <command>`; the watchdog before each job
(`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait). The owner's game
may be open: never more than ONE Godot, slices of 20 minutes or less, runs written under `E:/FightCamp/tmp/styleplace1/`;
headless, `--audio-driver Dummy`, never the `_console.exe`. Other sessions share this checkout: commit ONLY your own
paths; never touch proto/ or NEXT_SESSION_PROMPT.md.

## Feedback loops
As written in `ops/research/STYLEPLACE_SCOPE_S551.md` section "Feedback loops" (ropes -> guard wear -> ropes, capped by
the wear cap, stop at 50% of exchanges on own ropes; inside -> body -> tiring -> inside, stop if the inside share climbs
every round in over half the bouts; styles do not learn - confirm in code). One-rep trial first: one boxer, two styles,
40 bouts, all arms; stop if two arms print the same bouts or the control does not match PLANIMPACT2.

## Prior research
`docs/PLANIMPACT1_RESULT.md`, `docs/PLANIMPACT2_RESULT.md`, `ops/research/PLANIMPACT1_CHECK_S549.md`,
`ops/research/PLANIMPACT2_CHECK_S551.md`, `docs/PLANWORTH1_RESULT.md`, `ops/research/REALPLANS_S341.md`,
`ops/research/STRIKEMAP_S335.md`, `ops/research/CARDBOX1_JOHN_BRIEF_JOHN.md`, `ops/research/topics/footwork.md`. Run
`python ops/Tools/prior_research.py opponent style place inside ropes plan` and name the study each lever follows.

## What would a human do?
He would lay the six opponents' plans side by side on paper and circle the lines that differ. If almost nothing is
circled after a change, he would not run a single bout on it.

## Prefab check
PLANIMPACT2's probe, rules and summary scripts are the harness: preload them and add switches; PLANWORTH1's probe plays
the ten types without a live corner.

## Contract
OWNS: tools/styleplace1_probe.gd, tools/styleplace1_rules.gd, tools/styleplace1_sum.py, ops/research/DESIGN_STYLEPLACE1.md, docs/STYLEPLACE1_RESULT.md
RED_TEST: tools/styleplace1_probe.gd
REGRESSION: none under tests/ (nothing in scripts/ changes): the control arm is the regression
VISUAL: none

## Result
`docs/STYLEPLACE1_RESULT.md`: the verdict in four lines for the owner first (plain words, wins in 100); a NOT GREEN list;
the control; each lever as written before the run with its boxing reason; the paper table; the eight-bar table for each
arm; the menu table (every menu it would show on and what each is wired to) if it passes; honest limits; how to
reproduce. Commit ONLY your own paths with `git commit -m "..." -- <paths>`; do not push; do not ask questions: decide,
and write what you decided.

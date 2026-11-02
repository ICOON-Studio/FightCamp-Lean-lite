# TASK C133 — CODEX — WHAT THE ENGINE ALREADY HAS FOR RING POSITION, STANCE, DEFENCE, FEINTS AND THE TIME BETWEEN EXCHANGES

Model: `gpt-5.6-luna`, MEDIUM (pinned by `Tools/codex_task.cmd`). Owner: codex. MAIN checkout. Stage: S4e (ENGINE FIRST).

**Test tier: READING RESEARCH, NO CODE CHANGE.** No parse gate, no Godot, no test. `python research/C133_check.py`
is the whole gate and must print `C133_CHECK PASS`. If it does not, fix the digest until it does. Never edit
`C133_check.py` or any file under `Godot/scripts/`, `Godot/tests/`, `Godot/assets/`.

## Owned files

- `research/C133_ENGINE_POSITION_STANCE_DEFENCE.md` — NEW, 130 lines at most.

## Why this exists

The operator ruled ENGINE FIRST on 2026-09-14 night, after asking whether the simulation "lacks to simulate positioning
stances dodges etc". Verbatim, the chosen option: **"Engine first"** — the clip catalog waits until the engine simulates
ring position and the cage, stances and switches, real dodges, feints and commitment, and what fighters do between
exchanges. Claude is building those five behaviours. Before a line is written it needs to know, FROM THE CODE, exactly
what is already there — because the last stage's most expensive lesson was that a "new" action already existed
(C132: the engine throws `boxing_distance_read` and `boxing_feint` today and the room shows both with the plain jab clip).

This is C132's shape again: read the code, re-find every quote, propose nothing.

## What Claude already measured, so you do not re-measure it

`Godot/tools/measure_ring_position.gd` ran 30 seeded bouts per population through `FightRealtime` and wrote
`research/S4E_RING_POSITION_BEFORE.json`. Headlines: on the `circle` intent, handedness is **+0.91 to +0.93** on a
−1..+1 scale for all four fighters — the engine circles ONE WAY. Boundary (ROPES+CORNER) time is **42.3% / 38.9%** in a
6 m boxing ring and **25.6% / 24.6%** in a 9.1 m MMA "cage". While one man retreats and the other closes the gap SHRINKS
at **−0.40 m/s** (boxing). Do not repeat that work; answer the code questions below.

## Where to read (never open a file whole; use `rg -n` then read windows of 40-80 lines)

- `Godot/scripts/FightRealtime.gd` (2,681 lines) — `:1413` `_run_decision`, `:1455` `_run_movement`, `:639-670`
  `fight_seconds` / `position_of` / `separation` / `place_of` / `is_resting`, `:681` `advance_tick`.
- `Godot/scripts/RingSpace.gd` (45 lines, read whole) — the whole ring model.
- `Godot/scripts/FightFootwork.gd` (193 lines, read whole) — speed, acceleration, the four throttles.
- `Godot/scripts/FightIntent.gd` (145 lines, read whole) — `decide` and its CORNER branch at `:85`.
- `Godot/scripts/FightMoves.gd` (~1,000 lines) — `:87` `STRIKE_ROLES`, `:121` entry effects, `:191` the tier-1-2 palette
  default, `:944` `GUARD_EVADE_EFFECTS` and its use at `:967`.
- `Godot/scripts/ImpactModel.gd` — where `blocked`, `slipped` and `absorbed` are decided.
- `Godot/scripts/BalanceState.gd`, `Godot/scripts/FightSimulation.gd`, `Godot/scripts/FightStageDirector.gd` — the ONLY
  three files where the string `southpaw` appears. Find out what each does with it.
- `Godot/assets/data/combat_rulesets.json` — `arena_profile` / `arena_label` per ruleset (`boxing_ring`,
  `mma_cage` "Octagonal Competition Area").
- `Godot/scripts/TickBudget.gd` — what runs on which tick, and what a fighter does on a tick where no action fires.

## The questions (answer each in `## ANSWERS`, starting the line with `Q1.` ... `Q7.`)

- **Q1.** RING AND CAGE. Which code reads a fighter's position to decide anything other than the gap between the two
  men? Name every consumer of `place_of`, `pressure`, `is_cornered` and `half_width`. Does any ruleset's
  `arena_profile` reach `RingSpace` or `FightRealtime` at all — is a cage ever shaped differently from a ring?
- **Q2.** CUTTING OFF AND CIRCLING OUT. In `_run_movement`, what exactly decides the direction for `close`, `retreat`
  and `circle`? Quote the lines. Is the circling direction ever a decision, and is there any code anywhere that steers
  a chaser at open floor rather than at the other man?
- **Q3.** STANCE. What do `BalanceState.gd`, `FightSimulation.gd` and `FightStageDirector.gd` actually do with
  `southpaw`? Is a stance ever a property of a fighter, does anything switch it, and does any strike, defence or
  movement read it? Say plainly which of the three is a real stance model and which is a label.
- **Q4.** DEFENCE. `blocked`, `slipped` and `absorbed` are impact OUTCOMES. Trace the code that produces each: what
  inputs decide it, is it ever a decision the defender makes BEFORE contact, and is there any defensive node in the
  technique catalogue that a fighter can choose as an action? Explain, from the code, why a block never fired in nine
  measured bouts.
- **Q5.** FEINTS AND COMMITMENT. C132 answered this for the three jabs; extend it. Does anything in the engine make a
  feint NOT deliver a blow, make the opponent react to one, or leave a committed thrower open for a window afterwards?
  Name the state that would have to carry an open window if one existed.
- **Q6.** THE TIME BETWEEN EXCHANGES. On a tick where no action fires and neither man is throwing, what does the engine
  do? Quote the code path. How long are those gaps, and what state (if any) distinguishes measuring, resetting and
  recovering from plain `hold`?
- **Q7.** WHERE A CHANGE GOES, AND WHAT IT BREAKS. For each of the five behaviours, name the ONE function a change
  belongs in, and list the tests in `Godot/tests/` that pin a number that change would move (`rg -n` the test names, do
  not run them — you cannot boot Godot).

## Format the check enforces

- `# C133 - what the engine has for position, stance, defence, feints and the gaps`, then `## ANSWERS`,
  `## Evidence`, `## Where a change goes`, `## Open`.
- `## Evidence`: at least **18** rows, format exactly
  `` - `Godot/scripts/X.gd:N` "quote" - why it matters ``. Every quote is re-found within 3 lines of the cited line.
  At least **7** distinct files, and `RingSpace.gd`, `FightIntent.gd` and `FightRealtime.gd` must each appear.
- `## Where a change goes`: one table row per behaviour, each naming a `File.gd:N` and at least one test file name.
  Rows must cover: `ring`, `stance`, `defence`, `feint`, `between`.
- `## Open` — 8 lines at most.

## The trap specific to this task

**Do not confuse a word with a model.** `southpaw` appears in three files and `CONTACT_SLIPPED` is a constant in
`FightRealtime.gd` — neither is evidence that the engine has stances or slips. Q3 and Q4 exist because the last session
looked at those strings and had to open the code to find out that one is an impact outcome and the others are labels.
Say what the code DOES, quote it, and where the answer is "nothing", write "nothing" and cite the absence (the `rg -n`
that returns no consumer is itself the evidence — record the pattern you searched).

## Ship

Commit `research/C133_ENGINE_POSITION_STANCE_DEFENCE.md` only, push, write the digest, send one line with
`python Tools/agent_comms.py send --from codex --to claude --subject "C133 ready"`. Do NOT edit `HANDOFF.md`.

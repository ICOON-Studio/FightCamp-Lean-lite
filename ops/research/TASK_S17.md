# TASK_S17 — A KNOCKDOWN THAT SURVIVES THE FIGHT, AND A CHIN THAT PAYS FOR IT

Owner: Claude. Model: Opus, HIGH effort, Fast OFF.
GREENLIT by the operator 2026-09-19: *"we continue next session with your second
recommendation"* — the enabling change PLUS chin, as one stage.

**READ THIS FILE AND THE FILES IT NAMES. NOTHING ELSE.** Do not read `HANDOFF.md`
whole, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

---

## THE RULING THIS EXECUTES

Operator, 2026-09-19, verbatim:

> "Chin not trainable but it should play a role on how prominent to kos someone
> is, each time someone get knockdown should add up and make him vulnerable to
> Kos."

So chin is **rolled at creation like `potential`, spent by head trauma, and never
restored by training.** It is not a trainable stat and must not become one.

---

## THE BLOCKER, ALREADY MEASURED — DO NOT RE-DERIVE IT

**Knockdowns are counted during a fight and then thrown away.**

| quantity | where it lives | survives the fight? |
|---|---|---|
| `knockdowns_suffered` | in-fight stats, `FightSimulation.gd:962` | **NO** |
| `knockdowns_scored` | in-fight stats, `FightSimulation.gd:961` | **NO** |
| stoppage loss | `fight_history[].result` + `.method` | yes |
| `concussion_rhi` | `athlete.injuries`, on a healing timer | yes, then clears |

`BoutRead.capture` writes `bout_read` into every `fight_history` row and stores
scorecards, method, `result_type`, winner, rounds and range. **The word
`knockdown` does not appear in `BoutRead.gd` at all.** So a man dropped three
times who wins on points leaves no record anywhere in the save, and chin has
nothing to erode.

---

## PART A — MAKE A KNOCKDOWN SURVIVE (do this first; it is the whole enabler)

Add `knockdowns_suffered` and `knockdowns_scored` to the **`fight_history` row**,
written at `GameState.gd:2641-2650` where the row is already built from the sim
result. Three properties this shape buys, and all three are the reason for it:

1. **The career total is DERIVED by summing history** — never a second stored
   counter that can drift out of sync with the history it is supposed to
   summarise.
2. **No save migration.** A row without the field reads 0, which is exactly right
   for a fight nobody recorded.
3. It hands "knocked down 3 times in his last 5" to matchmaking, commentary and
   the tale of the tape for free, later, at no extra cost.

**Check whether the world/tournament paths write history rows too** —
`GameState.gd:2593`, `:2641` and `:9149` all touch history or results. A
knockdown that survives one path and not another is worse than one that survives
neither, because the number then looks trustworthy and is not.

---

## PART B — CHIN

`chin` is a new per-athlete quantity, rolled at creation from the same place
`potential` is rolled, and **absent from `AthleteStatModel.STATS`** — putting it
there would make it appear as a trainable stat in every panel that iterates the
stat list, which is exactly what the ruling forbids.

### THE SEAM IS ONE LINE

```gdscript
# FightSimulation.gd:166 - today
const HURT_HEALTH_THRESHOLD := 35.0
```

A constant, identical for every fighter. It is already modified in place by two
terms that point the right way (`FightSimulation.gd:1185`): camp composure
lowers it, the weigh-in penalty raises it. **A HIGHER threshold means he is hurt
EARLIER**, so the chin penalty is ADDITIVE and the formula's shape does not
change — only the constant becomes a function.

```
effective = HURT_HEALTH_THRESHOLD
          + chin_penalty(career_knockdowns, stoppage_losses, starting_chin)
          + weigh_in_penalty.hurt      # already there
          - camp_composure             # already there
```

### THREE DESIGN POINTS, ALREADY DECIDED — do not re-open

- **It never recovers.** A softening that never reverses is the truer model and
  the more interesting career pressure.
- **`knockdowns_scored` stays OUT of the chin maths.** It is the opponent's chin,
  not his. Store it (Part A) because it is free and useful elsewhere.
- **Do not print it.** Same posture as aggression: build it, do not surface it. A
  scout report is its natural home later, and printing it now closes a UI
  decision the operator has deliberately left open.

### THE NUMBER THIS STAGE IS JUDGED ON

Not a line count. **Measure the KO/TKO rate across a seeded population before and
after**, for three cohorts: a clean fighter, one with 3 career knockdowns, one
with 8. If the rate does not separate, the penalty curve is too flat and the
stage has shipped a number nobody can feel. Write a probe; do not assert it from
the formula.

**NEVER TEST IDENTICAL FIGHTERS** (standing rule). The cohorts differ by
knockdown history, so build them from ONE differentiated matchup and vary only
the history — and name the population in the output.

---

## OWNED FILES

- `Godot/scripts/GameState.gd` — the history row (`:2641-2650`), and wherever
  else a history row is written.
- `Godot/scripts/BoutRead.gd` — if the count rides the capture instead of the row.
- `Godot/scripts/FightSimulation.gd` — `:166`, `:1185`, and the fighter build at
  `:1038-1075`.
- `Godot/scripts/TaleOfTape.gd` — where `chin` is rolled, beside the other
  physicals it already rolls.
- new `Godot/tests/fight_chin_test.gd`
- new `Godot/tools/probe_chin_ko_rate.gd`
- new `research/S17_*`

## GATE (tier: a script edited)

```
python Godot/tools/check_scripts.py <each touched .gd>
python Godot/tools/run_tests.py --only chin
python Godot/tools/run_tests.py --only fight_sim
python Godot/tools/run_tests.py --only scoring
python Godot/tools/run_tests.py --only athlete
```
Then the FULL SUITE ONCE: `python Godot/tools/run_tests.py --timeout 2400 --jobs 3`,
**fails=6 or better as a CEILING**, failing FILENAMES matching
`AgentComms/last_suite.json` name for name. THREE jobs, not four (`nproc` is 4).

**A SAVE-COMPATIBILITY CHECK IS PART OF THIS GATE, NOT AN EXTRA:** load an
athlete whose `fight_history` rows predate Part A and confirm the career
knockdown total reads 0 and no fight throws. If no existing test covers it, write
it.

## THE TRAP SPECIFIC TO THIS TASK

`HURT_HEALTH_THRESHOLD` is read in a hot path. Compute the per-fighter value ONCE
at the fighter build (`:1038-1075`, where `jab_commitment` is already settled
with the comment *"settled once, here, because a camp does not change mid-bout"*)
and store it on the fighter, rather than summing history on every exchange.

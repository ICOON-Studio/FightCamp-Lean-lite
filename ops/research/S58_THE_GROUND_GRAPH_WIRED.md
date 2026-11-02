# S58 — THE GROUND GRAPH, WIRED AND MEASURED AGAINST ITS OWN CONTROL

**Stage: COMPLETE. Control arm reproduces S56 integer for integer. Full suite
run at the end of this file.**

S57 shipped `GroundGraph.gd` complete — the edge table, the scorer, the
weighted chooser and the hold decay — **wired to nothing**. S58 is the wiring,
behind `ground_arm`, and the measurement that says whether it was worth doing.
The code is small. The measurement is the stage.

The operator asked for this in these words, after looking at the rendered
side-control clip:

> *"i want to see the transition and sequence to other moves from that position
> there must be a logic and planning from the fighter to execute the moves"*

---

## 1. THE HEADLINE, AND IT IS NOT ONE OF THE THREE QUESTIONS

**The graph's `skill` term — the field all four agents asked for by name, the
one that makes a fighter's TRAINED ability decide what he attempts — was
scoring 0.000 on every edge of every decision, and nothing said so.**

The first full sweep ran 542 decisions across 120 bouts and produced a clean,
plausible-looking table: seven distinct edges taken, a sensible spread, the
control arm matching. Two authored edges came back at **exactly zero** —
`side_to_half` and `mount_to_side`. Driving the same graph directly with no
engine and no RNG (`tools/s58_roll_sweep.gd`) took both of them, on **21% and
24.5%** of rolls. A weighted chooser cannot disagree with itself like that.

The cause: **`FightRealtime._build_fighter` never carried the athlete's
`technique_progress` onto the live fighter at all.** `state[side]` has a
`stats` block and no training record, and `fighter.get("athlete", fighter)` —
the fallback three call sites use — resolves to the built fighter, which has
none either. So every `skill_of` lookup returned 0.0, every edge naming a
single technique scored a flat zero, and the chooser was running on `reward`
and `hold_value` alone.

**It never raised anything, because zero is a legal score.** A chooser weighing
two of its four terms still chooses, still logs, and still looks correct. This
is the same class of defect as a gate that reads its subject: the instrument
agreed with itself.

### What was done about it, and what deliberately was not

The record is now carried under **`ground_progress`**, read by `_ground_skill_of`
and by nothing else. The obvious repair — writing it under its real name — was
**refused in this stage**: `Moves.grapple_arsenal` reads
`athlete["technique_progress"]` and today falls back to the tier 1–2 palette
*precisely because the record is missing*, so fixing the name would change the
technique names in every bout in the tree in the same commit as the graph. A
merge is not its branches. **That repair is its own slice with its own control
arm, and it is assigned.**

And the defect is now gated rather than trusted: the sweep counts decisions
where some candidate scored a non-zero skill and **FAILS** when that is zero on
an arm where the chooser ran. It reads `613 of 613 (100.0%)`.

---

## 2. THE CONTROL ARM IS REAL AND IT IS CHECKED

`current` must reproduce the shipped engine exactly, and the tool does not take
that on trust. It reads S56's recorded numbers off disk
(`research/S56_ground_exits.json`, the same 120 bouts on the same seeds) and
compares seat ticks, control units, exits, bout methods, side entries, the gate
and the spell count **integer for integer**:

```
-- THE CONTROL ARM AGAINST S56's RECORDED NUMBERS
   MATCH, integer for integer: seat ticks, control units, exits, methods,
   side entries, the gate and the spells.
```

Without that, every other row is a new measurement wearing the control's name.

**POPULATION.** The same two fighters S56 used — `measure_ruleset_sweep`
index 0 and 1 under MMA, a **wrestle-grappler (grapple 82) against a striker
(grapple 34)**, both legal for the ruleset and legally able to grapple, never
one man twice. The tool refuses to run if their stat blocks match. 120 bouts,
3 rounds, seeds 561000+, catalogue `assets/data/technique_catalog.json`.

---

## 3. FOUR ARMS, THREE BEHAVIOURS

| arm | chooser | payout |
|---|---|---|
| `current` | off | flat (shipped) |
| `decay` | off | decayed |
| `graph` | on | flat |
| `both` | on | decayed |

**`both` is `graph` in behaviour, by construction.** `GroundGraph.score_edge`
weighs the hold's decay on *every* arm — S57 wrote it that way so the chooser
and the payout could never drift apart — so `both` differs from `graph` in what
it **pays** and never in what it **does**. Four arms, three distinct
behaviours, and the seat-tick rows prove it.

---

## 4. THE THREE NUMBERS THAT DECIDE IT

### Q1 — does `back` come off 0.1% of ground time? **YES. 0.11% → 2.47%.**

```
   current  back    160 ticks of  140158  =  0.11%
   decay    back    160 ticks of  140158  =  0.11%
   graph    back   3783 ticks of  153381  =  2.47%
   both     back   3783 ticks of  153381  =  2.47%
```

**22x, and the cause was an ORDERING, not a probability** — which is why this
number is the test of *where the chooser was placed*. From mount the engine
opens a submission at 20 held ticks (`seat == "mount" and held >=
SUBMISSION_OPEN_TICKS`), `sub_open` latches until the attempt resolves, and
`mount_to_back` cannot be chosen before 60. The advance branch was unreachable
from mount in practice.

**THE DESIGN DECISION, MADE HERE RATHER THAN ASKED:** on the graph arms the
chooser runs **first**, and picking the HOLD edge falls through to the shipped
ladder *including the submission branch*. That is what makes it a choice rather
than a pre-emption — the submission is still reachable, and it is reached by a
man who chose to keep the seat. Placing the chooser *after* the submission gate
would have left `back` at 0.1% and measured nothing; moving submissions onto
the graph as edges is SHAPE 2, which S57 deliberately did not build.

Full seat table:

```
   arm        ground_t    guard     half     side    mount     back
   current      140158   27.34%    6.45%   28.23%   37.86%    0.11%
   decay        140158   27.34%    6.45%   28.23%   37.86%    0.11%
   graph        153381   29.36%    8.81%   30.15%   29.21%    2.47%
   both         153381   29.36%    8.81%   30.15%   29.21%    2.47%
```

Mount drops 37.9% → 29.2% and the time spreads across half, side and back. The
escalator flattens.

### Q2 — does the 15-second hold in side control come down? **NO under `decay`. Marginally under the chooser.**

```
   arm        entries reached_gate    mean_held_t  mean_held_s
   current        199       74.9%          299.6        14.98
   decay          199       74.9%          299.6        14.98
   graph          233       73.4%          282.1        14.11
   both           233       73.4%          282.1        14.11
```

**`decay` reproduces `current`'s seat ticks EXACTLY, and that is the correct
result rather than a failure.** The decay changes what a held tick *pays* and
nothing else — **no code in this engine reads control value to decide whether
to leave a seat.** The seat ticks can only move on an arm where the chooser
runs, and there they move by 17.5 ticks: **14.98 s → 14.11 s, 5.8%.**

**So the hold cost is economically correct and behaviourally weak.** It does
what it was built to do — control units per 100 ground ticks fall **8.01 →
5.85, a 27% cut** — and it barely shortens the hold, because the only thing
reading the decay is the chooser's `hold_value` term, and that term competes
against `reward` on an edge the man may still fail.

```
   arm             units     ground_t     units/100t
   current         11229       140158           8.01
   decay            8205       140158           5.85
   graph           11564       153381           7.54
   both             8589       153381           5.60
```

**`DECAY_GATES = 2` REMAINS AUTHORED AGAINST NO TARGET.** S57 said so and this
stage does not change it. A 27% cut in scored control is a large move for a
magnitude nobody calibrated, and calibrating it is a measurement job for a
later stage — the same honest position the eight balance magnitudes shipped in.
**Do not quote 5.85 as a calibrated figure.**

### Q3 — does the chooser actually CHOOSE? **YES. Nine distinct edges, two or three from every seat.**

```
   graph    9 distinct edge(s), 613 decisions:
     back_to_mount           3    0.5%
     guard_to_side         232   37.8%
     half_to_side           79   12.9%
     mount_hold             38    6.2%
     mount_to_back          11    1.8%
     mount_to_side          11    1.8%
     side_hold             122   19.9%
     side_to_half           37    6.0%
     side_to_mount          80   13.1%
```

From **side**: hold 19.9%, to mount 13.1%, to half 6.0%. From **mount**: hold
6.2%, to back 1.8%, to side 1.8%. **More than one edge from the same seat, on
every seat that offers more than one** — which is the answer to the failure
Qwen and Dola both predicted in their self-objections. It is not the escalator
with extra steps.

Two supporting checks, both of which exist because the first sweep lied:

- **The roll is uniform.** Ten bands across 613 decisions: 10.4 / 12.1 / 10.4 /
  14.0 / 7.2 / 10.1 / 9.1 / 7.8 / 9.0 / 9.8 %. It has to be, or the weights are
  not what decides. The chooser rescales the top man's own gate draw off its
  own threshold and **consumes no fifth RNG draw** — `_run_grapple` takes FOUR
  DRAWS, HERE, ALWAYS, and that contract is intact, which is why the control
  arm can be byte-identical at all.
- **`tools/s58_roll_sweep.gd`** drives the graph directly with no engine and no
  RNG, sweeping `roll` across 0..1 at every seat, actor and held time, printing
  each edge's score breakdown and which rolls select it. That tool is what
  caught the dead skill term, and it reports any edge no roll can ever select.

---

## 5. WHAT ELSE MOVED, SAID PLAINLY

**Bout methods moved, and the graph caused it:**

```
   current  { "SUBMISSION": 42, "DECISION": 45, "KO": 22, "TKO": 11 }
   graph    { "SUBMISSION": 36, "DECISION": 52, "KO": 22, "TKO": 10 }
```

**Six fewer submissions in 120 bouts, seven more decisions.** That is a direct
consequence of the placement decision in Q1: a man who chooses to advance is a
man not holding mount long enough to open an attempt. It is small (5% of bouts)
and it is real, and it is named here rather than left for someone to find.
Knockouts are unchanged (22 / 22), so nothing leaked into the striking game.

**Ground spells end differently:** `stand_up` 71 → 83, `round_or_bout_end`
67 → 59, `stall` 6 → 5. More ground exchanges resolve on their own and fewer
run out the clock. Total ground time rises 140,158 → 153,381 ticks (+9.4%),
because a man who advances resets a hold gate rather than running down a stall
clock.

**Scope, so the edge tally is not over-read: only the TOP man chooses.** The
bottom man's escapes, sweeps and stand-ups are untouched on every arm and still
run the shipped ladder, so `mount_escape` and `side_escape` are authored on the
graph and deliberately never offered. Wiring the bottom man is its own slice
with its own control arm.

**`STALL_FIRE_TICKS` IS UNTOUCHED.** It is G35 §4's referee clock and it stays
as the hard backstop. The defect the decay answers is economic and separate,
and speeding the referee up would have been tuning a number to fix a problem in
a different mechanism.

---

## 5b. U139 CAME BACK BLIND AND THE DECAY IS ONE STEP, NOT A CURVE

Cursor wrote `tests/ground_graph_contract_test.gd` against the DEFINITION,
forbidden to open `GroundGraph.gd`. **Verified here on our own tree: parse
`CHECK total=1 fails=0`, `--only ground_graph` `SUITE total=1 fails=0`, six
mutants written and all six caught** (`current_decay`, `no_floor`, `skill_sum`,
`choose_argmax`, `ignore_min_hold`, `hold_constant`). It found no blocking
disagreement with the module, which is the seventh time the blind split has
paid.

**Its one flagged ambiguity is real, and the reading it gave is wrong in a way
worth correcting.** It reported that `hold_value` "plateaus at 0.5 while
`control_units_decayed` keeps stepping down on ints". Computed out, they
plateau at *the same* point — but chasing that claim found something neither
the test nor the module says out loud:

```
held   side/mount/back(flat=2)   half(flat=1)   hold_value
     0            2                  1            1.00
   119            2                  1            1.00
   120            1                  1            0.50
  6000            1                  1            0.50
```

**`DECAY_GATES = 2` IS NOT A HALF-LIFE AND NOT A CURVE. IT IS ONE STEP, AT 120
TICKS, AND IT IS THE ONLY STEP THERE WILL EVER BE.** `flat - steps` floors at
`CONTROL_FLOOR = 1`, and `flat` is 2, so a dominant seat has exactly two
possible values and reaches the second one after six seconds. The module header
describes "one step of decay per `DECAY_GATES` multiples of that seat's own
`hold_ticks`" — a ladder the integers cannot climb past its first rung.

**And half guard never decays at all**, because its flat value of 1 already
equals the floor. So under `decay` the three dominant seats are compressed to
half guard's rate and half guard is untouched.

**This changes how Q2's 27% must be read.** The cut from 8.01 to 5.85 units per
100 ground ticks is the product of a single binary step, not of a decaying
curve — which makes the "authored against no target" caveat *stronger*, not
weaker: the magnitude is uncalibrated and the SHAPE is not the shape its own
header claims. Anyone tuning this should fix the shape before touching the
number, and `CONTROL_FLOOR`, `DECAY_GATES` and the integer payout have to move
together or not at all.

---

## 5c. U140 TRIED TO FIX THE DECAY'S SHAPE. IT CANNOT BE FIXED IN INTEGERS, AND THE ATTEMPT DOES NOT SHIP.

Cursor was asked for the SHAPE, explicitly not the number, and told that
arguing the cliff is correct and only the header is wrong was a legitimate
answer. It delivered a stepped ladder, kept the control arm MATCHing S56
integer for integer, kept both test subsets green, and honestly separated
payout from chooser. **The change still does not ship, and the reason is
arithmetic rather than effort.**

What it actually does on the seats that exist:

```
held   shipped(flat=2)  U140(flat=2)   shipped(flat=1) U140(flat=1)
   119         2               2              1             1
   120         1               2              1             1
   238         1               2              1             1
   239         1               1              1             1
  6000         1               1              1             1
```

**It moves the one step from 120 ticks to 239 — 6.0 s to 11.9 s — and changes
nothing else.** Its multi-step branch is real code and is **unreachable on
shipped data**: `span = flat_units - CONTROL_FLOOR` is 1 for side, mount and
back and 0 for half guard, so no seat in the engine ever takes it. Half guard
still cannot decay, which its digest says plainly.

So the measured effect is a magnitude change wearing a shape fix's name: the
discount falls from 27% to about 17% (`units/100t` 8.01 → 6.66 rather than
8.01 → 5.85). **That is a quiet halving of a number nobody calibrated, and the
task said not to tune it.** Not merged.

**THE REAL FINDING, WHICH IS WORTH MORE THAN THE PATCH:** a graded discount is
**not expressible** while control is paid in whole units with `flat = 2` and
`CONTROL_FLOOR = 1`. There are exactly two integers between the value and the
floor, so every possible implementation is a cliff and the only free parameter
is *when* it fires. The header has described a curve that the number system
cannot represent since the day it was written.

**The repair is therefore a RESOLUTION change to control units, not a change to
`DECAY_GATES`** — pay in tenths, or accumulate fractional control and floor it
at emission. That changes what every existing scorecard adds up to, so it is
its own stage and it is a product ruling rather than an engineering one. It is
recorded in the roadmap's `then` and it is **not** being decided here.

---

## 6. THE HONEST LIMITS

1. **The skill term is flat across one man's own edges, by construction.** A
   `technique_progress` record **saturates** — `AthleteDevelopment` reports
   `progress = 1.0` the moment `learned` is true and never moves again — so
   once a man has learned both `bjj_mount` and `bjj_side_control` there is no
   per-technique number left to tell his mount from his side control.
   `_ground_skill_of` therefore reads his **grapple stat** for anything he has
   trained and zero for anything he has not. That differentiates the two MEN
   (82 against 34) and not one man's own options. Per-edge differentiation
   needs a proficiency the records do not carry, and inventing one inside a
   measurement would be authoring a number against no target.
2. **The fight-plan term contributed nothing in this population.** `FightPlans`
   names roles (takedown / control / submission / transition / damage /
   counter) and `GroundGraph` authored tags (control / pressure / finish /
   scramble / survive). **Neither is wrong and they do not match**, so the join
   is explicit in `PLAN_ROLE_TO_EDGE_TAGS` rather than hidden in a string
   compare that would score zero for ever. Both S56 fighters carry
   `"plan": "balanced"` as a bare string and no `fight_plan`, so
   `plan_by_id("")` is empty and the plan term is **0.00 on every edge here**.
   That is a property of the fixture, not of the mechanism, and it means **the
   plan half of the chooser is authored and unmeasured.**
3. **`DECAY_GATES = 2` is authored against no target** — see Q2.
4. **Nothing here was looked at.** These are engine numbers. No clip was
   rendered and no transition was watched, so "the chooser chooses" is a fact
   about the log and not yet about anything on screen.

---

## 6b. THE FULL SUITE, WHICH THIS FILE'S HEADER PROMISED

Run once at integration, `--jobs 4` (the operator's instruction; never 6 or 8):

```
SUITE total=356 fails=10
```

**Nine of the ten are the documented reds** and not one is new:
`athlete_development`, `capsule_coverage_contract` (module deliberately
absent), `fight_body_overlap`, `fight_pair_live` (PARKED by the operator
2026-09-15), `fight_scoring`, `fight_stage_realism`, `fighter_reachability`
(red on purpose — its error line IS the finding), `weight_cut`, and
`fight_metres`, which hung.

**The tenth was `fight_hud_read_test`, `rc=3221225501` — a Windows crash code,
and NOT on the known list.** Re-run on its own it reads `total=1 fails=0`, so
it is contention and not a defect. Codex, Cursor and Qwen were each running
Godot at the time. **That is stated as a measurement, not as an assumption: it
was re-run before it was called contention.**

**AND A CORRECTION TO THE RECORD ON `fight_metres`.** It is written down as
"HANGS under contention and PASSES ALONE". On this run it hung again at
`--only fight_metres` — `total=1 fails=1`, hang/timeout — **but Cursor was
driving Godot for U140 at that moment, so it was not truly alone either.** The
note is therefore neither confirmed nor refuted here. **Re-run it on a
genuinely quiet box before trusting either version.**

The three focused subsets this stage's gate named all passed: `--only grapple`
`total=10 fails=0`, `--only clip` `total=10 fails=0`, `--only technique_id`
`total=1 fails=0`, and U139's `--only ground_graph` `total=1 fails=0`.

---

## 7. HOW TO RE-RUN IT

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s58_ground_arms.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s58_ground_arms.gd -- 24
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s58_roll_sweep.gd
```

Written to `research/S58_ground_arms.json`. The arm defaults to `current`, so
**every existing caller of `FightRealtime.begin` is byte-identical to before
this stage** — pass `{"ground_arm": "both"}` to get the graph.

Touched: `scripts/FightRealtime.gd`, `tools/s58_ground_arms.gd` (new),
`tools/s58_roll_sweep.gd` (new). `GroundGraph.gd` is **unchanged** — it shipped
correct in S57 and this stage only found a caller that starved it.

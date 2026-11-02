# S4e (6) — THE TIME BETWEEN EXCHANGES: WHAT THE ENGINE HAD, WHAT IT HAS NOW, AND WHAT IS STILL OPEN

Claude, 2026-09-16. The LAST of the five behaviours the operator named on 2026-09-14 night when he ruled ENGINE FIRST.
C133 Q6 is the audit this closes; `S4E_COMMITMENT.md` is the shape it follows — one model file, its own switch, the whole
delta on the new side, and a checksum against HEAD's own scripts rather than an argument.

## POPULATION

Every figure below comes from bouts between men who are **not the same man** and who are **legal for the ruleset they
are in** (operator rules, 2026-09-12, both halves).

- **BOXING** — a rangy out-boxer (190 cm reach, 188 cm, technique 70, speed 72, defense 68, power 48, out-boxer plan)
  against a short pressure fighter (175 cm reach, 177 cm, power 70, conditioning 76, defense 50, technique 55, pressure
  plan). Neither can kick and neither is asked to. The same pair S4e (1) through (5) measured.
- **MMA** — a striker (188 cm reach, power 68, technique 66, grapple 38, orthodox, kickboxer plan) against a grappler
  (178 cm reach, grapple 78, conditioning 74, southpaw, grappler plan). Both able to do everything MMA permits;
  differentiated by style and attributes inside the ruleset, never by removing a technique it allows.
- **CATALOGUE** — the shipped `Godot/assets/data/technique_catalog.json`, no shadow (R137: a fixture is the fighters
  AND the data they fight under).
- 12 seeded bouts per ruleset, seeds 816000+, switch off and on. Boxing is 8×180 s, MMA 3×300 s.

## WHAT WAS THERE BEFORE — C133 Q6, verbatim

> "`_run_impact` opens with `if gap > STRIKE_RANGE: return {}` — **the engine emits literally nothing** on an impact
> tick where the men are more than 1.1 m apart. Impact runs every 2 ticks, decision every 10, movement every 1, so
> between exchanges a fighter gets: a new intent twice a second, and a body that wanders randomly at 8% throttle.
> **No state distinguishes measuring, resetting or recovering from plain `hold`**; `INTENTS` is four words and none of
> them is any of those."

True in every direction. What the audit could not say — because nobody had measured it — is what that costs.

## THE DEFECT, MEASURED BEFORE IT WAS CHANGED

`tools/measure_between_exchanges.gd` samples every standing tick and folds it into spells. An **exchange** is a maximal
run with the men inside `FightRealtime.STRIKE_RANGE`; a **pause** is the run between two exchanges. The definition is
the engine's own constant — the only range at which it can emit anything — not a threshold invented for this stage.

| | boxing HEAD | MMA HEAD | study |
|---|---|---|---|
| exchange spell, mean | **0.94 s** | **0.78 s** | JPES 2016 clash **1.9 ± 0.9 s** |
| pause spell, mean | **2.40 s** | **2.35 s** | Ouergui 2014 pause **5.4 ± 4.5 s** |
| in-range share of standing time | 0.281 | 0.249 | Ouergui HIA ~0.40 / Cappai fighting ~0.60 |
| gap, mean | 1.349 m | 1.406 m | Schortgen 2023 **1.23 ± 0.16 m** |
| standing speed, mean | 0.723 m/s | 0.754 m/s | Thomson 0.6 m/s |
| metres per man per round | 129.3 | 186.1 | Schortgen 155 ± 28 m |

**BOTH SPELLS ARE UNDER HALF THE PUBLISHED FIGURE, in the same direction, for one reason: nothing in the engine
persists.** A man with no phase re-decides twice a second off weights that barely moved, so he crosses the strike line,
crosses back, and the fight churns at about three times the rate a real one does. The mean GAP already sat inside
Schortgen's band — so this was never men standing in the wrong place. It was men **changing their minds too often in
the right one**, and a distance measurement alone could never have shown it.

## WHAT CHANGED

**One model, `FightBetweenExchanges.gd`, and ONE switch — `between_states`, default on** — because this stage is one
idea and a change nobody can switch off is a change nobody can attribute.

- Three phases: **`ENGAGE`** (the exchange), **`RESET`** (re-establishing after one) and **`MEASURE`** — which is
  Cappai's own word, *study*, for the phase this engine had no name for.
- `FightRealtime._build_fighter` carries `phase` and `phase_until_tick`, beside `commit_until_tick` and
  `evade_until_tick`, where C133 said the state had to go.
- `_run_decision` settles the phase BEFORE the draw and **takes none of its own**: `phase_for` is a pure read of the
  phase he was in, the clock and the gap. The phase is stamped **with the switch off too**, so the room and the log can
  name what a man is doing without the lean being on.
- `FightIntent.decide` takes an EIGHTH optional argument, `phase_bias`, exactly the way `opponent` already arrives: an
  empty default leaves every weight where it was, so the six- and seven-argument paths stay byte-identical.
- The lean is **one idea said twice**: a man does not take the move that would end his phase early. `ENGAGE` damps
  `retreat`, `RESET` damps `close`, `MEASURE` damps nothing. **`circle` is never damped** — turning off the line is how
  a fighter LEAVES an exchange, it is already modelled (S4e's circle-out), and damping it would make an exchange a
  thing men cannot get out of.

### EVERY DWELL IS SOMEBODY'S PUBLISHED NUMBER

`CLASH_S` 1.9 s is JPES's clash mean. `LOW_ACTIVITY_S` 2.2 s is Ouergui's low-intensity phase — the re-establish.
`PAUSE_S` 5.4 s is Ouergui's pause. None is rounded toward a rounder-looking number and the test asserts all three to
the digit. The only AUTHORED numbers in the file are the two damping fractions.

### THE SWITCH IS A SWITCH, PROVEN WITH THE OLD ENGINE

`tools/probe_between_off.gd` checksums the whole action log of three seeded boxing bouts. Run against **HEAD's own
`FightRealtime.gd` and `FightIntent.gd`** (`git show HEAD:`, restored after) and against the new files:

```
HEAD PROBE between_states=off bouts=3 actions=3535 biased=0    sha256=b6840ee9baada8ce...
NEW  PROBE between_states=off bouts=3 actions=3535 biased=0    sha256=b6840ee9baada8ce...
NEW  PROBE between_states=on  bouts=3 actions=2806 biased=9176 sha256=0e6fd4dcc1c4526b...
```

Byte-identical off, over 3,535 events, **with the phase still being settled and stamped on both men every decision
tick**. Naming what a man is doing costs the fight nothing. The shipped default is on, so every seeded fight moves and
the pins are re-found from each test's own printed actual.

## THE MEASUREMENT

| | boxing OFF → ON | MMA OFF → ON | study |
|---|---|---|---|
| exchange spell, mean | 0.94 → **1.34 s** | 0.78 → **1.12 s** | JPES **1.9 ± 0.9** (band 1.0–2.8) ✅ both |
| pause spell, mean | 2.40 → **3.16 s** | 2.35 → **3.15 s** | Ouergui **5.4 ± 4.5** (band 0.9–9.9) ✅ both |
| in-range share | 0.281 → 0.297 | 0.249 → 0.262 | reported |
| gap, mean | 1.349 → 1.341 m | 1.406 → **1.353 m** | Schortgen band 1.07–1.39 — MMA moves INTO it |
| standing speed | 0.723 → **0.669 m/s** | 0.754 → **0.654 m/s** | Thomson 0.6 — moves toward it, untuned |
| metres/man/round | 129.3 → 118.9 | 186.1 → **157.5** | Schortgen 155 ± 28 — MMA lands on the mean, boxing drops just below |
| step shape, on-line share | 0.551 → 0.496 | 0.542 → 0.439 | **NO STUDY** — reported, bounded by nothing |

**THE RATE IS TUNED, THE CONSEQUENCES ARE REPORTED.** The two damps were calibrated against the two spell BANDS and
nothing else. That the speed walks toward Thomson and the MMA gap walks into Schortgen's band are consequences nobody
asked for — a man who changes his mind less often crosses less floor — and they are reported here rather than claimed
as targets hit.

**0.50 WAS TRIED FIRST AND IS THE WRONG NUMBER**, recorded so the sweep is not re-run: at 0.50 the boxing clash scrapes
in at 1.09 s and the MMA clash lands at **0.93 s, below JPES's 1.0 s floor**. 0.70 puts both inside. Neither damp is
pushed further to close on 1.9 s: the engine's spell is a DISTANCE proxy for a phase JPES notated from video, and
tuning a proxy onto a study's mean is the mistake this project has already paid for twice.

## THE PHASE THAT WAS BUILT AND THEN NOT SHIPPED

C133 Q6 names three words. **Two are built. "Recovering" is not, and that is a finding, not an omission.**

It was written — a dwell of 5.4 + 4.5 s (Ouergui's pause plus its own published spread), entered below the last quarter
of the tank, which is where every exponent in `FatigueCurve` is above 1.0 precisely because that quarter is where the
collapse lives. Then the measurement was asked whether the tank ever GETS there.

**It does not.** Across 12 seeded 8-round boxing bouts and 12 three-round MMA bouts, switch off and on, the lowest
stamina either man ever reached was **70.7 in boxing and 53.0 in MMA**. A phase keyed to a low tank would have fired
zero times, and this project has now shipped SEVEN pieces of correct, tested, unreachable code. So it is not there, and
`fight_between_exchanges_test`'s S4E6-7 is a **live tripwire** rather than a sentence: the day the tank drops below 25
the check goes red, and that red is the SIGNAL to build the phase.

## WHAT THE RE-BASELINE COST, AND WHOSE EACH RED WAS

Four tests went red in the touched subsets. **One was not mine** — `fight_scoring_test` fails with the identical three
assertions against HEAD's own scripts (checked out, run, restored), as HANDOFF already recorded at 4116a30b.

1. **`fight_ring_position_test` R16** — cutting off read -0.509 → -0.495 m/s and the rule failed. **It is the bearing
   confound a second time**, and the test's own comment had already named the mechanism: the A/B holds `bearing: false`
   in both gated arms because bearing changes when a chase happens at all. The phases damp `close` while a man
   re-establishes, which is a second thing that decides when a chase happens. `between_states: false` is now pinned in
   the same two arms, the shipped arm still carries both, and R16 reads **-0.373 → -0.445 m/s in the ring and
   -0.321 → -0.357 in the cage**: cutting off works, and it was the measurement that had stopped isolating.
2. **`fight_realtime_test`, 12 of 14 failures — the judo endings.** Re-swept over the identical 94000..94099
   (`tools/find_r101_seeds.gd -- judo`): 13 ippon / 15 shido / 4 KO / 68 decision (S4e) → **10 / 9 / 4 / 77**. The men
   spend longer at range and reach fewer finishes inside one 240 s contest. Nothing was tuned to put them back; the
   assertion still says "all three" and the seeds were re-found — 94018 survived a fourth time, and **94017 has now
   changed family three times** across four stages.
3. **`fight_realtime_test`, the grapple-draw probe.** 92003 stopped reaching the floor. `tools/probe_ground_reach.gd`
   now sweeps three arms: pre-S4e 23 of 40 (57.5%), S4e (1) 28 of 40 (70.0%), shipped **27 of 40 (67.5%)**. The RATE
   did not move; the pin did, for the second time, and 92001 — the seed the check was originally written on — is the
   first of the 27 again.
4. **`fight_realtime_test`, the round-two throw check — GREEN ON LUCK, and now reported instead of gated.** It asserted
   `thrown[2] < thrown[1]`. Measured over its own 16 seeds with the phases OFF: r1 3236, r2 3233, r3 2523 — **a
   three-throw margin in 3,236, 0.09%, and nobody had ever written it down**. The engine's own model says it should be
   thin: the same function already notes that a 3×5 empties a man only to about 60 and that every `FatigueCurve`
   exponent is above 1.0 so the first half of the tank costs almost nothing. **Round three is where the curve bites and
   round three stays gated** — it falls 22% both ways, unmoved by this stage. Round two prints its numbers.
5. **`judge_panel_test`** — 13 seeded cards re-pinned from the test's own printed actual, each bout run twice and both
   runs agreeing, plus T11 half re-found: boxing 222 SURVIVED as the majority and kickboxing 5 went unanimous, so
   kickboxing 160 is the split. The 300-seed sweep per ruleset is recorded in the test with its alternates.

## OPEN

1. **THE TANK DOES NOT EMPTY.** 70.7 boxing / 53.0 MMA over 24 bouts on two conditioned-but-not-extreme pairs. It
   blocks the "recovering" phase; it probably also blunts every late-round behaviour the engine has. Its own slice, and
   S4E6-7 is the tripwire.
2. **THE SPELLS ARE INSIDE THE BANDS BUT BELOW BOTH MEANS** (1.34 against 1.9, 3.16 against 5.4). Whether that is the
   engine or the proxy cannot be settled from a distance threshold. **TASK_U109 is the assigned research** and it is
   the instrument that would settle it — between-punch footage rates from the 16 tracked videos. It is written and
   unlaunched because it needs the PC.
3. **THE STEP SHAPE IS UNBOUNDED AND MUST STAY THAT WAY UNTIL SOMEBODY MEASURES IT.** K31's act-on line refuses
   forward/back/lateral shares in as many words. The `hold` wander is still an isotropic compass direction and this
   stage deliberately did not re-base it onto the line to the other man, however plausible that sentence reads — that
   is the invented-constant mistake S4e (2) already paid for.
4. **BOXING'S METRES PER ROUND FELL JUST BELOW SCHORTGEN'S BAND** (129.3 → 118.9 against 155 ± 28). MMA moved the other
   way and landed on the mean. Reported, not tuned; and note the two studies disagree with each other, since Thomson's
   0.6 m/s is 108 m a round, not 155.
5. **`STRIKE_RANGE` 1.1 m is still below the measured 1.23 m mean** (C133 Open 1), and it is now doing double duty as
   the phase fence. Moving it would move both at once.
6. Carried, untouched, from S4e (5): a feint does not yet CAUSE a reaction; `boxing_feint` is unreachable;
   `FightMoves._chosen` still never returns `fit`, so `RANGE_FIT_PENALTY` has still never fired.

## Re-running it

```
godot --headless --path Godot --script tests/fight_between_exchanges_test.gd
godot --headless --path Godot --script tools/measure_between_exchanges.gd -- on
godot --headless --path Godot --script tools/probe_between_off.gd            # must equal HEAD's checksum
godot --headless --path Godot --script tools/probe_ground_reach.gd
godot --headless --path Godot --script tools/find_r101_seeds.gd -- judo
godot --headless --path Godot --script tools/find_r101_seeds.gd -- panel
```

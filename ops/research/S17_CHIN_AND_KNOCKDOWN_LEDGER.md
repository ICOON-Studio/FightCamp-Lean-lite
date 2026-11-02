# S17 — A knockdown that survives the fight, and a chin that pays for it

Stage S17, shipped 2026-09-19. Executes the operator's ruling of the same day:

> "Chin not trainable but it should play a role on how prominent to kos someone
> is, each time someone get knockdown should add up and make him vulnerable to
> Kos."

---

## PART A — the blocker is gone

`knockdowns_suffered` was counted during a fight and then thrown away, so a man
dropped three times who won on points left **no record anywhere in the save**
and chin had nothing to erode.

The count now rides the durable `fight_history` row, on every path that has a
simulation behind it:

| path | `GameState.gd` | writes the count |
|---|---|---|
| live-attended, settled off the roster | `record_live_fight_result` → `_apply_fight_result` | yes, via `pending_fight_result` |
| a watched world bout on the card | `record_watched_world_bout` | yes, per side |
| the Grand Prix **world** round | `:9149` | **no, and correctly so** — it rolls its method from RNG and never simulates a knockdown, so there is nothing to record |
| an unwatched generated world bout | `WorldPopulation` | no — same reason |

The career total is **derived by summing history** (`TaleOfTape.career_knockdowns_suffered`
/ `_scored` / `career_stoppage_losses`, read through
`GameState.get_athlete_knockdown_ledger`), never kept as a second counter that
can drift out of sync with the history it summarises. **No save migration is
owed**: a row written before S17 carries no key and reads 0, which is exactly
right for a fight nobody recorded.

### A direction bug this stage exposed and fixed

`sim_result["knockdowns"]` has ALWAYS been knockdowns **suffered** —
`knockdowns_total` is incremented on the TARGET (`FightSimulation.gd:2484`) —
and its name does not say so. `ContenderSeries.evaluate` read it as knockdowns
**scored**, so the showcase goal *"score a knockdown"* was being met by being
**dropped**. The result now carries `knockdowns_suffered` and `knockdowns_scored`
maps that name their own direction; `knockdowns` is kept unchanged for every
reader that already has it, and ContenderSeries falls back to it so a result
filed before S17 is never silently reclassified after the fact.

**The lesson is the general one: a two-sided count whose name does not say which
side it belongs to will eventually be read the wrong way round.** Nothing durable
is written from the old key.

---

## PART B — chin

Rolled once at creation from the athlete id (`TaleOfTape.migrate_athlete`,
35..85 around a 60 baseline), spent permanently by head trauma, **never trained
and never restored**. Deliberately absent from `AthleteStatModel.STATS`, because
every panel that iterates that list would render it as trainable. Deliberately
not printed anywhere — the visible/hidden decision stays open.

One authoritative number, settled ONCE at the fighter build (`hurt_threshold_base`,
beside `jab_commitment`, because `_hurt_threshold` is a hot path and summing a
career there would pay for the whole career on every exchange):

```
hurt_threshold_base = HURT_HEALTH_THRESHOLD + chin_penalty(chin, career_knockdowns, stoppage_losses)
chin_penalty        = (60 - chin) * 0.12                      # debut, +-3.0
                    + min(1.2*knockdowns + 2.0*stoppages, 12) * wear_scale
wear_scale          = clamp(2.0 - chin/60, 0.6, 1.5)          # a weak jaw spends faster
```

**A fighter with no rolled chin reads the baseline, which makes the debut term
exactly zero**, so every fixture written before S17 fights on the old constant
and nothing in the suite moves under it.

---

## THE NUMBER THIS STAGE IS JUDGED ON — and the thing that was nearly missed

`TASK_S17.md` named the hurt threshold as *the* seam, one line, additive. It is
correct and it was built. **On its own it does not move the KO rate at all.**

Measured, not assumed (`tools/probe_chin_ko_rate.gd`, 240 bouts per cohort):

| cohort | hurt@ | B stopped |
|---|---|---|
| baseline jaw, clean | 35.00 | 21.2% |
| baseline jaw, 3 knockdowns | 38.60 | 21.2% |
| baseline jaw, 8 knockdowns | 44.60 | 21.7% |

**+0.0 points at three knockdowns.** The reason is mechanical and is worth
keeping: `hurt` buys the opponent a 1.6x action weight (`FightSimulation.gd:2939`)
and feeds morale, and it **never enters the knockdown roll** —
`_maybe_trigger_knockdown` reads damage, remaining health and the battered-head
bonus, and nothing else. A chin built on the hurt threshold alone is a quantity
nobody can feel, which is precisely the failure the task file told this stage to
go and look for.

So the same settled number is also read where "vulnerable to KOs" literally
lives, as a signed term on that roll, mirroring the battered-head bonus it sits
beside:

```
chance += clamp((hurt_threshold_base - 35.0) * 0.012, -0.18, +0.18)
```

It moves how often a heavy shot **drops** him, never whether one lands: the roll
is already gated on real damage or an already-low health bar, so a spent chin
never invents a knockdown out of a jab. The cap is reached only by the worst jaw
with a maximally spent career (3 points of debut + the 12-point trauma cap), by
construction rather than by accident.

### The result, paired

600 bouts per cohort. **Every cohort fights the same 600 seeds against the same
opponent**, so this is a bout-by-bout comparison, not two independent
proportions — a bare 600-bout stop rate carries a ~2.0-point standard error,
which would have swallowed the whole effect and did swallow it at 240 bouts.
A **flip** is a bout the clean jaw survived and the spent one did not, or the
reverse.

| cohort (B) | hurt@ | B stopped | knockdowns/bout | +flips | −flips | net |
|---|---|---|---|---|---|---|
| baseline jaw, clean career | 35.00 | 17.0% | 0.25 | — | — | — |
| baseline jaw, 3 knockdowns | 38.60 | 18.5% | 0.27 | 12 | 3 | **+9** |
| baseline jaw, 8 knockdowns | 44.60 | 19.8% | 0.32 | 23 | 6 | **+17** |
| baseline jaw, 8 kd + 2 stopped | 47.00 | 21.3% | 0.33 | 31 | 5 | **+26** |
| granite jaw (85), clean | 32.00 | 16.7% | 0.24 | 4 | 6 | −2 |
| glass jaw (35), clean | 38.00 | 18.5% | 0.27 | 12 | 3 | +9 |
| granite jaw (85), 8 knockdowns | 37.76 | 18.2% | 0.27 | 10 | 3 | +7 |
| glass jaw (35), 8 knockdowns | 50.00 | 22.3% | 0.37 | 39 | 7 | **+32** |

McNemar on the discordant pairs: 3 knockdowns χ²≈5.4 (p≈0.02), 8 knockdowns
χ²≈9.97 (p≈0.002), the battered career χ²≈18.8, the glass jaw with eight
knockdowns χ²≈22.3. **Monotonic across all eight rows**, and the full jaw range
runs 16.7% → 22.3% stopped and 0.24 → 0.37 knockdowns per bout, a 54% increase
in how often he is put down.

`granite jaw, clean` is net −2 on ten discordant pairs, which is not significant
on its own. That is expected rather than disappointing: it is the SMALLEST
penalty in the table (−3.0 points of threshold, −0.036 of chance) and it carries
the right sign.

### The control column, and what its small drift means

A's stop rate across the eight rows: **10.3 / 10.0 / 9.7 / 9.5 / 10.3 / 10.0 /
10.0 / 9.8**. A's own jaw and history never change, so a large move there would
mean the fixture had moved rather than the chin. It does drift down by ~0.8
points at the extreme, and that is a mechanism, not noise: a B who is stopped
more often ends bouts earlier, which gives A fewer exchanges in which to be
stopped himself.

### The population (R137: a fixture is the fighters AND the data they fight under)

Boxing, catalogue md5 `c28ca56d1a1ffcb0d4ba19dde4d8eaaf`, seeds 917000+.
**Never identical fighters, and both legal under the ruleset they fight in:**
an Outside Boxer (188/193 cm, orthodox, jab-and-move, 15 learned) against a
Pressure Puncher (176/178 cm, southpaw, hooks and body work, 15 learned) — two
boxers in a boxing bout, differentiated by style and attributes rather than by
removing techniques the ruleset permits. The cohorts vary **only** the tested
man's jaw and career history, which is the one thing the experiment is about.

**Boxing deliberately:** `_maybe_trigger_knockdown` returns false for every other
ruleset, so a knockdown cannot happen outside it and an MMA population would
have measured nothing at all.

---

## Deliberately NOT done

- **Chin is not printed.** Same posture as aggression: built, not surfaced. A
  scout report is its natural home later.
- **`knockdowns_scored` stays out of the chin maths.** It is the opponent's jaw,
  not his. Stored because it is free and hands "dropped three times in his last
  five" to matchmaking and commentary later.
- **The softening never recovers** — ruled 2026-09-19 — but it is capped, or a
  long career walks the threshold past the knockdown health gate and every
  exchange reads as hurt.
- **`FightRealtime.gd` is untouched.** It owns its own hurt model and its own
  `knockdowns_total`; carrying chin across to the real-time engine is a separate
  slice with its own re-baseline, not a quiet widening of this one.

## Reproduce

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/probe_chin_ko_rate.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_chin_test.gd
```

# TASK R84 — CLAUDE — SCORING, STOPPAGE AND RESULT ON THE REAL-TIME CORE

Model: Opus, high effort, Fast off. Owner: Claude. Depends on: R82, R83,
R83F, C64, U22, G30, Q16 — all landed at `f5c44d0`, suite `total=200 fails=0`.

R82 stage 1 proved a seeded real-time fight replays byte-for-byte. R83 made the
core read the fighter and made the fight hurt. **The fight can now be fought and
cannot yet be WON.** `FightRealtime.run_to_completion` returns a state with a
log, two damaged bodies and no score, no stoppage and no result. R84 closes
that, and wires the one module that landed unwired.

---

## The lesson this task is written under

2026-09-09 found THREE defects that were all code which was correct, tested,
and could never run: U20's `absorbed`/`slipped` had no producer, `stamina` was
never drained, and the flash knockdown was arithmetically unreachable. Every one
survived a green suite because every test checked a single function alone.

**Assert that a feature OCCURS in a real fight, not that it is permitted.** A
test that proves `_stoppage_for` returns "KO" when handed a knockdown is the
same test that passed while nothing could ever produce a knockdown. Every gate
below runs a whole fight and counts what came out.

And the second half of it, from C64: **check thresholds against what the engine
really emits, not against a plausible-looking range.** Measure first, author
second, and put the measured figure in the digest.

### A fourth piece of the same, found while writing this task

`ImpactModel.LIVER_DELAY_MIN_SECONDS` (5.0) and `LIVER_DELAY_MAX_SECONDS`
(25.0) are used **nowhere in the repository** outside their own declaration.
C63's comment says "A successful roll is scheduled by the caller after U20's
5..25 fight-seconds" — R84 is that caller, and until R84 they were two
constants nothing could reach. Wiring them is in scope.

---

## DECISION 1 — the strike-target distribution (the open question, settled)

`_run_impact` picks `REGIONS[rng.randi_range(0, 1)]`. Only `head_neck` and
`torso_core` can ever be hit; the other four sit at 100.0 for the whole fight
and their `REGION_WEAR_COEFFICIENTS` (0.6 arms, 0.8 legs) are unexercised. R83
left it deliberately, wrote it up as R83_DIGEST finding 2, and it must not be
inherited a third time.

**RULED: a weighted table over FIVE targets. Legs become real targets. Arms
stay at zero, on purpose, and that is the substance of the ruling.**

```
const TARGET_WEIGHTS := {
    "head_neck":  0.60,
    "torso_core": 0.28,
    "left_leg":   0.06,
    "right_leg":  0.06,
    "left_arm":   0.00,
    "right_arm":  0.00,
}
```

**Why legs go in.** A leg kick is aimed at a leg. It is a target in every
ruleset this game will carry except boxing, `REGION_TO_ZONE` already maps both
legs to `RealtimeRoundStats`'s `legs` zone, and with the old draw that zone
could never be populated — a third piece of code that could not run.

**Why arms stay out, which is the part that is a decision and not an
omission.** An arm is not a thing anyone aims at; it is where a block lands.
U20's own record separates `target_region` from `guard_region` — "the
absorbing/blocking arm id" — and `ImpactModel`'s header says in as many words
that guard wear "belongs to the future richer impact record; this contract
returns target-region wear only." Emitting `region: left_arm, contact: clean`
would mean a fighter deliberately punching a forearm. Arm damage is real, and
it arrives through the guard channel, which needs `make_impact` to accept a
guard region and `wear_from` to return two regions. That is C63's contract and
33 of its tests, and it is not this task's to reopen.

So the honest answer to "four regions sit at 100.0 forever" is that the
question bundled two different faults: **legs were a bug and are fixed here;
arms are correct and stay at 100.0 until the guard channel exists.** A 0.6
coefficient on a region nobody aims at is correctly unexercised, not dead.
Recorded as the R84 follow-up, with that reason, so the next reader does not
re-open it as an oversight.

**Weights are AUTHORED**, labelled the way R44's membership rate is. They sit
near the real striking splits (MMA significant strikes run roughly 65% head /
22% body / 13% legs; boxing is head-heavier with no leg strikes at all) and are
a single const table so a ruleset can override the split later without
touching the draw.

**Cost: still exactly ONE draw.** A cumulative scan over one `rng.randf()`
replaces one `rng.randi_range(0, 1)`. The per-impact count on `_rng_impact`
does not move.

---

## DECISION 2 — where the new randomness lives

The gate: seeded replay stays byte-for-byte, and every new draw comes from an
existing stream. Stoppage needs a recovery roll, and the liver delay needs a
timestamp. Both are new randomness.

**RULED: `_rng_impact` STAYS AT SEVEN DRAWS PER IMPACT. R84 adds two new
streams instead.** `SEED_STOPPAGE` and `SEED_JUDGE`, alongside the three that
exist. This is the file's own stated principle — "each subsystem draws from its
own generator so that adding a draw to one can never shift another's sequence"
— applied rather than amended, and it means the R83 impact sequence is
untouched by everything R84 adds.

`_rng_stoppage` takes **three draws per built impact, all unconditional** (the
knockdown roll, the count roll and the liver-delay fraction), because the file's draw discipline
forbids drawing inside an `if`: a conditional draw would make the stream's
position depend on the fight's content. `_rng_judge` is drawn **once, at
`begin`**, for the panel — the R38 pattern, exactly as `FightSimulation.gd:468`
does it.

**Report in the digest:** impact stream unchanged at seven; two new streams
added; three draws per built impact on the stoppage stream.

---

## The work

### A. Stamina, wired (G30 landed unwired)

`FightStamina.gd` is on master and nothing calls it. `stamina` is on the
fighter, is READ by `FightIntent.decide` (it redistributes CLOSE weight as a
man tires) and is never written, so every fighter fights round three exactly as
fresh as round one.

* `_run_movement` — each man pays `movement_drain(intent, conditioning, 1.0/hz)`.
* `_run_impact` — the actor pays `strike_drain(force, conditioning)`; the target
  pays `impact_drain(<summed wear>, conditioning)`.
* Round close — each man takes `rest_recovery(stamina, conditioning, rest_seconds)`.
* `conditioning` is `stats.get("conditioning", 50)`.

**The trap, and it is a measurement one.** G30T (Qwen) reported the tank
empties to the 1.0 floor across a 3x5. Its arithmetic was right about the
method — `1.0/20.0` seconds per tick, not 1.0 — and wrong about `force`: it
passed 40.0 into `strike_drain`, whose contract is 0.0..1.0, making one strike
cost 3.22 instead of 0.056. **Do not tune the module against that number.**
Wire it, run the real engine, print the real end-of-fight band, and only then
decide whether anything needs tuning.

### B. The G30T reconciliation, finished and committed

Both files are sitting UNCOMMITTED in the working tree from a prior session:

* `Godot/scripts/FightStamina.gd` — modified, adds `MAX_REST_FRACTION := 0.9`
  so a long rest cannot hand back more than the deficit and clamp the man to a
  full tank. **This one is a real module defect and the fix is correct**: the
  raw fraction passes 1.0 at about 100 s of rest, sooner at high conditioning.
* `Godot/tests/fight_stamina_test.gd` — untracked, Qwen's G30T test, with the
  `force` unit error already corrected to 0.45 in a note.

Verify both, then commit them. G30's module and G30T's test both land here.

### C. Scoring

At each round close, for the round that just ended:

```
stats_a = RealtimeRoundStats.fold(state["log"], "a", n)
stats_b = RealtimeRoundStats.fold(state["log"], "b", n)
cards   = JudgePanel.score_round(profile, judges, stats_a, stats_b, detail)
```

`detail` carries `knockdowns_a`/`_b` and `damage_a`/`_b`
(`RoundScoring.damage_points`), the way `FightSimulation.gd:2742` builds it.
Append `{"round": n, "cards": cards, "consensus": JudgePanel.median_card(cards)}`
to `state["scorecards"]` — that is the shape `JudgePanel.decision` reads.

`profile` is `RoundScoring.profile_for(options.get("ruleset", {}))`, settled
once in `begin` beside the panel.

**A round closes when the clock leaves it, not on a cadence.** `fold` filters
the log by `round`, so closing round N at any moment after N ended gives an
identical answer; drive it off `round_number(state)` passing
`state["scored_through"]`, plus once at the final bell. **A stoppage does NOT
close its own partial round** — that matches the atomic engine, where
`rounds_completed` is `scorecards.size()`.

### D. Stoppage

One function, called from one place, the way `FightSimulation._check_stoppage`
is "the single place that actually ends the fight, so callers never have to
reason about two different places a fight can end."

1. **Knockdown.** `shocked` on an impact means he went down.
2. **Flash.** `ImpactModel.is_flash_knockdown(shock, head_remaining)` is used
   for what its name says — the kind of knockdown a man gets up from, a healthy
   head above 80 — so a flash knockdown recovers with no roll. It stops being
   decoration and becomes load-bearing.
3. **KO.** Any other knockdown rolls for recovery on `_rng_stoppage`, off
   conditioning, fight IQ and remaining head, bounded so it is never certain in
   either direction (the atomic engine's `KNOCKDOWN_RECOVERY_FLOOR`/`CEILING`
   shape). A failed roll is a **KO** to the other man. Note what this means:
   because `is_flash_knockdown` gates on a head above 80, a KO can only come
   from a head already worn below 80 or from a liver shot — which is the
   model saying a man is knocked out after he has been hurt, not from fresh.
4. **Three-knockdown TKO.** `knockdowns_round >= 3` — `THREE_KNOCKDOWN_RULE_COUNT`.
5. **Doctor stoppage, between rounds only, `head_neck <= 15`** —
   `DOCTOR_STOPPAGE_HEAD_CONDITION_THRESHOLD`. U20 says KEEP, and says it is
   already fight-time-scoped to the rest minute.
6. **The liver delay.** A liver-class shock he survived sets
   `delayed_shock_at_s = t_s + LIVER_DELAY_MIN..MAX`. When fight time reaches
   it, if he is still up, he goes down again. U20: "It is a timestamp, not a
   tick."

Methods are the atomic engine's own words, uppercase — `"KO"`, `"TKO"`,
`"DOCTOR STOPPAGE"`, `"DECISION"` — so one vocabulary describes both engines.

### E. Result

`FightRealtime.result(state)`:

* stopped → `{"winner_side", "method", "round", "t_s", "decision_type": ""}`
* full distance → `JudgePanel.decision(state["scorecards"])`, `method` `"DECISION"`.

---

## Owned files

| File | Lines | How to read it |
| --- | --- | --- |
| `Godot/scripts/FightRealtime.gd` | 507 | Owned. Tick loop `:230`, `_run_decision` `:306`, `_run_movement` `:325`, `_run_impact` `:366`, the region draw `:390`. |
| `Godot/tests/fight_realtime_test.gd` | 376 | Owned. Harness `:22`, gate `:86`, roster `:61`. |
| `Godot/scripts/FightStamina.gd` | 125 | Owned for this task. Small, read whole. Commit the working-tree fix. |
| `Godot/tests/fight_stamina_test.gd` | 239 | Owned for this task. Untracked; verify and commit. |

**Read only, do not edit:** `ImpactModel.gd` (128), `RealtimeRoundStats.gd`
(110), `RoundScoring.gd` (193), `JudgePanel.gd` (175), `FightIntent.gd` (75),
`TickBudget.gd` (52), `FightClock.gd` (90). `FightSimulation.gd` is 3,100+
lines and is **not touched** — read `:2742` and `:2843` as templates only.

---

## Gates — every one of them counts what a real fight emitted

1. **The R82 gate, unmoved.** Same seed twice → identical log, identical bodies,
   identical scorecards, identical result.
2. **A card is actually produced.** A full-distance fight has one scorecard per
   round, every card is ten-point-must, and `decision` names a winner or a
   typed draw.
3. **A fight actually stops.** Over a seed sweep, at least one fight ends by
   stoppage — and stoppages are a minority, not the norm. Print the rate.
4. **All five targets are actually hit** in one fight, and both arms are
   untouched at exactly 100.0 — the decision above, asserted rather than
   assumed.
5. **Stamina actually falls**, ends off both the floor and the ceiling, and a
   fitter man ends fresher than a less fit one.
6. **The liver delay actually fires** at least once across the sweep.
7. No impact refused; `impacts_built > 0`, so a zero refusal count means
   something.

## Parse gate, before any test

```
python Godot/tools/check_scripts.py Godot/scripts/FightRealtime.gd Godot/scripts/FightStamina.gd Godot/tests/fight_realtime_test.gd Godot/tests/fight_stamina_test.gd
```

## Tests

Focused, first:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_stamina_test.gd
```

Then the consumers R84 feeds — `realtime_round_stats_test.gd`,
`judge_panel_test.gd`, `round_scoring_test.gd`, `broadcast_read_test.gd`.

Full suite ONCE, in the background, before the commit:

```
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0` at `f5c44d0` with `total=200`. R84
adds `fight_stamina_test.gd`, so `total` rises to 201. Land `fails=0`; if
`total` differs from 201, say so and push.

# R84 DIGEST — SCORING, STOPPAGE AND RESULT ON THE REAL-TIME CORE

Owner: Claude. Base `f5c44d0` (suite `total=200 fails=0`).
Files: `Godot/scripts/FightRealtime.gd`, `Godot/tests/fight_realtime_test.gd`,
plus the G30/G30T reconciliation in `Godot/scripts/FightStamina.gd` and
`Godot/tests/fight_stamina_test.gd`.

The fight could be fought and could not be won. It now scores, stops and
returns a result.

---

## Everything below was MEASURED, not assumed

The day's lesson was three defects that were correct, tested, and could never
run, and C64's repeat of it one level up: tuning against an assumed
distribution instead of the emitted one. So every constant in R84 was authored
against a sweep of whole fights, and the sweeps are quoted here so the next
person can check the arithmetic rather than re-run it.

**Standard bout (the two test fighters, 3x5, 120 fights):**

| Figure | Measured |
| --- | --- |
| impacts / fight | 812 |
| shocks / fight | 5.43 |
| **knockdowns / fight** | **0.68** |
| stopped | **27 of 120 — 23%** (all KO) |
| went the distance | 93 of 120, every one with 3 cards |
| decision types | 90 unanimous, 3 unanimous draw |
| `head_neck` at the final bell | min 49.7, mean 65.3 |
| stamina at the final bell | min 57.7, mean 65.7 |
| liver collapses | 30 scheduled, **30 fired** |

**Target shares, over 32,490 impacts:** head 60.1%, torso 28.1%, legs 11.8%,
arms 0.0%. The authored table is 0.60 / 0.28 / 0.06 / 0.06 / 0 / 0.

---

## The open decision, settled: what a man aims at

`_run_impact` drew `REGIONS[rng.randi_range(0, 1)]`, so only head and torso
could ever be hit and four regions sat at 100.0 with their wear coefficients
unexercised. R83 left it and wrote it up; this settles it.

**The question bundled two faults with opposite answers.**

**Legs were a bug.** A leg kick is aimed at a leg, and `RealtimeRoundStats`
already maps both legs to its `legs` zone — a zone that could therefore never
be populated, which is the same defect one level up. Legs are now real targets
at 6% each.

**Arms are not a bug and stay at zero.** Nobody aims at a forearm; an arm is
where a block lands. U20's record separates `target_region` from
`guard_region`, and `ImpactModel` states that guard wear "belongs to the future
richer impact record; this contract returns target-region wear only." Emitting
`region: left_arm, contact: clean` would mean a fighter deliberately punching
an arm. **So the 0.6 arm coefficient is correctly unexercised rather than
dead** — it is waiting on the guard channel, which needs `make_impact` to take
a guard region and `wear_from` to return two. That is C63's contract and 33 of
its tests, and reopening it was not this task's to do.

Both halves are asserted: the test requires all four real targets to be hit in
a fight AND both arms to end at exactly 100.0.

Weights are AUTHORED, labelled like R44's membership rate, in one const table a
ruleset can later override. They sit near the real splits (MMA significant
strikes run about 65% head / 22% body / 13% legs; boxing is head-heavier with
no leg strikes).

**Cost: still exactly one draw.** A cumulative scan over one `randf()` replaced
one `randi_range(0, 1)`.

---

## The thing that nearly shipped

The obvious wiring is `shocked` means he went down. **At 5.43 shocks a fight
that is five knockdowns a bout and a KO in essentially every fight.** The suite
would have been just as green as with a rule that could never fire — a rule
that fires far too often is the same class of defect, and only running the
engine and counting says which one you built.

So **`shocked` is HURT**, and a knockdown is a second, rarer roll on top of it,
more likely against a worn head (off the same `head_wear` quantity
`shock_chance` already uses, so hurt and dropped never disagree about the head
that took it). That lands 0.68 knockdowns and a 23% stoppage rate.

`ImpactModel.is_flash_knockdown` finally does what its name says: against a
head still above 80 the man is up at eight — U20's flash knockdown, the one he
gets up from — and anything else rolls to beat the count. **A KO can therefore
only come from a head already worn below 80, or from a liver shot: a man is
knocked out after he has been hurt, never from fresh.**

Event vocabulary, three words kept apart: `shocked` (hurt), `knockdown` (down),
`flash_knockdown` (down and got up — U20's own definition, and the field
`RealtimeRoundStats` already counts, so U22's adapter scores this engine
unchanged).

---

## The fourth piece of unreachable code, found and wired

`ImpactModel.LIVER_DELAY_MIN_SECONDS` (5.0) and `LIVER_DELAY_MAX_SECONDS`
(25.0) were used **nowhere in the repository** outside their own declaration.
C63's comment says "a successful roll is scheduled by the caller" and no caller
existed. R84 is that caller: a liver-class shock he survived now schedules a
collapse at `t_s + 5..25`, U20's "timestamp, not a tick". Measured: 30
scheduled, 30 fired.

A collapse emits no impact record of its own, so `liver_scheduled` /
`liver_fired` were added as state witnesses — the `impacts_built` pattern —
because otherwise the one path U20 designed would be invisible to any test that
reads the log.

---

## Determinism: the impact stream did not move

The gate is unchanged and passes. **`_rng_impact` still takes exactly seven
draws per impact**, so the R83 impact sequence is untouched by everything R84
added. Rather than widen it, R84 applied the file's own stated principle —
"each subsystem draws from its own generator so that adding a draw to one can
never shift another's sequence" — and added two streams:

* `_rng_stoppage` — **three draws per built impact, all unconditional** (the
  knockdown roll, the count roll, the liver-delay fraction). Unconditional
  because a roll taken only when a man is hurt would make the stream's position
  depend on the fight's content.
* `_rng_judge` — drawn **once at `begin`** for the panel, the R38 pattern.

The delayed liver collapse consumes **no draw at all** when it fires: its
recovery roll is banked at the impact that scheduled it, because a draw taken
at collapse time would be a draw inside an `if`.

The replay gate now also compares scorecards, result and stoppage, not just the
log and the bodies.

---

## Stoppage rules, all four proven to OCCUR

| Rule | Value | Proof |
| --- | --- | --- |
| KO — a knockdown he does not rise from | recovery 0.55..0.92 off conditioning, fight IQ, head | 27 of 120 standard fights |
| TKO — three knockdowns in one round | `THREE_KNOCKDOWN_COUNT = 3` | 19 of 400 bomber-vs-iron-chin fights |
| DOCTOR STOPPAGE — between rounds | `head_neck <= 15` | 18 of 40 championship-distance fights |
| DECISION | the panel's cards | 93 of 120 standard fights |

Methods are the atomic engine's own uppercase words, so one vocabulary covers
both engines.

---

## THREE FINDINGS THAT ARE NOT FIXED HERE — reported, not left silent

**1. The doctor stoppage cannot fire in a three-rounder, and that is correct.**
Measured heads end between 49.7 and 75.3, nowhere near 15. **The threshold was
NOT tuned down to make it fire** — 15 is a medical rule, not a rate to hit. It
is proven reachable over a championship distance instead, and the test asserts
both: that it fires over 12 rounds and that it stays out of a 3x5.

**2. A 12-round fight is stopped 100% of the time (22 KO, 18 doctor, zero
decisions).** The head loses about 34 points per three rounds, so it cannot
survive twelve. **This is the WEAR rate, not the stoppage rules** — C63/R83F's
calibration, authored when nothing consumed a whole fight's worth of it. The
stoppage rules behave correctly at the 3x5 the game actually uses. This is the
next thing to look at before any championship-distance bout ships.

**3. A split or majority decision is currently impossible, and the three-judge
panel is decorative.** All 91 decisions across two sweeps came back unanimous,
including between two identical fighters. The cause is structural, not
statistical: judge bias perturbs SECONDARY criteria only (J1 §3.2 forbids
perturbing primary damage), and the real-time engine emits no grappling, so
`control_score`, takedowns, positions and submissions are all zero. **Damage is
the only non-zero term, and it is the one term every judge weighs identically**
— so three judges are arithmetically incapable of disagreeing. `_win_type`'s
"split" and "majority" branches and `decision`'s `split_draw` / `majority_draw`
are unreachable from this engine today. They become reachable when real-time
grappling lands. This was NOT worked around by perturbing damage; the R38
ruling stands.

---

## The G30 / G30T reconciliation, closed

Both files were sitting uncommitted in the working tree from a previous
session. Verified and landed:

* **`FightStamina.gd` — `MAX_REST_FRACTION := 0.9` is a real fix.** The raw
  rest fraction passes 1.0 at about 100 s and sooner at high conditioning, so a
  long rest handed back more than the deficit and `apply` clamped the man to a
  full tank — breaking the one rule the contract calls most important.
* **G30T's three "contract disagreements" were two, and both are resolved.**
  Its rest_recovery findings were the real defect above. Its third — a whole
  fight ending at the 1.0 floor — was **the test's unit error, not a module
  defect**: it passed `force = 40.0` into `strike_drain`, whose contract is
  0.0..1.0, making one strike cost 3.22 instead of 0.056. Corrected to 0.45.
* G30's own header arithmetic was right all along. Wired into the real engine
  and measured, a man finishes a 3x5 at **57.7–65.7** — "tired but standing",
  against the module's predicted 40–55 before the corner's minute was counted.

`fight_stamina_test.gd` now passes 223 checks and joins the suite.

---

## Gates

`fight_realtime_test.gd`: **122 checks, PASS** (was 14 test functions, now 22).
Every R84 gate runs whole fights and counts what came out:

* the target ruling — all four real targets hit, both arms at exactly 100.0
* a card is actually turned in, one per round, every one ten-point-must
* a fight actually stops **and not every fight does** — both directions
* a knockdown is rarer than being hurt, in the engine's own numbers
* stamina is actually spent, off both bounds, and the fitter man finishes fresher
* the liver delay actually fires
* three knockdowns actually stop a fight
* the doctor actually stops one, and stays out of a three-rounder

Focused consumers: `realtime_round_stats_test` 210/0, `judge_panel_test` 0
failures, `broadcast_read_test` 88/0, `fight_stamina_test` 223/0.

## Test command

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd
```

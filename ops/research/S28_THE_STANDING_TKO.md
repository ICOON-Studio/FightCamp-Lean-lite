# S28 — the standing TKO: the referee steps in, and the read that told him was already built

**Claude · 2026-09-20 · engine stage, ENGINE FIRST arc · continues S26 and S27**

## WHY THIS EXISTS

S26 calibrated the fight's pace to J20's D1 anchor and S27 the damage beside it, and together they
landed **both factors of the knockdown path**: bouts carrying a knockdown, and the share of those
that end by stoppage. What they could not reach was the total. **KO/TKO sat at 22.08% of bouts
against the sport's 32-34%**, and the arithmetic said exactly where the rest had to come from —
every remaining point arrives from a stoppage that does **not** follow a knockdown, and the engine
had no such rule at all. It stopped on a failed count or on three knockdowns in a round, and
otherwise let a man absorb punishment to the final bell.

`probe_balance_anchors` printed the hole in one line: **`stopped with NO knockdown 0`.**

## WHAT WAS ALREADY BUILT, AND WIRED TO NOTHING

`FightStoppageRead.fold` folds precisely the evidence a referee reads — shocks, knockdowns and
unanswered landed work in a 60 s window, amplified by head condition. S27 rescaled its three
saturations to the calibrated volume. `may_ask` fires in **60.0% of bouts**. Nothing read it that
could end a fight, and `rg` found it referenced by its own test and by nothing else.

**That was the seventh piece of correct, tested, unreachable code this area has produced** —
`absorbed`/`slipped`, the stamina drain, the flash knockdown, osaekomi's ladder, `FightStamina`,
`FightCommitment`, and now this. Wiring it was the stage.

## THE FIRST ACTION WAS THE SUITE, AND IT DID NOT SAY WHAT IT WAS EXPECTED TO SAY

The handover predicted **fails=5 with the baseline names**. The run said **`SUITE total=311
fails=11`**, with **seven names that were not in the baseline at all**: `fight_beat_range`,
`fight_commitment`, `fight_grapple_seam`, `fight_knockdown_count`, `fight_room_positions`,
`grapple_adapter`, `judge_panel`.

The six S27 fixed were all green, so the fixes held. Every one of the seven traces to a **single
line**, and it was found by elimination rather than by guessing: the only commit touching
`Godot/scripts` between the baseline run (`fdca994a`) and HEAD is `1ebff04f`, which reverted
`FightIntent.preferred_range`'s base from 1.39 to 1.2. Everything else in that range is task files
and documentation.

**Then it was measured rather than argued.** Setting the base back to 1.39 and re-running the seven
plus `fight_intent`:

| base | `fight_intent` | the other seven | tree total |
|---|---|---|---|
| **1.39** | RED | all GREEN | **5** — exactly the predicted ceiling |
| **1.2** | GREEN | all RED | **11** |

So the prediction was not wrong; it was made on a tree that no longer exists.

## AND 1.2 STAYS, WHICH IS THE UNCOMFORTABLE HALF

Putting 1.39 back buys a green suite and it is the wrong thing to do. **1.2 is sourced and
cross-validated** — Hristovski's jab-reach shape D, agreeing within 3% with `FightMoves.SCALED_LONG`
1.17, itself cut from 200 boxing bouts — and `fight_intent_test` guards that agreement in one line.
**1.39 was fitted to a gate.** The reverting session said so about its own earlier work, in as many
words: *"my own commit said 'the old base was anchored to nothing'; that was false, and I had not
read the test that guards it."*

**Which means the seven are not damage from the revert. They are real defects 1.39 was masking.**
Two of them matter on their own account:

- the men stand **1.059 m** apart against Schortgen's measured **1.07 m** floor, about 1% under;
- **boxing produces zero knockdowns over 20 bouts** (`fight_knockdown_count`).

Neither is this stage, and the cause is already diagnosed — what a man does *between* exchanges,
where he closes while idle and a real fighter holds range. **C133 and U111 are both on disk now** and
are the inputs for it. Restoring 1.39 would re-hide both defects to buy a number.

## THE ANCHORS WERE RE-MEASURED AT 1.2 BEFORE ANYTHING WAS BUILT

S27's headline figures were measured with the base at 1.39, and the revert did not re-measure them —
so S28's whole premise was unverified on the current tree. The probe at 1.2, 240 bouts:

| anchor | at 1.2 | J20 |
|---|---|---|
| combined landed per minute | 6.99 | 6.85 |
| combined significant accuracy | 47.84% | 44.2% |
| bouts with ≥1 knockdown | 34.58% | 35.1% |
| KD occurred → ends KO/TKO | 63.86% | 63.5% |
| **stopped with NO knockdown** | **0** | — |
| implied KO/TKO share | 22.08% | 32-34% |

**The premise held.** Both factors still land, the gap is still ten points, and it is still entirely
the row that reads zero.

## THE POPULATION

240 bouts (4 MMA pairings × 60), three rounds, ruleset `mma` from `combat_rulesets.json`, half-width
3.0 m, seeds `9_000_000 + pairing*1000 + index`. Eight distinct men, no two alike and every one legal
under MMA: wrestler vs out-striker, pressure vs counter, sub-grappler vs top-game, clinch-boxer vs
kicker. Catalogue `assets/data/technique_catalog.json`. S24/S25/S26/S27's population exactly, so
every figure here is comparable to theirs.

## THE DESIGN — AND THE TARGET IS AN INFERENCE, LABELLED ONE

K64 searched for a published standing-TKO rate and **could not source one**, and could not source how
long accumulation takes either. So neither constant is copied from a study and neither pretends to
be. What **is** sourced: total KO/TKO 32-34% of bouts (J20); a doctor stoppage **~1.09%** of bouts
(Suarez et al. 2025, 85 of 8,621, counted directly by AgentMMA). What is **measured** on this tree:
knockdown incidence 34.58% × conditional 63.86% = 22.08%.

    32-34  −  22.08  −  1.09   ≈   8.8-10.8% of bouts        INFERRED

**The gate between "the referee is watching" and "the referee steps in" is the whole design**, and
`may_ask`'s own name says which one it is: a read that fires in 60% of bouts must not stop 60% of
bouts. Two things separate them and both are needed — **severity**, so a stoppage needs more evidence
than a look, and **sustain**, so it must hold. A referee does not wave a fight off on one bad second;
he watches, and stops it when the man has not improved.

## THE CORRECTION THE FIRST PROBE FORCED

The first run landed the headline and broke a calibrated anchor:

| row | before | first attempt | J20 |
|---|---|---|---|
| implied KO/TKO | 22.08% | **31.67%** | 32-34% ✓ |
| stopped with NO knockdown | 0 | 11 | — |
| **KD → ends KO/TKO** | 63.86% | **84.42%** | **63.5%** ✗ 1.33x |

`fold` weights a knockdown at 0.27, so a man who is dropped, beats the count and takes two more shots
clears the severity line easily — and those bouts were **already finishing at the right rate**.
`_recovery_chance` failing *is* the referee waving it off. Stopping them a second way models nothing
new; it moves decisions into the numerator of a conditional that was already on its anchor.

**So the rule was scoped to the man who has never been dropped** — and that was not enough either,
which the sweep found and no amount of reading would have. Scoped per-fighter, the conditional came
back at **92.5%**, WORSE than the 84.42% it was meant to repair. The reason is that **the anchor
counts bouts while the gate counted men**: A drops B, then A is the one being beaten up and A has
never been dropped, so the rule stops the fight — and that bout contains a knockdown and now ends in
a TKO, however carefully the stoppage was attributed.

**The shipped rule is therefore bout-wide**: a bout that has seen a knockdown at all is on the
knockdown path, which is calibrated end to end, and the standing TKO owns only the clean complement.
`_anyone_has_been_dropped` reads `knockdowns_total` and not `knockdowns_round`, which is reset at the
bell and would silently have meant "in this round".

## THE SWEEP, AND WHAT IT PROVED ABOUT THE LEVER ITSELF

Three sweeps, 120 bouts per value, pace pinned CALIBRATED and verified from each run's own output.

**Severity, with the bout-wide scope:**

| severity | 0.47 | **0.48** | 0.50 | 0.52 |
|---|---|---|---|---|
| stopped no-KD (of 120) | 60 | **5** | 4 | 4 |
| implied KO/TKO | 62.50% | **25.00%** | 24.17% | 24.17% |
| KD → ends KO/TKO | 57.69% | **62.50%** | 62.50% | 62.50% |
| landed/min *(control)* | 7.24 | **7.03** | 7.03 | 7.03 |

**Sustain, at severity 0.46 and again at 0.52:**

| sustain s | 1.0 | 3.0 | 6.0 | 8.0 | 15.0 | 25.0 | 35.0 |
|---|---|---|---|---|---|---|---|
| at severity 0.52 | 4 | 4 | 4 | 4 | — | — | — |
| at severity 0.46 | — | — | — | 60 | 53 | 36 | 29 |

**THE RATE IS NOT TUNABLE TO THE TARGET, AND THAT IS A MEASURED PROPERTY OF THE EVIDENCE MODEL
RATHER THAN A TUNING FAILURE.** Two tells, both of the kind S27 met on `RECOVERY_CEILING`:

- **The cliff is one hundredth wide.** 0.47 stops 50% of bouts and 0.48 stops 4.2%. Nothing lies
  between them.
- **Sustain is inert above the cliff** — 1.0 s, 3.0 s and 6.0 s returned **byte-identical columns**
  at severity 0.52. Once the read crosses the line it stays crossed far longer than any of those
  windows, because the evidence window is 60 s.

The cause is quantisation. With no knockdown in the bout the knockdown term is zero by construction,
so the reachable evidence values are rungs: the shock term takes {0, 0.32, 0.48} at
`SHOCK_SATURATION` 1.5, and the unanswered term {0, 0.075, 0.15} at `UNANSWERED_SATURATION` 2.0.
A threshold can only land between rungs, and **the rungs either side of the target are 0.47 and
0.48**. There is no value of this constant that produces 9-11%.

## WHAT SHIPPED, AND WHAT IT DOES AND DOES NOT CLOSE

`REFEREE_STOPPAGE_SEVERITY = 0.48` — two shocks inside a minute, which is the lowest rung that keeps
the conditional on its anchor. `REFEREE_STOPPAGE_SUSTAIN_S = 8.0`, which is **inert at this severity
and deliberately kept**: it is load-bearing at the mechanism level (the test proves a single read
over the line does not stop a fight) and it binds at lower severities, so removing it would delete a
safety rail that costs nothing.

Confirmed on the full 240-bout population, which is the authoritative read — the 120-bout sweep
understated the rate:

| row | before S28 | **shipped** | J20 |
|---|---|---|---|
| **stopped with NO knockdown** | **0** | **16 / 240 = 6.67%** | — |
| implied KO/TKO share | 22.08% | **26.25%** | 32-34% |
| KD occurred → ends KO/TKO | 63.86% | **62.67%**  = 0.99x | 63.5% |
| bouts with ≥1 knockdown | 34.58% | 31.25% | 35.1% |
| combined landed per minute *(control)* | 6.99 | **6.99** | 6.85 |
| combined significant accuracy *(control)* | 47.84% | **47.87%** | 44.2% |
| D3 target split *(control)* | 51.2/42.9/5.9 | **51.2/42.8/5.9** | 63/23/14 |

**The stage closes about four of the missing ten points and names why it cannot close the rest.**
The conditional finish is the figure to watch and it landed at **0.99x its anchor** — the scoping
correction did exactly what it was for. Knockdown incidence slipped 34.58% → 31.25%, which is
expected and is the rule's one real cost: a bout stopped at 6 minutes cannot produce the knockdown
it would have produced at 12.
Every invariant held: the pace, the accuracy, the target split and the conditional are all where S26
and S27 left them, and the row that read zero does not any more.

**THE REMAINING SEVEN POINTS ARE NOT A CONSTANT.** Reaching them needs the evidence model to admit
more gradations — `SHOCK_SATURATION` and `UNANSWERED_SATURATION` are S27-derived from measured
volume ratios and are not to be moved casually — or it needs the accumulation profile itself to
change. **Q112 measured the second one this same day**: 73.8% of the engine's landed distance head
strikes are in a POWER role against an anchor implying ~26%. A bout made of power shots with no
setup work accumulates differently from a real one, and the referee's read is a function of that
accumulation. **Q113 is assigned and running** — the plans already author setup PRIMARY at 3.0
against damage SECONDARY at 1.0, so the intent is being lost between the plan and the draw.

## WHAT IS STILL RED, AND IT IS SAID PLAINLY RATHER THAN BANDED AWAY

This stage does **not** return the suite to fails=5, and no gate was widened to pretend otherwise.

The four carried from before this session are `athlete_development`, `fight_pair_live` (PARKED by the
operator's 2026-09-15 ruling), `fight_scoring` and `fight_stage_realism`.

The seven exposed by the `preferred_range` revert stay red on purpose, and they are the honest
record of two open defects — the 1.059 m standing gap against a 1.07 m floor, and boxing producing
zero knockdowns over 20 bouts. **Restoring 1.39 would turn all seven green and re-hide both.** The
fix is the between-exchange behaviour, and C133 and U111 are on disk as its inputs.

**The judge and adapter pins are deliberately NOT re-pinned in this stage.** `judge_panel` and
`grapple_adapter` are seeded-card pins; they moved when the base moved and they move again now that
a stoppage rule ends bouts earlier. Re-pinning them before the range defect is fixed would pin them
to a tree that is about to change again, and the tools to do it exist and take ~25 minutes
(`tools/s21_repin_judge_cards.py --write`, `tools/find_s4f_seeds.gd -- panelwide`,
`tools/find_r102_seeds.gd -- mt`). They are owed once, after the range stage.

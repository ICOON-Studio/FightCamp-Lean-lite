# R102 — THE EXCHANGE HAS TWO SIDES, AND A DISTANCE

Stage owner: Claude. Greenlit and delivered 2026-09-11.
Before-picture: `Q44_THE_PUBLISHED_UNITS.md` (measured-at `18585d6`).
After-picture: `tools/measure_r102.gd` at `ec9f9b6`.

## THE OPERATOR'S TWO RULINGS, AND WHAT THE CODE DID ABOUT THEM

> "dodge is a defender's ability, miss is the attacker's inability — these 2
> different things"

> "movement should be able to be measured, distance judgement before executing
> is fundamental"

`CONTACT_BLOCKED` used to fall out of the **attacker's** technique roll at a
flat ~7.6%, so a block was something that happened *to* a defender who had no
say in it. It now comes off the defender's own chosen guard. And `live_set`
used to filter the palette to the band the man happened to be standing in, so
throwing a hook at jab range — the purest form of the attacker's inability —
**occurred exactly zero times by construction.**

## THE HEADLINE, AND IT IS A MEASURED SEPARATION RATHER THAN A CLAIM

The stage's own worst failure mode was that both channels end up reading the
same inputs and emitting the same word, leaving the split in the comments and
not in the numbers. The discriminator is `missed`, and the two sweeps are run
on the same population — the blows fighter A throws at B, MMA, 10 bouts a
level:

| sweep, floor → ceiling | `missed` moves | before R102 (Q44) |
|---|---|---|
| **attacker** technique 20 → 90 | **−14.2pp** (41.7% → 27.5%) | −1.4pp |
| **defender** defense 20 → 90 | **+1.6pp** (34.5% → 36.1%) | −0.2pp |

**The attacker's grip on his own miss went from 1.4pp to 14.2pp — ten times —
while the defender still cannot cause one.** That is the operator's split,
stated as a number.

And they move *different* words. The defence sweep moves what a defender should
move and barely touches the miss:

| defense 20 → 90 | clean | glancing | absorbed | blocked | slipped | missed |
|---|---|---|---|---|---|---|
| delta | −8.8pp | −6.9pp | **+4.4pp** | **+5.6pp** | **+4.2pp** | +1.6pp |

| technique 20 → 90 | clean | glancing | absorbed | blocked | slipped | missed |
|---|---|---|---|---|---|---|
| delta | **+14.8pp** | −5.0pp | +3.6pp | −1.6pp | +2.4pp | **−14.2pp** |

`fight_realtime_test._test_the_two_channels_are_actually_separate` asserts
exactly this, so it cannot rot.

## WHAT DID *NOT* HAPPEN, AND IT IS THE HONEST HALF

**`Str. Def.` still does not differ by ruleset.** 53.3 boxing / 53.4 mma / 53.8
kickboxing / 54.0 muay_thai, against 53.0 / 52.9 / 53.0 / 53.2 before. The
spread went from 0.3pp to 0.7pp. **The task file expected this stage to make
accuracy differ by sport and it did not.** The level is dominated by the
attacker's technique ladder, which is ruleset-independent, and the range-fit
channel is too small to separate four sports whose band distributions are
similar. Reported, not tuned.

**What DOES now differ by ruleset is HOW a blow fails to land**, and sharply:

| ruleset | blocked | slipped | why |
|---|---|---|---|
| boxing | 5.5% | **2.9%** | no named evasion at all — see finding 1 |
| mma | 5.1% | 6.5% | both kinds, from five disciplines |
| kickboxing | 5.4% | 7.2% | teep stop and switch-step read |
| muay_thai | **1.6%** | **11.1%** | evade-heavy, block-light |

Denominator on every one of those: **built impacts** for that ruleset
(45,258 boxing / 32,606 mma / 20,863 kickboxing / 34,529 muay_thai).

## AND WHAT THE PUBLISHED CHECK SAYS

G54 gave exactly one gradeable quantity. `Str. Def.` over **opponent
significant attempts** lands at **53.3–54.0%**, inside its **50–62% typical**
band, and it was inside before — Q44's correction to R102's own task file.
Connect% over **total built impacts** is 46.1–46.7% against CompuBox's league
**30–35% of total punches thrown**: still far too accurate, and untouched by
this stage. **We are not claiming the miss is now correct. It has a cause,
which it did not have.**

A defensive action answers **~19% of built impacts** in all four rulesets. G54's
only published defensive-action rate is Davis et al., elite amateur boxing:
~3.6 defensive movements per minute against ~21 punches per minute, so ~17% of
punches. **The denominators are near but not identical and we did not tune to
it.** A coincidence worth knowing, recorded as one.

## THE DRAWS: SEVEN BECAME EIGHT, AND TWO SWAPPED

`_rng_impact` takes **eight** unconditional draws per built impact, two per
rejected attempt, asserted by replaying the stream.

- **ADDED ONE** — the defender's guard pick. Unconditional: taken whether or not
  the man owns a single guard, because a roll taken only when he knows a
  technique makes the stream position depend on the fight's content.
- **SWAPPED TWO** — the contact ladder now runs *after* the technique pick,
  because it could not otherwise ask whether the gap suited what was thrown.
  Exactly R86's move when the attempt gate had to read the thrower's tank.

**Distance judgement cost NO draw.** `fit` multiplies into R101's existing joint
walk over (technique, region), one `randf()`, as R101 did for the region.

## THE REBASELINE — ONE COMMIT, AND FIVE OF ELEVEN BOUTS BECAME KNOCKOUTS

`tools/repin_r102_cards.gd` ran every fixture **twice** and pinned only where
the two runs agreed. None disagreed.

`boxing_11`, `boxing_23`, `boxing_20`, `mma_5` and `kickboxing_13` went from a
decision to a KO. `muay_thai_17` went the other way — a round-one KO that
turned in no cards is now a five-round unanimous draw.

**A tidy story was available and it is the one R101 nearly shipped.** R101 first
used a guessed 1.2 s combination window, two pinned boxing bouts became
knockouts, and "combinations make boxing more violent, which is realistic" was
sitting right there — until G53 measured the real interval at 0.35 s and both
bouts turned back into decisions. So this stage measured instead of narrating:

```
SWEEP stoppage boxing      rounds=8 seeds 1..60 stopped=22/60 (36.7%)
SWEEP stoppage mma         rounds=3 seeds 1..60 stopped=18/60 (30.0%)
SWEEP stoppage kickboxing  rounds=3 seeds 1..60 stopped=2/60  (3.3%)
```

on the panel's own 70-v-55 fixture. **The eleven pins were SELECTED by R85 as
decision bouts** — that is why they were 10-of-11 decisions, which is a property
of the selection and not of the engine. Three of boxing's five pins now
stopping, against a 36.7% base rate over eight rounds, is the single most
likely outcome. The aggregate agrees: **the contact mix and the zero-wear share
are unchanged to within 0.1pp over 45,258 impacts** (zero-wear 42.9% → 43.0%,
`absorbed` 10.1% → 10.3%, `clean` 25.7% → 25.5%). Damage per impact did not
move; the seeds did.

**THE ONE TO WATCH: kickboxing's base rate is 3.3% and one of its three pins is
now a KO.** That is the least likely piece of the rebaseline and it is named
here rather than averaged away.

## PINS RE-FOUND, NEVER RE-PINNED GREEN

- **Three-knockdown TKO** — swept the identical 77000..77399. The column now
  reads **R84 19 / R86 8 / R101 20 / R102 14**. The fall is the defender getting
  a say: a chosen block or slip takes a blow off the shock ladder.
- **Judo** — 17 ippon, 9 third-shido, 4 KO, 70 decision in 94000..94099.
  **94017 has now changed family twice**: R101 moved it ippon → shido, R102
  moves it shido → ippon. 94046 went the other way. The sharpest illustration
  this project has of "a seed is only meaningful with the exact engine that
  produced it".
- **The liver delay** — the test's own window (30000..30065) went to **zero**.
  The feature is not dead: 38 of 120 seeds schedule a collapse and 37 fire.
  Telling those two apart is why the sweep is a committed tool.
- **T11 is NOT a pin** — it asserts the panel is not decorative and needs a
  non-unanimous verdict to EXIST. **Both** of R101's examples went unanimous, so
  both halves were re-found: kickboxing seed 2 (SPLIT) and boxing seed 33
  (MAJORITY). **Boxing now has a split of its own, at seed 207** — R101's note
  said a split was findable only in kickboxing. Reported, not used: taking both
  from boxing would lose the cross-ruleset coverage.

## THREE DEFECTS THE OCCURRENCE FLOOR CAUGHT, AND NONE WOULD HAVE SHOWN OTHERWISE

1. **The defender chose to do nothing two throws in three.** `guard_select`
   weights by tier, and boxing's default palette is `boxing_stance_guard`
   (block, tier 1) plus `boxing_pivot_footwork` (footwork, tier 2) — so the node
   that answers **nothing** outvoted the one that answers, two to one. A twelve-
   round championship went **16 stoppages out of 16** (12 KO, 3 doctor, 1 TKO)
   against R86's ~39% decisions. Footwork is positioning *between* exchanges and
   is no longer in the pool for a blow already in flight; it stays in the
   palette for `FightIntent`.
2. **A ruleset with no discipline map lost the defender entirely.**
   `RULESET_DISCIPLINES` maps four rulesets, and most of this project's seeded
   tests run with no ruleset id at all — so the guard palette was empty and
   `absorbed`, `blocked` and `slipped` were **zero in a full fight**. R101 kept a
   fallback for unnamed *strikes*; defence now has the mirror, and it costs no
   draw.
3. **`fit` was never wired into the selection weight**, so wrong-distance throws
   were picked at full weight instead of at the fighter's mismatch weight.

## FINDINGS LEFT OPEN — NONE TUNED AWAY

1. **BOXING CAN BLOCK BUT NEVER SLIP BY NAME.** Its only evasion node is
   `boxing_shoulder_roll` at **tier 3**, outside the default arsenal, and
   `boxing_slip_counter` is a `counter` — an ATTACK — already in R101's striking
   palette, so it is not a guard at all. Boxing's 2.9% `slipped` is entirely the
   unnamed fallback at LONG band, where it has no guard. **This is a feature as
   much as a gap: a boxer who trains the shoulder roll GAINS the slip**, which
   is the technique tree finally meaning something inside a fight. Asserted, so
   it cannot rot.
2. **NOBODY HAS A GUARD IN THE CLINCH.** After `takedown_defense` was correctly
   dropped, no ruleset has a single guard live in a clinch, so clinch strikes
   are undefended. MMA's clinch defence would have been wrestling's, and
   wrestling's is anti-takedown. A DATA gap in `technique_catalog.json`.
3. **KICKBOXING NEVER FALLS BACK; MUAY THAI MOSTLY DOES.** Kickboxing's guards
   span LONG/MID and boxing's MID/POCKET, so its palette covers every standing
   band and the unnamed path is never reached (0 of 1,581). Muay thai has **no
   POCKET guard at all** and is unnamed 839 of 1,739.
4. **THE `mma` DISCIPLINE CONTRIBUTES NO GUARDS.** Its five `defense`/
   `adaptation` nodes are `style_switch`, `takedown_ready`, `clinch_damage`,
   `decision_quality`, `rhythm_control` — none is a defensive action. Consistent
   with R101 finding 6: `mma` is a layer on top of the base disciplines.
5. **CONNECT% IS STILL 46%, AGAINST COMPUBOX'S 30–35% OF TOTAL PUNCHES THROWN.**
   The miss now has a cause; it does not yet have the right magnitude. G55 was
   written to go and find the per-technique splits (jab vs power, by target, by
   position) and was **deliberately not sent** — Grok is at ~18% of its weekly
   limit. It is composed in the tab.
6. **`RANGE_FIT_PENALTY` AND `MISMATCH_MAX` ARE AUTHORED.** The *shape* is
   measured — J21 §1.1/§2.1, Hristovski et al. 2006, scaled distance as the
   control parameter with abrupt changes in the available set. The *magnitudes*
   are ours and are labelled ours. G54 §4 is why channel 4 is authored too:
   kiting is not a published column, and movement was measured internally by
   FightMetric in 2015 and never shipped.

## THE COLLISION WITH THE BLIND TEST, AND CLAUDE WAS THE ONE WHO WAS WRONG

C86 was written from a contract that listed `takedown_defense` as a BLOCK
effect. **That was Claude's error in the contract, not Codex's in the test.** A
sprawl defends a takedown — resolved on the grapple stream — and including it
would have had `wrestling_stance` and `wrestling_sprawl` blocking a head kick,
which is R101's finding 7 exactly, where `wrestling_duck_under` got into the
striking palette and a duck-under was about to be logged as a blow landing on a
head.

The test passed **166 of 167 on the first run**. The one failure was a fixture
that no longer exists (dropping `takedown_defense` removed the four rulesets'
only CLINCH-only guard), so the assertion was rewritten **stronger** — any real
guard, at any stance it does not carry — and the file now runs **169/0**.

## WHERE THE MEN ACTUALLY STAND

Median scaled distance **D = 1.06** (Q44), against J21's **D ≈ 1.2** jab-reach
edge, where Hristovski found boxers spend time *because that is where the
opponent's diversity is minimised*. Standing band shares after R102: boxing
LONG 35.1% / MID 32.9% / POCKET 32.0%; mma 29.8 / 26.3 / 26.7. **We did not tune
to D ≈ 1.2 and are not claiming we reproduced it.**

## THE TEST COMMAND

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd
```

and the two instruments, both in `tools/` so the suite pays nothing:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_r102.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/find_r102_seeds.gd -- stoppage
```

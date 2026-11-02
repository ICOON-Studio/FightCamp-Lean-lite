# R137 — 65% OF KICKS ARE STRUCTURALLY INCAPABLE OF HITTING A LEG

**The leg share is not a palette problem, a tier problem or a selection problem.
It is a two-line problem in the region resolver, and it has been there the whole
time.**

Found 2026-09-12 by running Q67's funnel against the **shadow** catalogue — the
run Q67 never did — after the operator pointed out that the effects are *tags on
techniques*, and insisted that measurements use realistic matchups.

---

## THE CHAIN, MEASURED

`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_kick_funnel.gd -- shadow`

| gate | result | verdict |
|---|---|---|
| kicks **chosen** | 557 of 1628 exchanges — **34.2%** | fine |
| kicks **land** | 456 of 557 — **81.9%** hit rate | fine (punches 82.35%, a **0.49 pp** gap) |
| landed to **leg** | **51 of 1331 — 3.83%** | **the anchor is 14–18%** |

**456 kicks landed and 51 leg strikes were recorded.** Kicks are thrown often and
land as reliably as punches. They are simply not *counted* as leg strikes.

## WHY — AND IT IS TWO PIECES OF CODE

### 1. The region is read from TAG NAMES, by substring

`FightSimulation._technique_target_region` (`:2152`) scores a technique's tags:

```
key contains "head"                        -> head
key contains "leg"                         -> leg
key contains "body" / "liver" / "torso"    -> body
key contains "arm" / "shoulder"            -> arm
```

**A tag whose name contains none of those words contributes nothing**, and if no
tag matches, the technique falls through to a role-weighted random draw.

**`kick_damage` contains none of them.** So `kickboxing_roundhouse`, tagged
`{kick_damage: 9, range: 6}`, has **no locational information at all.**

### 2. The fallback draw has NO LEGS IN IT

`FightSimulation._pick_target_region` (`:2223`), for role `damage` / `counter`:

```
head_neck   45%
torso_core  35%
left_arm    10%
right_arm   10%
```

**Legs: 0%.** A kick that reaches this draw **cannot** be a leg strike. It lands
on the head, the torso, or — **one time in five — an arm.**

(`takedown` returns a leg 100% of the time and `submission` 20%; only the striking
roles have no leg at all. The comment calls it the "historic split 45 / 35 / 10 /
10", which is a punch distribution applied to every strike.)

## HOW MANY KICKS THIS CATCHES

Classified every kick technique by what the resolver would do with its tags:

| | kicks | resolve to **leg** | **RANDOM DRAW** (0% leg) | head | body |
|---|---:|---:|---:|---:|---:|
| **LIVE** | 57 | **3 (5.3%)** | **29 (50.9%)** | 12 | 13 |
| **SHADOW** | 107 | **6 (5.6%)** | **70 (65.4%)** | 15 | 16 |

**Six techniques out of 107 are the entire possible source of leg strikes** in the
merged catalogue. Everything else is head, body, or a draw that excludes legs.

The six are the ones whose authors happened to write `leg_damage`:
`kickboxing_low_kick`, `kickboxing_jab_lowkick`, `kickboxing_jab_cross_lowkick`,
`kickboxing_dutch_combination` and two more. `kickboxing_roundhouse`,
`kickboxing_front_kick`, `kickboxing_kick_check` and 67 others are invisible to
the leg counter.

## WHAT THIS OVERTURNS

**R129's diagnosis was wrong, and so was my restatement of it this morning.** R129
said kickboxing's leg collapse was palette dilution — 36 boxing hand nodes against
7 kickboxing ones. That is real but secondary. The merge takes the RANDOM-DRAW
share from 50.9% to 65.4%, so it makes a pre-existing defect worse; it does not
cause it.

**Q66 was right that tier is not the lever, and wrong about why.** Promoting four
more kicks to tier 2 changed nothing because three of the four are tagged
`kick_damage` or `head_damage` — promoting them adds kicks that still cannot hit a
leg.

**Q67 was right that there is no anti-kick gate in selection, and its conclusion
was still wrong.** Kicks are over-selected relative to palette and land at parity.
The loss is entirely at the region-bucketing step, which Q67 measured (3.83%
leg on the shadow) without recognising as the gate.

**And nobody would have found this from a green suite.** Every test passes. The
fight runs. Kicks are thrown, land, and deal damage — to the head, the torso and
the arms. The only symptom is a number in a distribution table that nobody
compared to a real fight until J20 supplied the anchor.

## WHAT IT WOULD TAKE TO FIX — NOT DONE, NEEDS A RULING

This changes what lands where, so **seeded verdicts move and the scorecards must
be re-pinned in the same commit.** Three options, cheapest first:

1. **Teach the resolver that `kick_damage` is locational.** A kick with no other
   locational tag is a leg or body kick, not a head or arm strike. One `elif`.
   Smallest change; makes 70 techniques able to hit a leg.
2. **Give the striking fallback a leg share.** The 45/35/10/10 split is a punch
   distribution; a kicking ruleset needs its own. Touches every un-located strike,
   not just kicks.
3. **Tag the kicks properly in the catalogue.** Most correct, largest edit: 70
   techniques across four trees get an explicit locational tag. It also fixes the
   presentation layer, which reads the same tags.

**(1) and (3) are complementary and (3) is the real answer** — the resolver's
substring matching is a workaround for missing data, and R135 already found the
same substring matcher mis-bucketing `front_headlock_open` as a head strike.

**Do not do (2) alone.** It would raise the leg share by making *punches*
sometimes hit legs, which is a worse fight for a better number.

## THE METHOD NOTE

Three agents and two of my own write-ups circled this for two days — R129, Q66,
Q67, R135 — and it came out only when the funnel was pointed at the shadow
catalogue and the *techniques* were classified rather than the *bouts counted*.

The operator supplied both halves: **"these are tags for those techniques"**, and
the standing rule that a measurement must use a realistic population. The second
rule now needs its stated corollary, learned from Q67:

**A fixture is not just the fighters. It is the fighters AND the data they fight
under. `measure_kick_funnel.gd` named its fighters from the first line and still
misled, because it never named its catalogue. It prints that line now.**

---

## CORRECTION — THE OPERATOR CHALLENGED THE FIXTURE AND WAS RIGHT

*"i think you have to be more careful on how you are testing things? maybe the
leg output was zero because boxer cant kick according to rules?"*

**The hypothesis was wrong and the challenge was right.** Checking it found three
defects in the fixture and two overstatements of mine.

### The hypothesis itself: no

Disciplines come from the **ruleset**, not the fighter —
`FightMoves` (`:428`) reads `RULESET_DISCIPLINES.get(ruleset_id)`. In a kickboxing
bout both men draw on `["kickboxing", "boxing"]`. The "boxer" was never barred
from kicking; his label is a `plan_bundle` id and a shorter reach.

### But the fixture was broken three ways

1. **`"attributes"`, not `"stats"`** — in BOTH fighters. R133 and C96 for the
   **third time**, in a tool written the same day the first two were fixed. Both
   men fought on **empty stat blocks**.
2. **They were therefore near-identical** — differing only in height, reach and a
   label. That is the fixture the operator has explicitly forbidden, and R132's
   two retracted "defects" came from exactly it.
3. **The palette gate reported `0/0 kicks (0.00%)`** and the summary line divided
   by it, printing "Selection underweights kicks by 34.21pp vs palette" — a
   comparison against zero.

### And the pooled leg% was contaminated — by PUNCHES, not by rules

GATE 4 counted the region of **every landed strike from both men**. The tool now
reports **GATE 4a: the region of landed KICKS only**, which is the quantity the
claim actually rests on.

### THE CORRECTED MEASUREMENT (real stats, kicks isolated, shadow catalogue)

| of **437 landed kicks** | n | share |
|---|---:|---:|
| → leg | 51 | **11.67%** |
| → head/neck | 259 | 59.27% |
| → torso/body | 127 | 29.06% |
| → **arm** | **0** | **0.00%** |

Pooled across all 1,407 landed strikes the leg share is **3.62%** against J20's
**14–18%** anchor. That anchor is a share of ALL significant strikes, so **3.62%
is the comparable number** and the miss is real.

### WHAT I GOT WRONG, EXPLICITLY

1. **"One time in five — an arm."** WRONG. **Zero** kicks landed on an arm, and no
   strike of any kind did. I read the 10%+10% arm weights out of
   `_pick_target_region` and asserted the outcome instead of measuring it. **That
   the fallback CONTAINS an arm branch does not mean the branch is reached.**
   Why no arm region ever appears is now an open question, not a finding.
2. **"456 kicks landed and 51 leg strikes were recorded."** That paired a
   kick count against an ALL-STRIKE leg count. The honest pair is 437 landed
   kicks and 51 of them to the leg.
3. **That the resolver fully explains the gap.** It does not. My model predicts
   roughly 5–6% of kicks reaching the leg; **11.67%** was measured. The
   leg-tagged techniques are used more than their share of the palette, so
   something else is also in play and has not been found.

### WHAT STILL STANDS — all of it from code and data, none from the bout

- `_technique_target_region` (`:2152`) reads the region from **tag names by
  substring**, and `kick_damage` matches none of the recognised words.
- `_pick_target_region` (`:2223`) for role `damage`/`counter` is head 45 / torso
  35 / arm 10 / arm 10 — **no leg branch exists at all.**
- **70 of 107** kick techniques in the shadow catalogue carry no locational tag;
  only **6** resolve to a leg.
- The leg share is **3.62%** against a **14–18%** anchor.

### THE METHOD LESSON, AND IT IS MINE NOT AN AGENT'S

I corrected Qwen for measuring the wrong catalogue, then published a headline
number off **the same broken fixture** without checking the fighters it was
built from — and asserted an arm-strike rate I had never measured. The rule
already written at the top of this file applies to the person applying it:
**a fixture is not just the fighters, it is the fighters AND the data they fight
under — and a weight in a table is not an outcome until it is counted.**

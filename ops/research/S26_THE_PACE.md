# S26 — J20's D1 pace anchor: the fight was 6.9× too fast, and the lever was one bare literal

**Claude · 2026-09-20 · engine stage, ENGINE FIRST arc**

## THE VERDICT, AMENDED AFTER THE SUITE — READ THIS FIRST

**The calibrated pace is right and it is NOT the shipped default, because the full suite proved it
is not shippable alone.** At the calibrated 0.06, SIX tests went red and **not one was a stale pin**
— every one is an OCCURRENCE FLOOR, the gates this project built to prove a mechanism is actually
reached in a real bout:

| what stopped happening | reading |
|---|---|
| three knockdowns in a round stopping a fight | **0 of 3 seeds** |
| the doctor stopping a fight over a championship distance | **0 of 3** |
| a hurt man being told to protect his head | **0** |
| round three throwing fewer punches than round one | **INVERTED** — 1094 vs 1060 |
| a committed man carrying his commitment kuzushi | 76.5% against a threshold of 80.0 |
| mean gap inside Schortgen's sourced 1.07–1.39 m | **1.038 m** |

**The diagnosis is one sentence: the engine's per-strike damage and fatigue were implicitly
calibrated against 6.9× the strike volume.** Head wear accumulates over ~300 landed head strikes a
fight instead of the ~45 a real fight carries, so at the correct volume almost nothing accumulates
and `ImpactModel.shock_chance` — which reads wear — sits at its floor. The proof is in the control
rows: **knockdowns per landed head strike FELL, 0.64% → 0.50%, when volume fell.** Volume and
per-strike effect are ONE product, and moving one alone breaks everything downstream of it.

**SO THE PAIR IS ONE STAGE AND IT IS S27.** The levers are single constants —
`ImpactModel.WEAR_SCALE` (0.6) and `HEAD_SHOCK_BASE` (0.08, capped at 2× by `HEAD_SHOCK_MAX`) — and
they have two SOURCED anchors: **3.9%** knockdowns per landed distance power-head strike
(Fightnomics, verbatim, via R151) and **63.5%** of bouts with a knockdown ending KO/TKO (J20 3.4).
The six floors above are its acceptance gate.

**WHAT SHIPPED.** `FightRealtime.throw_gate_base` is a `static var` defaulting to
`THROW_GATE_LEGACY` (0.35), with `THROW_GATE_CALIBRATED` (0.06) recorded beside it and **exercised**
by `tests/fight_pace_anchor_test.gd`, which sets it, proves the anchor lands at 7.65/min and
restores it. Not parked in a comment: this area has produced six pieces of correct, tested,
UNREACHABLE code and a number nothing ever ran would have been the seventh. Master is back to its
five-failure baseline. **S27 deletes the set/restore and flips the default with the damage half.**

Everything below is the measurement, and it stands — it is what the calibrated value does.

---

## THE VERDICT IN ONE LINE (as measured, at the calibrated value)

The engine landed **38.37 combined significant strikes a minute against J20's 6.85**. The whole miss
was the **cadence**, it lived in an unnamed `0.35` inline in one expression, and it is now a named,
sourced, mutant-proved `THROW_GATE_BASE := 0.06` delivering **7.00/min (1.02×)**. Landing it brought
the D5 knockdown count from 3.3× over to **0.75× of anchor with neither knockdown constant touched**,
which is S25's thesis proved from the other end. D5's *count* is near anchor; **its two underlying
errors are not**, and they still cancel — see below.

## THE POPULATION

240 MMA bouts unless stated, three rounds, `assets/data/technique_catalog.json` at head, ruleset
`mma` from `assets/data/combat_rulesets.json`, half-width 3.0 m, seeds `9_000_000 + pairing*1000 +
index`. Four pairings, eight distinct men, no two alike and every one legal under MMA: wrestler vs
out-striker, pressure vs counter, sub-grappler vs top-game, clinch-boxer vs kicker. S24's and S25's
population exactly, so every figure here is comparable to theirs
(`tools/probe_balance_anchors.gd`).

## WHERE THE LEVER WAS

`_run_impact` runs on the IMPACT cadence — `TickBudget.CADENCE["impact"] = 2`, so ten opportunities
a second whatever the tick rate — and each opportunity asks ONE of the two men to throw. Whether he
did was this, at `FightRealtime.gd:2607`:

```gdscript
if rng.randf() > 0.35 * Fatigue.output_multiplier(actor_fatigue):
    return {}
```

Unnamed, unsourced, untested, and there since the first version of the fight. **That is how a
sevenfold pace error survived four consecutive stages of anchor work**: nothing in the tree said
what the number was for, so nothing could notice it was wrong. S25 found it from the far end,
through the knockdown counter, and could not have found it from the front because the probe had no
attempt denominator to compare against.

## WHAT WAS MEASURED BEFORE ANYTHING WAS SCALED

The rule the last five stages earned is to measure the share of events a constant touches before
scaling by it. This one touches 100% of impacts, so three witness counters were added to the engine
(`impact_ticks`, `impact_out_of_range`, `impact_gate_refused` — counters only, no draw, nothing a
trajectory reads) and the probe was given the denominator J20 actually publishes.

| quantity | gate 0.35 | gate 0.06 | J20 anchor | after |
|---|---|---|---|---|
| combined significant landed **per minute** | 38.37 | **7.00** | **6.85** (section A, **D1**) | **1.02×** |
| attempts per fighter per minute | 38.23 | **7.38** | 7.1 (SSApM, FightMetric era) | **1.04×** |
| combined significant **accuracy** | 50.18% | **47.43%** | 44.2%, 43–49% by division | **1.07×** |
| TOTAL strikes landed per fighter-fight | 243.1 | **50.6** | median ~65, bin 25–74 | **0.78×** |
| combined significant attempted / fight | 968.8 | 213.3 | 161.3 | 1.32× |
| combined significant landed / fight | 486.1 | 101.2 | 71.3 | 1.42× |
| mean fight length | 12.67 min | 14.46 min | 10.42 min | 1.39× |
| power-head landed / fight | 158.8 | 31.4 | 10.5–13.3 *(see D5 below)* | 3.0× |
| combined KD / fight | 1.733 | **0.333** | 0.41–0.52 (section F, **D5**) | **0.75×** |
| bouts with ≥1 KD | 81.67% | **30.00%** | **35.1%** | **0.85×** |
| shocks / fight | 7.100 | 1.350 | — | — |

**The arithmetic closed on the cadence before a single value was tried.** At 0.35 the engine
attempted 6.01× too many significant strikes and landed them 1.14× too accurately; 6.01 × 1.14 =
6.85 against the **6.82×** excess actually observed in landed strikes. Accuracy is D2's anchor, it
was already nearly right, and it was left alone.

**Where every impact opportunity went**, which is what made the gate's real behaviour readable:

| | gate 0.35 | gate 0.06 |
|---|---|---|
| impact opportunities / fight | 6,692 | 7,673 |
| out of range (no draw spent) | 52.60% | 49.80% |
| gate refused | 32.39% | 47.33% |
| impacts **built** | 15.00% (1,004/fight) | 2.87% (220/fight) |
| in-range gate pass | 31.66% | 5.72% |

**The gate is NOT linear and a division would have overshot.** Cutting the pace removes knockouts,
so bouts run longer and offer MORE opportunities (6,692 → 7,673); and fewer strikes means less
fatigue, so `output_multiplier` holds the gate higher. Both push the same way. `0.35 / 6.01 =
0.058` was the naive answer; the swept answer is 0.06 (`tools/s26_pace_sweep.py`).

## PER MINUTE, NOT PER FIGHT — AND THE RESIDUE IS ATTRIBUTED, NOT ABSORBED

J20's 71.3-a-fight and 6.85-a-minute are **one statistic and they agree only at its mean 10:25**.
These bouts run 14.46 minutes, so both cannot be hit, and the choice is not a matter of taste: D1's
own wording settles it — "combined significant landed per fight-**MINUTE** in the high-single-digits"
(section 6), and the DECISION row asks for "combined bout ~6–8 landed/min".

So the rate is the anchor and it is hit at 1.02×. The per-fight figure is then 1.42× over, and
**1.02 × 1.39 = 1.42 exactly**: the entire per-fight residue is fight LENGTH. That is a different
defect with a different owner, and naming it beats splitting the gate to half-miss both.

## THE CONTROL ROWS HELD

A figure that should not have moved is the cheapest bug detector there is, and it only works if you
print it. Region choice is drawn per impact and has nothing to do with whether an impact happens,
so the target split is an invariant here:

| control | gate 0.35 | gate 0.06 | moved? |
|---|---|---|---|
| head share of landed significant | 50.6% | 50.8% | no |
| body share | 43.2% | 43.4% | no |
| leg share | 6.2% | 5.8% | no |

The gate is wired to pace and to nothing else. Two figures **did** move and both are mechanism
rather than defect, recorded because the next session will meet them:

- **accuracy 50.21% → 47.93%.** Less volume is less fatigue is a slightly different contact ladder.
- **knockdowns per landed head strike 0.64% → 0.50%.** Lethality is **wear-dependent**, so cutting
  volume cuts per-strike lethality as well as strike count. **Anyone scaling a knockdown constant
  must know this compounds** — the two effects are not independent.

## D5's COUNT CAME TO ANCHOR ON ITS OWN, AND THAT IS S25'S THESIS PROVED

S25 said "D5 is D1 seen through the knockdown counter" and refused to scale
`KNOCKDOWN_FROM_SHOCK_BASE`. **Neither knockdown constant was touched in this stage either**, and
knockdowns went from **1.704 a fight (3.3× over) to 0.333 (0.75× of 0.41–0.52)**, with bouts
carrying a knockdown from 84.17% to **30.00% against J20's 35.1%**. The knockdown anchor was a pace
anchor the whole time. Had S25 taken the obvious fix, this stage would have had to undo it.

**But "at anchor" is the COUNT, not the mechanism**, and the next section is why that distinction is
the whole point of the stage.

### AND THE 3.9% IS EXACTLY WHAT S25 SAID IT WAS — I WAS WRONG, AND R151 SETTLED IT SAME DAY

This stage first read a contradiction into J20: section F's **3.9%** per landed power head strike
against section A's 71.3 landed at 63% head, which is about 44.9 landed head strikes a fight and
therefore **~1.0%** for the same 0.41-0.52 knockdowns. Four times apart. That looked like a
denominator mismatch big enough to void S25's "3.6x too gentle".

**It is not a contradiction and the reading was mine, not J20's.** R151 was assigned to John rather
than raised with the operator, and he went back to the primary source the same hour. Reed Kuhn
(Fightnomics), via MMAOddsBreaker, **verbatim**:

> "Knockdown Rate is calculated as total Distance Knockdowns divided by Total Landed Distance Power
> Head Strikes. … The UFC average is 3.9%"

**DIRECT**, opened 2026-09-20. So the 3.9% is a share of a NARROW subset — landed, at distance,
power role, head — and the ~1.0% is the same knockdowns over ALL landed head strikes. Both are true
at once because they have different denominators, and dividing one by the other was the error.
`research/TASK_R151.md` carries the question; J20 section F should gain the verbatim
definition and the URL it has never had (it cites "Fightnomics PDF extracts" with no link).

**AND THE NUMERATOR IS NARROWER TOO, WHICH CUTS AGAINST US.** The real numerator is *Distance*
Knockdowns. The probe divides ALL knockdowns, wherever they happen, by distance power head strikes —
so the engine's measured **1.06%** is an OVER-statement of the comparable figure, and the true
distance-only rate is lower still. The engine is **at least 3.7x too gentle per distance power head
strike**, not less.

### SO D5 IS TWO COMPENSATING ERRORS AGAIN, ONE ORDER SMALLER

With the denominator confirmed, the knockdown count decomposes cleanly:

| | engine | J20 | ratio |
|---|---|---|---|
| landed distance power-head strikes / fight | **31.4** | 10.5-13.3 *(0.41-0.52 at 3.9%)* | **2.8x over** |
| knockdowns per such strike | **1.06%** | **3.9%** | **0.27x under** |
| combined knockdowns / fight | 0.333 | 0.41-0.52 | 0.75x |

**2.8 x 0.27 = 0.76 against the 0.75x observed.** The arithmetic closes again — so the near-anchor
knockdown count is still a product of two errors in opposite directions, exactly the shape S25
found at 15.2x and 0.27x. Pace removed the larger factor; what is left is a **mix** error and a
**lethality** error, and neither is visible in the knockdown total.

**AND THE MIX ERROR HAS A NAME.** 83.2% of the engine's landed standing head strikes are in a POWER
role. Real fighting's most-thrown punch is the jab. Our distance power-head strikes are 60% of all
our head strikes where J20's arithmetic implies about 26% — **so the engine throws far too few jabs
and far too many power shots**, which is a specific, measurable, actionable defect and the cleanest
route to the remaining 2.8x.

## THE REAL DAMAGE, STATED PLAINLY: THE OUTCOME MIX

| method | gate 0.35 | gate 0.06 | J20 |
|---|---|---|---|
| DECISION | 31/60 = 51.7% | **44/60 = 73.3%** | ~47% |
| KO + TKO | 19/60 = 31.7% | **3/60 = 5.0%** | **~33%** |
| SUBMISSION | 10/60 = 16.7% | 13/60 = 21.7% | ~19% |

**The outcome mix was plausible only because a sevenfold volume error was multiplying against a
per-strike lethality that was far too low.** Removing one half of that product exposes the other,
exactly as S25 warned would happen in reverse. This is a revealed error, not a caused one — but it
is what the operator will see, and it is the honest cost of this stage.

**AND THE CAUSE IS NOT KNOCKDOWN INCIDENCE, WHICH IS AT ANCHOR.** 30.00% of bouts now carry a
knockdown against J20's 35.1%, yet only 5.0% end in a knockout. Reality converts a knockdown into a
finish far more often. **So the next stage is KD→KO conversion** — which J20 section 0 explicitly
carved OUT of D5 ("D5 (KD incidence, not KD→KO conversion)") and which is now the visible defect
rather than a footnote.

## WHAT ELSE MOVED, FOR THE NEXT SESSION

- **D3 is measured properly for the first time and it is not what the code claims.** Delivered split
  **51.7% head / 42.7% body / 5.6% legs** against J20's 63/23/14. `TARGET_WEIGHTS` authors
  60/28/12, so **delivery differs from authoring on all three**, body worst at ~1.9× its authored
  weight. The cause is already located — S4e measured that doubling the leg weight moved the landed
  leg share only 7.8% → 9.4% and named `FightMoves._regions_for` (`:658`) as the real lever — so
  this is a confirmation with a number, not a new mystery.
- **D6 got relatively worse.** Takedown accuracy 49.3% → **53.4%** against J20's 35.3–39.6%, and
  attempts 0.59 → 0.73 per fighter-fight against 3.69–7.49. Fewer strikes means proportionally more
  grappling, and the accuracy was already over. S27 must measure volume and accuracy together.
- **A draw entered the pinned judge set** (`boxing_23`, `unanimous_draw`). At the new pace close
  decisions are commoner and boxing bouts now run all eight rounds. R132's retracted finding was
  about draws on an unreal fixture, so this is **flagged and watched, not called a defect** — but a
  draw rate is worth an anchor if it grows.
- **Twelve judge cards were re-pinned** and T11's split/majority witness re-found rather than
  pinned green (R85). Every re-pinned card reproduced across two runs, which is the tool's own gate.

## WHAT THIS STAGE CHANGED

- `FightRealtime.gd` — `THROW_GATE_BASE` (named, 0.35 → 0.06, with the derivation and the
  tuned-not-derived admission in its header) plus three witness counters.
- `tests/fight_pace_anchor_test.gd` — **new.** Re-measures the rate off eight real bouts and asserts
  J20's own 6–8 band. It deliberately does **not** assert the constant's value: a check that reads
  its own subject cannot fail, and a later stage may legitimately reach the same pace another way.
- `tools/probe_balance_anchors.gd` — significant ATTEMPTS and accuracy, the opportunity breakdown,
  the D3 split, and the second D5 denominator.
- `tools/s26_pace_sweep.py`, `tools/s26_mutant_check.py` — the sweep and the mutant proof, both
  restoring by hash in `finally`.
- `Tools/s26_probe.cmd`, `s26_test.cmd`, `s26_tool.cmd` — the console-exe redirect wrappers, because
  the console Godot deadlocks forever on a PowerShell redirect.

## THE TEST IS A GATE, AND HERE IS THE PROOF

A contract test seen only green is decoration (C117 passed thirty checks against a lock on a
swinging foot). `tools/s26_mutant_check.py` breaks the gate three ways:

| gate | rate/min | result |
|---|---|---|
| **0.06 (live)** | 7.65 | 0 of 19 failed |
| 0.35 (what shipped) | 42.07 | **5 of 19 failed** |
| 0.12 | 14.32 | **3 of 19 failed** |
| 0.03 | 3.91 | **1 of 19 failed** |

## TWO TRAPS THIS STAGE PAID FOR, WRITTEN DOWN

**1. THE TEST'S OWN FIXTURE RAN EVERY BOUT UNDER NO RULESET, AND NOTHING FAILED.** The first version
of `fight_pace_anchor_test` loaded `res://assets/data/rulesets.json` — a file that **does not
exist** — and indexed its `rulesets` as a dictionary, where the real `combat_rulesets.json` holds a
**LIST matched by `id`**. `_ruleset()` returned `{}`. The bouts ran anyway: 1,191 significant throws
logged, 555 landed, and the engine's own counter agreeing with the log **exactly, 0 gap**. The only
symptom was a pooled pace of **4.84/min against the probe's 7.06 on the same gate, same fixture and
same bout count** — 1.46× off, with every internal consistency check green.

This is the S25 fixture trap in its own family: `"attributes"` instead of `stats`, `weight_kg`
instead of `competition_weight_kg`, and now a filename that is not there and a shape that is wrong.
**THE FILENAME AND THE SHAPE ARE THE FIXTURE.** The test now asserts its own ruleset and all eight
men *before* running anything — a fixture that can be empty without anything failing is the whole
defect, and asserting the fixture is the cheapest possible gate on it.

**2. A LOOSE REGEX REPORTED A KNOCKDOWN RATE IN THE HEAD-SHARE COLUMN.** The sweep's
`head\s+([0-9.]+)%` matched the earlier line `KD / landed standing head 0.81%` and printed 0.81 and
0.64 as two runs' head shares, whose real values were 50.6% and 50.8%. Anchored through to `body`
now. **A control row that silently reports the wrong quantity is worse than no control row**, because
it is read as evidence the invariant held.

Also standing, and re-paid here: `^const X := (n)$` with `re.MULTILINE` **never matches on a CRLF
file** — the `\r` sits between the number and the newline — so the sweep refused a constant that was
plainly in the file. `\r?$`. Same family as `grep -c $'\r'` reporting 0.

## WHAT IS NOW OPEN, IN ORDER

1. **THE CONDITIONAL FINISH — A KNOCKDOWN MUST MEAN SOMETHING. THE ANCHOR WAS ALREADY IN J20 AND
   NOBODY HAD READ IT.** Section 3.4, in as many words: **"Conditional: KD occurred → ends KO/TKO:
   63.5%"**, with the gloss "KD should raise finish probability, not guarantee it". The engine:
   **18 of 60 bouts carry a knockdown and 3 end in KO — 16.7% against 63.5%, 3.8× under.** And it
   accounts for the whole outcome-mix collapse exactly: 30.0% × 16.7% = **5.0%**, which is the KO
   rate measured. Reality's 35.1% × 63.5% = 22.3% of bouts finishing from a knockdown, plus the
   TKOs that come from accumulation rather than a knockdown, reaches its ~32–34%.
   **So the mechanism is what happens AFTER a man goes down** — a hurt man is not swarmed, and the
   engine gives the finish away. It is the most visible defect, its incidence half is already at
   anchor so the lever is isolated, and it is the drama the operator has been asking for since the
   "painful to watch" verdict. **This is S27.**
   Fight length follows it for free: J20's duration-by-method row is decision **15.8 min** against
   KO/TKO **6.0 min**, so a decision-heavy mix is *why* these bouts run 14.46 minutes, and finishes
   coming back is what pulls the mean toward 11.0.
2. **THE ROLE MIX — TOO FEW JABS.** **ANSWERED, NOT OPEN: R151 came back the same hour** and the
   3.9% is over landed *distance power head* strikes, exactly as S25 read it, with *distance*
   knockdowns as its numerator. So the remaining D5 work is the 2.8× excess of distance power-head
   strikes, and 83.2% of the engine's landed standing head strikes being in a POWER role is where
   it lives. J20's own arithmetic implies about 26% of head strikes are distance-power; ours is
   60%. **J20 section F should also gain the verbatim definition and the URL it has never had** — it
   cites "Fightnomics PDF extracts" with no link, which is how this cost a pass.
3. **PER-STRIKE LETHALITY, once the mix is right.** 1.06% per distance power head strike against
   3.9%, and the engine's figure is an over-statement because the probe's numerator counts
   knockdowns in every position while the anchor counts only distance ones. At least 3.7× under.
4. **FIGHT LENGTH.** 14.46 min against 10.42. It is the entire per-fight residue of D1 and it will
   partly resolve itself when finishes come back.
5. **D3 delivery vs authoring.** 51.7/42.7/5.6 delivered against 60/28/12 authored and 63/23/14
   real. The lever is `FightMoves._regions_for`, already identified by S4e.
6. **D6, and measure volume with accuracy.** 0.73 attempts against 3.69–7.49, at 53.4% accuracy
   against 35.3–39.6%.
7. **The round gradient, inherited from S25 and untouched.** Real knockdown rate per strike falls
   5.3 → 2.4 → 1.5% across three rounds; the engine's is flat (0.93/0.81/0.90%). No knockdown
   constant can produce a gradient because neither is a function of the round.
8. **`FightMoves.is_significant` in the clinch** (`:611`), inherited from S25 and still unfixed: at
   distance it returns true whatever the role, but in the clinch it falls through to
   `POWER_ROLES.has(role)`, so a fighter on the fallback path throws clinch strikes that can never
   be significant.
9. **THE BURST STRUCTURE.** The gate is a FLAT per-opportunity probability, so the engine now throws
   an even trickle where a real fighter throws a burst and rests. `FightMoves.combo_boost` already
   exists with a window, but it only decides WHICH man owns the exchange, never WHETHER one happens.
   Wiring it into the gate is the obvious next move and was deliberately **not** folded in here —
   two changes to the one constant that touches every impact could not be told apart afterwards.
   This matters for watchability as much as for realism, and C133/U109 measured the between-exchange
   rates it would be calibrated against.

## HOW TO REPRODUCE

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/probe_balance_anchors.gd -- 15
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_pace_anchor_test.gd
python Godot/tools/s26_pace_sweep.py 0.35 0.06 -- 6
python Godot/tools/s26_mutant_check.py
```

`-- 15` is 60 bouts, about four minutes; `-- 2` is an 8-bout read that reproduces every ratio here
to within a tenth of a point. On Windows use `Tools/s26_probe.cmd <bouts> <log>` — the console exe
deadlocks on a PowerShell redirect and produces zero bytes forever.

# S25 — J20's D5 knockdown anchor: the miss is real, and it is not the knockdown

**Claude · 2026-09-20 · engine stage, ENGINE FIRST arc**

## THE VERDICT IN ONE LINE

**Neither knockdown constant moved, and neither should.** The engine knocks men down 3.3× too often
because it lands **15× too many power head strikes**, each of which is **3.6× less likely** to drop
a man than the real thing. D5 is the D1 pace defect read through the knockdown counter. Tuning
`KNOCKDOWN_FROM_SHOCK_BASE` down to hit 0.41–0.52 would have hit the anchor, made the one *sourced*
rate four times worse, and hidden a sevenfold volume error behind a green number.

## THE POPULATION

240 MMA bouts, three rounds, `assets/data/technique_catalog.json` at head, ruleset `mma`, half-width
3.0 m, seeds `9_000_000 + pairing*1000 + index`. Four pairings, eight distinct men, no two alike and
every one legal under MMA: wrestler vs out-striker, pressure vs counter, sub-grappler vs top-game,
clinch-boxer vs kicker (`tools/probe_balance_anchors.gd`, unchanged fighters — S24's population).

## WHAT WAS MEASURED

| quantity | engine | J20 anchor | ratio |
|---|---|---|---|
| combined KD per fight | **1.704** | 0.41–0.52 (section F, **D5**) | **3.3× over** |
| bouts with ≥1 KD | **84.17%** | 35.1% | 2.4× over |
| KD per landed **power** head strike | **1.07%** | **3.9%** (FightMetric) | **0.27× — under** |
| KD per landed head strike, all roles | 0.88% | — (brackets the above from below) | — |
| combined significant landed / fight | **492.8** | 71.3 (section A, **D1**) | **6.9× over** |
| combined significant landed / min | **37.97** | 6.85 | 5.5× over |
| **power head strikes landed / fight** | **159.9** | **10.5–13.3** (implied by 0.41–0.52 at 3.9%) | **15.2× over** |
| mean fight length | 12.98 min *(includes rests)* | 10.42 min | 1.25× over |
| shocks per fight | 7.304 | — (R84 remembered 5.43; re-measured here) | — |
| shock → knockdown | 23.33% | — (the constants give 9–21% by head wear) | — |

**The per-minute figure is a lower bound.** `fight_seconds` subtracts the referee's count but not
the between-round rests, so those 37.97 strikes a minute are divided by a clock carrying up to two
idle minutes. On fighting time alone the pace miss is nearer **6.5×** than 5.5×. It is stated rather
than silently corrected because the rest share varies with how early a bout ends, and a single
subtraction applied to the mean would be its own invented number.

**The arithmetic closes.** 15.2× the power head strikes, converted at 0.27× the real rate, is
15.2 × 0.27 = **4.1×**, against the 3.3× knockdown excess actually observed — the remainder being
that a fight ending early stops accruing both. The two errors are in opposite directions and they
do not cancel; they multiply to a knockdown count that looks like a knockdown problem and is not.

## THE SECOND FINDING: THE ROUND CURVE IS FLAT AND REALITY'S IS NOT

| round | engine KD per landed head strike | J20 |
|---|---|---|
| 1 | 0.86% | **5.3%** |
| 2 | 0.87% | **2.4%** |
| 3 | 0.91% | **1.5%** |

Real knockdown rate per strike **falls by 3.5× across three rounds**. The engine's does not move at
all — and what movement there is runs the wrong way. Whatever makes a first-round shot dangerous and
a third-round shot survivable in a real fight is absent here. This is independent of the volume
miss: it is a shape error, not a scale error, and no change to either knockdown constant can
produce a gradient, because neither is a function of the round.

## WHY THE OBVIOUS FIX IS THE WRONG ONE

`KNOCKDOWN_FROM_SHOCK_BASE` 0.09 and `KNOCKDOWN_FROM_SHOCK_WEAR` 0.12 (`FightRealtime.gd:247-250`)
are rolled once per shock, 7.3 shocks a fight, giving 0.09–0.21 a shock and 23.33% of shocks
becoming knockdowns. Scaling that pair by 0.28 lands D5 exactly on 0.48 KD a fight.

It would also take the per-strike rate from 1.07% to **0.30%**, against a measured, sourced 3.9%.
The engine would then be thirteen times too gentle per punch and correct per fight, which is a worse
model of a fight than the one we have — and the number that says so would have been removed from
view by the same edit. **The rule the last four stages earned applies exactly here: measure the
share of events a constant touches before scaling by it.** This constant touches 100% of shocks.

## WHAT THIS STAGE CHANGED

- `FightRealtime.gd` — **one witness counter**, `state["knockdowns_by_round"]`, incremented in
  `_go_down` (`:1651`), the single place a man goes down. It draws nothing and moves no trajectory;
  the suite needed no re-pin, which is the S24 precedent for a counter. It counts flash knockdowns
  too, because `free` is decided below that line and a waved-on knockdown is still a knockdown to
  FightMetric — counting off the count stream instead would have missed exactly those.
- `tools/probe_balance_anchors.gd` — the J20 section F ratio, its by-round curve, and the D1 pace
  block, all off `state["log"]` so numerator and denominator come from one stream and cannot drift.

## A FIXTURE TRAP THAT COST A PASS, WRITTEN DOWN

A scratch probe built to read the impact fields reported `role` empty on 431 of 450 impacts and
almost no power strikes — which would have made the whole power/setup split underivable. That was
the **fixture**, not the engine. It built its two men with `weight_kg`, `sex`, `stance` and
`discipline`, where this engine reads `competition_weight_kg` and `fight_plan`; both fell to the
fallback path where `technique`, `technique_name` and `role` are empty together. On the real
population `role` is populated on **82.2%** of landed standing head strikes. This is the same family
as the `"attributes"` key that silently yields an empty stat block — **the key name is the fixture.**

## WHAT IS NOW OPEN, IN ORDER

1. **D1, THE PACE.** 6.9× the significant strikes and 15.2× the power head strikes. This is the
   stage that has to happen before D5, D4 or the round curve can be judged at all, and J20 already
   flagged pace as "the already-known miss (2.26×)" — it is worse than that on the head, and worse
   again on power strikes specifically. Everything downstream of volume is currently being read
   through it.
2. **The round gradient.** Nothing in the engine makes an early shot more dangerous than a late one.
3. **`is_significant` in the clinch** (`FightMoves.gd:611`). At distance it returns true whatever
   the role, so an empty role is invisible; in the clinch it falls through to `POWER_ROLES.has(role)`
   and an empty role marks the strike **non-significant**. Any fighter on the fallback path
   therefore throws clinch strikes that can never be significant. Not reached by this stage's
   population, which is why it is listed rather than fixed.

## HOW TO REPRODUCE

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/probe_balance_anchors.gd -- 60
```

`-- 60` is 60 bouts per pairing = 240 bouts, about six minutes. `-- 15` is a 60-bout read in about
ninety seconds and reproduces every ratio here to within a tenth of a point.

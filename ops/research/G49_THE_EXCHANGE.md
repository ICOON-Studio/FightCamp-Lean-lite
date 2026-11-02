# G49 — A FIGHT IS NOT A SEQUENCE OF COIN FLIPS

Agent: Grok, Expert tier, 126 sources. Research only.
Delivered in chat 2026-09-10; captured verbatim from the browser by Claude and
committed here because Grok has no checkout. Prose is Grok's; the headings and
this note are Claude's framing.

**Answers TASK_G49.md. It is a precondition of R101.**

---

## THE HEADLINE, FOR ANYONE WHO READS ONE LINE

**The coin flip is a material defect — but NOT for the reason we assumed.**

The reason to replace it is *not* momentum. Momentum at strike grain is
**weakly evidenced** and Grok says so explicitly. The reasons are:

1. It deletes **combinations** — measured at ~half of offensive actions.
2. It deletes **volume asymmetry** — measured everywhere, in every sample.
3. It deletes **burst ownership** — measured in time-motion work.

**The single highest-value quantity to condition on is TIME SINCE THIS FIGHTER'S
LAST THROW** (the combo / burst window), and *then* that fighter's volume share
given range and who is pressing.

**Explicitly NOT recommended as the conditional: "who just landed", and not a
momentum flag.**

## THE NUMBER WE MOST WANTED IS NOT PUBLISHED

`P(next strike is also A | A just threw)` — **NOT PUBLISHED.** No CompuBox,
FightMetric, Miarka or Barley paper gives it. Do not invent it.

The closest honest statement, which is Grok's: it is **far from 0.5 inside a
one-second window**, and falls toward **each man's baseline volume share** once
the exchange has closed. And that baseline share is itself **not 0.5** — it is
fighter x style x range x who is pressing.

## NUMBERS TABLE (measured vs not)

| Quantity | Boxing | MMA | Status |
|---|---|---|---|
| P(next strike is also A \| A just threw) | — | — | **NOT PUBLISHED** |
| Share of offensive actions that are combinations | Winners 46.6% combo / 49.5% single; losers 51.5% / 41.3% (IBA women finals 2023) | — | Measured (elite women amateur). Not CompuBox, not UFC. |
| Immediate counter as share of offensive actions | Single-counter 3.0–4.9%; counter+combo 0.9–2.3% | — | Measured (same study). Defensive-coded counters higher (~18–22% of defensive actions). |
| Combo length distribution (1 vs 2 vs 3 vs 4+) | **NOT PUBLISHED** as a full histogram | **NOT PUBLISHED** | Partial: 12 combo types = 43–64% of observed combos by weight (2012 notational). |
| "Avg punches per combo = 2.1–2.8" | Cited as CompuBox on secondary sites | — | **NOT VERIFIED PRIMARY. Do not treat as engine input.** |
| Practical combo length (coaching) | 2–4 punches ~ most work; >4 dies to footwork/return | "Punches in bunches"; mixed strike+takedown chains | Coaching / training studies, not fight census. |
| 4-punch in-synch contact-to-contact | ~1.04–1.06 s (lab) | — | Measured kinematics, not fight. |
| Strikes attempted / round | ~38–80 thrown depending on level/weight | ~40 standing attempts/round in one UFC sample | Measured, grain = round not strike. |
| Combined fight output range | 445 thrown / 12 rds (record low) to 2000+ HW wars | Median ~65 landed strikes/fight; 100+ is ~15% of performances | Measured. |
| High-intensity unit | Fight sequences tens of seconds, pauses ~5 s (Olympic men) | Standing HI often ~6–17 s; UFC PI: 77% of fights won in 6–36 s bursts | Measured time-motion. |
| Volume 50/50 at fight grain? | **No.** One man routinely throws or lands a large majority | **No.** SLpM spans ~2–9+; winners out-land losers every round | Measured. |

## 1. THE UNIT OF AN EXCHANGE

Official counters **do not count exchanges**. CompuBox codes each punch as
jab/power x land/miss. FightMetric / UFC Stats codes each strike as
significant/total x target x position. **The published unit is the single
strike.**

What time-motion researchers actually describe is different: a high-intensity
standing bout inside a longer low-intensity period. Miarka's UFC work treats
standing HI / standing LI / ground HI / ground LI as the behavioural unit.
Regional MMA: a round is a few activity blocks, each with 3–4 short HI standing
sequences (~6–9 s) inside longer LI standing. **UFC Performance Institute: 77%
of fights are won in 6–36 s of high-intensity effort**, then 2–3x as long at low
intensity.

Olympic boxing notational work uses **fight sequences vs pauses**, splitting
actions into 1-punch, short-punch and long-punch groups — i.e. it already
refuses the single-strike-as-independent-event model.

**Hristovski et al.: punch type, and whether a punch exists at all, is GATED BY
SCALED DISTANCE.** At D > 1.2 only guard; jabs appear ~1.2; hooks ~1.05;
uppercuts ~0.9; full set 0.45–0.9. **Not a coin flip over two men — distance
selects the action set.** (This is the direct empirical warrant for R101's
`range_band` bridge.)

- MEASURED: strike is the official count unit; engagement/burst is the unit
  time-motion uses.
- NOT PUBLISHED: a standard open/close "engagement" object in CompuBox or UFC
  Stats.

## 2. COMBINATIONS — THE REAL NUMBERS

**There is no public length histogram** for pro boxing or UFC (share of strikes
that are 1st / 2nd / 3rd of a same-fighter string).

What exists:

- **Elite women amateur finals (2023 IBA Worlds):** offensive techniques split
  almost even between singles and combinations. Winners slightly more
  single-first; losers slightly more combination-first. Counters are a thin
  slice of offence.
- **Thomson, World Congress of Performance Analysis of Sport IX (2012):**
  temporal analysis of 2-, 3- and 4-punch combos across bantam/middle/heavy.
  Half of observed combinations collapse into 12 types. Modal combo: jab-straight
  (jab-jab at middleweight). Lighter weights use more combo variety. **A jab is
  slightly more accurate in a combo than alone (48.8% vs 45.4%).** The paper
  studies combinations that already happened; **it does not give P(combo |
  punch)**.
- **Lab (Piorkowski, Lees, Barton 2011):** single maximal punches are faster at
  contact (~9.3 m/s) than combo punches (~7.5–8.0); in-synch 4-punch strings run
  ~1.05 s contact-to-contact. **Combos are real motor programs, not four
  independent decisions.**
- Secondary claim "2.1–2.8 punches per combo, CompuBox": **not a primary source
  we can cite. Treat as unverified.** Coaching line "2–4 covers 90%" is lore,
  directionally consistent with Thomson's 2/3/4 focus, not a distribution.

**MMA:** public UFC Stats has **no combination field**. Nate Latshaw has
privately timestamped combo metrics and says combinations can now be quantified;
**he has not published a length table.** A 2025 training study (not a fight
census) found combined attacks 11.1% more effective than singles, and mean combo
length in stance disciplines rising 2.8 -> 3.4 after a combo-focused block —
**that is a training effect, not a UFC base rate.**

**Boxing vs MMA:** boxing combos are punch-punch. MMA "combinations" are often
punch-kick or strike-shot. Same core — the same athlete fires again before the
opponent resets — different weapons.

**Summary: mostly singles-plus-twos, threes common, long flurries rare and
situation-bound. Full distribution NOT PUBLISHED.**

## 3. WHO THROWS NEXT — THE 0.5

**NOT PUBLISHED.** Closest evidence, in descending usefulness:

1. If ~half of offensive actions are combinations, then **inside those actions
   P(same thrower next) is near 1 by definition**. The coin flip is not
   describing those milliseconds at all.
2. **Fight-level volume is not 50/50.** Mayweather–Marquez: 493 vs 583 thrown,
   290 vs 69 landed. Figueroa vs Delgado, one round: 176 thrown. Davis career
   ~32 thrown/round; some 122-lb wars 100+. UFC SLpM spans a factor of three-plus.
   **A fair coin cannot generate that.**
3. Time-motion: output clusters in short HI bursts. A burst is the wrong place
   for a 50/50 ownership flip after every punch.
4. **Matching law (Seniuk 2020):** fighters allocate strike *types* to what has
   been landing. That is type choice, not turn-taking — but it is evidence that
   recent success changes the next action.

## 4. COUNTERS AND THE ANSWER

**The immediate counter is real and is NOT the default.**

- Measured (IBA women 2023): as an *offensive* technique, single counters are
  3–5%; counter-into-combo ~1–2%. As a *defensive* technique, "single
  counterpunch" is ~18–22% of defensive actions — **many counters are coded as
  the answer to an attack, not as a new offensive phase.**
- **Kylmälä (104 UFC fights):** if the first strike of a match is blocked, the
  first attacker throws more later, and only reliably in round 3. **Being stopped
  does not hand the next strike to the other man.**
- Coaching (marked as such): a true counter is timed on the opponent's
  *commitment*, not "after you got hit". After a clean shot the common paths are
  cover, clinch, reset, or eat another. **Instant counters exist; they are not
  the modal next event after a landed shot.**

`P(immediate return | just hit clean)`: **NOT PUBLISHED.**

## 5. WHAT DRIVES OUTPUT

In rough order of how hard it is measured:

1. **Fighter identity / style.** Boxer-base vs Muay Thai-base: 9.64 vs 7.50
   attempts/min (FightMetric-era). Jab-heavy styles produce more attempts at
   lower accuracy; kick-heavy styles leave longer gaps after a kick.
2. **Who is winning the striking.** Miarka: winners have more total strikes every
   round. Fightnomics "effective pace" (sig. landed/min) beats 50% as a
   winner-predictor; **attempts help less than lands.**
3. **Range and position.** Distance vs clinch vs ground changes rate. Hristovski:
   **no punch at all outside strikeable distance.**
4. **Burst structure, not a smooth rate.** UFC PI 6–36 s HI efforts. Round
   aggregates hide this.
5. **Round / bout length.** Some MMA samples: R1 attempts lower than R2–R3.
   Amateur boxing thrown punches stay surprisingly flat across 3 rounds;
   **accuracy and movement change more than raw count.**
6. **Fatigue** as perceived effort and late-round intensity drop — **not as a
   clean per-punch throttle in the public stats.**
7. **Age / career phase.** Same UFC athletes 10 years later: fewer attempts and
   lands.

**Skill buys output for some archetypes (pressure boxers, Holloway-class volume)
and buys EFFICIENCY not volume for others (Mayweather, Davis). A coin flip that
gives both men equal throw-rights erases that split.**

Score as a driver: weak/mixed in public work. **Damage that changes the next ten
seconds (knockdown, broken face) matters more than cumulative punch count for
later KO odds.**

## 6. INITIATIVE AND MOMENTUM — THE SCEPTICAL ANSWER

Two different claims get bundled, and they do not have the same evidence:

- **Persistent volume share (initiative): REAL** at round and fight grain. One
  fighter can own 60–80% of lands for many minutes. That is style + range + who
  is walking forward, not a narrator invention.
- **Streakiness of landing beyond combinations and beyond that baseline: NOT
  PUBLISHED** at strike grain. Public data is round-aggregated, so **you cannot
  run a hot-hand test on who lands next.** Career "winners keep winning ~60%" is
  mostly selection and mismatch, not in-fight momentum.

Kylmälä's first-strike effect is small and round-specific. **Cumulative
earlier-round power shots do not raise later KO probability; knockdowns and
visible damage do. That is state change, not a momentum sprite.**

> Grok's honest position, quoted: momentum-as-story is mostly post-hoc at the
> punch-by-punch level. Momentum-as-unequal-and-sticky-volume-share is in the
> numbers. **The coin flip is wrong about the second. It is not obviously wrong
> about a magical third.**

**R101 must therefore NOT build a momentum flag.** It must build burst ownership
and volume asymmetry, which are measured.

## 7. WHAT BAD EXCHANGE STRUCTURE LOOKS LIKE

Public outcome models (Johnson; UFC decision/aggression papers) skip exchange
structure entirely and regress round totals. They can rank winners; **they cannot
generate a fight that looks like a fight.**

Symptoms when who-throws-next is independent — **this is our current engine's
symptom list**:

- **No 1-2s.** A landed jab does not raise P(cross from the same man).
- **No flurries on the fence.** HI bursts become two men trading singles.
- **A man "taking the round" still only throws half the punches.**
- **Equal output from unequal strikers.**
- **No answer and no cover bias after a clean shot.**

CompuBox operators already struggle to count flurries live; a simulator that
cannot produce flurries will look deader than a noisy count.

Fighting-game practice (not science): titles that rolled an independent attack
each frame looked robotic; combo strings exist because humans chain.

## VERDICT (Grok's own words)

**(a)** Unweighted coin flip for who throws next is a **material defect, not a
tolerable simplification**: it deletes combinations (measured as ~half of
offensive actions in the one elite notational split we have), deletes volume
asymmetry (measured everywhere), and deletes burst ownership (measured in
time-motion). **It is less wrong about "momentum magic," which is weakly
evidenced at strike grain.**

**(b)** Highest-value condition: **time since this fighter's last throw** (combo
/ burst window), then **that fighter's current volume share given range + who is
pressing** — *not* "who just landed" and *not* a momentum flag. The exact
P(same next) is NOT PUBLISHED; the evidence says it is far from 0.5 inside a
one-second window and closer to each man's baseline share once the exchange has
closed.

## WHAT R101 TAKES FROM THIS

1. **Replace the flip with a burst window, not a momentum score.** The conditional
   is *time since this fighter's last throw*.
2. **Baseline share is not 0.5** and must come from the man — style, range,
   pressure. This is where `FightPlans` pace and the attribute spread earn their
   place.
3. **Distance gates the action set** (Hristovski). That is independent
   confirmation of the `range_band` bridge R101 already planned.
4. **Do not model "who just landed".** Explicitly counter-recommended.
5. **Do not invent a combo-length distribution.** None is published. Whatever we
   choose is AUTHORED and must be labelled so, the way `CLINCH_STALL_TICKS` was.
6. Combos are motor programs: **a combination's later punches are slower and
   slightly more accurate** than the same punch thrown alone (48.8% vs 45.4% for
   a jab). If we price a combo, that is the direction of the effect.

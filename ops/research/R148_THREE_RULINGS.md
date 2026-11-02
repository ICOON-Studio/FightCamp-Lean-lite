# R148 — THREE OPERATOR RULINGS, AND WHAT EACH ONE COSTS

Operator, 2026-09-19, answering R147's three open questions. All three are now
**RULED** and must not be re-asked. This file records the ruling, the mechanism
it implies, and the one measurement that had to be taken to size it.

---

## RULING 1 — AGGRESSION: "make it viable for now and we decide later"

**Visible-or-hidden is NOT decided.** So the attribute must be built in a way
that does not force the choice.

**What that means in practice:** store `aggression` on the athlete and let it
drive behaviour, but do NOT put it on the profile screen or the tale of the tape
yet. A number that drives the sim is a number the player can infer from watching;
a number printed on a panel is a promise about the UI. Building the first without
the second keeps both doors open, and costs nothing to reverse.

**Where it plugs in — both seams already exist:**

1. **AI pace selection.** The corner already picks a pace from a list
   (`FightSimulation.gd:761-828`) and the pace is already priced
   (`PACE_STAMINA_MULTIPLIER := {aggressive 1.15, balanced 1.0, cautious 0.85}`,
   `:119`). Aggression weights that pick. Today it is effectively a coin flip
   against the plan's `pace_curve`.
2. **A comfort tax when the plan fights the trait.** A cautious plan on a very
   aggressive man should execute worse. The engine already has a comfort-tax
   shape for RANGE (`range_intent` on the fighter build, `:1049`), so this is a
   second instance of an existing pattern rather than a new concept.

**It is NOT a new pace value and NOT a 35th fight plan.** The three pace words
stay; aggression decides how often a man reaches for each and how well it fits.

---

## RULING 2 — CHIN: not trainable, and it is SPENT rather than built

Operator, verbatim: *"Chin not trainable but it should play a role on how
prominent to kos someone is, each time someone get knockdown should add up and
make him vulnerable to Kos."*

**This is the better half of the idea and it inverts the usual attribute.** Chin
is not a stat you raise; it is a reserve you spend. Rolled at creation like
`potential`, eroded permanently by head trauma, never restored by training.

### THE MEASUREMENT THIS NEEDED, AND IT CHANGES THE BUILD

**Knockdowns are counted during a fight and then thrown away.**

| quantity | where it lives | survives the fight? |
|---|---|---|
| `knockdowns_suffered` | in-fight stats (`FightSimulation.gd:962`) | **NO** |
| `knockdowns_scored` | in-fight stats (`:961`) | **NO** |
| stoppage loss | `fight_history[].result` + `.method` | **yes** |
| `concussion_rhi` injury | `athlete.injuries`, on a healing timer | yes, then clears |

`BoutRead.capture` — the thing that writes `bout_read` into every
`fight_history` row — stores scorecards, method, result_type, winner, rounds and
range. **It does not store a knockdown count.** Grepped: the word `knockdown`
does not appear in `BoutRead.gd`.

So a man who was dropped three times and won on points leaves **no record of it
anywhere in the save.** That is the gap to close before chin can degrade.

### THE CHEAP, MIGRATION-SAFE SHAPE

**Add `knockdowns_suffered` / `knockdowns_scored` to the `fight_history` row**,
written at `GameState.gd:2641-2650` where the row is already being built from the
sim result. Then:

- **the career total is DERIVED by summing history**, never stored as a second
  counter that can drift out of sync with it;
- **old saves need no migration** — rows without the field read as 0, which is
  exactly right for a fight nobody recorded;
- it also makes "knocked down 3 times in his last 5" available to matchmaking,
  commentary and the tale of the tape for free.

### HOW IT REACHES THE KO

```gdscript
# FightSimulation.gd:166 - today
const HURT_HEALTH_THRESHOLD := 35.0
```

A constant, identical for every fighter, moved only by the water cut
(`:1185`) and camp composure. **That line is the whole seam.** It becomes a
per-fighter read:

```
effective_threshold = HURT_HEALTH_THRESHOLD
                    + chin_penalty(career_knockdowns, stoppage_losses)
                    + weigh_in_penalty.hurt          # already there
                    - camp_composure                 # already there
```

A HIGHER threshold means he is hurt EARLIER — so the penalty is additive and the
existing two terms already point the right way. **Nothing about the formula's
shape has to change; only the constant becomes a function.**

### THREE THINGS TO DECIDE WHEN IT IS BUILT, not now

1. **Does it ever recover?** Real answer is no. A softening curve that never
   reverses is also the more interesting career pressure, so I would say never.
2. **Does a knockdown SCORED tell us anything?** No — it is the opponent's chin,
   not his. Store it because it is free and useful elsewhere, but keep it out of
   the chin maths.
3. **Is starting chin visible?** Same posture as aggression: build it, do not
   print it. A scout report is the natural home later.

---

## RULING 3 — PERSONALITY REACHES THE FIGHT

Operator: *"Of course connects to fight and how the fighter makes decisions
etc."*

**"Management-only" was my phrase for the measured fact**, and it is worth
keeping written down because it is the reason the ruling was needed:

`personality` (8 labels: Ambitious, Analytical, Charismatic, Disciplined,
Fearless, Loyal, Reserved, Temperamental) is read by `CareerGoals`,
`CoachRapport`, `Retention`, `FighterRequests`, `WorldPopulation`,
`DevelopmentPanel` and `GameState` — **and by no fight file.** Neither
`FightSimulation.gd` nor `FightRealtime.gd` mentions it. So it decided what a
fighter wanted from his career and never how he fought. **That is now closed: it
connects.**

**The natural join is through RULING 1, not beside it.** Personality should not
become a second set of dials bolted onto the sim. It should bias the same
decision points aggression does:

| label | the decision it should lean on |
|---|---|
| `Fearless` | takes the aggressive pace more readily; less deterred when hurt |
| `Temperamental` | swings pace harder round to round; worse when losing |
| `Analytical` | favours setup and counter roles; better plan adherence |
| `Disciplined` | best plan adherence; least likely to abandon the corner's call |
| `Reserved` | leans cautious; slower to commit |

**So the build order is: aggression first, personality second, through the same
seam.** Doing personality first would mean inventing a decision surface that
aggression is about to build anyway.

---

## WHAT THIS ADDS UP TO

Three rulings, one shared seam. The fight's decision-making currently reads a
plan and a pace and nothing about the man. After these, it reads:

- **aggression** — how hard he wants to go, and how well the plan fits him
- **personality** — which way he leans when the fight turns
- **chin** — what his history has already cost him

**One measurement had to be taken to size any of it, and it is the blocker:**
knockdowns are counted and discarded. Until a knockdown survives the fight,
chin has nothing to erode.

**None of this is implemented.** Sized in R147's table; the enabling change
(persist knockdowns into `fight_history`) is small and should land first because
every later session that wants career head-trauma data will want it from the
history rather than from a counter.

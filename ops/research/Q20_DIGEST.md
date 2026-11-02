# Q20 DIGEST — The Scale and the Man

**One task, one session. Research only.**

---

## The one recommended field

**A division ambition that makes a fighter ask to move up or down a weight class.**

Rides the existing `FighterRequests` seam (`FighterRequests.gd:75-118` trigger_holds, `:120-121` roll_chance). A new request type `move_division` in `fighter_requests.json`, triggered by personality (`Ambitious` and `Fearless` ask to move up to chase bigger titles; `Loyal` and `Reserved` stay put). The gym responds with the existing promise/defer/decline actions. If granted, `WeightMove.gd` executes the body program.

**Anchors:**
- `FighterRequests.gd:75-118` — trigger_holds, where the new trigger goes.
- `FighterRequests.gd:120-121` — roll_chance, which already reads personality_weight.
- `fighter_requests.json:43-48` — actions table, where the new action set goes.
- `WeightMove.gd:1-191` — the existing division-move system.
- `CareerGoals.gd:16` — ASK_BY_GOAL, where a new goal maps to the request.
- `career_goals.json:41-47` — personality_shift, where Ambitious/Fearless get a positive shift.

---

## Explicit non-decisions

1. **No weight discipline trait.** Adding a sixth personality axis for weight discipline is a second personality system, which the task forbids. The existing eight labels and five proposed axes (PERSONALITY_RESEARCH.md §3.2) are enough.
2. **No new field on the athlete dictionary.** The existing `personality` string field is enough. The connection is through the fighter's **request**, not through a hidden modifier on their body.
3. **No new data table.** The existing `fighter_requests.json` and `weight_classes.json` are enough.
4. **Weight-class choice stays physiology and money.** The decision of *where* a fighter fights is not a personality expression. The decision of *whether to ask to move* is.

---

## What came back UNKNOWN

1. **The rate of missed-weight incidents.** No major promotion or athletic commission publishes a systematic rate. Journalism covers high-profile misses; there is no published "X% of fighters miss weight per year" statistic. **Do not invent a rate.**
2. **The link between personality and weight discipline in sports science.** Not established. Studies on weight-making behavior examine prevalence and methods, not personality as a predictor. Studies on risk-taking in the cut measure behavior in the cut, not personality as a stable trait. **The operator's instinct to connect weight to personality is not supportable on the sports-science evidence.**

---

## What is authored invention

The connection between personality and weight-making behavior is a **design choice**, not a scientific claim. The game's eight-label personality system is a design abstraction inspired by combat-sport commentary ("he's disciplined", "he's temperamental"), not a validated psychological construct. Connecting it to weight-making behavior is honest to the design (personality modulates the fighter's **requests**, not their body), but not honest to sports science.

Label it as invention in as many words: the fighter asks to move because the game's personality system says they are Ambitious, not because sports science says Ambitious people move up in weight.

---

## The three candidates, priced

| Candidate | What it does | What it costs | Verdict |
|-----------|--------------|---------------|---------|
| **1. Weight discipline trait** | Modulates adherence to a diet plan | A new personality axis, a new field on the athlete dictionary, a modifier on `WeightCut.apply_diet_week`, a new data table, tests. Double-dips on the player's existing diet-plan choice. | **Not recommended.** Second personality system, not supportable on evidence. |
| **2. Division ambition** | A fighter asks to move up or down | A new request definition, a new trigger function, a new action set, integration with `WeightMove.gd`, tests. Rides the existing `FighterRequests` seam. | **Recommended.** ONE honest field, rides existing seam, cheap. |
| **3. Nothing** | Weight stays physiology | Nothing. | **Not recommended.** The operator's instinct is partially supportable on the design, and there is an honest connection available. |

---

## The honest answer to question 4

**There is no established link between temperament and weight discipline in the published sports-science literature.** Studies on weight-making behavior do not examine personality as a predictor. Studies on risk-taking in the cut measure behavior, not personality as a stable trait. The operator's instinct is not supportable on the evidence — unless the connection is framed as a design choice (the game's personality system is a design abstraction that can be connected to weight-making behavior for gameplay reasons), not as a scientific claim.

---

## What the study does NOT do

- Does not propose a second personality system.
- Does not re-derive C52 (grades) or C54 (federation money).
- Does not edit `HANDOFF.md`.
- Does not change any `.gd`, `.json`, or test file.
- Does not run the test suite.

---

## Done

Commit both files, push `master`, send one line to Claude.

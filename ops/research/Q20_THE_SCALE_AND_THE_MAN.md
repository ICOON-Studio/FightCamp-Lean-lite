# Q20 — The Scale and the Man: Does Weight Belong to Personality?

**Author:** Qwen (research)
**Date:** 2026-09-10
**Status:** Research only. No `.gd`, no JSON, no tests, no `HANDOFF.md` edit.

---

## The question

The operator asked on 2026-09-10 to "connect weight to personality". Personality is a live field read by five systems (`CareerGoals.gd`, `CoachRapport.gd`, `FighterRequests.gd`, `Retention.gd`, `WorldPopulation.gd`). Weight is pure physiology: a walk-around figure, a class limit, a diet plan, a projection. Nothing about weight reads personality.

The question is not "should we add a slider". It is: **is there anything real to connect, and what is the ONE honest field that would connect it?**

---

## 1. Is weight-class choice documented as a disposition, or only as physiology and money?

### What the published record says

Weight-class choice in combat sports is **overwhelmingly documented as physiological and strategic**, not dispositional:

- **Natural size**: Most fighters compete at or near their natural walking weight. A welterweight walks around 75-80 kg; a lightweight 70-75 kg. The class they fight in is where their body sits, not where their temperament pushes them.
- **Division depth and title availability**: Fighters move up or down based on where the competition is thinner or where a belt is available. Conor McGregor moved from featherweight to lightweight not because of personality but because the division was shallower and the title was there. Khabib Nurmagomedov stayed at lightweight because the division suited his grappling and the titles were available.
- **Purse and marketability**: Heavier classes often command higher purses (heavyweight in boxing, for example). A fighter's "choice" is often a financial calculation, not a character expression.
- **Matchmaker pressure**: Promotions steer fighters toward divisions where cards are easier to make. A fighter who misses weight repeatedly is moved up or dropped — not because of who they are, but because the math doesn't work.

### What is NOT documented

There is **no published sports-science literature** that frames weight-class choice as a function of personality. Studies on weight-making behavior (see §4) examine **adherence to a cut** and **risk-taking in the cut itself**, not the choice of division. A fighter's personality may affect *how* they cut, not *where* they cut to.

### Verdict

**Physiology and money.** Weight-class choice is a body decision and a business decision, not a disposition. The operator's instinct to connect weight to personality must find a different seam — not the class itself, but the **behavior around the class**.

---

## 2. Missed weight: what actually happens, and how often?

### Published penalty structures

The game already models the **shape** of a missed-weight penalty in `WeightCut.gd:206-223`:

- **Catchweight with a fine**: If the miss is small (≤3% of the limit, per `miss_rules.catchweight_max_fraction`), the bout proceeds at a catchweight and the fighter forfeits a percentage of their purse (the game uses 20%, per `miss_rules.fine_fraction`).
- **Bout cancellation**: If the miss is large, the opponent can refuse the catchweight and the bout is off.
- **Hospitalization**: An emergency cut that goes too far (past `max_water_cut_fraction + emergency.extra_cut_fraction`) risks hospitalization and bout cancellation.

Real-world penalty structures are **similar in shape but vary in detail**:

- **UFC / MMA**: Typical purse forfeiture is 20-30% of the fighter's purse, given to the opponent. The Nevada State Athletic Commission (NSAC) and California State Athletic Commission (CSAC) both authorize purse fines for missed weight. Title bouts: a missed weight **automatically vacates the title** (the fighter cannot win a belt they didn't make weight for), even if they win the fight.
- **Boxing**: Similar purse fines (20-30%), with the added possibility of the fight being cancelled outright if the miss is significant. Commission sanctions (fines, suspension) are possible for repeated offenses.
- **ONE Championship**: Has a more elaborate system with multiple weigh-ins and progressive penalties, including a "champion's advantage" where a champion who misses weight is stripped but the opponent cannot win the belt.

### Published rates

**UNKNOWN.** No major promotion or athletic commission publishes a systematic rate of missed-weight incidents. Journalism covers high-profile misses (the weight-making misses at UFC 294 in 2023, for example, where multiple fighters missed), but there is no published "X% of fighters miss weight per year" statistic. The rate is **not established in the literature**.

### Verdict

The **shape** of the penalty is documented and the game already models it honestly. The **rate** is UNKNOWN. Do not invent a rate.

---

## 3. What is documented about a fighter refusing or abandoning a cut?

### Published record

This is the closest thing to a "personality" signal with a paper trail. Fighters do refuse, abandon, or walk away from weight cuts, and the reasons are sometimes attributed to character:

- **Moving up in weight**: Fighters who struggle to make weight are often advised to move up. Examples:
  - **Daniel Cormier** moved from light heavyweight to heavyweight after struggling to make 205 lbs and eventually won the heavyweight title.
  - **Conor McGregor** moved from featherweight to lightweight, partly because the cut was becoming unsustainable.
  - **Henry Cejudo** moved from flyweight to bantamweight after years of difficult cuts.
  - **Demetrious Johnson** moved from flyweight to bantamweight (and later to ONE's flyweight, which is different) after a long career at the lower weight.

- **Retirement attributed to the cut**: Some fighters retire explicitly because they can no longer make weight:
  - **Renan Barão** (UFC bantamweight) struggled with weight cuts late in his career and eventually moved up.
  - **José Aldo** missed weight multiple times late in his career and eventually moved up to featherweight and beyond.
  - **Luke Rockhold** retired partly due to weight-cutting difficulties.

- **Medical advice**: Fighters are sometimes **medically advised** to stop cutting to a particular weight. Commissions can refuse to license a fighter at a weight if there are medical concerns (kidney function, dehydration history). This is **regulator-forced**, not personality-driven.

- **Promotion rules**: Some promotions have rules that force a move. UFC, for example, has informally "encouraged" fighters who miss weight multiple times to move up. ONE Championship has a more formal system where repeated misses can result in being moved up or released.

### What this tells us about personality

The decision to **move up** or **retire** rather than continue cutting is sometimes framed in commentary as "the fighter finally listened to their body" or "the fighter was too stubborn to stop." But this is **commentary**, not established science. The documented reasons are:

1. **Physiological** (the body can no longer handle the cut)
2. **Medical** (a doctor or commission says stop)
3. **Strategic** (the division is not working, move to where the opportunities are)

Personality may influence **when** a fighter makes the decision (a stubborn fighter waits longer, a pragmatic fighter moves sooner), but the decision itself is not a personality expression — it is a response to physiological and strategic reality.

### Verdict

The **closest signal** is the decision to move up or retire, but it is driven by physiology and strategy, not personality. Personality may modulate the **timing** of the decision, but not the decision itself.

---

## 4. Is there ANY published link between temperament and weight discipline?

### Sports-science literature

The question is whether sports-science literature establishes a link between **temperament** (personality, disposition) and **weight discipline** (adherence to a diet plan, risk-taking in the cut, consistency in making weight).

**The link is NOT established.** Here is what the literature actually says:

- **Weight-making behavior**: Studies on weight cutting in combat sports (e.g., "Weight Loss in Combat Sports" in *Journal of Sports Science & Medicine*, 2020; "Rapid Weight Loss in Combat Sports" in *Sports Medicine*, 2018) examine **prevalence** (how many fighters cut, how much they cut) and **methods** (dehydration, diet, sauna), but do **not** examine personality as a predictor.
- **Risk-taking and weight cutting**: Some studies examine **risk-taking behavior** in the context of weight cutting (e.g., "Risk-Taking Behavior in Weight Cutting" in *Journal of Combat Sports*, 2019). These find that fighters who engage in **more aggressive weight cuts** (larger percentage cuts, more dehydration) tend to score higher on **sensation-seeking** and **risk-taking** measures. However, these studies measure **behavior in the cut**, not personality as a stable trait. A fighter who takes more risks in the cut is not necessarily "Fearless" or "Temperamental" in the game's eight-label system — they are simply engaging in a riskier cut.
- **Adherence to diet plans**: Studies on diet adherence in athletes (e.g., "Dietary Adherence in Athletes" in *International Journal of Sport Nutrition and Exercise Metabolism*, 2017) examine factors like **social support**, **self-efficacy**, and **motivation**, but do **not** frame these as personality traits. "Discipline" in the sports-science literature is a **behavior**, not a trait.
- **Personality and performance**: There is extensive literature on personality and athletic performance (e.g., "Personality and Performance in Sports" in *Handbook of Sport Psychology*), but this literature focuses on **performance outcomes** (win/loss, ranking), not on **weight-making behavior**.

### What this means for the game

The game's eight-label personality system (`Disciplined`, `Ambitious`, `Loyal`, `Analytical`, `Fearless`, `Reserved`, `Charismatic`, `Temperamental`) is a **design abstraction**, not a sports-science model. The labels are inspired by real combat-sport commentary ("he's a disciplined fighter", "he's temperamental"), but they are not validated psychological constructs.

The question is whether the game's **design abstraction** can be connected to weight-making behavior in a way that is **honest to the design**, even if it is not honest to sports science.

### Verdict

**The link is not established in sports science.** The honest answer is that there is no published evidence that personality (as a stable trait) predicts weight discipline (as a behavior). The operator's instinct to connect them is **not supportable on the evidence** — unless the connection is framed as a **design choice** (the game's personality system is a design abstraction that can be connected to weight-making behavior for gameplay reasons), not as a **scientific claim** (personality causes weight discipline).

---

## 5. THE RECOMMENDATION, with anchors

### The three candidates

The task asks me to price three candidates and propose another if I find a better one:

1. **A weight discipline trait** moving adherence to a `WeightCut` diet plan.
2. **A division ambition** that makes a fighter *ask* to move, riding the existing `FighterRequests` seam.
3. **Nothing** — weight stays physiology, and the operator's instinct is not supportable on the evidence.

### Candidate 1: A weight discipline trait

**What it would do**: Add a new field `weight_discipline` (or use an existing personality axis) that modulates how well a fighter adheres to their diet plan. A "disciplined" fighter follows the plan; a "temperamental" fighter deviates.

**What it would cost**:
- A new field on the athlete dictionary, or a new axis in the personality system (PERSONALITY_RESEARCH.md §3.2 proposes five axes: `composure`, `drive`, `bond`, `show`, `nerve` — none of them is `weight_discipline`).
- A modifier on `WeightCut.apply_diet_week` (`WeightCut.gd:108-118`) that adjusts the `rate` or the `fatigue`/`morale` costs based on the trait.
- A new data table in `weight_classes.json` or a new JSON file.
- Tests to verify the modifier works.

**Why it is not the right choice**:
- The game's personality system already has eight labels and five proposed axes. Adding a sixth axis for weight discipline is **scope creep** — it is a second personality system, which the task forbids.
- The sports-science literature does not establish a link between personality and weight discipline (see §4). The connection would be **authored invention**, not evidence-based.
- The game already has a **diet plan** system (`WeightCut.gd:95-118`) with three plans (none, moderate, aggressive). The player chooses the plan, not the fighter. Adding a fighter-level modifier on top of the player's choice is **double-dipping** — the player's choice should be the lever, not the fighter's personality.

**Verdict**: **Not recommended.** It is a second personality system, not supportable on evidence, and it double-dips on the player's existing choice.

### Candidate 2: A division ambition that makes a fighter ask to move

**What it would do**: Add a new request type to `FighterRequests.gd` — `move_division` — where a fighter asks the gym to move up or down a weight class. The request is triggered by personality (e.g., `Ambitious` fighters ask to move up to chase bigger titles, `Loyal` fighters stay put).

**What it would cost**:
- A new request definition in `fighter_requests.json` (following the existing pattern: `id`, `label`, `kind`, `ask`, `detail`, `deadline_weeks`, `weight`, `trigger`, `kept_line`, `broken_line`).
- A new trigger function in `FighterRequests.gd:75-118` (following the existing pattern: `trigger_holds` checks conditions like `rank`, `win_streak`, `fatigue`).
- A new action set in `fighter_requests.json:43-48` (following the existing pattern: `actions` defines what the gym can do — `promise`, `defer`, `decline`).
- Integration with `WeightMove.gd` (the existing division-move system) to execute the move if the request is granted.
- Tests to verify the request triggers, the gym can respond, and the move executes.

**Why it is the right choice**:
- It rides the **existing `FighterRequests` seam** (`FighterRequests.gd:1-222`), which already has eight request types (`title_shot`, `step_up`, `raise`, `rest`, `hometown`, `release`, `rematch`, `retire`). Adding a ninth is **consistent with the existing design**, not a new system.
- It connects personality to weight **through behavior**, not through physiology. An `Ambitious` fighter asks to move up because they want a bigger title; a `Loyal` fighter stays put because they are content. This is **honest to the design** — personality modulates the fighter's **requests**, not their body.
- It is **supportable on evidence** — fighters do ask to move divisions (see §3), and the request is a **behavior**, not a trait.
- It is **cheap** — the existing `FighterRequests` system already handles the trigger, the response, and the consequence. The only new code is the trigger condition and the integration with `WeightMove.gd`.

**Anchors**:
- `FighterRequests.gd:75-118` — `trigger_holds` function, where the new `move_division` trigger would be added.
- `FighterRequests.gd:120-121` — `roll_chance` function, which already reads `personality_weight` to modulate the chance of a request. An `Ambitious` fighter would have a higher `personality_weight` for `move_division`.
- `fighter_requests.json:43-48` — `actions` table, where the new `move_division` action set would be added.
- `WeightMove.gd:1-191` — the existing division-move system, which would execute the move if the request is granted.
- `CareerGoals.gd:16` — `ASK_BY_GOAL` table, which maps goals to requests. A new goal (e.g., `move_up`) could map to the `move_division` request.
- `career_goals.json:41-47` — `personality_shift` table, where `Ambitious` and `Fearless` would have a positive shift for the new goal.

**What it would look like in the game**:
- An `Ambitious` fighter at lightweight with a 5-fight win streak asks: "I want to move up to welterweight. The division is shallow and the title is there."
- The gym can `promise` (book a move within 8 weeks), `defer` (wait 4 weeks), or `decline` (refuse).
- If the gym promises, `WeightMove.gd` executes the move: the fighter's walking weight drifts up over 4-16 weeks, they pay fatigue and morale costs, and their stats change.
- If the gym breaks the promise, the fighter's morale drops and a grudge forms (existing `FighterRequests` mechanics).

**Verdict**: **Recommended.** It is the ONE honest field that connects weight to personality: a **division ambition** that makes a fighter **ask** to move, riding the existing `FighterRequests` seam.

### Candidate 3: Nothing — weight stays physiology

**What it would do**: Conclude that the operator's instinct is not supportable on the evidence, and leave weight as pure physiology.

**Why it is not the right choice**:
- The operator's instinct is **partially supportable** — not on the evidence (see §4), but on the **design**. The game's personality system is a design abstraction that can be connected to weight-making behavior for gameplay reasons, even if it is not honest to sports science.
- The existing `FighterRequests` system already has a seam for this (see Candidate 2). Not using it is a **missed opportunity**, not a principled stand.
- The operator asked for a connection, and there is an honest one. Saying "nothing" is not the right answer — the right answer is "this one, not that one."

**Verdict**: **Not recommended.** The operator's instinct is partially supportable on the design, and there is an honest connection available.

### The recommendation

**Candidate 2: A division ambition that makes a fighter ask to move.**

This is the ONE honest field that connects weight to personality. It rides the existing `FighterRequests` seam, connects personality to weight through behavior (not physiology), is supportable on evidence (fighters do ask to move divisions), and is cheap (the existing system already handles the trigger, response, and consequence).

**What it costs**:
- A new request definition in `fighter_requests.json`.
- A new trigger function in `FighterRequests.gd`.
- A new action set in `fighter_requests.json`.
- Integration with `WeightMove.gd`.
- Tests.

**What it does NOT cost**:
- A new personality system (the existing eight labels and five proposed axes are enough).
- A new field on the athlete dictionary (the existing `personality` field is enough).
- A new data table (the existing `fighter_requests.json` and `weight_classes.json` are enough).

**Anchors**:
- `FighterRequests.gd:75-118` — `trigger_holds` function.
- `FighterRequests.gd:120-121` — `roll_chance` function.
- `fighter_requests.json:43-48` — `actions` table.
- `WeightMove.gd:1-191` — the existing division-move system.
- `CareerGoals.gd:16` — `ASK_BY_GOAL` table.
- `career_goals.json:41-47` — `personality_shift` table.

**What came back UNKNOWN**:
- The **rate** of missed-weight incidents (see §2).
- The **link** between personality and weight discipline in sports science (see §4).

**What is authored invention**:
- The **connection** between personality and weight-making behavior is a **design choice**, not a scientific claim. The game's personality system is a design abstraction; connecting it to weight-making behavior is honest to the design, but not to sports science.

---

## Sources

- `WeightCut.gd` — the existing weight-cut system (read whole, 248 lines).
- `FighterRequests.gd` — the existing request system (targeted grep).
- `CareerGoals.gd` — the existing goal system (targeted grep).
- `Retention.gd` — the existing retention system (targeted grep).
- `CoachRapport.gd` — the existing rapport system (targeted grep).
- `WorldPopulation.gd` — the existing world-gen system (targeted grep).
- `PERSONALITY_RESEARCH.md` — the existing personality research (read whole, 1193 lines).
- `fighter_requests.json` — the existing request data (read whole, 149 lines).
- `career_goals.json` — the existing goal data (read whole, 80 lines).
- `WeightMove.gd` — the existing division-move system (read whole, 191 lines).
- Sports-science literature on weight cutting (see §4 for references).
- Real-world penalty structures (see §2 for references).
- Real-world examples of fighters moving divisions (see §3 for references).

---

## Corrections

None. This study does not re-litigate any prior research.

---

## Unknowns

- The **rate** of missed-weight incidents is UNKNOWN.
- The **link** between personality and weight discipline in sports science is UNKNOWN (not established).
- The **connection** between personality and weight-making behavior is a **design choice**, not a scientific claim.

---

## Verdict

**Candidate 2: A division ambition that makes a fighter ask to move.**

This is the ONE honest field that connects weight to personality. It rides the existing `FighterRequests` seam, connects personality to weight through behavior (not physiology), is supportable on evidence (fighters do ask to move divisions), and is cheap (the existing system already handles the trigger, response, and consequence).

**What it costs**: A new request definition, a new trigger function, a new action set, integration with `WeightMove.gd`, and tests.

**What it does NOT cost**: A new personality system, a new field on the athlete dictionary, or a new data table.

**What came back UNKNOWN**: The rate of missed-weight incidents, and the link between personality and weight discipline in sports science.

**What is authored invention**: The connection between personality and weight-making behavior is a design choice, not a scientific claim.

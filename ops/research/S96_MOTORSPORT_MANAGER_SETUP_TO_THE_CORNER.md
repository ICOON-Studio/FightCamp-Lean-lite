# S96 - MOTORSPORT MANAGER'S SETUP LOOP, AND WHAT IT BECOMES IN THE FIGHT CAMP AND THE CORNER
Claude, 2026-09-27. Operator request (verbatim): *"analyze the mechanism of motorsport manager ... fine tuning the setup of
you racing cars (and the consequences it has on the race) , and see if it is possible to create new similar ways for that
logic of tuning/calibrating on the fighter with training and everything else (corner advice dillema do not blow the nose in
danger of the eye swalling or risk blowing it for some benefit ?) ... in between the rounds i want the corner to be
presented (visually indicators,text wtc) with the problems and be able to understand them and be able to address them
against the limited time"*.

Source: the operator's own install, `E:\SteamLibrary\steamapps\common\Motorsport Manager` (Unity). Read from type/field names
and float constants in `MM_Data/Managed/Assembly-CSharp.dll` (dnfile, scratchpad `mm_types.py`/`mm_il.py`) and the English
tutorial strings in `resources.assets`. Nothing copied into the game; this is a design study.

## 1. How Motorsport Manager's setup works (measured, not remembered)

**Inputs -> outputs -> hidden optimum.** `SetupInput` has six sliders - tyre pressure, camber, suspension stiffness, gear
ratio, front wing, rear wing (+ ballast in some series) - each a value in **-1..1, step 0.01** (`SetupInput_v1..cctor`).
`GetSetupOutput` folds them into only **three outputs**: `aerodynamics`, `speedBalance`, `handling` (`SetupOutput`). Each
slider moves more than one output, so the player is solving a small coupled puzzle, not setting three dials.
`OptimalSetup` holds the target output for this driver on this track; the player never sees it directly.

**The driver's opinion is the readout.** `SetupStintData.GetSetupOpinion` bands the distance of each output from its
optimum: **<= 0.03 Excellent, <= 0.10 Great, <= 0.20 Good, <= 0.30 OK, beyond that Poor / Very Poor** (`SetupOpinion`
enum: None, VeryPoor, Poor, OK, Good, Great, Excellent). The three opinions (aero / speed balance / handling) plus an
overall percentage are what the player reads - in words and colours, never the number.

**Knowledge narrows the band you can see.** `SetupPerformance.GetVisualKnowledgeRangeFromNormalisedValue` draws the "where
the optimum is" band on each slider at full width with no knowledge, **0.75** at medium, **0.3** at high. Knowledge comes from
practice laps (`PracticeKnowledge.UpdateBonusesForDistance`) and grows faster with a driver's FEEDBACK stat. Levels Low /
Medium / High / Great (`SetupKnowledgeLevel`) also unlock *knowledge bonuses* (tyre compounds, qualifying trim, race trim)
the player slots into two per-driver slots for the session.

**Feedback arrives over the radio, on a clock.** `RadioMessageSetupFeedback.CalculateNextFeedbackTime`: every **20-120 s**
of sim time the driver says what he feels ("understeer", "not enough top speed") - the direction to move, not the answer.

**Consequence.** The overall setup percentage feeds lap time for the session; a Great/Excellent car is a real pace gain,
and a trim choice trades qualifying pace against race pace. Driver and track differ, so last week's setup is a start, not
the answer (setups can be saved per circuit - `SessionSetupSaveFile` carries a player note).

**The pit stop is the time-boxed version.** `SessionSetup` / `SessionSetupChange`: every change (tyres, fuel, setup,
trim, repair, driver) has a TIME COST (`SetupDesignData.*TimeCost`), steps run in parallel on a critical path
(`CalculateTimeLimitingPitStep`, `IsOnTheCriticalPath`), and the player picks a crew STRATEGY - **safe / balanced / fast** -
that trades seconds for a **mechanic error chance** (`safeStrategyErrorPercent` ... `fastStrategyErrorPercent`,
`mistakeTimeCost`, `hadMistake`; a `isRiskTakerBonusActive` trait shifts it). A fumbled wheel nut costs more time than the
fast strategy saved. That is exactly the shape of a corner minute.

## 2. Why it works (the parts worth taking)
1. **Hidden target, readable symptoms.** You never see the answer; you see the driver's feeling in 5 bands and a direction.
2. **Coupled inputs.** One slider moves two outputs, so every fix has a side-effect to watch.
3. **Information is earned.** Practice + a good-feedback driver narrow the band; a rookie driver leaves you guessing.
4. **Time is the currency** in the pit: every action costs seconds, and speed buys risk.
5. **Few outputs.** Three opinions, not twenty stats - readable in a glance.

## 3. The same loop for a fighter

### 3a. The camp is the "setup" (weeks before the bout)
| Motorsport Manager | FightCamp |
|---|---|
| Six sliders -1..1 | The FIGHT PLAN sliders: range (inside <-> outside), pace (patient <-> pressure), level mix (head / body / legs), lead (orthodox / southpaw / switch), grappling intent (keep it standing <-> take it down), risk (defend first <-> trade) |
| Three outputs | Three READS the coach reports: **Offence fit**, **Defence fit**, **Engine (pace vs cardio)** |
| Hidden optimum per driver+track | Hidden optimum per fighter+OPPONENT (his style, reach, what he does not check) |
| Driver opinion bands (0.03/0.10/0.20/0.30) | Coach's opinion in the same 5 bands, in coach voice ("his jab is going to beat us to the spot") |
| Practice laps + driver feedback stat | SPARRING with a partner who fights like the opponent (we already hire style-clone partners, S88/S89) + the coach's reading stat; SCOUTING film; each spar narrows the band |
| Knowledge bonuses (2 slots) | Camp "reads" unlocked by enough spars/film: e.g. "he drops the right after the jab", "he doesn't check low kicks" - slot two into the corner for fight night |
| Save setup per circuit | Save a plan per opponent style |

### 3b. The corner minute is the "pit stop" (60 s, between rounds)
The operator's example is the model case: **blowing the nose with a damaged orbit.** Real corners forbid it (air forced
into the orbit can close the eye); a fighter who cannot breathe through blood gasses out. So it is a genuine dilemma:
**clear the airway now (breathing back, cardio +) vs risk the eye swelling shut (doctor-stop chance +).**

Each problem arrives as a CARD with a visual indicator on a small body figure (the operator's "pointing" figure lives HERE,
where there is time to read it; live in the round it is the on-fighter cues + chips G132 recommends):
- **What the corner sees** (text, one line, coach voice): "Right eye is closing." / "He's breathing through his mouth." /
  "Lead leg won't hold weight."
- **Severity** in the same 5 bands as setups (colour + word, never a number).
- **Actions**, each with a TIME COST in seconds and a RISK: e.g. eye - Enswell 20 s (swelling slows); cut - adrenaline +
  Vaseline 25 s (bleed stops for a round, cutman skill = error chance); leg - ice 15 s; breathing - "blow your nose"
  3 s (airway clear, cardio back **but** orbital-swelling risk if the eye/orbit is hurt); instruction - 10 s of the chief
  second's voice (tactical change: switch stance, clinch, go to the body).
- **A 60 s bar** that the chosen actions fill (parallel where real: the cutman works the face WHILE the chief second talks,
  like MM's critical path), and a crew STRATEGY: **careful / normal / rushed** - rushed fits more in but raises the
  cutman's error chance (a smeared hematoma, Vaseline in the eye) exactly like MM's fast pit crew.
- **Payoff next round, visible**: the card's region shows its new state at the next bell, the fighter's round opinion
  ("I can see him now" / "I can't breathe") reads like MM's radio feedback, and a mistake is shown as a mistake.

Cadence (G132): zero cards in a clean fight; one hard choice when a region reaches HURT; a second when two regions or the
doctor state light. Never eight equal buttons.

### 3c. What else the loop gives us (ranked)
1. **Corner minute as a pit stop** (time bar, parallel crew, careful/normal/rushed, visible payoff) - the core of S97.
2. **Fight plan as a setup with coach opinion bands** - replaces blind sliders with "does this plan fit THIS opponent?".
3. **Knowledge from style-matched sparring** - makes the S88 visiting partner and scouting pay a readable dividend.
4. **Round-by-round "radio"**: one line from the fighter/coach per round, a direction not an answer.
5. Saved plans per opponent style; cutman/coach skill as the "chief engineer" who may give bad advice.

## 4. Decision for S97 (lead developer)
Build S97 as planned (per-limb state behind a switch, live on-fighter cues + chips) and make its step 3 - corner actions -
**the MM pit-stop model**: problem cards with the body figure, a 60 s bar with per-action seconds, careful/normal/rushed crew,
the nose-blow dilemma as the first two-sided card. The fight-plan-as-setup (3a) is its own later stage after the corner.
Surveys sent: D44 (Dola, player's chair - re-sent, the first send never got an answer) and G133 (Grok, which management/
sports games make a time-boxed dilemma fun, and real corner rules on nose-blowing with an orbital injury).

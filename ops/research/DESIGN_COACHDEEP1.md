# DESIGN_COACHDEEP1 - coaches as people (Football Manager depth), from the code (S539)

Owner, S539: "why not make proper coaches like fottball manager and use them more to tighten and improve the core loop ?";
"make him more deep , what he know how he mix with fighters and different personalities , his playbook , needs proper
attributes and personality"; on the pro weigh-in pop-up: "can the 'their corner' be hyperlinked to their coach so you can
quickly see what his coach is good at and get some clues ?".
Task: ops/research/TASK_COACHDEEP1.md. Probe: tools/coachdeep1.gd + tools/coachdeep1_rules.gd, result docs/COACHDEEP1_RESULT.md.
Every line tagged CODE was read on 2026-11-23 at the file:line named. Lines tagged NEW are this design; ESTIMATE = a probe value.

## 0. Why the last coach design failed, and what is different here
- CODE docs/COACHHIRE1_RESULT.md (S538): a second coach as a stat multiplier plus a wage was never a choice - with one boxer the
  wage only closed the gym sooner; CoachMarket and CoachFit were removed. Its own limit: "a coach matters when coaching TIME is
  short (three or four boxers sharing one coach's evenings)".
- NEW: the choice here is not "hire or not" but WHO COACHES WHOM, every week, with fewer coached evenings than the boxers want.
  A coach is a person with a way of boxing and a temper; the same coach is right for one boxer and wrong for the next.

## 1. What the game has today (CODE)
- One coach per club: `Career.coach` is one Dictionary (scripts/state/Career.gd:23); `Sim.hire` refuses a second
  (scripts/state/Sim.gd:475-479). `Career.extra_coaches` (Career.gd:69) is an evening-class count, not a person.
- The coach is numbers only: `Data.COACHES` (scripts/state/Data.gd:33-40) - Reid and Hale, a rating, a spec, five areas
  (pads, bag, sparring, conditioning, strength). No personality, no playbook, no knowledge.
- Areas lift training: `CoachAreas.lift` (scripts/rules/CoachAreas.gd:63) = (0.5 + r x 0.7 / 100) / 0.6 against training
  alone (ALONE_FACTOR 0.6, :8). Pads teach moves: `MoveMastery.gain` x (1 + 0.40 x coach skill / 100)
  (scripts/rules/MoveMastery.gd:66), the skill read by `DrillWeek.pad_skill` (scripts/state/DrillWeek.gd:159).
- The coach writes her plan when the player writes none: `CoachPlan.write` (scripts/rules/CoachPlan.gd:65), one card read at
  rating 50 and two at 70 (READ_AT, :27); `BoutRead.chance`'s `coach` argument feeds it (scripts/rules/BoutRead.gd:272, :382).
- Film opens the opponent's file: `OppFile.tape` (scripts/rules/OppFile.gd:135), `known` (:120), `film_depth` (:209).
- The boxer is a person already: `FighterProfile.TRAITS` heart, temper, confidence, discipline, coachability, loyalty
  (scripts/rules/FighterProfile.gd:7); trust in the corner by mood `TRUST` (:39); "overruled" hurts a low-coachability boxer
  more (:163); a Low boxer stops taking in the corner (`CornerTrust.lands`, scripts/rules/CornerTrust.gd:11); the corner's
  word lands by coachability (`Exchanges.uptake`, scripts/rules/Exchanges.gd:249).
- Coached mornings are dealt by the coach (`CoachedMornings.week_deal`, scripts/rules/CoachedMornings.gd:142; `owned` :34).
- The other corner is a style only: the weigh-in answer reads the OPPONENT's style (`WeighMiss.answer` / TOUGH,
  scripts/rules/WeighMiss.gd:16-20, called from scripts/state/WeighMissWire.gd:29); the pop-up says "THEIR CORNER ANSWERS"
  (scripts/ui/modals/WeighIn.gd:46). REPEATBITE's read speed depends on the opponent's rating, not a coach
  (tools/repeatbite1_rules.gd:16-22, IQ_AT 65).
- The player's own background already follows "one clear edge" (`HeadCoach`: free_tells :65, cut_kcal :79).
- Staff cards list `Data.COACHES` (scripts/ui/StaffCard.gd:53, scripts/ui/OfficeDesk.gd:356).

## 2. The coach (NEW)
### 2.1 Attributes, 1-20 (eight, each wired to a rule that exists)
| Attribute | What it changes | Wired to (CODE) |
|---|---|---|
| Pads | moves learned on his pad nights | MoveMastery.gain coach_skill (MoveMastery.gd:66) via DrillWeek.pad_skill (DrillWeek.gd:159), per boxer instead of per club |
| Conditioning | engine gains on his sessions | CoachAreas.lift on the conditioning / strength areas (CoachAreas.gd:63) |
| Tactics | how many cards his plan reads | CoachPlan.write rating (CoachPlan.gd:27, :65), BoutRead.chance coach (BoutRead.gd:382) |
| Film | tells opened before a bout | OppFile.tape sessions (OppFile.gd:135): 8+ one, 14+ two (ESTIMATE) |
| Weight | the miss chance on a cut | the cut's daily kcal, as HeadCoach.cut_kcal (HeadCoach.gd:79); upstream of WeighMiss (WeighMiss.gd:20) |
| Cutman | guard recovery between rounds | GuardState recovery (scripts/state/GuardState.gd:124) - PHASE 2, not probed |
| Motivation | weekly morale on his boxers | FighterProfile morale (FighterProfile.gd:147) |
| Teaching young | learning for boxers under 21 | the learning multiplier (NEW), Kira 18 in the test club |
x5 = the game's 0-100 rating, so today's Reid (pads 74) reads Pads 15. One overall number stays for old readers (Data.gd:33 note).

### 2.2 What he knows
- Arts: boxing, BJJ (no-gi), later MMA. A coach who does not know the art teaches it at training-alone rate (probe: the Ana
  column; the only BJJ coach is C). Moves he knows: his best two punches drill at full pads, the rest at 80% (PHASE 2).
- Styles he reads best: his playbook's style; his film opens one more tell against it (PHASE 2).

### 2.3 His playbook (his way of boxing)
- One of: outbox ("jab and move"), pressure ("walk them down, body"), counter ("make them miss, pay them"), later volume.
- Fit with her style (FIT table, tools/coachdeep1_rules.gd): +1 his way, -1 against it. Learning x (1 + 0.15 x fit); his plan
  reads x (1 + 0.20 x fit) (ESTIMATE). A pressure coach on an out-boxer teaches slower and plans worse; on a presser, faster.
- Shown as his PLAN LINES: the arrows he writes first (CoachPlan.write's cards in his style's order) - the player sees what
  "his" plan for her would be on the Plan screen before choosing who corners her.

### 2.4 Personality and how he mixes
- Coach traits (0-100): temper, discipline, patience (+ ambition and loyalty for PHASE 3 careers).
- Chemistry -1..+1 from the two people (rules copy `chemistry`): two short fuses -0.4; a shouting coach folds a soft heart
  (heart < 45) -0.3; a hard heart likes a hard voice +0.2; strict coach + undisciplined boxer -0.25 (or +0.1 if she is very
  coachable); both disciplined +0.2; patience builds a doubter (confidence < 45) +0.3, impatience -0.25; a calm voice cools a
  hothead +0.15; positives scale with her coachability.
- Effects: learning x (1 + 0.30 x chemistry); morale +3 x chemistry a fully coached week, plus his motivation; her mood sets how
  much she takes in (FighterProfile.TRUST, FighterProfile.gd:39). Low for 6 weeks running: she leaves (the probe's stand-in for
  Loyalty.leaves, scripts/rules/Loyalty.gd:202).
- The BOND: +0.01 chemistry a week together, up to +0.25; fades 0.005 a week apart. Moving a boxer between coaches costs it.
- A clash is VISIBLE: the coach card's "with her" line (Good / Fine / Rubs her wrong, with the one reason in words: "he shouts,
  she folds"), her mood arrow, and the week review's "learned slower: wrong voice".

### 2.5 Time - the core choice
- Each coach has evenings a week (sessional 3, full time 5). Each boxer wants her three pad nights coached (PadWeek's
  Mon/Wed/Fri). Four fighters want 12; two sessional coaches give 6. The Week board assigns: drag a coach onto a boxer's night.
- An evening without a coach is training alone (CoachAreas ALONE). Her corner on fight night = the coach with most of her
  evenings that week (he writes the plan and watches the film).

### 2.6 The other corner (PHASE 2)
- Opponents' coaches on the same model; "THEIR CORNER" on the weigh-in pop-up opens a card: Tactics (how fast they adjust in
  round 2), Film (how fast they read a repeated combination - REPEATBITE's read: one throw sooner at Film 14+, replacing the
  opponent-rating rule tools/repeatbite1_rules.gd:22), Weight (their own boxer's miss chance), Temper (walks or takes terms on a
  weigh-in miss - WeighMiss.answer reads their corner's temper instead of TOUGH styles). Only lines the player can act on.

### 2.7 Careers (PHASE 3, sketch only)
Reputation grows with his boxers' wins; a rival gym offers him a job (poaching); a retired boxer of yours becomes a coach with
her own style as his playbook (MMA Empire, MMAEMPIRE1_COMPARE.md s1; MMA Fighter: Road to Champion's mentor); wages by reputation.

## 3. Every menu it appears on, and what each is wired to
| Menu | What shows | Wired to |
|---|---|---|
| Staff (StaffCard.gd:53) | the coach card: eight attributes 1-20, arts, playbook, three traits, evenings used/free | Data coach row (new fields) |
| Staff -> coach card -> boxers | one row per boxer: chemistry word + reason, fit word, bond weeks | rules chemistry / fit / bond |
| Week board (Training) | each pad night: who coaches it; drag to change; unfilled = "alone" | the week's assignment -> DrillWeek.pad_skill per boxer |
| Boxer card | "her coach", chemistry word, mood arrow with the coach's share | morale_week |
| Plan screen | "his plan for her": the arrows CoachPlan.write would write at his tactics and fit | CoachPlan.write (CoachPlan.gd:65) |
| Fight week | who corners her; his film = tells opened; his weight = miss chance on the cut line | OppFile.tape, cut kcal |
| Week review | learned faster/slower and why (coach, fit, chemistry); bond up | the week's multipliers |
| Weigh-in pop-up (PHASE 2) | THEIR CORNER links to their coach card | WeighMiss.answer by their temper |
| Hire screen | candidate coaches with the same card; wage | PHASE 2 (prices) |

## 4. Phase plan
1. YOUR COACHES (this probe's lever): coach model, two coaches, per-boxer assignment on the Week board, chemistry, fit, bond,
   per-boxer pads skill and corner. Golden path: assign, see learning and mood change, fight with his plan.
2. THE OTHER CORNER: opponents' coach cards, their weigh-in answer, their read speed, cutman.
3. CAREERS: hiring market priced by reputation, poaching, retired boxer -> coach.

## 5. Cut list
- Coach "rating" as the main number: kept only for old readers; never shown.
- CoachMarket / CoachFit (already removed S538): not brought back - their hire-as-multiplier was the failed lever.
- A coach that is better at everything: no. The probe's coach A (Pads 15, patient) was the better coach for all three boxers in 3 of
  the 4 pairs he is in (see the result): wages must scale with ability, or the pair choice is solved by the hire screen.
- Ambition / loyalty traits until PHASE 3 (nothing uses them before careers).

## 6. The probe (summary; details docs/COACHDEEP1_RESULT.md)
10 coach pairs x 6 assignment rules x 30 paired careers x 104 weeks, the test club, the game's fight read. All five bars
PASS: no rule best in more than 6 of 10 cells (chemistry-first 6, expected-learning 2, numbers 1, star-first 1); chemistry moves
a line in 10 of 10; the right coach differs by boxer in 9 of 10 (5 of 10 without Ana's BJJ); best beats "everyone the same"
by 11-20 lines in 10 of 10. Caveats in the result: chemistry's size is an ESTIMATE, losing a boxer is too cheap in the score.

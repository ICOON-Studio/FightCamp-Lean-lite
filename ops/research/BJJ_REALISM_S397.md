# BJJ realism (S397): what decides a no-gi match, measured, and the grappler model v1 -> v2

Operator (S397): asked what decides a BJJ and a boxing win and whether the mechanisms are deep enough for realistic
results; "done properly", critics review the design. This page: (1) today's two engines, measured; (2) the real numbers;
(3) design v1; (4) the critics; (5) design v2 as built; (6) after-numbers. [R] = a real-world number with its source,
[G] = a game value (our choice), [M] = measured in our code.

## 1. What decides a match today (code read S397, measured by tools/bjj_realism_probe.gd, 400 bouts a cell)

Two engines:
- **The walk** (`BjjWalk.walk` on `BjjTree`, the simulated opens): a beat every 33 s; the side with the initiative takes
  its plan step or its best p x gain - (1-p) x loss move (17% the second best). Odds = base rate x mastery factor of the
  attacker / mastery factor of the defender's best answer, x chain x mood / the read. No body at all: strength and
  cardio are not read. At the bell: points, advantages, then `rng.randi() % 2` - a coin.
- **The live belt match** (`BjjMatch` on GrappleMap, `BeltMatch.gd`): odds = KIND_BASE x (0.6 + m/75) + skill gap/200
  (+ strength gap/250 on takedowns, passes, escapes, mount), x gas; no advantages; level points = the one with more gas.
- **Opponents** (`BjjOpp.generate`): one of five lane styles; owned moves roll OWNED_M **30-45 at every belt**; only the go-to
  route rises (50-70 from purple); IQ by belt; strength/cardio 45-60 from the seed (live match only).

Measured, BEFORE (the higher belt's win share; the lower belt's rules and clock; sides alternated):

| walk | vs white | vs blue | vs purple | vs brown | vs black |
|---|---|---|---|---|---|
| white | 0.52 | 0.77 | 0.79 | 0.75 | 0.79 |
| blue | | 0.47 | 0.50 | 0.54 | 0.54 |
| purple | | | 0.48 | 0.51 | 0.51 |
| brown | | | | 0.48 | 0.51 |

- **Past blue the belt means nothing**: blue vs black 54%, purple vs black 51%. A black belt loses to a white belt 1 in 5.
  Cause: owned mastery 30-45 at every belt (`BjjOpp.T0.OWNED_M`); a black owns more moves, not better ones, and the defender's
  answers are the same 30-45.
- Finishes, even fields [M]: white 21% subs, 52% points, 16% advantages, **11% referee coin**; blue 47/44/2/7; purple
  55/37/4/5; brown 66/27/0/7; black 77/20/0/3. 0-0 at the bell 13-28%.
- Styles [M, purple]: the five styles move a matchup 3-10 points, mostly within noise (e.g. Passer vs Wrestler 0.59 one
  way, 0.52 the other). Styles change which lane is weighted x2, nothing about the body.
- **Live engine** [M, BjjMatch.odds on a class chain, not the GrappleMap graph]: `skill_of` (the mean syllabus mastery) is
  white 24.7, blue 37.0, purple 38.1, brown 37.5, black 38.1 - the same flat line; white vs black 0.87, blue vs black 0.62,
  brown vs black 0.50. On the chain nearly every match ends in a submission (the chain has no positional dead time, so the
  sub rate there is an artefact; the belt-gap shares are the finding).

Verdict before: within a belt the walk is decent (calibrated bars 1-16 of GAMETREE1); across belts it is wrong; the body
is invisible in the sim; the referee is a coin; every opponent of a belt is the same person with a different lane weight.

## 2. The real numbers (research S397; full report with every source: ops/research/BJJ_REAL_NUMBERS_S397.md)

| what | number [R] | source (solidity) |
|---|---|---|
| no-gi black belt, IBJJF No-Gi Worlds | 45% submission (2023, 218 matches), 46% (2025, 257); women 54-56%, men 39-42% | BJJ Heroes 2023/2024, DigitSu 2025 (medium) |
| no-gi black, method split | sub 44%, points 39%, advantages 2.4%, decision/other ~14% (2025, 125 recorded) | DigitSu (weak) |
| all-level no-gi, established athletes | sub 44%, points 30%, referee decision 19%, draw 7% (3,912 matches) | nogiratings.com/studies/accuracy (medium-strong) |
| regional, belts mixed | 50-63% by submission | jits.gg Grappling Industries pages (weak-medium) |
| referee decisions, IBJJF Worlds black | 7% (800+ matches); the winner usually had more takedown attempts (85%) and top pressure | BJJ Heroes decision studies (medium) |
| level on points at the bell (gi black) | ~32%; 24% end 0-0 | BJJ Data by Riggs 2020 (medium) |
| IBJJF order at the bell | points, advantages, FEWER PENALTIES, referee decision (who was more offensive, closer to scoring or a sub) | IBJJF Rules Book 5.2, 2021 (strong) |
| penalties | 1st marked only, 2nd = an advantage to the opponent, 3rd = 2 points, 4th = DQ; stalling counted after ~20 s; not stalling while holding mount/back/side properly | same (strong) |
| belt gap | **no published number**; proxy = no-gi rating gap: 0 -> 50%, 100 -> 66-75%, 200 -> 76-84%, 300 -> 85-90%, 400+ -> 90-93% | nogiratings.com/studies (medium-strong) |
| mismatches finish | favourite submits / gets submitted: even 22% / 33%; 200 gap 53% / 9%; 500+ 76% / 1% | nogiratings.com/studies/submissions (medium-strong) |
| first scorer wins | 89% (2018 Pans), 75% (2019 Worlds), gi black | BJJ Heroes, Riggs (medium) |
| no-gi black finishes | RNC ~21-22%, heel hooks 17-23%, leg locks together 30-35%, armbar 8-15% | BJJ Heroes, DigitSu (medium) |
| white/blue (gi) | sub attempts 75% from guard; RNC attempts land 75%, triangle 22% | Williams et al. 2019, IJPAS (medium) |
| physical | aerobic capacity does not separate levels; grip endurance, relative strength, jump, flexibility do | reviews in the report (medium) |
| weight, open weight | the heavier wins 60.5%, 69% at ~33 kg more | nogiratings.com (medium) |
| match length | white 5, blue 6, purple 7, brown 8, black 10 min (gi and no-gi) | IBJJF Rules Book 2021 (strong) |

### Targets (bars) for v2 - which are real, which are ours
- **Belt gap** [G from the R proxy; coach lore for 3+]: one belt up 70-85% (rating gap ~100-250), two belts 85-95%, three or
  more 92-99%; **no gap is a certain win (every cell <= 99%)**; the higher belt finishes more as the gap grows (3+ belts:
  most matches end by submission).
- **Even fields**: black 40-60% by submission (R: 45%); brown 45-60% (the GAMETREE1 bar 3a, FloGrappling 2022); white 30-55%
  (bar 3d); referee decisions 2-10% of even matches (R: 7% black, 19% all-level incl. sub-only overtime formats); advantages
  decide <= 8% at brown/black (R no-gi: 2.4%).
- **Styles** [G]: at an equal belt the worst matchup for a style moves the chance 8-15 points from even (the boxing model's bar).
- **Within a belt** [G, R proxy]: a 4-stripe vs a fresh athlete of the same belt ~60-65% (a ~75-100 rating gap).
- First scorer wins 0.80-0.87 (GAMETREE1 bar 16, kept).

## 3. Design v1 - the grappler model (for the critics)

Principles (the same as the boxing fighter model, ops/research/FIGHTER_MODEL_S397.md, so the two sports read alike):
every number changes a situation you can see; nothing is averaged - each move reads only what matters for it, side
against side; one model for Ana, Marta, every open's opponent; the rating is a summary for tables, never fought on.

### 3.1 A grappler = technique + body + mind + a game
- **Technique** stays what it is: mastery per move (the tree), the owned/felt/learning arrows, the answers. This is the
  core and the thing the player trains.
- **Body** (0-100, new for the walk; the live match has strength + cardio today):
  | attribute | what it does on the mat |
  |---|---|
  | strength | drives through a body: takedowns finished, passes that pin, pressure from top, chokes squeezed; makes the opponent's escapes harder |
  | cardio | the tank: every attempt costs gas (strength moves more); a tired grappler's attacks and answers both fade |
  | flexibility | guard retention (passes against them fail more), triangles and leg entries from bottom, hard to arm-lock |
  | explosiveness | scrambles and shots: takedowns, sweeps finished on the move, escapes, back takes in a scramble |
- **Mind**: IQ (the read, by belt, exists), **composure** (a bad spot does not cascade: a miss slides less far, escapes
  under a pin hold up, the late lead is kept), **aggression** (a dial, not good or bad: more attempts and fewer holds, sub
  hunting, the referee's eye - against more missed attempts and more gas spent).
- **Body facts**: weight within the division (light / mid / heavy end; heavy = + strength edge, - cardio) - later, with
  open-weight divisions.

### 3.2 What each move reads (side against side, then the dice)
odds = base x mastery(att) / mastery(answer) x chain x mood / read **x body(kind)**, where body(kind) = exp(K x sum of
w x (att_attr - def_attr) / 100) over the attributes that matter for the kind, clamped [0.70, 1.40]:
| kind | attacker | defender |
|---|---|---|
| takedown / entry from standing | explosiveness, strength | explosiveness (sprawl), strength |
| pass | strength, cardio left | flexibility (retention), explosiveness |
| sweep | explosiveness, flexibility | strength (base) |
| escape | explosiveness, composure | strength, composure |
| back take | explosiveness | composure |
| submission | strength (chokes) / explosiveness (legs) | flexibility (joint locks), composure |
Gas: each non-base attempt costs gas by kind x (1.5 - cardio/100); a hold breathes; odds x lerp(0.7, 1, gas_att) and the
answer x lerp(0.7, 1, gas_def) - equal cardio cancels, so today's calibration holds; only a cardio gap shows late.

### 3.3 What a belt means (the fix for the flat line)
A belt is time on the mat, for everyone, Ana included:
- **Seasoning**: an OWNED move of a lower belt keeps sharpening in every class after it - SEASON (start 7) per belt above
  it, read-time (`BjjTree.season`). A black belt's white-belt armbar and shrimp sit at owned + 28; its newest black-belt
  moves are as fresh as anyone's. The same rule lifts Ana's white moves when she is promoted, so a promotion is not a cliff.
- **Answers**: the defender's answers are moves too, so a black belt's defence is seasoned the same way.
- IQ by belt (exists), composure by belt (BjjBody.BELT_COMPOSURE), breadth (the owned count, exists).
- **Time at the belt**: an opponent's class share at the belt (0.5-0.9) slides every rolled mastery by (share - 0.7) x
  TIME_W (start 15): a fresh blue is a little worse than a 4-stripe blue.
SEASON and TIME_W are tuned on the probe until the belt-gap table sits in the section 2 bands.

### 3.4 Five games, each one a different opponent
Each style is a shape of the body + mind (with noise, so two Wrestlers still differ), a lane weighting (exists) and a
signature route at the top of the belt's band, plus a way of fighting:
| game | body / mind shape | fights like |
|---|---|---|
| Wrestler | strength +, explosiveness ++, flexibility - | shoots first, keeps top, holds a lead (stalls on top) |
| Guard player | flexibility ++, cardio +, strength - | pulls guard (no points), sweeps and triangles, patient |
| Passer (pressure) | strength ++, cardio +, composure + | pins, grinds passes, mount; slow, heavy |
| Half-guard player | composure ++, strength +, flexibility + | plays half and deep half, sweeps to the back |
| Leg locker | explosiveness +, flexibility +, aggression ++ | goes to the legs early (brown+ rules for heel hooks), all or nothing |
Bars: at equal belt a bad matchup moves the chance 10-15 points (a guard player with flexibility vs a passer without
pressure, the reverse with a strong passer); each style wins its own positions (the probe counts points by lane).

### 3.5 The referee decision (no coin)
IBJJF order at the bell: points, advantages, penalties, then the referee. v1:
- Penalties for stalling: a side that holds (the late-lead hold) or makes no attempt for STALL_S of match time while the
  match is level or it leads draws a stall count; IBJJF steps (section 2) turn counts into advantages / points for the
  other side. Aggression lowers it, a Wrestler or Passer holding a lead raises it.
- Then the referee's decision: who was more offensive - an offence tally through the match (submission attempts 3,
  pass / sweep / takedown / back attempts 2, entries 1, time on top), the higher share wins; within 10% of even it is a
  judgement call, weighted by the shares (never a flat 50/50 unless the tallies are equal).
- The live match gets the same: advantages (a missed submission that was close, a near pass) and the same decision
  instead of "more left in the tank".

### 3.6 The world's fields
An open's bracket is at Ana's belt and weight (as today), but the field is not one person: each opponent is a game, a
body and a time at the belt; the later rounds draw from the better half (survivors). Gym rolls may mix belts (the
partner, a coach roll), which is where the belt-gap table shows. Absolute (open weight) and superfights come later.

## 4. The critics (three fresh reviewers in parallel, S397) and our verdicts

| critic | score of v1 | first thing they saw |
|---|---|---|
| (a) a BJJ black belt competitor / coach | 6/10 | riding mount was penalised as stalling; even black fields finished 77% (real 45%) |
| (b) a game systems designer | 6/10 | the body is dice the player cannot steer; explosiveness and composure everywhere; Ana's composure flat while the field's rose |
| (c) a sports-sim veteran | 5/10 | the mastery factor moves odds ~0.6% a point, so seasoning cannot carry a belt; multiplicative stacking; EPS is noise, not upsets |

Verdicts (YES = in v2 now, LATER = queued, NO = not taken), with the reason:
- YES stalling by position (all three): a hold on a pin (mount, back, side, knee on belly, north-south) or under one is never
  a stall; a penalty every 2nd hold (~66 s) off a pin; IBJJF ladder kept.
- YES the referee tally counts a miss at half and every beat on top, holds too (c).
- YES READS v2 and a smaller body cap (a): strength cut on passes, chokes, escapes; flexibility off choke and heel-hook
  defence; leg-lock defence mostly the answer's mastery; cap +-0.25 on the logit (~x0.8-1.25).
- YES the belt gap as MAT TIME, a lever of its own on the logit (c), stepped bigger low and smaller high (a's per-pair bands),
  built class by class so a promotion is no jump (b). It REPLACES v1's seasoning of moves (c: too weak; b: it made drilling
  old moves pointless); moves stay what was drilled.
- YES (a's "defence above all" in another form) the FINISH GATE (c): a landed submission is escaped before the tap by tier
  and mat time; an escaped one is an advantage (a near submission, as IBJJF scores it).
- YES the logit for every new lever (c): mat time, body, tanks, form add the same amount on any base rate; a zero shift is
  the GAMETREE1 formula exactly, so the within-belt calibration stands.
- YES FORM on the day for both sides (c): one draw a side a match (sd 0.25 on the logit); correlated upsets the card can name.
- YES EPS shrinks with IQ (c): x1 at white (calibrated), x0.5 at brown/black.
- YES composure by belt at read time for everyone, Ana too (b).
- YES the player's mat call (b): f["mat_call"] hunt / steady / hold moves Ana's aggression (+25 / 0 / -20); a hunter never
  sits on a lead, a holder starts holding twice as early. The bout card button is a UI follow-up (LATER).
- YES the live match shares mat time (c, minimal form): its skill = mean mastery + 20 a level of mat time; level points go to
  the referee's offence decision, not the fuller tank. LATER: the live odds on the walk's formula (BjjClash shows the terms).
- LATER the back-taker / scrambler game and the matchup wheel (a); a scouting card with tells, the duel line and a counter
  drill on screen (b; the duel line exists as the body note); training the body and mind in the Week (b); hand fighting and
  frames as technique lines, weight as a body fact (a); 15-s beats so gas means more (c).
- NO shorter beats now (a: with position-aware stalling the 33-s beat is fine).

## 5. Design v2 (as built)
odds = clamp(logit+( base x mastery(att)/mastery(answer) x chain x mood / read ,
               MAT_W x (mat_att - mat_def) + body(kind) + GAS_W x (gas_att - gas_def) + (form_att - form_def) ), 0.03, 0.90)
then for a submission: the finish gate, escape = logit+(ESC by tier, ESC_W x (mat_def - mat_att)).
- mat_time (BjjBody): white 0, blue 1.0, purple 1.8, brown 2.4, black 2.9 (+0.4 over a black belt's first 300 classes), plus
  the class share towards the next belt. Ana at 130 of 200 white classes = 0.65.
- Opponents: a game (style) = a body shape + noise (BjjBody.SHAPES), lane weighting, a go-to route; their class share at the
  belt is their time at it. Ana's body: strength 52, cardio 58, flexibility 56, explosiveness 50, composure 50, aggression 52.
- The bell (BjjRef): points, advantages, fewer penalties, then the more offensive side; inside 5% of even a weighted call.
- Files: BjjBody.gd (body, mat time, finish gate), BjjRef.gd (the bell), BjjWalk.gd (the levers, notes), BjjTree.gd (odds with
  the logit shift), BjjOpp.gd (bodies), BjjMatch.gd + BeltMatch.gd (live: skill with mat time, the decision).

## 6. The deep-fight loop (operator S397: "proper and deep mechanism implementation of the bjj fight ... start implementing
what passes a 8/10 by critics")
Method (operator): a free designer seat writes "the version that would score 8"; a NEW fresh blind critic panel scores it;
build a part only at 8 from two fresh critics; re-score the built thing.
- Miro (production map uXjVEV03QWA=) read S397: the operator's YOUR NOTES boxes on "BJJ belt match - you call the next move"
  and "GAMETREE1" are empty. Kept from the board: Argon's coach posture "Stall, Cook, or Hunt" (= our Hold / Steady / Hunt),
  "opponent scouting reveals hidden counter traps", "tunnel vision when gassed" (exists), "corner composure limits
  overrides" (later); John: "belt technique bands are ESTIMATE", "first scorer should win 80-87%" (bar 16, kept).
- Designers round 1 (on v2 + critics round 1): Dola (ops/research/BJJ_DESIGN_DOLA_S397.md) and Qwen
  (ops/research/BJJ_DESIGN_QWEN_S397.md). Taken into v3: hand fighting and frames as trainable lines (both), a sixth game -
  the back-taker / scrambler (both), the matchup wheel (both), the pass as a contest of several beats (Dola), defence
  weighted over attack (both), the counter drill (Qwen), a grip beat (Dola). Not taken: 15-s beats now (both bars sets would
  need re-calibrating; measured first), Dola's self-scores and its formulas that disagree with each other, Qwen's heel-hook
  injury DQ (later), body training focuses in the Week (the Week is another seat's area; later).
- v3: ops/research/BJJ_DESIGN_V3_S397.md. Blind panel round 2 (ops/research/BJJ_CRITICS_R2_S397.md):
  | part | A | B | C | D | E | F | G | H | I |
  |---|---|---|---|---|---|---|---|---|---|
  | critic 1 | 6 | 6 | 6 | 5 | 7 | 6 | 6 | 5 | 6 |
  | critic 2 | 6 | 6 | 6 | 5 | 6 | 5 | 6 | 7 | 6 |
  No part at 8: nothing new is built from v3. The structural faults they agree on: the belt gap matters less than the
  spread inside a belt (IBJJF never mixes belts); defence read twice (odds + gate); the gate double-counts attempt-to-tap
  base rates; a pull needs a grip and can be punished; side control held without advancing IS stalling; too many attempts
  per match (ADCC 2019: ~3.5 an athlete); one style label per athlete (real players have a standing plan + top game +
  bottom game).
- Designers round 2 (on v3 + critics round 2): Qwen (ops/research/BJJ_DESIGN_V4_QWEN_S397.md). Taken into v4: three parts
  per athlete (standing plan, top game, bottom game), the grip edge lowered to +0.15 with decay, the punished pull, the double
  pull, most beats are holds, one pressure stack of +0.35, the exemption list fixed, decision weights from the data, scouting
  only for opponents known in advance, the counter week that costs growth. Not taken: a separate hidden rating beside mat
  time (it would count the belt twice - folded into one lever), the heel-hook injury DQ (later).
- v4: ops/research/BJJ_DESIGN_V4_S397.md. Panel round 3 (ops/research/BJJ_CRITICS_R3_S397.md):
  | part | A | B | C | D | E | F | G | H | I |
  |---|---|---|---|---|---|---|---|---|---|
  | critic 3 | 7 | 5 | 6 | 5 | 6 | 7 | 5 | 7 | 7 |
  | critic 4 | 6 | 7 | 5 | 7 | 6 | 7 | 5 | 5 | 6 |
  First contradictions (B, D, H) - their shared cause is the beat budget.
- Designers round 3: Dola (ops/research/BJJ_DESIGN_V5_DOLA_S397.md, raw). Taken: the inside-belt spread as a share of the
  step, a skewed sandbagger tail, working vs idle holds, escape positions per submission. Not taken (wrong or invented): 95+
  moves at black (the map has 80), a "+5 logit" counter, live calls only at a 40-60% win chance, an advantage to both after a
  double pull, white/blue sub rates labelled [R] from youth data.
- v5 (parts A, E, F, H, I): ops/research/BJJ_DESIGN_V5_S397.md. Panel round 4:
  | part | A | E | F | H | I |
  |---|---|---|---|---|---|
  | critic 5 | 6 | 6.5 | 7 | 8 | 6.5 |
  | critic 6 | 7 | 6 | 7 | 7 | 6 |
  H got its first 8 (needs two). STRUCTURAL (rule 5 of the method): one acting side per 33-s beat gives a white match 9
  beats, which cannot hold real white-belt action density + holds + stalling (critic 6: 3-5 attempts an athlete = every beat
  an attempt). Part E waits for a beat-length change measured in the harness; paper rounds stop for E.
- v6 (parts A, F, H with the one fix each the critics named): ops/research/BJJ_DESIGN_V6_S397.md.
- Panel round 5 on v6 (A, F, H):
  | part | A | F | H |
  |---|---|---|---|
  | critic 7 (black belt, referee course, women's team) | 7.3 | 6.8 | 5.8 |
  | critic 8 (match-engine engineer) | 6 | 7 | 5 |
  H went 8 -> 7 -> 5.8 -> 5 over the rounds: the critics now contradict each other, and every H/E fault traces to one cause.

## 7. Where the loop stopped, and the structural change (rule 5 of the method)
Five paper rounds; no part reached 8 from two fresh critics, so NOTHING NEW IS BUILT from the paper designs. The faults left
are structural, not wording:
1. THE BEAT. One acting side per ~33-s beat (9 beats at white, 18 at black) cannot hold real action density, a 20-s stall
   count, a simultaneous double pull, or a white belt's scrappy pace (critics 4, 6, 7, 8). DESIGN CHANGE: a beat of ~11 s
   (27 at white, 55 at black) in which BOTH sides choose (act / work / idle) and the initiative decides whose action resolves
   first; a "working" beat is grip fighting or framing with no roll. Every within-belt bar of GAMETREE1 (BEAT_S 33, EPS, PLAN_PULL
   ...) must be re-fitted on the harness after it, so it is built as its own measured step, not on paper.
2. THE BARS MUST BE SOLVED, NOT WRITTEN. Critic 8 showed A's inside and across bars imply the same mat-time gap at the same
   weight and cannot both hold: the belt bands get fitted on the probe (SPREAD and MAT_W solved), then the critics score the
   MEASURED table (the operator's rule: the score that counts is on the built thing).
Already in the branch (v2 code, unmeasured): mat time on the logit, the body reads, gas, form, EPS by IQ, position-aware
stalling, the IBJJF bell with penalties, the referee's offence decision (no coin), the finish gate, the live match's
decision. It stays on the branch until the probe has measured it and it is cut to what passes.

## 8. S398: v2 measured, then fitted (tools/bjj_realism_probe.gd; seeded, `-- n=2000 parts=walk,inside,style`)
The probe had no entry point in S397 (the BEFORE table was run from an older copy); S398 gave it one, `KEY=v` tuning, the
four-stripe vs fresh rows and BAR lines. The walk was split into shared helpers for the two-sided beat; the probe table
is identical to the unsplit walk at n=100 (diffed).

### 8.1 v2 as built (n=2000 a cell, MAT_ATT 0.8 / MAT_DEF 1.2, levels 0 / 1.0 / 1.8 / 2.4 / 2.9, ESC_PRO 0.35)
| higher belt wins | vs white | vs blue | vs purple | vs brown |
|---|---|---|---|---|
| blue | 0.91 | | | |
| purple | 0.97 | 0.77 | | |
| brown | 0.99 | 0.90 | 0.75 | |
| black | 0.995 | 0.95 | 0.86 | 0.69 |
- The belt means something past blue now (BEFORE: blue vs black 0.54; v2: 0.95). Over: blue>white, purple>white, black>white
  (0.995, above the 0.99 cap); brown>black 0.69 under; a four-stripe white beat a fresh white 0.85.
- Even fields by submission: white 0.23, blue 0.50, purple 0.50, brown 0.57, black 0.65 (real no-gi black 45%; women 54-56%).
  Referee decisions 0.02-0.06 (real 7%); advantages decide 0.02-0.04 above white (white 0.13).
- Styles (n=2000 a pair): the worst matchup 6-13 points off even; white Guard player mean 0.58 (bar 0.45-0.55).

### 8.2 The fit and the bands it was fitted to
Finding: cutting the white step 1.0 -> 0.7 moved blue>white only 0.91 -> 0.91 and the inside-white row 0.85 -> 0.82 - the
white->blue gap is carried by the MOVE LIST (a white owns 8-12 moves, a blue 25-36) and class time (it teaches the tree
moves), not by mat time. So the bands are per pair, each with its reason:
- one belt 0.70-0.85 [R proxy: a 100-250 rating gap]; white->blue 0.80-0.90 (the move list as well; v6 80-88; the coach
  critic: white to blue is the biggest gap); brown->black 0.60-0.72 (the smallest step); two belts 0.85-0.97; three or more
  0.92-0.99, no cell above 0.99.
- four-stripe vs fresh, same belt: 0.62-0.76 [R proxy: a 75-200 gap]; white 0.72-0.85 (a fresh white has no classes, a
  ready one is a fresh blue).
- even fields: submissions white 0.30-0.55, brown 0.45-0.60, black 0.40-0.60; referee 0.02-0.10; advantages <= 0.08 from brown.
Shipped (BjjTree.T0): MAT_ATT 0.7, MAT_DEF 1.0, levels white 0 / blue 0.6 / purple 1.35 / brown 1.95 / black 2.6 (+0.4
over a black's first 300 classes), ESC_PRO 0.5. Five configurations swept at n=1000; the shipped one passed every belt bar:
| higher belt wins (n=1000) | vs white | vs blue | vs purple | vs brown |
|---|---|---|---|---|
| blue | 0.88 | | | |
| purple | 0.96 | 0.72 | | |
| brown | 0.975 | 0.88 | 0.76 | |
| black | 0.990 | 0.94 | 0.87 | 0.64 |
four-stripe vs fresh: white 0.78, blue 0.73, purple 0.70, brown 0.75, black 0.68. Even subs: blue 0.50, purple 0.50, brown
0.47, black 0.56; referee 0.02-0.07. Still OUT: white even subs 0.22 (bar 0.30-0.55; GAMETREE1 bar 3d, open since S384).
Tests: all 11 BJJ tests green; retuned with the reason in the code - bjj_body_test (mat-time asserts read the fitted levels;
"the steps shrink" -> "steps 0.4-1.0, black's own the smallest", since the move list carries white->blue), bjj_tree_test
(a result line may end "penalties a-b", v2's IBJJF bell), GAMETREE1 bar 2 holes visited 6-14 -> 6-16 (form on the day: 15
with FORM_SD 0.25, 14 with 0). GAMETREE1 bars still open (as before): 3b, 3d (white subs 0.16), 4b (white sub attempts 1.3
a bout, bar 2-4), 6, 8, 16 (first scorer wins 0.67, bar 0.80-0.87).

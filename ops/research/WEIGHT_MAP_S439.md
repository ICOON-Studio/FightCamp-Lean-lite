# WEIGHT1: the weight mechanic, design map, clarity round 3 (S439)

Roadmap row WEIGHT1. Author: Claude (designer seat). Status: CLARITY ROUND 3, for two fresh critics.
History: S434 round 2 (`WEIGHT_MAP_S434.md`) depth 8 and 7, clarity 6 and 5. S439 round 1 (`screen_r1.png`) depth 5 / 5,
clarity 6 / 6. S439 round 2 (`screen_r2.png`) depth 5 / 5, clarity 6 / 5. Round 3 changes the MECHANIC where round 2's
critics found lookups or wrong code claims:

| Round-2 finding | What changed in the mechanic (round 3) |
|---|---|
| The roadwork row was fixed to "4 slip-rope mornings", which are not even in the coach's week (WeekPlan / WeekPhase) | BURN MORNINGS is a picker over the coach's REAL peak week (WeekPhase.WEEKS["peak"], CODE). Each morning shows what it trains and its own price, computed with WeekPlan.day (CODE). The goal price appears only on the mornings that feed the goal; the others cost their own stat. Mornings that already burn (roadwork, intervals) are not offered |
| Meal prep was a $120 lookup; the slip was a dice roll the player could only buy down | The slip is now SAMIRA'S ASK, built on the game's own asks (PushBack: chance from coachability, heard +5 / overruled -5, CODE). The player sets the standing answer: Let Samira eat / Half a plate / No. Each answer has a different currency (Energy, mood, a small kg). Meal prep is $25 a day ($300 for 12 days, two-thirds of the bout's $450 ticket cut) and halves how often she asks |
| The diet row (Lean / Lean + roadwork / Hold / Cut) read off one cell | The diet is no longer a free pick: Lean is the coach's and runs; Cut appears ONLY as one of three priced answers to the Monday check. Hold is a hover line (it cannot make 65.0 for Samira) |
| Standing order "Switch to Cut / Ask me": one answer | Three priced answers: Trust the trim (Energy kept, less room under the cap) / Cut 5 days (-1 Energy at the bell, twice the room) / Pull out now ($300 slot, the $450 not earned, no loss) |
| The goal price claimed "the corner's calls land less on the night" | Wrong: the goal is judged AFTER the bout (BoutNight._finish :423 morale first, :426-432 goal). The screen now says "judged after the bout" and shows the mood after the bout for a win and a loss. The ON-THE-NIGHT mood price comes from the ask's "No" (Samira 54 -> 49.6 = Flat, trust 0.85, CODE) |
| Save round 1 refills to 100 and erases every weight plan's price | B0 SAVECAP1 (fight model, before anything else): Save breathes back 1 an exchange (was 6), the next round never starts above this round's start, live Energy never above 100. With the cap the weight gap carries into round 2 (94 -> 92, 84 -> 82). P16 measures it |
| The curve drew Samira's lines (55, 40, 35) as if Kayleigh had them; her own line (45) was missing | Each fighter's own lines: 70 (both, the round's power), 45 (Kayleigh: under it she goes "Tiring" 3 exchanges in 4, Exchanges.OPP_TIRED / next_mode), 35 (Samira: "tired", her plan's situations stop, Exchanges.SHE_TIRED / situation). The 40 line is gone (read on the round's START Energy, never reached by Samira); 55 is said only on the Push card |
| The window where "When Kayleigh tires" can fire was not shown | THE WINDOW is shaded: Kayleigh under 45 AND Samira at 35 or more. Its exchange count is on every plan row and every pace card (5 / 4 / 3) |
| Pace only for round 1, no round tell | A pace for each round (R1 / R2 / R3, the plan's own store f.round_pace, CODE), with the tape's round tell (PlanFile.round_hints, CODE) or "none found yet" |
| Watch tape 2 priced in a pad night through WeekPhase.film_night (wrong: Build phase with a camp only) | Watch tape 2 is FREE, as the Tape Room is today (TapeRoom.gd: a viewing costs nothing). It is a link, not a decision |
| Write it compared +0.6 against +0.9 with no count | One unit: exchanges it fires x the line's edge (PlanFight.EDGE best 9, ok 3, UNDRILLED 0.8). The replaced line: about 7 pressing exchanges x 3 = 21. The new line: window x 3/4 x 9 x 0.8. Worth it at a window of 5 (27), even at 4 (21.6), a loss at 3 (16.2): the weight plan decides it |
| Opponent Energy, walkover, scale on the day shown as if they exist | Tagged NEW on the screen ("today she starts at 100"); the worth cards carry the code's loss and win prices (CODE) and mark the walkover NEW |
| Clutter (Hold row, Cut note, scale-day timeline, Body and class strip, two selection controls) | Cut. One control per choice; the scale day is one bar of three rules |

Read for this round: `CRITIC_PACK.md` (whole), `WEIGHT_MAP_S434.md`, both round-2 critics' notes and 10/10 drawings
(`critic_systems_r2.png`, `critic_coach_r2.png`) and the code: `scripts/rules/{Exchanges,PaceAim,Combos,OwnCombos,PlanFile,
PlanFight,PlanBoard,WeekPlan,WeekPhase,WeekTwist,PushBack,FighterProfile,BoutRules}.gd`, `scripts/state/{BoutNight,LiveRound,
LiveRoundAfter,RingDuel,Data}.gd`, `scripts/ui/{FightPrep,TapeRoom}.gd`. The Energy numbers are a replay of the code's formulas
(Combos.after_round, RingDuel.her_energy / opp_energy, PaceAim) with no calls and no body shots: the drawn curve is the best case.

THE DRAWING: `docs/mockups/s439/weight/screen_r3.html` (+ `.png`, 1920x1080): Samira Khan's Fight prep, sub-tab THE WEIGHT, on
Mon 16 Feb 2026 (day 42), the day the offer is accepted, 12 days before a club show.
Rendered headless with tools/render_mockup.py and opened: nothing clipped. Left: the three levers (burn mornings strip over the
real peak week, her ask's three answers + meal prep, the Monday check's three answers), the result row, four plans side by side,
the scale-day rules. Right: pace per round, the curve with each fighter's own lines (70 / 45 / 35) and the shaded window, the
other three paces as cards, the other corner (tape 2 free, Write it in one unit). NEW parts carry a NEW tag on the screen.

Tags: CODE = in the game today (file:line or constant). ESTIMATE = our value, not in the code. NEW = must be built (task named).

## 0. The idea in five lines

1. Every fighter walks above the class limit; making weight is the work of every bout, and it pays in Energy at the first bell.
2. The player shapes the cut with three priced levers: which training mornings to burn (a stat or the goal), how to answer the
   fighter's ask to eat (Energy, mood, or cash for meal prep), and what to do if the Monday check reads over (Energy, room, or pull out).
3. Energy at the bell decides the WINDOW: the exchanges where the opponent tires and our fighter is still fresh enough to punish it.
4. Pace per round and the plan's "when she tires" line are bought against that window, so weight, pace and the plan are one budget.
5. What runs for months (the walk, between-fights eating, the class) lives on the fighter's Body and class tab.

## 1. What is built today (read in the code)

| Part | What runs | Where (CODE) |
|---|---|---|
| One weight a fighter | `f["weight"]` moves daily by a kcal sum; no walking weight | Sim.gd:207-209; WeekPlan.day :241-270 |
| Sessions burn and train | kcal = MET x kg x min/60 x burn; gain = 0.2 (SESSION_SHARE) x intensity gain x headroom x coach; roadwork MET 9.3 / 45 min, slip rope 4.5 / 30, shadow 5.5 / 30, intervals 11 / 30; Light gain 0.6 burn 0.7, Hard gain 1.3 burn 1.35 load 1.5 | WeekPlan SESSIONS :31-41, INTENSITY :45-49, day :241-270 |
| The coach's week by phase | 12 days out = PEAK: Mon intervals Hard, Tue the focus session, Wed roadwork, Thu slip rope Light, Fri intervals, Sat shadow Light, Sun rest. Fight week = TAPER: roadwork Light, shadow Light, rest, speed bag Light, roadwork Light, rest, rest | WeekPhase.WEEKS :25-34, phase :43-47 (ceil(days/7): 2 = peak, 1 = taper), FOCUS :35 (defence -> slip_rope) |
| Two diets | HOLD (+300 kcal allowance), CUT -500 kcal (Old hand -620) | WeekPlan ALLOWANCE 300, CUT_DEFICIT 500 |
| The scale | made = weight <= limit + 0.05, the day before | BoutRules WEIGH_TOLERANCE 0.05, made_weight :171 |
| A miss today | bout off, $300 empty slot, next offer 6 days later, no loss, no morale change | Bouts.weigh :327-347; BoutRules MISSED_WEIGHT_COST 300 |
| Energy at the first bell | TANK 100 - hurt - stale; the opponent always 100 | BoutNight._energy :300-306 |
| Stale | 2 a fatigue point over 50, at most 20, only after a camp | BoutRules.stale_energy :165-168 |
| A round's spend | ROUND_COST 18 + punches, x spend_factor (1.2 - 0.4 x Stamina/100); the minute refills 52% of the fast 60% x fitness | Combos :26-38, after_round :272-276 |
| Live Energy in a round | lerp(start, end, exchange/6) - the calls' and pace's cost - body shots x 1.2 | RingDuel.her_energy :299-302, opp_energy :305-308 |
| The round's power fade | tired_penalty(round END Energy): 0 at 70, 6 at 0, BOTH fighters, computed before pace and calls | Combos.tired_penalty :285; BoutNight.gd:323 |
| Own combinations | share 0.33, 0.25 when the ROUND'S START Energy is under 40; 0.40 when the plan names the go-to whatever the Energy | OwnCombos.use_share, ring_edge :183-194 (called with a0) |
| Samira tired | under 35 the situation is "Your fighter is tired" whatever the opponent does; best call Breathe, Let your hands go is wrong | Exchanges.SHE_TIRED 35, situation :170-175, MODES she_tired |
| Kayleigh tires | under 45 the opponent goes "Tiring" 3 exchanges in 4; a "fades late" habit 1 in 2 in round 3 | Exchanges.OPP_TIRED 45, next_mode :221-227 |
| Pace | Push +6 an exchange, 1.35x the drop, its edge fades from 55 to -6 net at 25; Save -4 an exchange, 0.6x the drop and +6 back an exchange | PaceAim PACE_EDGE, PACE_SPEND, SAVE_RECOVER 6, push_gassed :187-190; LiveRoundAfter.gd:51-53 |
| Pace carried | the round's pace cost comes off the next round's start, clamped at the ceiling | LiveRound.close :392-399 |
| Round pace in the plan; round tells | f.round_pace (PlanFile.pace_for / set_pace); the tape's "slow to start" -> push R1 (+3 in its first 2 exchanges), "fades late" -> R3 | PlanFile.round_hints :113-125, cold_edge :128-133, COLD_EDGE 3 |
| Plan lines | best 9, ok 3, wrong -7 an exchange; an undrilled combination x0.8; the coach holds 6 lines (Luke Reid 58) | PlanFight.EDGE :19; PlanBoard.UNDRILLED 0.8, arrow_limit |
| Weapons | a move or combination is a weapon from 30 mastery; pads 2.1 an hour, a pad night 75 min | BoutRules.WEAPON_MASTERY 30; Combos.LEARN_AT 30; WeekPlan EVENINGS |
| Her asks | when she has a reason, she asks lerp(0.6, 0.2, coachability/100) of weeks; answers heard +5 / overruled -5 (overruled x lerp(1.4, 0.7, coachability), negatives x lerp(1.3, 0.7, heart)); low discipline = under 50 | PushBack ASK_MOST/LEAST, pick, LOW_DISCIPLINE 50; FighterProfile.MORALE_EVENTS :18-33, apply_morale :155-170 |
| Mood is trust | Fired up 75+ 1.05, Steady 50+ 1.0, Flat 30+ 0.85, Low 0.7 of the corner's word taken in | FighterProfile.trust |
| After the bout | morale of the result first (win +8, loss -12), THEN the goal (met +10, missed -20) | BoutNight._finish :423, :426-432 |
| Club prices of a result | win +8 members +5 reputation; loss -1 member -2 reputation; every bout fought pays the $450 ticket cut | BoutRules WIN_MEMBERS 8, WIN_REPUTATION 5, LOSS_MEMBERS 1, LOSS_REPUTATION 2, TICKET_CUT 450 |
| The tape | the Tape Room plays the films free; a spotted tell opens; tape study in a camp opens one a session | TapeRoom.gd; OppFile; FightPrep.next_step :71 (button only with camp.film) |
| Samira Khan | 65.9 kg, Welterweight 65.0, 2-1, Slugger, Stamina 60, Defence 50.5, Technique 54.5, discipline 34, coachability 52, heart 70, confidence 66, potential 82 | Data.gd:210-213 |

Four code findings for the main session (fight model, not weight; this design leans on the first):
- SAVE REFILLS PAST THE TOP. Save's per-exchange cost is drop x (0.6 - 1) - 6, so a round on Save adds about +48 to the next
  start (clamped at 100 in LiveRound.close) and the LIVE Energy rises inside the round with no clamp (a 96 start reads 111 by the
  sixth exchange, RingDuel.her_energy). One Save round erases any start gap. B0 fixes it.
- Pace does not change its own round's power fade: tired_penalty reads the round's end Energy from _energy, before pace.
- The goal's mood lands after the bout, so a goal missed never touches the night it was earned for.
- 12 days out with no camp, FightPrep.next_step says "Set the camp" (CAMP_MIN_DAYS 7): until AMATEURWEEK1 lands, an amateur
  bout still asks for a camp.

## 2. What is thin today

- Weight never reaches the fight: no Energy price for a trim, the opponent always starts at 100, two invented opponent-weight
  formulas disagree (TapeRows.gd:71-80, TaleOfTape.gd:24-29).
- A miss is $300 for everyone, no loss, though amateurs lose by walkover (EB 10.7.2); everyone weighs in the day before though
  amateurs weigh on the day (EB 7.1.3).
- The fighter's character never touches weight (the asks exist for training only).
- Energy has rules but no screen shows where it runs out, the window it buys, or what pace does to it.

## 3. The words (one set on every screen)

| Word | Means | Never |
|---|---|---|
| Walking weight ("walks 66.8") | where the body settles when nobody cuts | natural weight |
| Class, limit ("Welterweight 65.0") | the class and its scale number | division |
| The scale ("Sat 28, 4 pm") | the official weigh-in, its day and hour | weigh-in check |
| Burn morning | a training morning swapped for Hard roadwork to lose weight | cardio day |
| Trim ("trim 0.53") | the last 3 days' low-fibre, low-salt eating, at most 2% of the limit | water cut (amateurs) |
| Her ask ("Samira asks to eat") | the fighter asks to break the diet one weekend | cheat day |
| Meal prep | the club pays for the fighter's meals for this bout's days | |
| Energy | fight-night fuel, 100 at a fresh first bell | Tank, gas |
| The window | the exchanges where the opponent is tiring and our fighter is not tired | |
| Stamina | the fitness stat (code `conditioning`) | Cardio, Engine |
Names on every line ("If Samira asks"), never he or she.

## 4. The split: what lives where

| Where | What the player decides there |
|---|---|
| FIGHT PREP > THE WEIGHT (a bout booked) | burn mornings (D1), the answer to her ask and meal prep (D2), the Monday check's answer (D3), the pace of each round (D4), Write it (D5); Watch tape 2 is a free link |
| HOME need, only past the trim cap | Pull out or go to the scale (D6) |
| BODY AND CLASS tab | reads: walk, between-fights eating (the coach's), last 6 scales; decides the class (D7) when two are in reach |
| CLUB > PEOPLE | the nutritionist (D8) |
| THE BOUT OFFER | Accept or Pass (CODE, free); one line: the coach's plan and its Energy at the bell |
Fight prep keeps its head (VS, days, the one primary button) and gets four sub-tabs: THE WEIGHT / YOUR PLAN'S ANSWERS / THE TAPE /
THE WEEK. Between-fights eating is the coach's setting (Lean while over the limit and able to take offers, Hold when injured or at
the limit), shown on Body and class with its reason.

## 5. The mechanics, each a decision with priced options

The price of a kilo (ESTIMATE, B1): the trim costs -1 Energy a 0.1 kg up to 0.5, -2 a 0.1 from 0.5 to 1.0, -3 a 0.1 past 1.0;
the cap is 2% of the limit (65.0 -> 1.3) in 3 days (REAL.md 7). Lean is -250 kcal a day, 0.03 kg a day (ESTIMATE, B4).
What Energy buys: the WINDOW (section 6 table, replay of CODE formulas) and the round's power (tired_penalty, CODE: 0.086 power a
point under 70 at each round's end). As a win chance: 0.4 in 100 a point of start Energy (ESTIMATE, P10).

### D1. Burn mornings (pick 0 to 3)
The coach's peak week (CODE WeekPhase.WEEKS["peak"], focus Defence -> Tue is slip rope). A picked morning becomes Hard roadwork
(CODE kcal and gain formulas). Only training mornings that do not already burn are offered; the fight week is the coach's taper
(fresh legs) and is not offered; Mon 16 is done.
| Morning (Samira, 65.9 kg) | kcal today -> Hard roadwork | kg off | Lost | Gained | Its price for Samira |
|---|---|---|---|---|---|
| Tue 17 slip rope Normal | 148 -> 620 | 0.061 | Defence 0.23 (0.2 x 1.25 headroom x 0.906 coach) | Stamina 0.21 | THE GOAL: Defence 50.64 < 50.8, missed (mood -19.9 after the bout) |
| Thu 19 slip rope Light | 104 -> 620 | 0.067 | Defence 0.14 | Stamina 0.21 | THE GOAL: Defence 50.72, missed |
| Sat 21 shadow Light | 127 -> 620 | 0.064 | Technique 0.12 (0.12 x 1.1 x 0.906) | Stamina 0.21 | Technique only |
| Wed 18 roadwork, Mon 16 / Fri 20 intervals | already burn (0.02-0.03 kg) | | | | not offered |
- The goal (ESTIMATE example): "Defence 50.8 by Sat 28", set two weeks ago. The coach's week reaches 50.86 (Tue 0.23 + Thu 0.14;
  the taper has no slip rope): met by 0.06.
- Each morning is worth about +1 Energy while the trim sits in the -1/-2 tier, about +2 in the -3 tier, and it is what keeps a
  trim under the cap after a slip. Stamina +0.21 lowers the round's spend by about 0.1 Energy (spend_factor, CODE): shown in the hover only.
- Not a lookup. Samira: only Sat is worth it (Tue and Thu cost the goal, -19.9 mood after the bout). Kira Mensah (58.3 kg over a
  57.0 limit, no goal due): her trim is 0.94, in the -2 tier near the -3 tier, so all three mornings (Tue speed bag, Thu slip
  rope, Sat shadow) buy 3.4 Energy for Speed -0.14, Defence -0.12, Technique -0.12. A fighter whose trim is under 0.5 buys 1 Energy
  a morning for 0.12-0.23 of a stat and takes none. The answer comes from the trim's tier, the goal, and which stat each morning feeds.

### D2. If Samira asks to eat (a standing answer, set now; and meal prep)
NEW B7: a weekend ask beside the weekly card (it touches only the diet, so it does not break the one-card-a-week rule). She has a
reason when a diet is running and discipline is under 50 (CODE LOW_DISCIPLINE); she asks lerp(0.6, 0.2, coachability/100) of
the weekends she has a reason (CODE PushBack rate): Samira (coachability 52) 0.39, "about 2 weekends in 5". This bout has one
weekend (Sat 21). Kira (discipline 64) never asks: her screen has no D2.
| Answer | kg (ESTIMATE) | Mood (CODE apply_morale, Samira) | Energy at the bell (with Sat burned) | Best when |
|---|---|---|---|---|
| Let Samira eat | +0.5 | heard: +5.2 -> 59.4 | 84 (trim 1.03) | she is Flat near Steady (+5 lifts her trust 0.85 -> 1.0 for the night) and the trim has room |
| Half a plate (NEW middle answer) | +0.2 | 0 -> 54.2 | 90 (trim 0.73) | mood near the Steady/Flat edge AND the trim near a tier |
| No, stay on the plan (the coach's default, as every ask's "b") | 0; but under discipline 50 she eats anyway (50 - discipline)/100 = 1 in 6 (NEW, ESTIMATE) | overruled: -4.6 -> 49.6 = FLAT on the night, trust 0.85 | 94 (82 if she eats anyway: trim 1.09) | mood well inside a band, trim near the cap |
- MEAL PREP for this bout: $25 a day (ESTIMATE from GBP 5.5-8 a meal, 3 meals, x1.25; TO SOURCE B13), $300 for 12 days, paid at
  once (CODE c.pay, Club > Money PAID OUT). She asks half as often (0.39 -> 0.20) and a "No" always holds (the food is planned).
- Not a lookup: three currencies. For Samira at Steady 54 the "No" puts her Flat on the night 2 times in 5 (-2 in 100, ESTIMATE
  P17); Half a plate costs 4 Energy 2 times in 5; Let her eat costs 10 Energy and gives +5 mood. Meal prep is worth $300 only with
  Let her eat or No (it halves a big price), not with Half a plate (it halves 4 Energy: 0.8 Energy for $300). The mood band edge, the
  trim tier and the runway each move the answer.

### D3. If the Monday check reads over (Mon 23; a standing answer, the clock does not stop)
Target = the plan's line + 0.1 (Samira: 65.7). Over it, the standing answer runs:
| Answer | Price (Samira after eating, 66.13 on Mon 23) | Best when |
|---|---|---|
| Trust the trim (the coach's) | trim 1.03: Energy 84, room under the cap 0.27, miss 4 in 100 (ESTIMATE) | the trim stays under 1.0 |
| Cut 5 days (Mon 23 - Fri 27) | -0.16 kg (250 kcal a day more, CODE CUT_DEFICIT), -1 Energy a Cut day (ESTIMATE, B4): Energy 83, room 0.43, miss 1 in 100 | the trim passes 1.0 (the -3 tier) |
| Pull out now | $300 slot (CODE MISSED_WEIGHT_COST, the injury pull-out path), the $450 ticket cut not earned, no loss, the next offer 6 days later (AFTER_MISSED_WEIGHT) | the forecast trim is near the cap |
Not a lookup: Energy against room under the cap against cash. The miss chance by room (ESTIMATE, B1): 1 in 100 from 0.4, 4 at 0.27,
8 at 0.2, 20 at 0.1.

### D4. The pace of each round (Energy panel)
Three picks a round, writing the plan's f.round_pace (CODE, the store Playbook > Game plan uses): Push / Steady / Save. "Opening pace:
you change it every 30 s on the night." The round tell from the tape (CODE round_hints) shows when found.
| Samira 94, Kayleigh 86 (NEW B6) | Window | Exchanges Samira is tired | Price |
|---|---|---|---|
| Steady all three | 5 | 1 (R3 last) | none |
| Push round 1 | 3 | 3 | +6 an exchange in R1 while over 55 (CODE); +3 more in R1's first 2 against a slow starter (CODE cold_edge) |
| Save round 1 (after B0) | 6 | 0 | R1 at -4 an exchange and 0.75x output (CODE): round 1 is likely given away |
| Push round 3 | 4 | 2 | best only against "fades late" (CODE round_hint) |
Not a lookup: the pick turns with the weight plan (Samira 84: Steady window 3, Push R1 window 0 and 7 tired exchanges), with the round
tell (none found yet; tape 2 can open one) and with Write it (the window is where its line pays). Win change per pace waits for P16.

### D5. Write it: "When Kayleigh tires -> 1-2-3" (the plan is full, 6 of 6)
It replaces "When Kayleigh presses -> Step back" (Works, ok 3, CODE PlanFight.EDGE). One unit, edge x exchanges it fires:
- Replaced: about 7 pressing exchanges of 18 (ESTIMATE: Kayleigh is a Pressure fighter) x 3 = 21.
- New: window x 3/4 (CODE OPP_TIRED chance) x 9 (best, the 1-2-3 against a tiring opponent, PlanFight) x 0.8 (the 1-2-3 is at
  27, under 30: UNDRILLED, CODE) = 27 at a window of 5, 21.6 at 4, 16.2 at 3. Drilled to 30 (two more pad nights on it: +2.6 each,
  CODE 2.1 an hour x 75 min) it is 33.8 at 5.
- Not a lookup: worth it on the 94 plan (window 5), even on the 90 plan (4), a loss if she eats (84, window 3). The weight plan and
  the pace decide it; pad nights on the 1-2-3 (the Training tab) move it.

### D6. Past the cap (a Home need that stops the clock; the only weight card)
When the forecast trim passes 1.3: PULL OUT ($300, no ticket cut, no loss) or GO TO THE SCALE (the cap's trim, up to 0.3 sweated
off at -2 Energy a 0.1, ESTIMATE; past that a WALKOVER LOSS, NEW B5: the loss path, -12 mood, -1 member, -2 reputation, the record).

### D7. The class (Body and class; only when two classes are in reach) and D8. The nutritionist (Club > People)
Kept from round 2 unchanged: D7 within reach = no more than 9.5% under the walk and 4 kg over it; a move leaves the regional table
(CODE, per class). D8 $100 a week for all fighters: trim price x0.8, asks x0.75 (ESTIMATE); pays back with two fighters cutting at once (P13).

### Watch tape 2 (a free link, not a decision)
The Tape Room plays tape 2 free (CODE TapeRoom.gd). Spotting the tell opens it (CODE OppFile: weapon first, weakness last); it may be a
round tell (D4). NEW B2: it also narrows Kayleigh's trim, so her Energy reads to +-1.

### Cut, with the reason
- Diet rows Lean / Lean + roadwork / Hold / Cut: read off one cell. Lean runs; Cut is a Monday-check answer; Hold is a hover.
- Per-bout meal prep at $120 and the weekly house rule: cash lookups. Now $300 tied to the ask's answer.
- "Switch to Cut / Ask me": one answer. Now three priced answers.
- A priced Watch tape 2: contradicted the free Tape Room.
- The 40 and 55 lines on the curve, the water note, the scale-day timeline, the Body and class strip, PICKED/ADD chips.
- A gym weigh-in Saturday as cover (critic 1): its price (mood) duplicates the "No" answer; one mood lever is enough.

## 6. One week, played (Samira Khan, Mon 16 to Mon 23 Feb 2026)

Start: day 42, week 7 (CODE: day 0 is Mon 5 Jan 2026). Samira (CODE Data.gd:210-213), 65.9 kg, Welterweight 65.0, 2-1. Walks
66.8 (ESTIMATE, B3). Mood 54.2 Steady (ESTIMATE example: 49 after her loss, booked +5 x1.03 = +5.2). Goal Defence 50.8 by Sat 28
(ESTIMATE example). Focus Defence. Cash $12,940, running -$280 a week. No camp (fight week, S428). Coach Luke Reid 58.

MON 16. Offer: Kayleigh Bell (2-1, Pressure fighter, an example rival), club show Sat 28 (day 54). Accept. The worth cards: a win
3-1 (one win from the regional table, CODE: enters at 4) +8 members +5 reputation +8 mood; a loss -1 member -2 reputation -12 mood;
the $450 ticket cut either way (CODE); Samira misses = walkover loss (NEW); Kayleigh misses = walkover win, about 4 in 100 (NEW, ESTIMATE).

THE WEIGHT opens on the coach's plan: Lean 12 days -0.36 -> 65.54, trim 0.59 (Thu-Sat) -> price 5 + 1.8 = 6.8 -> Energy 93.
The player's three levers:
1. BURN MORNINGS: Tue and Thu are marked "Defence: the goal" (50.86 -> 50.64 / 50.72, missed). Sat shadow costs Technique 0.12. The
   player burns SAT: 65.48 at the trim, trim 0.53 -> 5 + 0.6 = 5.6 -> Energy 94 (+1).
2. IF SAMIRA ASKS TO EAT: the coach's "No" would put her at 49.6, Flat on the night, 2 times in 5. The player sets HALF A PLATE: if
   she asks, +0.2 kg, trim 0.73 -> 9.6 -> Energy 90, mood stays 54. No meal prep (it would buy 0.8 Energy on average for $300).
3. IF THE MONDAY CHECK READS OVER: TRUST THE TRIM (a half plate leaves the trim at 0.73, under 1.0).

| Plan | Energy clean / if she asks | Mood on the night if she asks | Window | Win (ESTIMATE, band 46-62) | Costs | Mood after the bout, win / loss |
|---|---|---|---|---|---|---|
| Coach's: no burn, No, trust the trim | 93 / 93 (82 if she eats anyway) | 49.6 Flat (trust 0.85) | 5 (3) | 53 | Flat 2 in 5 | 73 / 54 (68 / 49 if she asked) |
| Yours: Sat burned, Half a plate | 94 / 90 | 54.2 Steady | 5 / 4 | 54 (+1) | Technique -0.12 | 73 / 54 |
| Sat burned, Let her eat, meal prep $300 | 94 / 84 (she asks 1 in 5) | 59.4 Steady | 5 / 3 | 54 (+1) | $300 | 73 / 54 (78 / 59 if she asked) |
| All three burned, Half a plate | 96 / 93 | 54.2 Steady | 5 / 5 | 55 (+2) | Defence goal missed, Technique -0.12 | 43 Flat / 24 Low |
Arithmetic: Win = 54 at Energy 93 (the bout's band middle, ESTIMATE) + 0.4 a point; Flat on the night -2 (P17); averaged over the ask
(0.39, or 0.20 with meal prep) and "eats anyway" (1 in 6 of a No). Mood after: win +8.26, loss -10.56 (heart 70), goal met +10.32,
goal missed -19.9 (CODE apply_morale with Samira's traits). The differences in win chance are inside the band: the screen says "too
close to call" and the decision rests on the tails (Flat on the night, the goal, the cash).

THE PACE: no round tell on file. Steady all three: Samira 94 -> 64, 74 -> 44, 58 -> 28 (tired for the last exchange); Kayleigh
86 -> 56, 65 -> 35, 49 -> 19 (NEW B6; today she starts at 100). The window: round 2's last exchange and round 3's second to fifth = 5.
Push R1 would cut it to 3 and leave Samira tired for 3. Save R1 (after B0) widens it to 6 and gives round 1 away. The player keeps Steady.
WRITE IT: window 5 x 3/4 x 9 x 0.8 = 27 against 21 for Step back: the player writes it. Pads on the 1-2-3 (Training tab) would make it 33.8.
TAPE 2: free in the Tape Room; the player watches it on Tue (a round tell would change D4).
TUE 17 - FRI 20. Lean: 65.87, 65.84, 65.81, 65.78 (ESTIMATE, CODE day formula).
SAT 21. The ask comes (0.39). Half a plate: +0.2. News: "Samira asked to eat at a birthday meal: half a plate."
MON 23. The check: 65.63 + 0.2 = 65.83 against 65.7: over 0.13. The standing answer (Trust the trim) runs; the week review says so.
SAT 28 (as it will run): 4 pm the scale 64.95, made (zero allowance NEW B5; up to 0.3 over sweated off at -2 Energy a 0.1);
5 pm the first bell at Energy 90; the window is 4.

## 7. The professional (debut onwards): the same sub-tab, more levers
Kept from S434: the scale the day before about 30 h out (BBBofC 3.2.2), the last day's water (0 to 3%), refuel, catchweight for 10% /
15% of the asker's purse (CODE gym share 25%), a missed opponent (box for +25% of their purse, or refuse). A pro camp's stale Energy
(CODE stale_energy) prices every burn morning in fatigue as well.

## 8. Every menu it appears on, and what each is wired to

| # | Menu | What it shows | Wired to today (CODE) | New wiring |
|---|---|---|---|---|
| M1 | FIGHTER > FIGHT PREP > THE WEIGHT (drawn) | worth cards; the three levers (burn mornings strip, the ask's answer + meal prep, the Monday answer); the result row; plans side by side; Energy round by round with pace per round, each fighter's lines and the window; the other corner (tape 2 link, Write it) | FightPrep.gd:34-50, next_step :60-74, _camp_card :140-163; Sim.weigh_forecast; PlanFile.set_pace; TapeRoom | WeightRules.plan / mornings / ask_rows / monday_rows / window; EnergyCurve; PlanLines.add(replaces) |
| M2 | FIGHTER > BODY AND CLASS (a shown tab) | walk and drift, between-fights eating (the coach's), asks to eat (rate), the last 6 scales, the class card | FighterPage.gd:29-30 (TABS[2] not in TAB_ORDER) | TAB_ORDER [0, 2, 3, 5, 7, 4]; BodyClass.make |
| M3 | FIGHTER > TRAINING (week board) | a burned morning shows "Hard roadwork, for the weight" | WeekBoard.gd:402-416; WeekPhase.edits | WeightRules writes f.week_edits (the Week's own exceptions store) |
| M4 | FIGHTS > BOUT OFFER | the scale's day and hour; the coach's plan's Energy at the bell | VersusPanel.gd:159, :185-196; BoutPage.gd:44-56 | WeightRules.coach_plan(f, day) |
| M5 | HOME > NEEDS | only past the cap: Pull out / Go to the scale | Needs.gd:75-76 | WeighDay.past_cap |
| M6 | THE WEIGH-IN (modal) | the hour, the reading, made / sweated (-Energy) / walkover loss | WeighIn.gd:13-28; Bouts.weigh :327-347 | WeighDay.weigh |
| M7 | TALE OF THE TAPE + 3D intro | weights on the scale and on the night | TapeRows.gd:64-80; TaleOfTape.gd:24-29 | OppWeight (the two formulas go) |
| M8 | FIGHT NIGHT | first card "Energy 90: trim 0.7 -10" for both corners; the round pace as set | BoutNight.gd:306; PlanFile.pace_for | WeightRules.energy_sum into :306 for both |
| M9 | RESULT > THE WHY | "Weight: Energy 90 at the bell; the window 4; your tires line fired 3 times" | WhyCard.gd | WeightRules.why_line |
| M10 | WEEK REVIEW | the ask and its answer, the Monday answer that ran, planned vs actual | WeekReview.gd:413-414; WeekActual.gd:82-91 | WeighDay.check; EatAsk.log |
| M11 | HOME fighter row, Coming up | "0.83 to lose · scale Sat 4 pm" | HomeRows.gd:195-201; Fixtures.gd:19 | WeighDay.hour |
| M12 | FIGHTERS > ROSTER | weight against the limit; amber when the Monday answer ran, red past the cap | RosterCards.gd:213-220 | f.plan state |
| M13 | CLUB > PEOPLE | the nutritionist | StaffRoles.gd:7-21 | StaffRoles + "nutritionist" |
| M14 | CLUB > MONEY | "Meal prep: Samira, 12 days $300" in PAID OUT | c.pay | WeightRules.buy_meal_prep |
| M15 | WORLD > NEWS | the ask and answer, made / sweated / walkover | c.add_news (Bouts.gd:339) | WeighDay, EatAsk |
| M16 | PLAYBOOK > GAME PLAN | the round pace (same store); the line Write it added, "from the weight plan", and the line it replaced | GamePlanRows.gd:20-32; PlanFile.set_pace | PlanLines.add(line, source, replaces) |
| M17 | NO-GI athlete page | "Scale at the mat, before the first match" | NoGi.gd:74 | WeighDay.hour for bjj (TO SOURCE) |

## 9. The build (each file under 500 lines, one owner, its test red on main first; nothing before two critics score 7+)

| # | Task | Owner | Owns (lines) | Test red first |
|---|---|---|---|---|
| B0 | SAVECAP1 (fight model, first): SAVE_RECOVER 6 -> 1; the next round never starts above this round's start; live Energy clamped at 100 | Claude | PaceAim.gd (+2), LiveRound.close (+2), RingDuel.her_energy (+1), tests/save_cap_test.gd | Save R1 from 90 starts R2 at 100 and reads 111 live (red today); after: R2 <= 90, live <= 100. Then P16 and the fight balance re-measure |
| B1 | WEIGHTRULES1 (pure): trim price and cap, burn-morning prices from WeekPlan.day, the ask's answers, the Monday answers, miss by room, Energy sum, window by replay, win change | Qwen (Goose route) | scripts/rules/WeightRules.gd (~340), tests/weight_rules_test.gd | Samira's three mornings return 0.061 / 0.067 / 0.064 kg and Defence 0.23 / 0.14, Technique 0.12; Energy 93 / 94 / 90 / 84 |
| B2 | OPPWEIGHT1: opponent walk and trim, fog by tape | Qwen | scripts/rules/OppWeight.gd (~120), tests/opp_weight_test.gd | tape and 3D intro give one weight (red: two today) |
| B3 | WALKWEIGHT1: `walk` in the save, Hold drifts back, the clamp replaced | Claude | Data.gd, ClubStart.gd, Sim.gd (net <= 0, at 499), SaveGame.gd | Hold from 65.9 reaches 66.4 in 12 days for a 66.8 walk (red: flat) |
| B4 | DIETS1: Lean; Cut as the Monday answer with its -1 Energy a day | Qwen | WeekPlan.gd (+~25), WeekCoach.gd | a Lean day loses 0.03 kg (red: no Lean) |
| B5 | WEIGHDAY1: the hour, amateurs on the day, zero allowance, sweat-off, the walkover loss through the loss path, the Monday answers, the past-cap need | Claude | scripts/state/WeighDay.gd (~240), Bouts.gd (net <= 0), Needs.gd (+~10) | an amateur miss writes a loss and -12 morale (red: none) |
| B6 | NIGHTENERGY1: the Energy sum into BoutNight for both sides; the Why line | Arena | BoutNight.gd (:306, net <= +6), WhyCard.gd (+~20), tests/night_energy_test.gd | a trim of 1.0 starts at 85 (red: 100); the opponent's trim lowers hers |
| B7 | EATASK1: the weekend ask (reason, rate from PushBack), the three answers with the standing answer, "eats anyway", meal prep | Qwen | scripts/rules/EatAsk.gd (~160), tests/eat_ask_test.gd | discipline 34 / coachability 52 asks 35-43 in 100 weekends over 1,000 seeds, discipline 64 never (red: no ask) |
| B8 | CLASSES1: classes within reach | Claude | scripts/state/Classes.gd (~180) | Josh's card offers 75; Samira's none |
| B9 | WEIGHTPANEL1: M1 | Cursor (or Grok Dev) | scripts/ui/WeightPlan.gd (~380), BurnStrip.gd (~140), EnergyCurve.gd (~200), FightPrep.gd sub-tabs (+~30) | the panel's numbers equal WeightRules'; a pace pick writes f.round_pace; a picked morning writes f.week_edits |
| B10 | BODYCLASS1: M2 | Cursor | scripts/ui/BodyClass.gd (~300); FighterPage.gd (net <= +3) | the tab shows; the ask rate changes with the nutritionist |
| B11 | WEIGHTSHOW1: M3-M17 small edits | Cursor | the files in section 8, each under 30 lines | every menu shows its line in the .exe |
| B12 | WEIGHTGOLDEN1: offer -> burn Sat -> Half a plate -> the ask comes -> Monday answer -> scale on the day -> Energy 90 -> the window in the Why; second run: No -> eats anyway -> past the cap -> Go to the scale -> walkover loss; third: Kira shows no ask and a different best set of mornings | Grok Dev | tests/weight_golden_test.gd | red until B0-B11 land |
| B13 | John: TO SOURCE (club-show weigh-in hour, meal prep and nutritionist prices, no-gi scale rule) | John | ops/research/WEIGHT_SOURCES_S439.md | - |
Order: B0 first (it changes every fight number), AMATEURWEEK1 (S428) with B5.

Probes before the board (headless tools/ scripts on the PC, after B0):
- P10: the win chance a point of start Energy (the 0.4 ESTIMATE): 400 bouts a cell, starts 100 / 90 / 80 / 70.
- P14: across the four starters x three cash levels x goal due / not due x 300 seeds, no burn-morning set and no ask answer is best
  in more than 60 in 100 cases.
- P15: the best and worst sensible plans differ by 3+ in 100 in 60 of 100 bouts; if not, the screen leads with the tails.
- P16: Save R1 + the worst plan does not beat Steady + the best plan in more than 1 bout in 3 (after B0).
- P17: Flat on the night (trust 0.85) against Steady, in win chance (the -2 ESTIMATE).
- P18: the window's count against the "when she tires" line's fires in 400 bouts (the replay is the forecast; this checks it).

## 10. Rejected, and why

| Rejected | Why |
|---|---|
| Diet rows with one answer column | the pick read off one cell (round-2 critics) |
| A fixed "4 slip-rope mornings" roadwork row | not the coach's week (WeekPhase); the price was a drawing choice |
| Meal prep at $120 | a cash lookup at any healthy runway |
| A slip as a dice roll bought down with cash | the game already has asks with mood prices; the slip is now her ask |
| Standing order "Switch / Ask me" | Switch won every case |
| A priced Watch tape 2 | the Tape Room plays it free |
| Gym weigh-in Saturday | a second mood lever beside the "No" answer |
| Energy lines 20, 40, 55 on the curve | 20 is 3D-only; 40 reads the round's start; 55 is Push only (said on its card) |
| Burn mornings in the fight week | the coach's taper is for fresh legs; the code has no price for its fatigue without a camp, so it would be free |
| The other corner's walk and eat-back | nothing to act on |

## 11. Open for the owner (scope only)
- Women's 70 kg and men's 65 kg (World Boxing classes): without them D7 is a decision for few fighters.

## 12. Risks
- B0 changes every fight number: Save is used by the corner and the fight balance (59 / 45 / 41) must be re-measured.
- The win differences between plans are 1-2 in 100, inside the band; P15 decides whether the screen leads with the win chance or
  with the tails (Flat on the night, the goal, the cash, a walkover).
- The trim prices, the 0.4-a-point rate, the ask's kg and "eats anyway" are ESTIMATES (REAL.md 2b: no measured link between kg
  regained and winning).
- Opponent Energy under 100 (B6) changes the window from 0-2 (today, Kayleigh at 100) to 3-6: without B6 the window, and so D4 and
  D5's link to weight, is mostly empty. B6 is not optional.
- A walkover from a dice roll feels unfair: B5's test: no walkover without the past-cap need shown first, unless the slip came in
  the last 3 days.
- Sim.gd is at 499 lines (B3 net <= 0). Cursor was out of usage in S438: B9-B11 may go to another seat.

## 13. The critics, clarity round 3
Not yet scored. Brief: CRITIC_PACK.md + CRITIC_ACCESS.md first, then this map and `docs/mockups/s439/weight/screen_r3.png`.

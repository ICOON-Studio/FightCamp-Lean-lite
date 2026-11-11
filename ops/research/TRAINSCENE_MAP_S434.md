# TRAINSCENE1: Training as its own scene, and a summary on the fighter's Training tab (design map, S434)

Roadmap row TRAINSCENE1 (after FOUNDATION). Author: Claude. Status: final drawing, for the owner's eyes. It adds NO rule: every
element shows a decided rule or code. TR = `TRAINING_MAP_S432.md` v6.1 (critics 7, 7 on depth), CL = `CORE_LOOP_MAP_S432.md`,
CW = `CLUBWEEK_MAP_V41_S432.md`, PB = `PLAYBOOK_MAP_S432.md`, BRIEF = `docs/mockups/s434/train/BRIEF.md`.
Tags: CODE (in the game today), MAP (decided, not built), UI (a screen decision of this page: where a thing sits and what it is
called, never what it does).

THE DRAWINGS (1920x1080, rendered with tools/render_mockup.py; every animation and the hover work in the HTML):
- `docs/mockups/s434/train/final_scene.png` (`final_scene.html`): the scene with a bout booked; the preview dock open on Monday's
  pads, playing the Check hook (the move Samira learns).
- `docs/mockups/s434/train/final_scene_nobout.png` (`final_scene_nobout.html` = `final_scene.html#nobout`): the same week with no
  bout booked; the dock idle (the fighter's picture).
- `docs/mockups/s434/train/final_summary.png` (`final_summary.html`): the fighter's Training tab, no bout booked; the dock open on
  Wednesday's roadwork (a session Samira does).
- Shared: `final.css` (the matched dark gym look, sport-sim panels), `final_dock.js` (the preview dock, count-ups, the no-bout swap).

## 1. The owner's words, and the one answer to each
| He said (S434 unless marked) | The answer on screen |
|---|---|
| "too much room for a simple slider and headline weekload" | THE LOAD is one slim bar: four stops, the headline beside it, each stop's price in two short lines. 100 px tall, was a 4-card panel |
| "i dont understand any of this" (the abilities table) | The table is gone. WHAT THE RING GETS: three lines, each "ability now -> next, what it does in the ring" |
| "whatif the re is no fight booked, what is displayed there?" | The season target takes the bout's place everywhere (section 5); both pages drawn |
| "what exactly happens when he changes or sets the program?" | YOUR CHANGE, bottom centre: the change as cause and effect in one line, with an X to undo it; the three sums move |
| "where is he learning the moves and the combos?" | EVENINGS: THE PADS, titled "where moves and combinations are learned"; THE HAND beside it with "+ Build a combination" |
| "what kind of training is this?" | Coach's line opens with the kind of week: "BASE WEEK · building the body", and the road shows BASE -> FIGHT WEEK -> BOUT -> REST |
| "the training should be seperate on a different scene ... and here only display a sumamry" | Training is its own scene; the fighter's Training tab is five lines and one gold OPEN TRAINING button |
| "like when i hover the mouse over the training program i can see the move he learns or hiting the quickbag without this being annoying" | THE PREVIEW DOCK (section 3): rest the mouse on any session or move card and the fighter's own frame plays it, beside the cards, never over them |
| "i expect a bit animation or visual effects and graphics ... more like sport simulator" | Chamfered broadcast panels, cards dealt in one by one, gauges that fill, numbers that count up, a light sweep on the titles, the changed card pulsing gold, the change line sliding in, the clip's push-in and bob |
| S354 "when picking up the morning exercises it has to sum up gains/loses towards a goal" | Each morning card shows its gain ("+0.3 Stamina", GOAL tag); the GOAL bar is built from those mornings, one coloured piece each |
| S370 "how we make the player feel the goal" | The goal is the first sum, big: "62 -> 63, MET (close struck through), by Fri 13 Mar", and the goal ring on the tab |
| S370 "moves and strikes as cards" | Pad nights and THE HAND are cards with the move's picture, its tier bar and the date it climbs |

## 2. The scene in plain words (top to bottom, left to right)
LEFT COLUMN
- TRAINING and the four fighters' faces. A dot on each face: red = needs you, amber = one answer by Monday, green = set.
- THE FIGHTER'S FRAME = THE PREVIEW DOCK. Idle: the fighter's picture, name, weight class, record, "Age 18: grows faster" and the
  hint "Rest the mouse on a card: it plays here." On hover it plays the card (section 3).
- RIGHT HAND SORE (only when a niggle exists): two answers, each priced, Coach's pick outlined, "answer by Mon".
- LAST WEEK: "Stamina +1 · roadwork Mon, Fri"; it opens the Week review.

CENTRE
- COACH'S WEEK: Coach's face, the kind of week ("BASE WEEK · building the body"), and the week in one sentence: "Normal week.
  Stamina near 63 by Fri 13 Mar, most tired Thursday. The right hand rests. Next week is fight week." Beside it: TAKE COACH'S WEEK
  (gold) and "1 change of yours X" (pulses).
- THE THREE SUMS the mornings fill:
  - GOAL · STAMINA: 62 -> 63, MET (CLOSE struck through), goal 63 by Fri 13 Mar; the bar is made of the mornings that feed it
    (Wed blue, Sat gold = yours) and the next 3 weeks (hatched); a white mark at the goal.
  - WEIGHT · SCALE SAT 28: 65.9 -> 65.4 kg, MADE; limit 66.0 at 9 am (a club show weighs in the same day); a gauge with the red
    zone past the limit; three diet chips with what each leaves on the day: Hold 65.9 / Lean 65.4 / Cut 65.0.
  - FRESH AT THE FIRST BELL · SAT 28: 95 -> 94 of 100; the tiredness line day by day to the bell with the red 80 line and the peak
    ("peak 73 Thu").
- THE LOAD: "Normal · 82% of a usual week's work"; four stops EASY / NORMAL (Coach) / HARD / SHARPEN on a bar with a gold knob; under
  each stop its price ("goal close, fresh 95" / "goal met, fresh 94" / "Footwork 60, injury 2 in 100" / "fresh 97, nothing fades");
  RULES "3 of 4 on" (hover names the four).
- MORNINGS (build the body · click a card to swap its session): seven cards. Each: day, who runs it (You / Coach / Alone), the
  fighter doing it (or its icon), the session name, its gain ("+0.3 Footwork"), pace pips (1 Light, 2 Normal, 3 Hard), a GOAL tag
  when it feeds the goal, a lock on Coach's mornings (set on Club week), a gold pulsing frame on the player's change (Sat: YOURS).
- EVENINGS: THE PADS (where moves and combinations are learned · 3 pad places, set on Club week): seven cards under the seven
  mornings, so all fourteen sessions are visible. Mon pads with Coach: CHECK HOOK, its five-step bar, "Usable Mon 2 Mar", an amber
  "after the bout" tag. Wed pads, you, 2 places: HABIT FIX, "Half fixed Sat 28". Thu sparring with Lucy, locked: "every Usable card
  gets work". Other nights: Off, fresher.

RIGHT COLUMN
- NEXT BOUT · CLUB SHOW: Sat 28 Feb vs Kayleigh Bell, counter-puncher, 4-2; same-day scale 9 am, limit 66.0; 12 DAYS; the road:
  BASE now -> FIGHT WEEK 23 Feb -> BOUT Sat 28 -> REST 2 Mar.
- WHAT THE RING GETS vs Kayleigh: Footwork 57 -> 58 (Jab and move works better, Good at 62); Stamina 62 -> 63 (no tiring in
  round 3 from 64); Defence 51 (Hands up works better from 56).
- SAT 28: THIS WEEK BUYS: Fresh on the night 94 of 100; Stamina goal met (was close); Habit half fixed by Sat 28; Check hook Usable
  after the bout.
- THE HAND (drag a card onto a pad night): Jab Sharp 64, 1-2-3 Usable 38, Uppercut fading (red), Step back New; "+ BUILD A
  COMBINATION".

FOOTER: Back · Coach runs Samira · YOUR CHANGE (one line, X to undo) · Keep my changes next week · DONE (gold).

## 3. The preview dock (the owner's hover ask)
- WHAT: the Playbook's MoveTip card (CODE, `scripts/ui/MoveTip.gd`: one shared card, ~0.25 s hover intent, the move played live on a
  loop on the fighter's own body, hides when the mouse leaves) used for EVERY session, move and combination on both pages, and
  DOCKED in the fighter's own frame. Both critics drew it there on their own (their 10/10 pictures); it is the one place the card can
  never cover a card the player is about to click, nor the sum it explains.
- WHAT IT SHOWS: the clip (LIVE · SAMIRA, the fighter's body doing the session or move, a slow push-in and a small bob in the drawing),
  who and when ("MON EVENING · PADS WITH COACH · 75 MIN"), the name, for a move its five-step bar and tier ("Learning 24 · Usable at
  30"), then at most four short rows: BUILDS (what it adds: "Learning 24 -> 27 this week. Usable on Mon 2 Mar"), COSTS ("1 of 3 pad
  places · tiredness +6"), WHY ("A lead hook while pivoting out: catches a counter-puncher stepping in"), and the other load ("ON
  HARD: Footwork +0.45").
- THE SAME DOCK EXPLAINS WORDS AND NUMBERS: rest on the goal, the weight, Fresh at the first bell, a load stop, RULES, the road, a
  fighter's dot or "Coach runs Samira" and the dock shows a compact card (icon, no clip) saying what it is and does. One place for
  every explanation; nothing floats.
- NOT ANNOYING (all in the HTML): opens after 250 ms of rest; while open, the next card swaps at once (no second wait, no flicker);
  leave every card for 300 ms and the fighter's picture comes back; it never follows the cursor; one at a time; no sound; it never
  opens while dragging a card (build); keyboard focus does the same (build); Settings can switch it off (build).
- PICTURES: the game's own session pictures (`assets/ui/training/mh_boxer_20_<session>.png`, TRAINCLIPS1) and move pictures
  (`assets/ui/moves/<id>.png`; Check hook uses lead_hook.png as ExchangeBeats.READ_MOVE does). Footwork drills, strength circuit,
  intervals and rest have no picture yet: an icon. In the game the clip is MoveTip's live player (MovePlayer on the fighter's body);
  sessions need the same (TRS1 below).

## 4. The fighter's Training tab: the summary
Five lines and one button, beside the fighter's big picture (which is the same preview dock):
| Line | On screen (no bout booked) | Rule / code |
|---|---|---|
| Coach's week | "No bout yet, so we build. Normal week: Stamina near 63 by Fri 13 Mar. The right hand rests." + the "Coach runs Samira" switch | TR T35, T1, C20 |
| 1 This week | BASE WEEK · NORMAL, "building the body · 82% of a usual week's work", seven day pictures (GOAL tags; Sat gold = yours); each plays in the dock | TR T35, T1, T3 |
| 2 The goal | a ring 63, "STAMINA 62 -> 63 MET (close struck)", "by Fri 13 Mar · your Saturday intervals made it · met: mood +10" | FighterGoal (CODE), TR T25 |
| 3 On the pads | the Check hook picture, "Learning 24 -> Usable Mon 2 Mar", the five-step bar with its words, "+2 more: habit fix, sparring" | PadWeek, MoveMastery (CODE) |
| 4 Next | "NO BOUT BOOKED · TARGET: THE NATIONALS", "entries close Sun 15 Mar · next offers Mon 23 Feb · 2 bouts to go", "tiredness peaks 73 on Thu, under 80", 27 DAYS TO ENTRIES | CW 3.9, SeasonPath (CODE), TR T14 |
| 5 Last week | "STAMINA +1 from roadwork Mon, Fri", Week review > | WeekCause (CODE), TR T20 |
| Alert (only when one exists) | RIGHT HAND SORE: "Coach rests it · answer by Monday: rest it or push on" | TR T19 |
| ONE BUTTON | OPEN TRAINING: "the week, the load, the pads" | UI |
With a bout booked, line 4 reads "NEXT BOUT · CLUB SHOW · SAT 28 FEB vs Kayleigh Bell · fresh 94 at the first bell · 12 DAYS".
WEEK 1 (TR 11.5 reveal order, not drawn): lines 1 and 3 and the button; the goal ring once a goal is set; Next with the first
sheet; Last week from the first Monday; the dock's hint line shows only in the first two weeks.

## 5. No bout booked (both pages)
| Panel | With a bout | No bout booked | Rule / code |
|---|---|---|---|
| Right column head | NEXT BOUT · CLUB SHOW, the date, the opponent, the scale, 12 DAYS | NO BOUT BOOKED · TARGET, THE NATIONALS, entries close Sun 15 Mar, next offers Mon 23 Feb · 2 bouts to go, 27 DAYS | CW 3.9, SeasonPath (CODE) |
| The road | BASE now -> FIGHT WEEK 23 Feb -> BOUT Sat 28 -> REST 2 Mar | BASE now -> BASE 23 Feb -> FOR THE TARGET 2 Mar -> FOR THE TARGET 9 Mar | TR T35 (Coach's default BASE 5+ weeks off), T9 |
| Coach's line | "... Next week is fight week." | "No bout yet, so we build. ..." | TR T35 |
| Third sum | FRESH AT THE FIRST BELL 95 -> 94 | TIREDNESS · NO BOUT, peak 73 Thu, FRESH BY THU | TR T14 (the Tank on bout days only) |
| Weight | SCALE SAT 28, 65.9 -> 65.4, MADE | NO SCALE YET, LIMIT 66, 65.9 -> 65.4 by Sun 1 Mar | TR T8 |
| What the ring gets | vs Kayleigh (what she tests) | for the nationals (the season target's pull) | TR T18, CW 3.2 |
| What this week buys | SAT 28: THIS WEEK BUYS (fresh, goal, habit, after-the-bout card) | SUN 15 MAR: THIS BLOCK BUYS (goal met, Fast hands at Speed 70 about 4 weeks, habit gone by 2 Mar, Check hook Usable 2 Mar) | TR T23, T30 |
| Pad tags | "after the bout" on a date past the bout | none | TR T2 |
| Change line | "... fresh 95 -> 94" | "... peak tiredness 73, under 80" | TR T24 |
| Top bar | CONTINUE to Mon 23 Feb, fight week | CONTINUE to Mon 23 Feb | UI |

## 6. What a change shows
Every change runs the week again with it and prints the difference in ONE line at the bottom, in the change's colour, at most three
terms: what changed ("Sat: Shadow -> Intervals"), then in this order the goal's band, the aim's points by the target, injury in 100,
fresh at the first bell, the weight on the scale day, a card's next date. An X undoes it. The three sums move to the new values (the
bars tween), the changed card keeps a gold pulsing frame and a YOURS tag, and "1 change of yours X" counts it at the top. Hovering a
load stop shows its price before the click (TR T1's three numbers; in the build the sums ghost to the new values while the mouse
rests there). TR T24 one run (TrainWeek.run, ONERUN1), T1, C13.

## 7. Where moves and combinations are learned
- On the PADS, in the evenings. Each pad place holds one card: a move, a book combination, an own combination or a habit fix
  (PadWeek CODE). The card shows the move's picture, the five-step bar New > Learning > Usable 30 > Sharp 60 > Signature 85
  (MoveMastery.LADDER, CODE), and the day it climbs, with "after the bout" when that day is past the bout.
- THE HAND holds every move and combination the fighter has, with its tier; a fading one is red. Drag a card onto a pad night; the
  card it pushes off is priced in the change line (TR T10 KEEP-IT).
- "+ BUILD A COMBINATION" opens the combination builder (ComboBuilder / ComboStrip / ComboFlow / ComboOdds, CODE) on Playbook >
  Combos: stitch move cards, see its strength and the gas it costs, Save, then "Drill it" puts it on the next free pad place and
  comes back here with its change line (PB 4.6, 4.9). Combinations have ONE home (the coach critic's point); the Training scene
  never carries a second bench. (This replaces the BRIEF's E2 "bench in the scene".)
- Sparring trains every card already Usable (PadWeek, CODE).

## 8. Every element and the rule or code it shows
| Element | What it reads | Built? |
|---|---|---|
| Fighter faces with a dot | RosterFlag.pick (needs), the niggle's answer-by | CODE + UI |
| Preview dock | MoveTip.info / MoveTipInfo, MovePlayer; session pictures (TRAINCLIPS1) | CODE (moves), NEW for sessions and words |
| Coach's week sentence, TAKE COACH'S WEEK | WeekPlan.COACH_WEEK / Coach's deal (C20), TR T35 block word, the run's peak day | CODE + MAP |
| "1 change of yours X" | the cells that differ from Coach's deal (TR T10-13) | MAP |
| GOAL sum | FighterGoal (CODE), TR T25 bands (GOALBAND1), WeekPlan.project (CODE), the mornings' Stamina doses (MORNINGS1) | CODE + MAP |
| WEIGHT sum | Diet kcal (CODE), TR T8 (Lean NEW, Cut x0.9), the weigh-in's hour (same day for a club show) | CODE + MAP |
| FRESH AT THE FIRST BELL | BoutRules.tank (TR F5, T14: 0.3 a point 20-50, 2 a point over 50, weight left, last bout); WeekPlan.week tiredness, the 80 line (CODE) | MAP (F5) |
| THE LOAD | TR T1 four loads and their three numbers, WeekPlan INTENSITY, the Hard aim (T1 default aim), PushBack's ask (CODE) | CODE + MAP |
| RULES 3 of 4 | MorningRules (TR T37) | MAP |
| Morning cards | WeekPlan.SESSIONS (CODE), Attrs shares (MORNINGS1), CoachAreas who + lift (CODE), Club week locks (CW 3.1) | CODE + MAP |
| Evening cards | PadWeek.run_week / project, MoveMastery, HabitFix, SparNights (CODE); pad places from Club week (CW 3.1) | CODE |
| The road | SeasonPath (CODE), SeasonStrip blocks (TR T9, T35) | CODE + MAP |
| What the ring gets | TR T17 lines (Exchanges.grade after F10, PerkRoad), OppTests (TR T18) | partly CODE |
| This week buys | TR T23 (readiness, the goal, HabitWork, after-the-bout cards) | MAP |
| THE HAND | MoveBook, OwnCombos, MoveMastery.decay_week (fading) | CODE |
| Build a combination | ComboBuilder, ComboStrip, ComboFlow, ComboOdds, PlanCards.drill_it | CODE |
| Niggle card | Niggle, TrainAround (TR T19), InjuryRoll (CODE) | MAP |
| Last week | WeekCause.words, WeekRead.cause | CODE |
| YOUR CHANGE line | TrainWeek.run diff (TR T24, ONERUN1) | MAP |
| Coach runs Samira | Coach's deal every Monday with Coach's rules (C20, TR T11) | MAP |
| Keep my changes next week | TR T13 | MAP |
| No-bout swap | SeasonPath, CW 3.9 season target, CW 3.2 pulls | CODE + MAP |

## 9. Every menu this touches, and what each is wired to (the S425 rule)
| Menu | What it shows of training | Wired to |
|---|---|---|
| Training scene (NEW, `scenes/areas/TrainingScene.tscn`) | everything in section 2 | the reads in section 8, through TrainWeek.run |
| Fighter page > Training tab | the five lines, the alert, OPEN TRAINING, the dock | the same reads, one line each |
| Fighter page > Profile | the goal ring (same goal); the 14 abilities with ceilings ("Show all" from WHAT THE RING GETS opens here); "Plan the week" opens the scene | FighterGoal, AttrBoard |
| Fighter page > Condition | the tiredness curve with the 80 line, fresh at the first bell on the next bout day | WeekTired, BoutRules.tank |
| Fighter page > Playbook | the record of moves and combinations; ON THE PADS / ON THE MORNINGS open the scene with that card placed; Combos is where combinations are built | PlanCards.drill_it, ComboBuilder |
| Fighters > Club week | the load chip (opens the scene on that fighter), pad places and coached mornings dealt (the scene's locks point here) | ClubDeal, PadWeek |
| Fighters page (the squad) | the dot per fighter (needs you / one answer / set), "COACH SAYS, THIS WEEK" and the goal ring | RosterFlag, FighterGoal |
| Week review (Monday) | "Last week" opens it: each whole point with its cause, rules fired, the goal's band | WeekReview, WeekCause |
| Bout sheet / the bill | fresh at the first bell for both corners, the weigh-in's hour | BoutSheet, BoutRules.tank |
| The Why after a bout | "Train X" / "Rest the hand" open the scene with that change already set | FightWhy, WhyCard |
| Settings | "Preview on hover" on/off | NEW (one flag) |
GOLDEN PATH (one test, TRS9): the tab -> OPEN TRAINING -> rest on Monday's pads (the dock shows Check hook) -> the load to Hard (the
change line names Footwork and injury) -> back to Normal -> Saturday swapped to intervals (the goal band moves close -> met) -> the
uppercut dragged onto a pad night (its date shows) -> Build a combination -> Drill it -> back in the scene with its pad place -> DONE
-> the tab's lines changed. Then the same walk with no bout booked (the target, tiredness in place of fresh).

## 10. What of today's Training tab (`docs/mockups/s432/trainingb2_23e_real.png`) is cut, moved or kept
| Today | Fate | Goes to |
|---|---|---|
| THIS WEEK'S LOAD, four big cards (his mark 1) | CUT to a slim bar | THE LOAD; work, clock hours, "usual 92 · safe to 120" one hover away |
| ABILITIES table: worth dots, "tests x1.3", room bars, fast/slow, next line, 4 wks, kept by (his marks 2-3) | CUT | three lines in WHAT THE RING GETS; the 14 with ceilings on Profile; "fades <date>" only on a fading card |
| Week grid cells "+48%", "x0.8", "weak spot" | MOVED | the dock (who runs it, and "alone, gains 20% smaller") |
| PAD PLACES, small rows | KEPT and promoted | EVENINGS: THE PADS as cards, under their days |
| BODY niggle panel | KEPT only when one exists | the niggle card; the tab's alert |
| WHAT THIS WEEK BUYS | KEPT, four lines | right column |
| TO THE BELL chart | KEPT small | inside FRESH AT THE FIRST BELL; the long curve on Condition |
| WEIGHT panel | KEPT as a sum | WEIGHT with the three diets priced |
| The season strip | KEPT as a 4-step road | right column |
| Morning rules toggles | FOLDED | RULES 3 of 4 (the dock names the four) |
| Five footer buttons | CUT to Back, Coach runs Samira, DONE and one switch | footer |
| The combination bench inside Training (BRIEF E2) | NOT BUILT HERE | Playbook > Combos (one home); "+ Build a combination" opens it |
| "Season so far", the colour key | MOVED | Week review; the dock |

## 11. Screen words decided here (UI; the code keeps its own names)
| Thing | On screen | Why |
|---|---|---|
| The ability | Stamina | the game's label (Attrs.LABEL). "Cardio" is the owner's word for the body GROUP (Stamina, Recovery, Heart) on Profile (S431 C290). The C drawing's "Cardio" for the ability was wrong |
| The Tank | FRESH AT THE FIRST BELL, "94 of 100" | both critics could not read "Tank"; the dock says what it does |
| The week's load | Easy / Normal / Hard / Sharpen | TR T1 (decided). A session's pace stays Light / Normal / Hard (WeekPlan INTENSITY). Sharpen always shows its effect ("fresh 97, nothing fades") |
| The blocks | BASE, FOR THE TARGET (SPECIFIC), FIGHT WEEK, REST | TR T9, T35 and BRIEF A. Never "deload", "engine" or "PEAK" for an amateur |
| Move tiers | New, Learning, Usable, Sharp, Signature | MoveMastery.WORDS (owner S429: "What raw means?") |
| Who runs a session | You / Coach / Alone, as a word on the card | was a colour stripe nobody could read |
| Injury | "injury 2 in 100" | a lone number needs its unit (S429) |
| Record | 2-1 everywhere | the matched look (`s431/final/build.py`) |
| Diets | Hold / Lean / Cut | TR T8 (Lean is decided, NEW) |

## 12. The critics (blind, S434), their scores, and what was done with each to-10 item
| Approach | Player critic (clarity / depth / look) | Coach critic (clarity / depth / look) |
|---|---|---|
| A goal-led (`a_goal_*`) | 6 / 6 / 7 | 6 / 7 / 7 |
| B cards (`b_cards_*`) | 5 / 8 / 7 | 5 / 8 / 7 |
| C coach-led (`c_coach_*`) | 7 / 7 / 8 | 8 / 8 / 8 |
Both critics: best = C. The final is C, with B's weight choices and move cards, A's goal-made-of-mornings bar, and the critics' 10/10s
(`critic_player_10.png`, `critic_coach_10.png`) for the dock and the day columns.

PLAYER CRITIC'S LIST TO 10
| # | Ask | Done |
|---|---|---|
| 1 | Preview in a fixed dock, 250 ms, back after 400 ms, keyboard, Settings off | TAKEN (300 ms; keyboard and Settings in TRS1) |
| 2 | One word per concept; Tank -> fresh of 100; drop safe 107 / work 75 / rules 3 of 4 unless hovered | TAKEN, except Stamina vs Cardio (section 11) and RULES kept with its hover |
| 3 | Fix contradictions: phase, one record, weight on this bout, Hold/Cut only | TAKEN; the phase is BASE then FIGHT WEEK (decided for amateurs, now shown on the road); Lean kept (TR T8) |
| 4 | A "This week does" strip of stat tiles | PARTLY: each card carries its gain; the sums and WHAT THE RING GETS carry the rest (no extra panel: his mark 1) |
| 5 | Each load priced before pressing; hover ghosts the values | TAKEN (prices on the stops; ghosting in the build) |
| 6 | Day cards: picture, name, pips, stat +gain, GOAL and YOURS tags, no sentence | TAKEN |
| 7 | Evenings: picture, 5-step bar, date; THE HAND with tiers, fading red; bench numbers in the builder | TAKEN |
| 8 | Choices as one card, two priced answers, Coach's pick outlined | TAKEN |
| 9 | State dots on the fighter switcher | TAKEN |
| 10 | Draw the no-bout scene | TAKEN (`final_scene_nobout.png`) |
| 11 | Session loops on the same fighter as the portrait | PARTLY: the pictures are the game's own per-fighter set (TRAINCLIPS1); the live loop is TRS1 |
| 12 | No designer notes on screen | TAKEN (one player hint in the first two weeks only) |

COACH CRITIC'S LIST TO 10
| # | Ask | Done |
|---|---|---|
| 1 | PEAK week 12 days out, game phase words only | NOT TAKEN: PEAK is the professional camp (TR T33). An amateur bout needs no camp (S428): BASE, then one FIGHT WEEK (TR T35). The road and Coach's line now say so |
| 2 | Weight on the booked bout's scale, both diets priced | TAKEN (same-day club scale; Hold / Lean / Cut each priced) |
| 3 | Drop Tank; tiredness line with the 80 line, peak day, fight-night number | TAKEN |
| 4 | Load priced in game numbers; Light/Normal/Hard; drop Sharpen; name the rules | PARTLY: prices in goal band, fresh and injury in 100 (the % stays as the headline, TR T1); Sharpen kept (decided); rules named in the dock |
| 5 | MoveTip in one fixed place, 0.25 s then instant swap, 300 ms back, never while dragging, Settings off | TAKEN |
| 6 | Preview says BUILDS / COSTS / other loads | TAKEN |
| 7 | A column per day, morning above evening, all 14 visible; pad split bar; partner and cost | TAKEN for the columns; the 75-minute split and a partner's cost live on Club week |
| 8 | Cardio everywhere; Raw | NOT TAKEN: Stamina is the game's word, Learning replaced Raw on the owner's ask (section 11) |
| 9 | The hand choice with two priced answers, answer by | TAKEN |
| 10 | THE HAND drill cards only; Build a combination opens Playbook > Combos; no second bench | TAKEN |
| 11 | Change line as cause and effect, X, Keep my change | TAKEN |
| 12 | One set of facts across both tabs in the no-bout case | TAKEN: the tab and the no-bout scene are the same week |
| 13 | No designer notes | TAKEN |
| 14 | Coach's pad nights row when two fighters share a camp | LATER: it belongs to Club week (CW 3.1) |

THE CRITICS' UNCLEAR WORDS: every one on their lists is gone from the face of the screen or explained in the dock. Gone: safe 107,
work 75 / usual 92, Tank, deload, engine, hand day, alone x0.8, "stripe; gold you", fires 1 in 2, Lands whole, Gas 7%, smooth / a
beat late, LIVE without a subject (now "LIVE · SAMIRA"), the colour key, Condition/Character/Crowd questions (outside this page).
Kept with a hover: 82% of a usual week's work, RULES 3 of 4, Sharpen, Age 18: grows faster, met: mood +10, Fresh 94 of 100.

## 13. Build tasks (one owner each, every file under 500 lines; nothing starts before FOUNDATION and TrainWeek.run, CL 4)
| ID | Owner | What | Files (new unless marked) | Test (golden-path step) |
|---|---|---|---|---|
| TRS1 | Cursor | The preview dock: MoveTip's card docked in a frame; attach(control, item) for sessions, moves, combinations and word cards; 250 ms, instant swap, 300 ms back, not while dragging, keyboard focus, the Settings flag; a session plays its picture with push-in until its live clip exists | `scripts/ui/PreviewDock.gd` (~220), `MoveTipInfo.gd` (edit, +40 for session rows) | `tests/preview_dock_test.gd`: rest 0.25 s opens, the next card swaps in one frame, 0.3 s off returns idle, drag never opens |
| TRS2 | Qwen | The change line: from two runs pick at most three terms in TR T24's order, with the cause | `scripts/rules/ChangeLine.gd` (~120) | `tests/change_line_test.gd`: Sat shadow -> intervals gives "goal close -> met · fresh 95 -> 94" |
| TRS3 | Qwen | Bout or target: the facts the scene shows with and without a bout (head, road, third sum, buys title, ring sort) | `scripts/rules/TrainTarget.gd` (~150) | `tests/train_target_test.gd`: no bout -> the nationals, 27 days, road BASE BASE TARGET TARGET |
| TRS4 | Cursor | The scene shell: header, Coach's week, right column, footer, the no-bout swap | `scenes/areas/TrainingScene.tscn`, `scripts/ui/areas/TrainingScene.gd` (~300) | golden step: OPEN TRAINING lands here with the fighter selected |
| TRS5 | Cursor | The three sums and the load bar, tweened | `scripts/ui/TrainSums.gd` (~260), `scripts/ui/LoadBar.gd` (~160) | golden step: Hard prints its price; the goal band moves on the Sat swap |
| TRS6 | Cursor | The lanes: seven morning and seven evening cards under their days, THE HAND, drag to a pad night; split today's `WeekCards.gd` (552 lines, over the rule) into `DayCard.gd` and `PadCard.gd` | `scripts/ui/WeekLanes.gd` (~280), `DayCard.gd` (~150), `PadCard.gd` (~170) | golden step: the uppercut dragged onto a pad night shows its date |
| TRS7 | Cursor | The Training tab summary: five lines, the alert, OPEN TRAINING, the dock in the hero | `scripts/ui/TrainTab.gd` (~220), `FighterPage.gd` (edit) | golden step: DONE returns to a changed tab |
| TRS8 | Cursor | Build a combination round trip: Playbook > Combos opened from the scene, Drill it returns with the card placed | `PlanCards.gd` / `ComboBuilder.gd` (edits, +40) | golden step: a built combination sits on a pad place |
| TRS9 | Grok Dev | The golden path, both cases (section 9) | `tests/trainscene_golden_test.gd` (~200) | the whole walk, bout and no bout |
| TRS10 | Ziva | Session clips: the eight sessions as short loops on each fighter's body, and the four without a picture (footwork drills, strength circuit, intervals, rest) | assets via TRAINCLIPS1's route | the dock plays a clip, never a still, for every session |
Order: TRS2, TRS3 (pure, cloud) -> TRS1 -> TRS4, TRS5, TRS6 -> TRS7, TRS8 -> TRS9; TRS10 runs beside them (animation item).

## 14. Said plainly
- Every number on the drawings is Samira's hand-worked TR v6.1 example (TR section 9), or a reasonable fill where the map has none:
  the per-session gains (+0.2 Defence ...), the tiredness per day after the Saturday change, 65.4 kg on Lean, limit 66.0, Fast hands
  "about 4 weeks", habit gone by 2 Mar. The built page reads every number from the run (TR T24), never from this page.
- The live loop on the fighter's body exists for moves (MoveTip). For sessions the game has still pictures for eight of twelve:
  until TRS10 lands the dock shows the picture with a push-in, which is what the drawing shows.
- Two choices here go against one critic each, on purpose: Stamina (not Cardio) and BASE then FIGHT WEEK (not PEAK). Both follow
  the game's code and the owner's own rulings (S429, S431, S428).
- The bench moved out of the scene (BRIEF E2) to Playbook > Combos: one home for combinations, as both critics asked.

## 15. v2 (his marks)
His marks on `final_scene.png` (board feedback `ops/Feedback/2026-11-11-14/marked.png`), then two fresh critics on the first v2
(newplayer clarity 6 / depth 7 / look 7; coach 6 / 7 / 7). Both said marks 1-5 and 7 fixed, mark 6 only half. This round fixes
mark 6 and the words they could not read. Drawings (saved over v2): `docs/mockups/s434/train/v2_scene.png` (bout booked, the dock
open on Monday's pads) and `v2_summary.png` (the Training tab, the SAME week, bout booked; `v2_summary.html#nobout` and
`v2_scene.html#nobout` swap to the no-bout case). Shared: `v2.css`, `v2_dock.js`.

THE ONE VOCABULARY (both pages; a legend line says it once, one colour each)
| Word | Means | Colour | Replaces |
|---|---|---|---|
| STAMINA | the fitness stat the mornings build; the goal (62.4 -> 63.1) | gold | "Cardio" (never on these pages) |
| FATIGUE | 0-100, how worn out she is: the day's cards add, each night's sleep takes 10 off, a rest day 6 more; red mark 80 = overworked (gains x0.6, injury risk x3) | orange | "tiredness", "fresher" |
| ENERGY | 0-100 fuel at the first bell; every 10 Fatigue over 20 on the night = -3, a same-morning weigh-in = -2 | green | "fresh", "Tank", "fresh at the first bell" |
Also: weight is blue (kg); a session's owner is one word on the card (You run it / Coach + lock / Alone -20% / Rest) and a
pencil "Changed" marks your change; move tiers are MoveMastery.WORDS (New, Learning, Usable 30, Sharp 60, Signature 85; a
slipping move is "Sharp 61" with a red arrow, never a sixth word "Fading"); the fighter page tabs are Routes.gd's (Overview,
Training = today's Week tab, Fight prep, Playbook, History).

| # | His mark | What changed |
|---|---|---|
| 1 | "THE HAND drag a card onto a pad night": "what is this for" | "YOUR MOVES - drag one onto a pad night to practise it"; each tier word is underlined and explains itself on hover (what it means, the ladder with its numbers) |
| 2 | "SAT 28: THIS WEEK BUYS": "you mean week gains ?" | "THIS WEEK'S GAINS, Mon 16 to Sun 22": only this week, every stat now -> Sun 22 with the card it comes from (Stamina 62.4 -> 62.8 Wed, Sat; Footwork 57.0 -> 57.3 Tue; ...), the habit by name, the new move, and the one loss (Explosiveness, if the hand rests). Fight-night numbers live in the Energy and Weight panels only |
| 3 | "tiredness": "fatigue" | Fatigue everywhere; the word "tiredness" is gone from both pages |
| 4 | "WHY": "use : What it does" | WHAT IT DOES / BUILDS / COSTS in the dock on both pages |
| 5 | the sore hand panel "can be designed a bit better" | A choice card: the problem in one line ("4 hand days in a row last week"), two big buttons, each with what it gives and its price in numbers: REST IT (Coach's pick) "the 3 glove cards go easy", price Explosiveness 61.0 -> 60.5; PUSH ON "as planned, Explosiveness holds", price "4 in 100 the hand goes: the bout is off, out 3 weeks". The three hand days carry a glove on their evening cards. Same words on the tab |
| 6 | weight: how is it lost, the end-of-week number, "stamina or energey (i am confused what we use" | WEIGHT leads with three numbers: today 65.9, END OF THIS WEEK 65.4 (Sun 22), the scale 65.1 (Sat 28, limit 66.0, "0.9 kg spare"); a day-by-day line (13 dots, day letters, this week / fight week); BURN MOST: Wed roadwork -0.2, Sat intervals -0.1; each diet with its scale number (Hold 65.5 "0.5 spare: risky", Lean 65.1 Coach's pick, Cut 64.6 "gains -10%"). Every card that takes weight off says its kg, so the cards add up to the panel. STAMINA: each morning card shows its Stamina gain where it has one (no "+0" lines), the week total sits on the lane header (Stamina +0.4, Fatigue +39, -0.3 kg). FATIGUE has its own line under the mornings: a 0-100 meter per day at bedtime (53 51 61 65 58 54 38) with the 80 mark, so the card sums and the peak agree. ENERGY is a number and its sum only (100, -3 for Fatigue 30 on the night, -2 same-morning weigh-in = 95; Coach's week 96), the rule printed once |
| 7 | the YOUR CHANGE bar: "not sure what that means where these numbers come from" | Three plain lines: what you changed ("Saturday: shadow boxing -> intervals. Every number here is on the Sat card"), the gains (Stamina +0.3 -> the goal is met, 63.1 by 13 Mar, Coach's week 62.8; 0.1 kg more off) and the costs (no Accuracy +0.1, Fatigue +3 more, still there on fight night: Energy 96 -> 95). One Undo, here only |

THE CRITICS' OTHER WORDS, and what was done
| They could not read | Now |
|---|---|
| THE LOAD in percentages (82%, 64%, 106%, 47%) | No percentages: each stop says what it is and its two results, under one header "goal · Fatigue peak": EASY all Light (close, 56), NORMAL Coach 1 Hard (met, 65), HARD on Footwork with a chooser (met, 76, injury 2 in 100), SHARPEN fight weeks (close, 50) |
| "RULES 3 of 4 on" | "SAFETY RULES 3 of 4 on", the four listed in the dock |
| "nothing fades" | gone |
| You / Yours, the lock, "You x2", GOAL badges, "+0 Stamina" | one owner word per card; lock explained on hover ("Coach's key session: change it on purpose"); Wed evening "2 places"; GOAL badges gone (the gold Stamina line does it); +0 lines gone |
| Fatigue numbers that did not add up | every card's Fatigue plus the night's -10 gives the bedtime line (Mon: 49 - 10 + 8 + 6 = 53) |
| Energy card drawing a Fatigue line | removed; Energy shows only its number and sum |
| Weight sum on this week only, 12-day horizon | split: this week to Sun 22 (65.4), fight week to Sat 28 (65.1); fight-week roadwork counted |
| Ring numbers that could not be reached by the bout (Stamina 63, Footwork 58) | WHAT THE RING GETS is merged into THIS WEEK'S GAINS with real decimals (62.8, 57.3) |
| The Coach's quote taking credit for your change | "My week: Stamina 62.8 by 13 Mar, close. Your Saturday makes it 63.1: met" |
| "Explosiveness slips a little" | 61.0 -> 60.5 by 9 Mar (Explosiveness and Recovery are Attrs.LABEL stats) |
| Who picks the sparring partner | Thu card "partner: Lucy" with a chooser; hover: Coach picks the closest in weight and style |
| "LIVE · SAMIRA" | "PREVIEW · SAMIRA" |
| "Coach runs Samira" button vs toggle | one toggle on both pages, "Coach plans her week", with its meaning (every Monday; your changes stay); beside it "Keep my changes" |
| Four commit controls, two Undos | TAKE COACH'S WEEK (puts every card back to his), one Undo (the change bar), DONE |
| "3 pad places, set on Club week" | "Samira has 3 of Coach's pad places this week" |
| Age 18 with the nationals (19-40) | Age 19: still growing |
| Tabs Condition / Character / Crowd | the fighter page's real tabs |
| Summary dieting to 1 Mar with no bout; "mood +10" | the summary now shows the same booked week (scale Sat 28: 65.1 kg, Energy 95); mood +10 lives in the goal's hover only |
| Same-day weigh-in vs the pack's "day before" | kept: amateur club shows weigh in the same morning; the pack line is the pro fight prep |

NOT TAKEN: Raw for Learning (MoveMastery.WORDS is Learning since S429); a ghost row of next week's cards (no room; the road and
the fight-week numbers cover it); stills labelled as cases (no designer words on a game screen: both pages now show one case).
Every number above is the worked example of this drawing; the build reads them from the week run (TR T24).

# FIGHTLINK3: from the build to the fight - map v3 (S432)

The operator's ask (S432): "do the same for the most important aspects of the game that affect the loop like building the fighter and the coach, playbook,
training and how these 2 impact fight, need reviewed them all and properly strenghen and add mechanics".
This map is the LINK: how the fighter you build (attributes, punches, traits, habits, perks, style) and the week you run (training, tiredness, pads,
sparring) become the result of a bout, what the player DECIDES before the bell and in the corner because of it, and how the player SEES which choice won
or lost it. It does not redesign its neighbours; it hooks into them (read for v3, not redesigned):
- the week and the fight week: `CLUBWEEK_MAP_V41_S432.md` (pad places, sparring pair and setting, THE LEGS, the bill's one number, the sheet, Coach's corner)
- training sessions, the habit card, the season strip: `TRAINING_MAP_S432.md` (T1 load, T4 sparring settings, T5 habits, T9 season, T10 FireLevel on)
- the plan: `PLAYBOOK_MAP_S432.md` (4.1 line grade, 4.3 line prices and ANSWERS, 4.4 IF READ, 4.5 rounds on lines and the ahead/behind read, 4.11 receipt)
- coach levels, Known, loyalty bands, marks, the ledger, build direction: `RPG_LAYER_MAP_S432.md` (sections 2, 3, 8, 9, 12, 13)
- the night's word (Entertain / Box smart / Safe): `HYPE_MAP_S432.md` section 4.4
Read for v3: CRITIC_PACK, CRITIC_ACCESS, the four critic reviews in `docs/mockups/s432/critics/` (fl_judge 5.5, fl_simdesign 6, fl2_trainer 6.5,
fl2_player 7), the RPG critic's towel (`rpg3_clubcoach_review.md`), and the code (LiveRound.exchange, RingDuel, Duels, Attrs, AttrGen, Exchanges,
Knockdowns, PlanFight, FireLevel, HabitFix, PerkFight, PaceAim, TheRead, CornerJobs, BoutRules, BoutNight, FightWhy, Sim._as_of, Data). Nothing was run.
TAGS on every effect: CODE = the rule exists and this map only changes or reads it (the hook named); WEEK = it lands on a club-week rule the CLUBWEEK or
TRAINING map designs (not built yet); NEW = a new rule in this map. ESTIMATE = a design value its probe sets before any screen shows it.
Drawing: `docs/mockups/s432/fightlink_v2.html` / `.png` (v3: the result page of a bout lost on a count, with the receipt, THE COUNT, the towel's minute,
the judges the coach knew, the bill against tonight, and who decides this fighter's fights).

## 0. What the v2 critics found, and the answer in v3
| Critic point (trainer 6.5, player 7) | Answer in v3 |
|---|---|
| Mostly a way to READ the fight, not new things to DECIDE before it (trainer) | Section 3 BEFORE THE BELL: nine decisions, each priced on the bill in the same unit as the receipt; three are new (matchup sparring, the towel line, which officials you know by the show you pick) |
| HOLE 1: amateur bouts read `BoutRules.stale_energy`, which is 0 with no camp, so a hard week costs nothing while NO_CAMP_EDGE taxes every exchange (trainer) | Defect 1 widened: THE LEGS (CLUBWEEK) replaces stale_energy on EVERY bout; NO_CAMP_EDGE leaves amateur bouts in the same task (NOCAMP1, 400 amateur bouts before and after) |
| HOLE 2: all four punches start below the opponent's (jab 51, straight 45, hooks 34, uppercut 1 against an opponent's 58), hidden (trainer) | Defect 5 widened: ONE PUNCH RULE for both corners (M8): the same start shares and raw floor for us and for opponents by their bouts; the strip shows every punch against its answer from the first offer |
| No target for how much the weeks should explain against the night and luck; the corner's 17 outweighs 5 points of training (trainer) | Section 2.2 THE TARGET, set before LEVERS1 runs: preparation 55-70 of every 100 exchanges turned, the night 20-30, luck 10-20; upsets 20-30 in 100; the knob for each miss named |
| A stoppage, the most painful result, gets no receipt (both) | M12 THE COUNT card: power against chin, damage carried in and which groups built it, heart at the count, the referee's roll as luck; the counts replayed on the same seed with each group out |
| No towel; durability is never a decision on the night (both; the RPG critic too) | M13 THE TOWEL: one design for the whole game (the RPG layer only hangs loyalty and the mark on it; the agreed cutman card is one of its reasons), plus the towel line set before the bell |
| `Sim._as_of` swaps stats only; the training row misses the pads (player) | M1 store: a MONDAY SNAPSHOT of the 14 abilities AND every move's mastery, and a SIGNING SNAPSHOT kept for good |
| The headline is the line most hurt by the first-order replay (player) | The headline row comes from a TRUE REPLAY: the whole bout re-run from the bell without that group, same seeds; "probably" when it disagrees with the same-dice rows |
| The build split at 28 days blames "who they are" for your weeks 1-5 (trainer) | Split at SIGNING: SINCE YOU SIGNED and LAST 4 WEEKS are yours, THE GAP YOU SIGNED is theirs |
| WeekOpp, the lefty week, the stance edge are stored and in no row (trainer) | READY FOR THEIR STYLE row; PARTS1 also asserts every part has a group |
| HOW BUSY doubles the built Pace (player) | Merged: Push / Steady / Save also move the pace dial +15 / 0 / -15; WHERE is the only new pick |
| WORK is a professional idea; all three leans shown for free (trainer) | Amateur panels lean CLEAN / RING / INITIATIVE, pro panels CLEAN / RING / WORK; leans are known only for shows whose officials you know |
| Perks folded into "small things" (trainer) | Every perk or trait that fired gets its own chip with its count |
| Two headlines (IT TURNED ON and the Why) (trainer) | The headline lives in the first row; the Why is one line |
| No WHEN; no opponent's half; two receipts with CLUBWEEK; "See the rounds" is not a decision; the Monday sum has no comparison (player) | The 18-tile bout strip; "what you did to them"; CLUBWEEK's result sizes ARE scales rows; "Replay the shouts"; the month against Coach's week |
| The strip's "wins 4 in 10 in the pocket" reads as the bout's chance; mixed units (player) | ONE UNIT (section 2.1): every size is in exchanges; the only chance on a screen is a chance, always "in 100" |
| Where this fighter wins against the field, not only the next opponent (player) | M3: the strip against the division's four kinds on the fighter's Overview, beside the build direction |
| The bill should show the same rows as a forecast, the result the forecast beside what happened (trainer) | M1 ON THE BILL: the bill's forecast rows are the scales' rows; the result marks each row's bill value |

## 1. The idea in nine lines
1. Every exchange already is one number (the edge) plus dice. Keep it; store each part of that number, and snapshot the fighter every Monday.
2. Before the bell, the player decides with prices in ONE unit (exchanges of the bout's 18): the card on the sheet, the pads, the sparring, the shape of the
   week, the lines, where to fight, the pace, the towel line. The bill shows those decisions as the receipt's own rows, forecast.
3. After the bout, take each group of parts out on the same dice and count what each turned: exchanges, rounds, the result. The headline is checked by a
   true replay from the bell.
4. Four groups: YOUR WORK, YOUR NIGHT, WHO THEY ARE, LUCK. Every row has one button that IS the next decision.
5. Rounds are scored the way judges score them; a count is 10-8; the panel's leans are known only where you know the officials.
6. Counts and stoppages get their own receipt (THE COUNT), and a decision (THE TOWEL) that trades a loss tonight for the fighter's future.
7. The plan's lines are worth more when they take the fight where YOUR fighter wins; WHERE is the night's one new pick; form is earned and shown.
8. A target says how much preparation must decide (55 to 70 of every 100 exchanges turned); the lever table measures it and the knobs fix it.
9. Anything worth less than 1.5 wins in 100 over a season is cut, merged or shown without a size.

## 2. How the build decides the fight today (traced in the code)
One exchange (30 s; 18 in a 3-round bout, 24 in the 4-round debut): `LiveRound.exchange` sums the edge `d`, then `Exchanges.settle(d, roll_a, roll_b)`:
margin = d + (roll_a - roll_b) x 66 (EX_SPREAD), a triangle from -66 to +66. An edge of +5 wins about 57 exchanges in 100. The dice are seeded per round and
exchange (`rng.seed = day x 31 + n x 7 + i x 101 ...`), so a bout can be re-run from the bell on the same dice. Counts are a second set of dice per round,
seeded too (`BoutNight._counts`).
| Part of d | Code | Size in one exchange | Fed by | Verdict |
|---|---|---|---|---|
| The duel at the place it is fought | RingDuel.step -> Duels.at, K 0.5 | +5 for a fighter 5 better everywhere (measured: +5 wins 72 in 100, +10 about 95) | 14 abilities + 4 punch levels (= move mastery, Attrs._punches) + pace and forward dials, reach, height, stance; tired and hurt copies | THE BACKBONE; one line of words on the round report today |
| Form on the night | RingDuel.form, FORM_SD 5 | gap spread about 7, fixed for all 18 exchanges | nothing | LUCK, HIDDEN, too big |
| Corner shout | Exchanges.call_edge: best 17, ok 5, wrong -10 x can-do (1.0 / 0.6 / 0.3) x uptake (coachability 0.7-1.0, halved after 2 shouts) x trust (morale 0.7-1.05); the minute's call keeps working when nothing is shouted | +12 to +14 right, about -15 wrong | Fight IQ, punches, coachability, morale, Ring general x1.25 | REAL, the biggest single lever: one right call is two to three times a 5-point build gap on every exchange it fits |
| Plan line | PlanFight.edge best 9, ok 3, wrong -7, less the card's mean; PlanRead +3.5 x2; PlanPressure +3 | up to about +16 stacked | ANSWERS (opponent's game only), drilled or not | REAL, one plan fits most (RULE4) |
| Open habit | HabitFix 6 x HABIT_BOUT 1.75 | about -10.5 when punished | the habit list; the corner's fix x uptake | REAL, never sized after the bout |
| Pace and aim | PaceAim: Push +6 (to -12 on an empty tank), Save -4, hurt aim +4, body on a tired opponent +3 | 3 to 6 | shouts | REAL |
| The Read, the set-up | TheRead +7 / -5; CornerJobs set-up +14 / -9 | one exchange each | Fight IQ, film, temperament; combination mastery | REAL |
| Legs (week tiredness) | BoutRules.stale_energy: -2 energy a point over 50, max -20, BUT 0 when camp.protocol < 1 | through the duel's tired copy | the week, only with a camp | REAL for pros, SWITCHED OFF on every camp-free amateur bout (defect 1) |
| Camp night edge | PROTOCOLS 0.25 / 0.6 / 1.0; NO_CAMP_EDGE -1.5 | under 1 (no camp: -1.5 on every exchange) | camp (pros) | a flat tax on the amateur path (defect 1) |
| Film | FILM_PER_ANSWER 0.4, max 1.2 | about 1 | tells the plan answers | small; its value is the plan and The Read |
| Weapons count, combinations known | WEAPON_EDGE 0.3 per weapon over 4, max 0.9; Combos.edge about 0.6 | under 1 | moves at 30+ | DECORATION, counted twice |
| Peak camp | PeakCamp +1 every stat | about 0.5 | camp lines met | near decoration |
| Perks | PerkFight: Stiff jab +3, Ring general x1.25, Counter sense 3 in 10 a +12 counter, Second wind +10, Finisher x1.5, Fast hands x1.4 | 1 to 4 when they fire | PerkRoad | REAL, small; one round line |
| Traits | coachability, morale as trust, heart at the count and the fade, temper / confidence / discipline in the talk and the read | a few points | personality | REAL, hover only |
| Style dials | FighterProfile.style_dials -> Attrs pace / forward -> Duels (FWD_GUARD 0.28 a point, FORWARD_CLOSE 0.55, PACE_WORK 8, PACE_GUARD 6, PACE_COUNTER 15) | decide WHERE the fight happens | rolled at signing | REAL and HIDDEN |
| Punch levels | Data.START_MOVE_SHARE (Jab 0.85, Cross 0.75, Lead hook 0.62, Body hook 0.5, Uppercut 0, Check hook 0 of Technique); opponents get all four at their rating (AttrGen._attrs_build -> Attrs.lay) | at Technique 60 against a rating-58 opponent: jab 51 v 58, straight 45 v 58, hooks 34 v 58, uppercut 1 v 58 | pads | REAL and HIDDEN: the pocket and inside start lost (defect 5) |
| Counts and stoppages | Knockdowns.round_counts: count chance 0.05 x margin (close 0.3 / clear 1 / dominant 2.2) x e^((power - chin) / 12) x (1 + damage / 60), three tries at x0.6; referee stop 0.2 x (1 + damage / 60) x (1.4 - heart / 100) x stop_mult; 3 counts a round or 4 a bout stop it | a second set of dice per round | power, chin, damage from lost rounds (close 8 / clear 18 / dominant 32), heart, Finisher | REAL, NO RECEIPT; a stoppage loss lowers the durability ceiling for good (Attrs.wear_stoppage -2) and costs 30 days |
Then `Exchanges.round_of` gives the round to whoever won more of its exchanges; `BoutRules.scorecards(rounds_won)` writes three cards from that count.
The shown chance (BoutRead) walks the same duels and stayed within 6 in 100 of played bouts in the eight checked cases (FIGHTER_MODEL_S397).

DEFECTS FOUND IN THE CODE (fixed first, whatever else is built):
1. NO CAMP = NO LEGS AND A TAX. `BoutRules.stale_energy` returns 0 when `camp.protocol < 1` (read in BoutNight._peak, line 108), and `night_edge` gives
   NO_CAMP_EDGE -1.5 to every exchange of a bout with an empty camp; `Bouts.start_camp` is the only thing that fills `camp`. On the S428 amateur path (no
   camp) a hard week costs nothing at the bell and every bout pays a flat tax the player cannot avoid, with the false line "looked a step slow". FIX
   (task NOCAMP1, widened): THE LEGS bar (CLUBWEEK 4: tiredness over 50 costs 1 a point, eaten weight, the last bout; at most 25 off) is computed on EVERY
   bout and replaces stale_energy in BoutNight._peak; NO_CAMP_EDGE applies only to a professional with no camp. Probe on 400 amateur bouts before and after.
2. `BoutRules.why` writes "The camp: <focus> held up when it mattered" for any Standard or Hard camp, won or lost, and "Your corner call before round N won
   that round" for any won round that had a call. Both canned; both deleted.
3. `BoutRules.scorecards` builds cards from rounds won only: every 2-1 is a split by formula, and FightWhy's "a standing count: that round went wide on the
   cards" is false (a count never changes a card). On the real result screen the side that won 10 of 18 exchanges and landed 61 to 56 lost all three cards.
4. `FireLevel` is built and off (no bout sets `fire_level`); TRAINING T10 and PLAYBOOK 4.2 switch it on. This map only reads it.
5. ONE CORNER'S PUNCHES START LOW, THE OTHER'S DO NOT. Our fighter's four punch levels are mastery (START_MOVE_SHARE; uppercut and check hook at 0, so the
   level clamps to 1); every opponent's four punches sit at its rating. The pocket and inside start lost before a week is trained, the seven-stat rows on
   the bout page do not show it, and the first offers are harder than the shown stats say. Fixed in M8 (one punch rule for both corners).
6. `Sim._as_of` swaps `stats` only: moves (the punch levels) stay at today's values, so a "last 4 weeks" row built on it misses the pads. Fixed by the
   snapshots in M1.

### 2.1 ONE UNIT (every screen of this map, and proposed to the neighbours)
The player reads three kinds of number, each always in the same unit:
- WHAT THE FIGHTER IS: abilities and mastery, 0 to 100 ("hooks 41", "guard 61"). Unchanged.
- WHAT SOMETHING DID OR WILL DO IN A BOUT: EXCHANGES, counted out of the bout's own total (18 in three rounds, 24 in four), and the rounds and bouts those
  exchanges turned. The strip ("at range: about 8 of 18 here, Lucy wins about 5"), the bill's forecast rows, the receipt, readiness ("sharp: about +1
  exchange"), the pad card ("pocket +1 exchange by Saturday"), the Monday sums and the lever table all speak exchanges.
- A CHANCE: "N in 100", only for things that are chances: the bout's win chance (one per bout), a stoppage risk, a judge's lean scoring a level round.
  Never "in 10", never "1 in N", never a percentage, never "power points" on a screen.
One bridge, in the Handbook only: "near an even bout, 1 exchange in 18 is worth about N in 100 to win" (N set by LEVERS1; ESTIMATE about 6).
PROPOSED TO THE NEIGHBOURS (their call, one line each, not redesigned here): CLUBWEEK's lever sizes beside the bill's one number, TRAINING T2's "the week's
worth on that bout" and T5's habit card, PLAYBOOK 4.11's receipt and RPG 13's fight ledger print exchanges, with the in-100 value on hover. The bill's ONE
number (your week against Coach's) stays a chance: it IS the bout's chance, two ways. Until they take it, this map's screens print exchanges and theirs
keep their own lines.

### 2.2 THE TARGET: how much preparation must explain (set before LEVERS1 runs; the trainer's rule "the preparation wins fights, the corner saves close ones")
Measured on the played bout, four matchups (an out-boxer, a presser, a counter-puncher, a slugger), bouts between fighters within 5 points at signing,
a bot that plays all three groups well, 600 bouts a cell. Shares are of the exchanges the scales turn (the absolute sum of all rows):
| Who decides | Rows | Target share of exchanges turned | If it misses, the knob (one change, then the ripple list re-measured) |
|---|---|---|---|
| PREPARATION | your work (last 4 weeks, since you signed, Legs, ready for their style, habits) + the plan written before the bell + where and the pace chosen before it | 55 to 70 in 100 | under 55: Duels K 0.5 -> 0.6 (each point of the build counts more) |
| THE NIGHT | shouts, the minute (fix, set-up, talk, one step), the towel, Read calls | 20 to 30 in 100 | over 30: Exchanges call EDGE best 17 -> 12, and can-do Poor 0.3 -> 0.2 (more of the call tied to the punch it needs) |
| LUCK | the night's form + the dice against what the edge expected + the referee's roll | 10 to 20 in 100 | over 20: FORM_SD 3 -> 2; under 10 (reads scripted): EX_SPREAD 66 -> 72 |
| UPSETS (a second check) | bouts lost by the side whose preparation rows sum higher | 20 to 30 in 100 (ESTIMATE; John checks the real rate at which favourites lose in amateur and pro boxing) | over 30: as LUCK; under 20: as LUCK, the other way |
Today's measured levers (exchanges_test; FIGHTER_MODEL_S397) suggest the night is over 30 (reading the clue 0.67 against silence 0.47, about the size of
5 points of training). The Handbook page "What wins a bout" says the target in one plain line: "Your weeks win most fights; the corner turns close ones;
luck turns about one in four." LEVERS1 prints each share with its control arm (today's game) first; no screen size is shown before the target holds.

## 3. BEFORE THE BELL: what the player decides because of this map (each priced on the bill in exchanges)
| When | Decision | Priced as | Tag and hook |
|---|---|---|---|
| Monday, the sheet | WHICH CARD of the three (HOME, A NAME ABOVE, THE UNKNOWN) | each card's strip line ("wins at range, loses in the pocket") and its stoppage risk; HOME and a host you have boxed for this season show the judges' leans, others "?" (M2) | WEEK CLUBWEEK BoutSheet; CODE Duels.at; NEW Officials |
| The fight week | PAD PLACES on a punch or a combination | "Lead hook 41 -> 47 by Sat, against Priya's guard 61: pocket +1 exchange" (M8) | WEEK CLUBWEEK pad places; CODE MoveMastery, Duels |
| The fight week | THE HABIT CARD (TRAINING T5) | "punished by Priya's counter game: costs about 3 exchanges; half fixed 1.5" | WEEK TRAINING T5; CODE HabitFix |
| The fight week | MATCHUP SPARRING: one sparring evening "as <opponent>" (M14) | "+1 exchange where Priya counters; one tell; the southpaw answer" | NEW SparAs on WEEK CLUBWEEK SparSet / TRAINING T4 |
| The fight week | THE SHAPE: Rest up / Tick over / Train through (CLUBWEEK 4) | the Legs at the bell and readiness: "Tick over: Legs 92, sharp: about +1 exchange" (M6) | WEEK CLUBWEEK Legs; NEW Readiness |
| The plan | WHICH LINES (PLAYBOOK) | Beats it / Works / Walks into it x the line grade x SUIT: "suits Lucy +1 exchange at range" (M4) | CODE PlanFight; NEW suit |
| The bill | WHERE: Keep it long / Mid-ring / Walk them down (M5) | the strip recomputed and the stoppage risk both ways: "Walk them down: pocket +1, range -2; Lucy stopped 9 -> 13 in 100" | NEW Aim on CODE Duels dials, Knockdowns |
| The bill | THE PACE for each round phase: Push / Steady / Save (built; PLAYBOOK 4.5 places it by round; HYPE 4.4's Entertain and Safe set it) | Push now also moves the pace dial +15 (M5) | CODE PaceAim + NEW dial shift |
| The bill | THE TOWEL LINE: Careful / Normal / Brave (M13) | when the towel card comes to you, and what Coach does when Coach corners: "Careful: Coach pulls Lucy at 12 in 100" | NEW Towel |
Every row above appears on the bill as the forecast row of the receipt it will be read by (M1, ON THE BILL), so the player learns to read their own prep.

## 4. The chain, one picture (each arrow is a hook that exists, or a mechanic below)
| The week (CLUBWEEK, TRAINING) | -> the build | -> the plan (Playbook) | -> the night | -> the result | -> next week |
|---|---|---|---|---|---|
| mornings, pad places, sparring as the opponent, the habit card, the shape | abilities and punch levels (snapshotted every Monday), habits half or gone, perks open | lines, valued by where YOUR fighter wins (M4) | where and pace, readiness, the Legs, the towel line, the judges' panel | THE SCALES, THE COUNT, the judges' reasons, the bill against tonight | each row's button puts the fix on the next week's board |
| sizes on each card in exchanges (M8, from LEVERS1) | the three places strip moves with each card (M3) | "suits" chip on each line | the corner's card (M7), the towel (M13) | the three places: fought and won | Monday: "your choices this month against Coach's week" |

## 5. The mechanics

### M1 THE SCALES (what turned it) - NEW, the receipt
WHAT THE PLAYER DECIDES: nothing here; every other decision is read by it, and every row carries one button that IS the next decision.
WHERE: the result page (replaces "What decided it" and the plan-only headline), the round report (its rows so far), History (each bout), the Monday review
(the month's sums), the RPG Character tab (that fighter's rows, joined to RPG 13's ledger), and the BILL as a forecast (below).
THE STORE (NEW): `LiveRound.exchange` stores `rec["parts"]`, one number per term it already adds: the duel split three ways (below), form gap, Legs, call,
pace and aim, The Read, set-up, talk, habit, plan, reads and pressure, film, week on their game (WeekOpp), lefty week, stance edge, clinch, perks, fade,
the base. Test PARTS1: the parts sum to d within 0.01 on every exchange, AND every part key belongs to exactly one group (a new term with no group fails).
THE SNAPSHOTS (NEW, written by the Monday stop, `Clock`'s Monday tick, and at signing): per fighter the 14 abilities AND every move's mastery (the six
punches and own combinations), the last 5 Mondays kept, plus the SIGNING SNAPSHOT kept for good. The duel part is computed three ways in each exchange,
same place, same tank, same opponent: d_now; d_4w with the abilities and punch levels of 4 Mondays ago; d_sign with those at signing.
LAST 4 WEEKS = d_now - d_4w; SINCE YOU SIGNED = d_4w - d_sign; THE GAP YOU SIGNED = d_sign. The three add up to the duel. Test SNAP1: a fighter given +10
hook mastery on the pads shows a non-zero LAST 4 WEEKS row in a pocket-heavy bout (the player critic's test).
THE REPLAY (rows): for each GROUP, settle every exchange again with that group's parts removed and the SAME rolls (as `plan_swing` does today), re-score the
rounds with the judges (M2), re-roll the counts on their same seed (M12), and count exchanges turned, rounds turned (named) and whether the RESULT turns.
| Group | Row | Parts | Its button |
|---|---|---|---|
| YOUR WORK | LAST 4 WEEKS | d_now - d_4w (abilities AND punch levels) | Open the week |
| | SINCE YOU SIGNED | d_4w - d_sign | Season plan (TRAINING T9's strip) |
| | LEGS | the duel and Push at this tank minus at the tank without the Legs' cost; THIS ROW IS CLUBWEEK's result size ("Legs: 9 off the tank, round 3 lost") | Rest up (the fight-week shape) |
| | READY FOR THEIR STYLE | WeekOpp (weeks on their game, matchup sparring M14), the lefty week, the stance edge | Spar as the next opponent |
| | HABIT (one row per open habit) | HabitFix cost paid, at its TRAINING T5 state (there / half / gone) | Put the habit card on (TRAINING T5) |
| YOUR NIGHT | YOUR PLAN | plan + reads + pressure + film (today's plan_swing, kept); PLAYBOOK 4.11's per-line receipt opens from it | Open the plan |
| | YOUR CORNER | shouts, The Read calls, set-up, talk, the minute's fix share, the towel's round | Replay the shouts (the round with each shout's result) |
| | WHERE AND PACE | the duel and pace edge with the night's picks minus with the fighter's own dials and Steady (M5) | Change it on the next bill |
| WHO THEY ARE | THE GAP YOU SIGNED | d_sign: who the two fighters were, talent against talent | the weakest place's card on the pads ("Hooks on the pads") |
| | PERKS AND TRAITS | each perk or trait that fired, both sides, ONE CHIP EACH with its count ("Heart 71: up at 6", "Priya's Counter sense: 2 counters"), never folded | Perk road / Character tab |
| LUCK | THE NIGHT | the form gap (M6's leftover) + the dice against what the edge expected (exchanges won minus the sum of each exchange's win chance) + the referee's roll at a count (M12); one row, the parts on hover | none: "luck, named" |
Rows under 1 exchange fold into "small things: +1" EXCEPT perk and trait chips, which always show. Eight rows at most; the rest fold.
THE HEADLINE, BY A TRUE REPLAY (NEW): the top row is the group whose removal turns the RESULT. It is checked by re-running the WHOLE bout from the bell
without that group (same seeds per round and exchange; the player's shouts replayed at the same exchange numbers and re-graded against what the opponent
does in the re-run; the counts on their seeds). One extra simulation per candidate, pure rules, no 3D; at most two candidates. If the true replay agrees:
"IT TURNED ON the open habit: without it no count in round 2, and Lucy wins on two cards (checked: the whole bout re-run)". If it disagrees: "PROBABLY".
If no group turns the result: "No single part turned it: the gap you signed and the plan decided it together". The headline sits IN the first row (its
highlight); there is no second headline. The Why below is one line.
THE BOUT STRIP (NEW, above the rows): 18 tiles, one per exchange (24 in four rounds), coloured by who won it, each carrying the letter of its biggest part
(W week, H habit, L legs, P plan, C corner, A where/pace, G the gap, K perk, ? luck), gold on the exchanges that flip when the headline group is out.
Clicking a tile gives that exchange's parts. A count is marked on its round.
ON THE BILL (NEW): before the bout the bill shows the same groups and rows as a forecast, in exchanges, from BoutRead walking the parts (its LEGS row is
CLUBWEEK's Legs bar; its plan row is PLAYBOOK's plan number). After the bout each row carries its bill value as a tick on the bar and a small "bill +2",
so "the Legs cost 2 more than the bill said" is visible. The bill's one number (CLUBWEEK: your week against Coach's) is printed under the scales unchanged.
WHAT YOU DID TO THEM (NEW, one line under the rows): their habit you punished (exchanges), their Legs at the bell, the tells your plan answered.
WHO DECIDES THIS FIGHTER'S FIGHTS (NEW, one line): the shares of section 2.2 over this fighter's last five bouts ("your work 58, your night 29, luck 13
of every 100 exchanges turned"); on the result and the Character tab.
SEASON: the Monday review sums the month: "Your choices this month: +6 exchanges, 2 rounds, 1 bout turned; Coach's week would have given +2" (the month's
sum of CLUBWEEK's your-week-against-Coach's, in exchanges). History keeps each bout's scales.
REAL BASIS: a corner's post-fight review (what worked, what did not, what to drill); the replay on the same dice is what `plan_swing` already does (S388).
FIRST-ORDER, SAID PLAINLY: the rows keep the same places, tanks and opponent games (path effects ignored), like plan_swing; only the headline is a true
replay. SCALES1 checks the season sums against true switch-off probes; a group off by more than 1.5 in 100 shows exchanges only, never a season number.
DELETED BY IT: BoutRules.why's canned camp and corner-call lines, "What decided it", the "worth about +X%" on one bout, "GOOD PLAN" as the headline of a lost
bout. The Why's three lines become ONE: "Plan: GOOD, 9 right, 2 wrong · Against you: the dropped right · Next: <the top red row's button in words>".

### M2 THE JUDGES - CHANGED (scoring like a judge; "judges with taste" brought forward as scoring only, no names)
WHAT THE PLAYER DECIDES: the card on the sheet (whose officials you know), WHERE and the plan against the panel you know.
WHAT IT CHANGES (NEW rule Judges, called from CODE BoutNight.outcome_of / _finish in place of BoutRules.scorecards): each round is scored by each judge
from what the exchanges record:
- CLEAN PUNCHES landed (rec["landed"], from the margin band), the base for every judge;
- BIG SHOTS: a landed set-up, a landed Read, a Counter sense counter, an exchange that left the opponent hurt count 2 extra each;
- RING CONTROL: per exchange, the side that kept the place it wanted (rec wa / wb against place) AND won the exchange takes 1. Backing off while losing gives
  control away; boxing at range while winning keeps it, so a step back is right only for a fighter who wins at range (M4);
- INITIATIVE (amateur): forward exchanges won (the side that came forward and won it); WORK (professional): the busier side's pace dial gap / 10.
LEANS: amateur panels draw from CLEAN / RING / INITIATIVE (the amateur criteria: quality blows, domination, competitiveness); professional panels from
CLEAN / RING / WORK (clean punching, ring generalship, effective aggression). The lean doubles its part (ESTIMATE weights, set by JUDGES1). The round's
higher total gets 10, the other 9; a count is 10-8 (two counts 10-7) on every card, so the count line becomes true. A round level on a judge goes to the
lean's side.
OFFICIALS YOU KNOW (NEW, Officials rule, no names): a show's officials are the host's. You know tonight's leans for HOME shows (your own and the local show
near the club) and for any host whose show one of yours has boxed this season (CLUBWEEK: an away bout earns a favour with the host); otherwise each lean is
"?". A professional's panel is known after the first pro bout under that promoter. Known leans show on the sheet card, the bill and the tale of the tape;
"?" leans are drawn at the bell and named after.
REAL BASIS: amateur 10-point must (England Boxing / IBA); professional criteria; local officials are known to club coaches; judges differ in what they
weigh, which is why splits happen. Names and records of judges wait for the small world (LEFT FOR LATER).
LINKS: plan lines (step back, tie up) cost or earn control; WHERE moves control; the pace moves WORK; HYPE's ENTERTAIN gains with WORK and INITIATIVE judges;
the corner's card (M7) reads the cards.
SHOWN: three cards with the lean, known or "?" before the bell, ONE reason each ("Ring: Priya kept the pocket in rounds 2 and 3"), round marks on hover.
PROBE JUDGES1 (gate): (a) the exchange-winner still takes the round in 80 to 90 in 100 rounds (ESTIMATE band); (b) "out-landed and lost the card" in under
15 in 100 decisions, and every one names the judge and reason; (c) split decisions inside a band John's research sets (ESTIMATE 10 to 25 in 100); (d)
BoutRead within 6 in 100 of played bouts on the eight cases; (e) plan_effect_probe's spread kept; (f) knowing the leans is worth 1.5 in 100 or more to a bot
that picks WHERE by them, else the leans show for every show (the Officials rule is cut, the panel stays). Ripple: plan_templates_test, CoachPlan,
BalanceHarness, the career harness's records.

### M3 THE THREE PLACES - NEW (the matchup read, before, during and after; in exchanges)
WHAT THE PLAYER DECIDES: which card on the sheet, which pad card and morning to buy, which lines, WHERE; over months, the build direction.
WHAT IT SHOWS: AT RANGE / IN THE POCKET / INSIDE, each with:
- the exchanges expected there tonight ("about 8 of 18 here", from RingDuel.mode_bias and PLAYBOOK 4.7's place counts) and how many this fighter wins of
  them ("wins about 5"), from `Duels.at(a, b, place)` -> P(win) = 1 - (66 - d)^2 / (2 x 66^2) for d >= 0 (mirror below), times the count;
- the tool against the answer with both numbers: "jab 60 against feet 54" (Duels.TOOLS, TOOL_WORD / ANSWER_WORD, a_best / b_best), every punch from the first
  offer (defect 5);
- where THEY want it ("Priya wants the pocket", RingDuel.wins_breaks);
- what moves it by fight night: the pad card or morning with its forecast ("Lead hook 41 -> 47 by Sat: pocket +1 exchange").
LABEL (player critic): the strip says "on the build alone", with one line under it: "the plan and the corner can add about N exchanges" (LEVERS1), so no
one reads a place as the bout's chance. An unscouted opponent shows each place as a range (AttrGen's scouted range), narrowing with the file.
WHERE THIS FIGHTER WINS (NEW, the fighter's Overview): the same strip against the division's four kinds (out-boxer, presser, counter-puncher, slugger) at the
fighter's own level, each with the pad card or morning that moves it, beside the build direction (RPG 12: "Walk them down would move inside +1 against a
presser in 8 weeks"). It gives training a target beyond the next opponent.
WHERE ELSE: the sheet card (one line), the bout page's Full report (replaces the seven-stat rows; the duel never reads Technique), Fight prep (the strip +
"moves it by Saturday"), the Fight plan header, the corner minute (live: tank and hurt included, Duels.effective), the result (fought and won per place),
the Monday review ("at range +1 exchange since last month").
REAL BASIS: a coach's matchup read: "beat them on the outside, don't stand in the pocket with them".
PROBE PLACES1: the strip's expected exchanges and wins per place within 1 exchange of played bouts (600 bouts, 4 matchups).

### M4 LINES THAT SUIT THE FIGHTER - NEW (the build's half of RULE4; the Playbook map owns the line table)
WHAT THE PLAYER DECIDES: which lines to write, for THIS fighter against THIS opponent.
WHAT IT CHANGES: a line's positive worth is multiplied by how well this fighter does at the place the line takes the fight to:
`suit = clamp(1 + E / 10, 0.5, 1.5)`, E = Duels.at edge at that place (the step back takes it long; slip 2-3, 2-3, 3b-3, 1-2-3b, 1-6-3 stay in the pocket;
tie up, push off, herd, cut off, step in go inside; jab lines stay long). A wrong line keeps its full cost (PLAYBOOK 4.3's prices). With M2, a retreating
line that loses at range also gives away ring control. It sits beside PLAYBOOK 4.1's line grade (how this fighter DOES the move): grade = the body doing
it, suit = where it takes the fight. Two chips, two causes, one number in PlanFight.value.
SPLIT OF WORK: PLAYBOOK rewrites ANSWERS (4.3), switches FireLevel on (4.2), adds IF READ (4.4); this map adds `suit` in PlanFight.edge / value, CoachPlan,
BoutRead and FightWhy, and the PLACE_OF table. One gate for both, from RULE4_PARKED_S398.
SHOWN: on each line, beside Beats it / Works / Walks into it and the grade: "suits Lucy +1 exchange at range" or "Lucy loses there -1".
GATE RULE4 (with the Playbook map): a reader beats a fixed universal plan and a board-top headline bot by 3 in 100 or more on each of four opponents, N = 600,
on equal information. If `suit` alone does not move the gap by 1.5 in 100 on any opponent, it is cut and the chip goes.

### M5 WHERE, AND THE PACE THAT ALREADY EXISTS - NEW / CHANGED (the agreed Aggression slider as one new pick)
WHAT THE PLAYER DECIDES, on the Fight plan header and the bill:
- WHERE (NEW): KEEP IT LONG (forward dial -15) / MID-RING (the fighter's own) / WALK THEM DOWN (+15).
- THE PACE (CODE PaceAim, built; PLAYBOOK 4.5 places it per round phase; HYPE 4.4's ENTERTAIN = Push in rounds 1 and 2, SAFE = Save): Push / Steady / Save
  now ALSO move the pace dial +15 / 0 / -15. One control, both effects; there is no separate "how busy" pick (merged, player critic).
The duel's caps stay (FWD_CAP 26 over 50, PACE_HOT 72 past which pace misses). In the corner minute, ONE CHANGE may move WHERE one step (it competes with the
habit fix and Elbows in / Gloves high); the pace changes as built.
WHAT IT CHANGES (code constants, sizes ESTIMATE until AIM1): Walk them down = guard -4.2 (FWD_GUARD 0.28 x 15), closing +8 (FORWARD_CLOSE 0.55 x 15) once
the feet can use it; Keep it long the reverse. Push's dial shift = own guard -0.9 (PACE_GUARD), the opponent's counters +2.3 (PACE_COUNTER), close
exchanges +1.2 (PACE_WORK) and more for a WORK judge. The corner's default place (RingDuel.CALL_PLACE) and the plan's opening card (PlanFight GAME_CARD)
follow WHERE.
PRICE SHOWN BEFORE THE PRESS (trainer: the count, not only the places): "Walk them down: pocket +1, range -2 exchanges; Lucy stopped 9 -> 13 in 100,
Priya 4 -> 6" (M3's strip recomputed with the dial; the stoppage risk from M12's rule run over the bout forecast).
LINKS: RPG 12's build direction moves the fighter's own dials 2 a week (the band moves; WHERE stays one step around it); RPG's SWITCH IT UP stays that
direction's bigger corner move.
SHOWN AFTER: the WHERE AND PACE row; the places strip shows where the fight went.
PROBE AIM1: three WHEREs x three paces on four matchups: every pick wins 1.5 in 100 or more somewhere and loses somewhere; no pair wins on all four; else
WHERE is cut to two options, or to none.

### M6 THE NIGHT, EARNED - CHANGED (form readable and moved by the week)
WHAT THE PLAYER DECIDES: nothing new on the night; the week's choices that set readiness now carry a visible night, and round 1's pace is picked after
seeing it.
WHAT IT CHANGES (NEW rule Readiness; CODE RingDuel.form): the form roll's mean = READINESS (-3 to +3 on the duel) and its spread drops from 5 to 3 (FORM_SD
5 -> 3 on watched bouts; world bouts keep 8).
| Input | Readiness | Source |
|---|---|---|
| Fight-week shape: Tick over or Train through, sharp | +1 | WEEK CLUBWEEK 4, the last five days' pad place |
| Rest up | 0, and its slow start in round 1 | WEEK CLUBWEEK 4 |
| Mood: Fired up / Steady / Flat / Low | +1 / 0 / -1 / -2 | CODE morale (FighterProfile) |
| Weight eaten off on the day over 0.5 kg | -1 | WEEK CLUBWEEK 4, the scale |
| A professional's peak camp (all three lines met) | +1 (replaces +1 to every stat) | CODE PeakCamp |
| Nerves: heat Hot and confidence under 45 | -1 | HYPE 2.2, RPG 5 |
| Over 8 weeks since the last bout | -1 | NEW, ring rust |
The opponent's readiness follows the same rules from their file (their Legs: CLUBWEEK "the other corner has a week").
SHOWN: the tale of the tape before "Begin fight": "Lucy: SHARP tonight, about +1 exchange" with its causes on hover; the opponent's is "?" unless shared.
After the bout, the LUCK row names both sides' form on hover.
REAL BASIS: day-to-day variance is real but mostly explained (sleep, the cut, freshness; a taper improves performance by a few per cent).
PROBE FORM1: (a) a player who manages readiness wins 1.5 in 100 or more over a season than one who ignores it; (b) BoutRead within 6; (c) the form part of
LUCK under 1 exchange a bout on average. Else readiness is cut to the Legs only.

### M7 THE CORNER'S CARD - NEW (the coach reads the cards; the same read PLAYBOOK 4.5 uses for IF AHEAD / IF BEHIND)
WHAT THE PLAYER DECIDES: the last round's pace, WHERE step and fix, and the towel, with a read behind them.
WHAT IT SHOWS: in each corner minute after round 1, one line: "We're a round up / level / a round down", with how sure ("sure", "think so"). PLAYBOOK 4.5's
late-round split (IF AHEAD / IF BEHIND) reads THIS line, not its own count: one read, two uses.
RIGHT AS OFTEN AS THE COACH: right in 60 + 0.3 x the cornering coach's rating in 100 (ESTIMATE: Luke Reid about 75, Marcus Hale about 82; you by your coach
level, RPG 2); known leans (M2) add +5. Coach's corner (CLUBWEEK) gives it too.
LINKS: M2 (the cards it reads), RPG 2 level 4 picks, RPG 11 (the hired coach grows).
SHOWN AFTER: when it was wrong, the YOUR CORNER row says so ("your corner had round 2 as Lucy's; the Ring judge gave it to Priya").
PROBE CARDREAD1: on bouts level after two rounds, a bot that follows the card beats always-Push and always-Steady in the last round by 1.5 in 100 or more;
else the line shows only before the last round, or is cut.

### M8 WHAT THE WEEK BUYS ON SATURDAY, AND ONE PUNCH RULE - CHANGED (sizes where the week is planned)
WHAT THE PLAYER DECIDES: the mornings and pad places of the week (CLUBWEEK, TRAINING), against the booked opponent.
WHAT IT CHANGES: nothing in the fight except the punch rule; it puts the fight's numbers on the cards:
- PAD CARDS: "Lead hook 41 -> 47 by Sat (Priya's guard 61): pocket +1 exchange" (CODE MoveMastery forecast + Duels.at). Pads give 2.1 mastery an hour, the
  fastest week-to-night link: the card says so in its own numbers. Past Usable the card also prints its fire share (PLAYBOOK 4.2, TRAINING T10).
- MORNING CARDS: the attribute's forecast and its move on the strip, in exchanges, only from LEVERS1 (CLUBWEEK's rule: no size before its probe). TRAINING
  owns the second uses of Flexibility and Recovery; this map asks only that each morning's fight value is printed or the morning is folded away.
- ONE PUNCH RULE FOR BOTH CORNERS (fixes defect 5; NEW rule PunchStart, CODE Data.fighter_state and AttrGen._attrs_build): every punch starts at
  max(Technique x its START_MOVE_SHARE, RAW FLOOR), RAW FLOOR = 0.4 x the mean of Accuracy and Timing (ESTIMATE); its mastery stays as it is for plans and
  fire shares. Opponents use the SAME rule from their rating, then grow each punch toward their rating with their bouts (the start share at 0 bouts, full
  rating at 12 bouts or more; ESTIMATE): a novice opponent has the same gaps a new signing has; a 20-bout opponent does not. The card says "Uppercut: raw
  (22), not yet a weapon". PROBE PUNCHFLOOR1 (all four punches): a fresh signing's win chance on the first sheet stays 40 to 60 in 100 against its HOME card;
  the strip shows each punch's gap from the first offer; BoutRead within 6. Ripple: BalanceHarness, the career harness, plan_templates_test.
- THE HABIT (TRAINING T5 owns the training: THERE / HALF FIXED after 3 of your pad places / GONE after 6, and the relapse): the fight half is here: HabitFix
  reads the state (there x1, half x0.5, gone 0). The card, the Why and the scales' HABIT row print the same number in exchanges ("cost 3 exchanges last
  bout; half fixed: about 1.5"). HABITDRILL1: a fixed habit is worth 1.5 in 100 or more against opponents who punish it; half fixed about half that.

### M9 HONEST SMALL LEVERS - CUT, MERGED or SIZED
| Lever (code) | Today | Change | Gate |
|---|---|---|---|
| Camp intensity night edge (PROTOCOLS 0.25 / 0.6 / 1.0, pros) | under 1, listed as a reason | removed from the night; the camp card says what it does: "Hard: camp stat x1.35, Legs about 8 lower at the bell" | CAMPNIGHT1: if a step reaches 1.5 in 100 on its own, keep and print it |
| NO_CAMP_EDGE -1.5 | every camp-free bout | professionals with no camp only; never an amateur fight week | NOCAMP1 (defect 1) |
| stale_energy (0 without a camp) | the Legs for pros only | replaced on every bout by CLUBWEEK's Legs bar | NOCAMP1 |
| Weapons count (WEAPON_EDGE, max 0.9) and combinations known (Combos.edge) | counted twice | removed from the base; punches stay in the duel, combinations in the plan and the set-up | WEAPONCUT1: under 1.5 in 100, then cut and never listed |
| Film (0.4 a tell answered, max 1.2) | a separate reason | kept, counted inside YOUR PLAN (a tell only counts when a line answers it, S381) | in LEVERS1 |
| Peak camp (+1 every stat) | a reason line | +1 readiness (M6) | FORM1 |
| "What decided it", the canned camp and corner-call lines, the false count line | on every result | deleted; the count line is true under M2 | PARTS1, JUDGES1 |
| HabitBeats (picture only) | could be read as cause | stays picture; the scales carry the real habit cost | none |

### M10 LEVERS1 - NEW (one measured table; every size on a screen reads from it)
A probe tool beside plan_effect_probe / train_effect_probe / fire_level_probe: four matchups (an out-boxer, a presser, a counter-puncher, a slugger), 600
played bouts a cell, paired dice, populations named in the output, no identical fighters. Rows: +5 on all abilities; each punch +10; each mastery tier;
good / wrong plan; suit on and off (M4); reading the clue / Coach's pick / silence; each WHERE x pace (M5); readiness -2 / 0 / +2 (M6); the corner's card
(M7); each camp level; film; each perk version (RPG 6); a fixed / half / open habit; the Legs at 0 / 12 / 25 off; matchup sparring (M14); each towel line
(M13). Output: exchanges a bout AND wins in 100 per row per matchup, plus THE TARGET's shares (section 2.2), written to `ops/AgentComms/levers.json`, read
by LeverSize (CLUBWEEK), the Handbook and the cut rule. Runs weekly in the 05:00 slot or when a lever changes, never in a session (heat rule).
ORDER: THE TARGET is written into the tool before its first run; the first run prints today's game (control arm), then the target's shares; if a share
misses, the knob in 2.2 is changed and the run repeated before any size reaches a screen.
HANDBOOK > "What wins a bout": the target line, the table in plain words in exchanges, the groups of M1, refreshed from levers.json.
THE CUT RULE: a player's choice that moves less than 1.5 wins in 100, averaged over the four matchups (or on the bouts where it applies, over a season), is
cut, merged, or shown without a size.

### M11 THE SCALES ON THE MAT - NEW (BJJ, the same receipt; any grappler, Ana is the example)
The BJJ match runs on beats (BjjMatch, BjjClash, BjjBeat). Same method: each beat stores its parts (BjjClash.factors already lists them for the reason line),
replayed with each group out on the same dice. Groups: THE BELT GAP (who they are), YOUR WEEKS (drilled moves owned, classes, TRAINING T12's class kinds),
YOUR CALLS (when the player fights it: the picks on the move graph), THE REFEREE (stall counts), LUCK. Shown on the open's result and the grappler's record,
in points scored and beats won (the mat's unit). BJJSCALES1: parts sum per beat; season sums match switch-off probes within 1.5 in 100 of matches. The
judges (M2), the count (M12) and the towel (M13) do not apply: BJJ scores points and submissions end it.

### M12 THE COUNT - NEW (a receipt for every count and stoppage)
WHAT THE PLAYER DECIDES: the towel (M13), WHERE and Gloves high against a puncher, and next week's chin, defence and habit work.
WHERE: the result (a card in place of the three places when a count happened, either side; the places fold to one line), the round report, the corner
minute (it feeds the towel), History.
WHAT IT SHOWS (from CODE Knockdowns.round_counts and puncher_chance, stored per count, NEW record): the round and the exchange; THE PUNCH: their power against
this fighter's chin, both numbers ("Priya's power 63 against Lucy's chin 57"); THE DAMAGE CARRIED IN: head damage at the start of that round and which
groups built it (the rounds lost and, through the replay, the habit's, the Legs', the gap's share: "26 carried in: 11 from the open habit, 9 from the
gap"); THE COUNT CHANCE that round ("16 in 100"), the margin band that set it; HEART at the count ("Heart 71: up at 6"); THE REFEREE'S ROLL ("waved on: a
stop was 18 in 100") named as luck; perks at work (Iron chin's stagger, Finisher on the other side), each as a chip.
THE REPLAY: the counts are re-rolled on their SAME seed with each group out, so the card can say "Without the open habit: no count in round 2" or "The
count came anyway: power against chin". The same rows feed the scales (a count's round turned by a group counts there).
ITS BUTTONS: "Chin and defence mornings" (Durability, Defence; TRAINING T3), "Put the habit card on" when a habit built the damage, "Gloves high next time"
(the minute's fix, built).
REAL BASIS: a corner's first question after a knockdown: what landed, why there, could they take it, was the stop right.
PROBE DAMAGE1: on 400 stoppages the card's biggest group matches a true switch-off replay in 8 of 10; the shown count chance within 3 in 100 of played rounds.

### M13 THE TOWEL - NEW (one design for the game: the RPG layer hangs loyalty and the mark on it; the agreed cutman card is one of its reasons)
WHAT THE PLAYER DECIDES:
- BEFORE THE BELL, on the bill: THE TOWEL LINE: CAREFUL (the card comes at 12 in 100 stoppage risk), NORMAL (20 in 100), BRAVE (33 in 100) (ESTIMATE).
  When Coach corners (CLUBWEEK's Coach's corner, or the other hall on a two-show night), Coach pulls the fighter out at that line by itself; when you
  corner, the card comes to you at that line.
- IN THE CORNER MINUTE, when the card comes (any of: a count in the round just gone; head damage past the critical band; an eye closing, the agreed R28 cutman
  case; the risk past your towel line). Behind a divider, never a pop-up, never pre-selected, and it does not use one of the minute's two fixes:
| Answer | What happens | Lasting |
|---|---|---|
| PULL THEM OUT | a loss (retired); no next round | no durability loss (Attrs.wear_stoppage skipped), 14 days out not 30, no injury roll for the round not boxed; morale -4; LOYALTY by band (RPG 3): Settled and up +2 "you looked after me", Wavering -6 "you quit on me"; the RPG mark "pulled me out" |
| ONE MORE ROUND | the round as planned, the shown risk | stopped: durability ceiling -2 for good (CODE wear_stoppage), 30 days (90 again inside 90 days), the knockout turn (RPG 5); won the bout: the RPG mark "sent me out", Hardened +10 on the next knockout card |
| BOX SAFE | the round on Save and "Hands up, move your head", Gloves high; a losing round's margin drops one band (dominant -> clear -> close, NEW in Knockdowns' margin input) | the stoppage risk falls (shown), the round is usually lost (shown) |
THE RISK SHOWN: "stopped next round: 14 in 100 (Box safe: 6 in 100; the round: Lucy wins it 35 in 100, Box safe 15 in 100)" from Knockdowns run 200 times
on the next round from the current state (power v chin, damage, heart, the margin from the live strip). EXACT when the fighter's Fire is KNOWN (RPG 8:
heart is in Fire), a range when not. The eye case reads "a lasting cut 1 in N" from the cutman rule (Injuries) instead.
SHOWN AFTER: the result's YOUR CORNER row and THE COUNT card name the call ("before round 3: stoppage risk 14 in 100, your line 20: one more round").
REAL BASIS: the corner's hardest call; amateur corners and referees stop bouts to protect boxers; a boxer stopped once is likelier to be stopped again.
PROBE TOWEL1 (600 careers): a corner that pulls at its line keeps more season wins (through the durability ceiling and fewer layoffs) than one that never
pulls, AND one more round shown at 12 to 20 in 100 still wins the bout 1 time in 5 or more (one more round is not always wrong). Else the lines move, or Box
safe goes.

### M14 MATCHUP SPARRING - NEW (the amateur's camp partner; hooks into CLUBWEEK's pair picker and setting, TRAINING T4)
WHAT THE PLAYER DECIDES: in a fight week, one sparring evening "as <opponent>": a club mate whose style or stance matches the booked opponent's plays their
game (the pair picker shows "fights like Priya: counter-puncher" on a matching mate).
WHAT IT CHANGES: WeekOpp on the opponent's main game (CODE, today only a camp sets it); one tell opened on the file (CODE OppFile, as a camp's tape study);
against a southpaw with a southpaw mate, the never-faced-a-southpaw cost goes (CODE, the lefty week). It costs the mate's evening (their own training
that night as CLUBWEEK's setting gives), and the setting's tiredness and cut roll for both (CLUBWEEK 3.6). A professional's camp partner ($160) stays.
SHOWN: on the bill as the READY FOR THEIR STYLE forecast row; after the bout its row.
PROBE SPARAS1 on the played bout: 1.5 in 100 or more against the opponent it copies; else it keeps the tell and the southpaw answer only.

## 6. Every decision (B before the bout, D during, A after). The last column is the designer's test, never printed on a screen.
| When | Decision | Options and what each costs and gives | Right when (never on screen) |
|---|---|---|---|
| B, Monday | Which card on the sheet | strip line, stoppage risk, known leans or "?" | the card whose places this fighter wins, with known officials when the strip is close |
| B, the week | Pad card for a punch | 2.1 mastery an hour; the punch level in the duel; the strip moves (M3, M8) | the place the opponent wants is the one this punch decides |
| B, the week | The habit card (TRAINING T5) | 3 of your pad places to half, 6 to gone | the booked opponent's game punishes it |
| B, the week | Matchup sparring (M14) | a mate's evening and the setting's cut roll; WeekOpp, a tell, the southpaw answer | the opponent's game is one this fighter has not faced |
| B, the week | The fight-week shape (CLUBWEEK) | Rest up: full Legs, slow round 1; Tick over: sharp, Legs about 8 lower; Train through: sharp, Legs about 12 lower, all training kept | Rest up after a hard bout; Tick over against a slow starter |
| B, the plan | Which lines | Beats it / Works / Walks into it x grade x suit (M4) | the line takes the fight where this fighter wins |
| B, the bill | WHERE (M5) | Long / Mid-ring / Walk them down: guard against closing, the stoppage risk both ways | long when the strip wins at range and a Ring judge is known; walk down when the pocket or inside is yours and their power is low |
| B, the bill | The pace by round phase (built, M5's dial) | Push / Steady / Save: edge and the pace dial | Push early against a slow starter with the tank for it |
| B, the bill | The towel line (M13) | Careful / Normal / Brave | Careful for a chin under their power or a fighter stopped inside a year |
| B, the bell | Round 1 pace after the readiness read (M6) | Push / Steady / Save (built) | Push when SHARP and the opponent starts slow |
| D, each 30 s | Shout, pace, aim, NOW, Wait / Take (built) | as built | as built |
| D, the minute | ONE CHANGE: habit fix, Elbows in / Gloves high, or one step of WHERE | one only | the step when the strip has turned; the fix when the habit was paid twice |
| D, the minute | THE TOWEL when it comes (M13) | Pull them out / One more round / Box safe | pull when the risk is over the line and the bout is lost on the card; one more round when a round down with heart known high |
| D, before the last round | Push or save, read from the corner's card (M7) | Push +6 (to -12 on an empty tank) / Save -4 | Push when a round down with half a tank; Save when ahead |
| A, the result | Each row's button | Open the week / Season plan / Rest up / Spar as the next opponent / Put the habit card on / Open the plan / Replay the shouts / Change it on the next bill / Chin and defence mornings / Perk road | the biggest red row the player can act on |

## 7. Every menu it appears on, and what each is wired to (only what the player can act on; a graphic before any words)
| Menu | Shows | Wired to |
|---|---|---|
| Fights > the sheet card (CLUBWEEK) | one strip line ("wins at range, loses in the pocket"), the stoppage risk, the leans known or "?" | Duels.at, RingDuel.wins_breaks, AttrGen scouted range, Knockdowns, new Officials |
| Bout page > Full report | THE THREE PLACES (replaces the seven-stat rows) with every punch against its answer; the opponent's readiness "?" or their Legs | Duels, BoutCompare (rewired), OppFile, new PunchStart |
| Bout page > the bill | the forecast rows of the scales in exchanges (week, Legs, ready for their style, habit, plan, where and pace), WHERE with its price and stoppage risk, the towel line, the known leans | BoutRead (parts), new Aim, new Towel, Knockdowns, Judges, LeverSize |
| Fighter > Overview | WHERE THIS FIGHTER WINS against the division's four kinds, with the card that moves each, beside the build direction | Duels, AttrGen (kinds), RPG BuildDirection |
| Fighter > Fight prep | the strip, "moves it by Saturday" per place with the card's button, WHERE | MoveMastery forecast, WeekPlan forecast, Duels, Aim |
| Fighter > Week and Club week | on each pad card the punch level against their answer and its exchanges; each morning's strip move; the "fights like <opponent>" chip in the pair picker | Duels, MoveMastery, LeverSize, levers.json, new SparAs |
| Playbook > Fight plan | header: the strip and WHERE with prices; each line's "suits" chip beside the grade | PlanFight (suit), Duels, Aim |
| Weigh-in (fight day) | the judges' leans you know | Judges, Officials |
| Fight night > tale of the tape | readiness word in exchanges, the leans, WHERE, the towel line, Begin fight | new Readiness, Judges, Aim, Towel |
| Fight night > the round | the live strip on the corner card (tank and hurt included); a count marked | Duels.effective, RingDuel, Knockdowns |
| Fight night > corner minute | the corner's card (M7), ONE CHANGE incl. one WHERE step, the strip, THE TOWEL when it comes | Judges, coach rating, Aim, Towel, Knockdowns, CornerJobs |
| Fight night > result | the bout strip (18 tiles), THE SCALES (headline in row 1, true replay, bill ticks, buttons), perk and trait chips, THE COUNT when one happened, the three judges with one reason each, the places, what you did to them, who decides this fighter's fights, the rank earned, the Why in one line | new Scales, Judges, FightWhy, RankLine, Knockdowns record, BoutRead |
| History | each bout's scales and count card | the stored scales |
| Monday review | "Your choices this month: +N exchanges, R rounds, B bouts turned; Coach's week would have given +M", the strip's change | sums of the scales, CLUBWEEK's your week against Coach's, LEVERS1 |
| Character tab (RPG) | that fighter's rows joined to the ledger of picks (RPG 13); who decides this fighter's fights | Scales + Ledger |
| Handbook > What wins a bout | the target line and the lever table in exchanges | levers.json |
| A grappler's open result and record | the mat scales | BjjClash factors, new BjjScales |

## 8. THE HOOK TABLE (every effect, its tag, where it lands)
| Effect | Tag | Hook |
|---|---|---|
| The Legs on every bout; stale_energy retired | WEEK + CODE | CLUBWEEK 4 Legs rule -> BoutNight._peak (line 108) in place of BoutRules.stale_energy |
| NO_CAMP_EDGE professionals only | CODE | BoutRules.night_edge (line 200) |
| Canned camp and corner-call lines deleted | CODE | BoutRules.why (lines 280, 285) |
| Parts stored on every exchange | NEW | LiveRound.exchange rec["parts"] |
| Monday and signing snapshots (abilities AND mastery) | NEW | Clock Monday stop; Recruit signing; read in place of Sim._as_of |
| The duel split three ways | NEW | LiveRound.exchange: Duels.at on three attribute sets |
| Same-dice replay of each group | CODE pattern | plan_swing (LiveRound line 335) generalised; new Scales |
| The headline's true replay | NEW | BoutNight / Sim to result run from the bell with one group off, same seeds, recorded shouts |
| Bout strip, what you did to them, who decides | NEW | Scales |
| The bill's forecast rows | NEW on CODE | BoutRead walking parts; CLUBWEEK bill (WEEK) |
| Judges and leans | NEW | Judges rule in BoutNight.outcome_of / _finish, replacing BoutRules.scorecards |
| Officials known | NEW + WEEK | Officials (host of the show; CLUBWEEK favours with the host) |
| Three places strip and its label | NEW on CODE | Duels.at, RingDuel.mode_bias / wins_breaks, PLAYBOOK 4.7 PlanWhere counts |
| Where this fighter wins (Overview) | NEW | Duels against AttrGen's four kinds at the fighter's level |
| Suit on lines | NEW | PlanFight.edge / value, CoachPlan, BoutRead, FightWhy, PLACE_OF |
| WHERE | NEW | forward dial in Attrs; RingDuel.CALL_PLACE; PlanFight GAME_CARD |
| Pace moves the pace dial | CODE + NEW | PaceAim (built) + the pace dial in Attrs |
| Readiness and FORM_SD 3 | NEW on CODE | Readiness rule -> RingDuel.form mean and spread |
| The corner's card | NEW | Judges + coach rating; read by PLAYBOOK 4.5 PlanPhase |
| One punch rule for both corners | NEW on CODE | Data.fighter_state (START_MOVE_SHARE), AttrGen._attrs_build -> Attrs.lay |
| Habit state in the fight | WEEK + CODE | TRAINING T5 HabitWork -> HabitFix cost x1 / x0.5 / 0 |
| Pad and morning card sizes | WEEK + NEW | LeverSize (CLUBWEEK), levers.json |
| Camp night edge removed, weapons and combo counts cut, peak camp to readiness | CODE | BoutRules.PROTOCOLS, weapons_edge, Combos.edge, PeakCamp |
| THE COUNT record and card | NEW on CODE | Knockdowns.round_counts / puncher_chance results stored by BoutNight._counts |
| Counts re-rolled per group | CODE pattern | BoutNight._counts seed (day x 53 + n x 11 + ...) |
| The towel line and Coach's pull | NEW + WEEK | Towel; CLUBWEEK Coach's corner |
| The towel card, its three answers | NEW on CODE | CornerJobs (the minute), Knockdowns (risk, margin band for Box safe), Attrs.wear_stoppage skipped, Injuries (the eye) |
| Loyalty and the mark on the towel | WEEK (RPG) | RPG 3 Loyalty bands, RPG 9 Marks, RPG 5 knockout turn |
| Matchup sparring | NEW + WEEK | SparAs on CLUBWEEK pair picker and SparSet, TRAINING T4; CODE WeekOpp, OppFile, the lefty week |
| Lever table and the target | NEW | LEVERS1 tool, levers.json |
| The mat scales | NEW on CODE | BjjClash.factors |

## 9. The numbers (code or ESTIMATE; each ESTIMATE is set by its probe before a screen shows it)
| Number | Value | Source |
|---|---|---|
| Exchange luck | each dice x 66, triangle -66..66 | code EX_SPREAD |
| Form | mean = readiness -3..+3; spread 3 (was 5); world bouts 8 | ESTIMATE, FORM1 |
| Target shares | preparation 55-70, the night 20-30, luck 10-20 of every 100 exchanges turned; upsets 20-30 in 100 | ESTIMATE (trainer's rule), LEVERS1; upsets checked by John |
| WHERE step | 15 dial points; caps FWD_CAP 26, PACE_HOT 72 kept | ESTIMATE, AIM1; caps code |
| Pace dial shift | Push +15, Steady 0, Save -15 | ESTIMATE, AIM1 |
| Suit | clamp(1 + E / 10, 0.5, 1.5) on positive line worth only | ESTIMATE, RULE4 gate |
| Judges | clean x1 base; big shots +2; control +1 an exchange; initiative +1 a forward exchange won (amateur); work = pace gap / 10 (pro); the lean doubles its part; count 10-8 | ESTIMATE, JUDGES1 |
| Corner's card | right 60 + 0.3 x coach rating in 100, +5 with known leans | ESTIMATE, CARDREAD1 |
| Raw punch floor | 0.4 x the mean of Accuracy and Timing; opponents' punches reach their rating at 12 bouts | ESTIMATE, PUNCHFLOOR1 |
| Habit in the fight | x1 there, x0.5 half fixed, 0 gone | TRAINING T5 states; HABITDRILL1 |
| Towel lines | Careful 12, Normal 20, Brave 33 in 100 | ESTIMATE, TOWEL1 |
| Pulled out | 14 days out, no durability loss, morale -4; loyalty +2 / -6 by band | ESTIMATE, TOWEL1; loyalty RPG 3 |
| Stopped | durability ceiling -2 for good, 30 days (90 again inside 90) | code Attrs.STOP_DROP; CLUBWEEK |
| Count chance | 0.05 x margin x e^((power - chin) / 12) x (1 + damage / 60), three tries x0.6 | code Knockdowns |
| Referee stop | 0.2 x (1 + damage / 60) x (1.4 - heart / 100) x stop_mult | code Knockdowns |
| Exchange-to-chance bridge | 1 exchange in 18 about 6 in 100 near even (Handbook only) | ESTIMATE, LEVERS1 |
| Cut rule | 1.5 wins in 100 | operator rule |

## 10. To be measured before the build (on the played bout, never the harness's average; populations named; no screen before its table)
PARTS1 (parts sum to d within 0.01; every part has a group), SNAP1 (pads show in LAST 4 WEEKS), NOCAMP1 (widened: the Legs on every amateur bout, no
NO_CAMP_EDGE; 400 amateur bouts before and after), LEVERS1 with THE TARGET (first), JUDGES1, SCALES1 (season sums against switch-off probes, within 1.5 in
100), TRUEHEAD1 (the true replay and the same-dice row agree on the headline in 8 of 10 bouts; where they disagree the page says "probably"), PLACES1, RULE4
(with the Playbook map), AIM1 (three WHEREs x three paces), FORM1, CARDREAD1, PUNCHFLOOR1 (all four punches, both corners), HABITDRILL1, DAMAGE1, TOWEL1,
SPARAS1, CAMPNIGHT1, WEAPONCUT1, BJJSCALES1. Each prints its control arm first (today's game to the decimal, as fire_level_probe does).
GOLDEN PATH (Grok Dev): one test walks the build to the fight: sign a fighter, two weeks of mornings and pads (a hook card), a plan with two lines, WHERE, a
bout; it asserts the scales name LAST 4 WEEKS with a non-zero row that includes the hook's mastery, YOUR PLAN equals plan_swing, the judges' cards carry
reasons, and the result's buttons open the week, the plan and the pads. Then a NO-CAMP AMATEUR BOUT after a hard week asserts a non-zero LEGS row and no
NO_CAMP_EDGE part; then a BOUT WITH A COUNT (an open habit, a weak chin) asserts THE COUNT names power, chin, the damage and the habit's share, the
referee's roll as luck, and that the towel card came at the line; the test pulls the fighter out once and asserts no durability loss and 14 days out.

## 11. Build order, in small tasks (each under 500 lines, one owner, one test command)
1. NOCAMP1 widened (Claude, small, the defect first): the Legs on every bout in BoutNight._peak, NO_CAMP_EDGE professionals only, the canned lines deleted.
2. Snapshots (Qwen: pure Snapshot rule + test) and PARTS1 (Claude: LiveRound.exchange stores rec["parts"] and the three-way duel; core file, careful) ->
   Scales.gd pure module + test with the true-replay headline (Qwen).
3. LEVERS1 tool with THE TARGET (Arena, cloud) before any size goes on a screen; the knobs of 2.2 if a share misses.
4. Judges.gd + Officials (Qwen), wired in BoutNight.outcome_of / _finish (Claude); JUDGES1 (Arena).
5. PunchStart for both corners (Qwen) + PUNCHFLOOR1 (Arena); the ripple re-measured in one pass.
6. Readiness.gd + FORM_SD (Qwen); FORM1. Aim rule and the pace dial (Qwen) + AIM1; suit in PlanFight with the Playbook map's ANSWERS rewrite (one pair,
   one gate).
7. The count record and card (Qwen: pure CountCard from Knockdowns results) + DAMAGE1; Towel rule (Qwen) + TOWEL1; SparAs on the club week's pair picker
   once CLUBWEEK's SparSet exists + SPARAS1.
8. Screens, one per task from this map's drawing (Cursor; Claude checks the stills): result page, the strip component, the bill's forecast rows, Fight plan
   header, tale of the tape, the towel card, the Overview strip.
9. Corner's card (Qwen) + CARDREAD1; the mat scales; the golden-path test (Grok Dev); the Handbook page.

## 12. Risks, said plainly
- The judges change who wins rounds, and the punch rule changes every opponent: every balance number moves (plan_templates_test, BoutRead, CoachPlan, the
  career harness). JUDGES1 and PUNCHFLOOR1 run before the screens and the ripple list is re-measured in one pass.
- The target may force a cut to the corner's size (EDGE 17 -> 12). The corner then feels weaker; LEVERS1 shows it still turns 20 to 30 of every 100
  exchanges turned, which is the trainer's "saves close ones".
- The rows are first-order; only the headline is a true replay. SCALES1 demotes a row that disagrees with true switch-off probes to "exchanges only".
- A result page with eight rows, a count card and three judges can bury the one that matters: the headline is in row 1, rows under 1 exchange fold (not perk
  chips), and the count card replaces the places when it appears.
- Readiness can snowball (win -> mood -> sharper): capped at +3 and mood already moves both ways.
- The towel could become a solved pick: TOWEL1 requires one more round to win 1 in 5 or more at the shown risk.
- The Legs on every bout makes a hard week cost something on the amateur path for the first time: CLUBWEEK's shape picks (Rest up / Tick over) become the
  answer, which is the point; NOCAMP1 checks no fighter is worse off than today on a normal week.
- `suit` alone may not open RULE4: it ships only with the Playbook map's line table, under one gate.

## REJECTED (and why)
- "Wins in 100" per row on one bout's result: one bout has no probability; exchanges and rounds on the bout, the season in exchanges a bout.
- "Wins 6 in 10 here" on the strip (v2): a third unit that read as the bout's chance; now exchanges (2.1).
- A separate HOW BUSY pick beside the built Pace (v2): two controls for one thing; the pace now moves the dial (player critic).
- A true replay for every row: true replays do not add up, so the rows would stop summing to the exchanges won; the headline alone is re-run.
- A second headline flag above the rows and a three-line Why (v2): two lines saying the same thing; the headline is row 1, the Why one line.
- Folding perks and traits into "small things" (v2): it hid the RPG layer's rewards; each that fired gets a chip.
- Splitting the build at 28 days (v2): it blamed talent for the player's weeks 1 to 5; split at signing.
- A WORK lean on amateur panels: amateur scoring has no effective-aggression criterion; INITIATIVE instead.
- All three leans shown for every show (v2): knowing local officials is earned; only shows you know.
- Named judges with records now: the small world's job (S425); scoring honesty is the defect and comes first.
- A separate STOP IT card beside the cutman card, and a second towel in the RPG layer: one card, THE TOWEL, whose reasons include the eye; the RPG layer
  only sets the loyalty answer and the mark.
- Making ONE MORE ROUND always cost a lasting injury roll: it would make pulling out the only answer; the price is the stoppage's own (ceiling -2, days).
- Lowering the opponents' punches by a flat number: the fix is one rule for both corners, by bouts, so a seasoned opponent stays seasoned.
- Showing the opponent's form before the bell: it turns the night into a gamble the player cannot answer. Their Legs show (CLUBWEEK); their form is named after.
- Removing form altogether: a fight with no night-to-night variance reads scripted, and upsets are part of boxing. It is shrunk, earned and targeted (2.2).
- A free Aggression slider 0-100: one step of 15 around the fighter's own keeps the build in charge.
- A momentum meter: nothing the player does drives it; decoration.
- Per-punch selection sliders: the plan's lines and WHERE already say it, in boxing words.
- A "best plan" button: the game would play itself; Coach already writes a plan when none is written.
- Keeping the exchange-count cards with a better text: the text would still lie when the cleaner puncher loses.
- A separate hype slider: HYPE's Entertain and Safe set the pace, one control.

## FROM THE BUILD TO THE FIGHT FOR THIS VERSION (v3)
1. The defects first: the Legs on every bout (stale_energy retired), NO_CAMP_EDGE for professionals only, one punch rule for both corners, the canned lines
   gone, the snapshots that let the pads show.
2. BEFORE THE BELL: the card picked by its places and known officials, pads and the habit card priced in exchanges, matchup sparring, the shape, the lines
   that suit, WHERE with its stoppage risk, the pace that moves the dial, the towel line; all forecast on the bill as the receipt's own rows.
3. THE SCALES: every part stored and replayed on the same dice, four groups, eight rows, a button each, perk chips, the bout strip, the headline in row 1 by
   a true replay, the bill beside tonight, what you did to them, who decides this fighter's fights.
4. THE JUDGES: clean punches, big shots, ring control, initiative or work; a count is 10-8; the leans known where you know the officials; one reason a card.
5. THE COUNT: power against chin, damage carried in and who built it, heart, the referee's roll as luck, replayed per group.
6. THE TOWEL: the line before the bell, the card in the minute (count, damage, the eye, the line), pull out / one more round / box safe, priced exactly
   when you know their heart.
7. THE THREE PLACES in exchanges on the sheet, the bill, Fight prep, the plan, the minute and the result, and against the field on the Overview.
8. THE NIGHT EARNED, THE CORNER'S CARD, LINES THAT SUIT: readiness shown, the luck halved and named; one ahead-or-behind read for the corner and the plan.
9. THE TARGET and LEVERS1: preparation explains 55 to 70 of every 100 exchanges turned, the night 20 to 30, luck 10 to 20, set before the probe runs; one
   unit, exchanges, on every screen; the cut rule; the Handbook page; the mat's own receipt; one golden-path test that walks a count and a towel.

## LEFT FOR LATER
- Named judges with taste and history, and judges a promoter can lean on (the small world, S425).
- The professional's longer fights: judges' leans by commission, 10- and 12-round pacing in the corner's card, a towel for title fights.
- Opponents who read YOUR scales (a rival corner that saw your habit cost you; the Playbook map's IF READ, in full).
- A season-long "style report" chart on History (held back: the progress chart is on the held list).
- MMA's places (range, clinch, ground) on the same strip, and a towel and count card for MMA, after the first update.

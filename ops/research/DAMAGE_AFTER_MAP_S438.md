# DAMAGE AFTER THE FIGHT: what a bout leaves, the care, the next bout (design map, S438, round 3)
Author: Claude (lead designer). The AFTER half of DAMAGE1; the fight half (hits, places in the ring, the minute) is
DAMAGE_FIGHT_MAP_S438.md. This half starts at the final bell. EVERY NUMBER BELOW IS PRINTED BY `tools/damage_after_numbers.py`
(stdlib Python, fixed seeds, 543 asserts, about 10 seconds). Tags: CODE (file:line), REAL, TUNE.

## 0. The result of round 3, first (read this before the tables)
Round 3 changed the mechanic as directed: every answer is priced on the BOUT (win chance, the chance of being stopped or injured
on that place, days and shows missed), her weapon is a GUESS until known, four answers are four jobs on the ribs AND the face,
and the game's own weight, tiredness, morale, goal and camp lines are in the price. Then every decision was judged by REGRET:
how many training days a simple rule loses against the best answer, case by case, over a first amateur season.
- THE MONDAY CARE CARD FAILS THE BARS. The best one-thing rule loses 0.50 of a training day a case (bar 2.5); "always Train"
  loses 0.71 (bar 3); Spare is best in 11% (bar 15%). Three redesigns were run, none comes near (section 4.3).
- FIGHT PREP'S NEW ASKS FAIL THE BARS. Reading the place number loses 0.15 a case (bar 2.5).
- WHY, in plain words: in 5 to 12 days a sore place heals only a few points whatever you choose, so the four answers end
  close together. Where the stakes ARE big (a hurt rib against a body puncher), one look at the place number says what to do.
So, as directed, the bar is not lowered: the weekly care card is CUT as a player decision and becomes STANDING ORDERS the coach
applies (pre-filled, editable, priced); "Ask to move" and "Ask for another opponent" are CUT. What stays is a CONSEQUENCE
LAYER: one number per place that carries from bout to bout and is priced, in three prices, on the screens where the player
already decides (the offer, Fight prep, the weigh-in). On its own this half will not score 7 on depth; it should be judged as
part of the fight half, whose choices it prices. That call is the owner's (section 10, item 8).

THE CHAIN (kept): last bell -> the morning after -> each place gets a WORD from its number -> the coach's standing order works
or spares it, day by day -> the next offer shows the place with its three prices against that opponent -> Fight prep: Keep or
Pull out, Aim her carried place -> the weigh-in medical, with the risk shown -> the place STARTS the next bout at its number.

## 1. What is wrong today (read in the code)
| # | Today | Code |
|---|---|---|
| 1 | Places are made fresh for every bout; nothing a bout did reaches the next one | BodyMap.gd:21-28, :190-193 |
| 2 | Places exist only when the bout was watched in 3D; words mode and Sim carry none | BodyLive.gd:33-36; Injuries.gd:188-191 |
| 3 | The bout injury is ONE 6% roll, type by fixed weights, days a flat random range | InjuryRoll.gd:7, :20, :25-35 |
| 4 | The result page says "sore" but no rule reads it: no state, no date, no price | Aftermath.gd:74-99 |
| 5 | Fighting hurt is a flat 10 / 15 / 20 energy by days, not by place | Injuries.gd:33, :84-102 |
| 6 | The week does not know a place: no session is "on the ribs" | InjuryRoll.gd:136-154; Injuries.gd:208-226 |
| 7 | The S428 1-2 week amateur lead is agreed but not built (offers still 2-4 weeks); this map prices the S428 lead | AmateurBooking.gd:10-11 |

## 2. Words (one word per level; use only these)
| Word | Place number | After the last bell |
|---|---|---|
| fine | 90-100 | nothing to decide |
| sore | 56-89 | heals by itself; a session that works it slows that and can knock it |
| hurt | 36-55 | the same, knocked three to four times as easily |
| injured | 0-35 (or knocked under 56) | a named injury; fails the weigh-in until back at 56 |
- Settled bands 55 / 35 / 15 kept. Places: left eye, right eye, nose, left ribs, right ribs; the HEAD sets the stand-down only.
- RISK WORDS (round 2 floored 0% at "1 in 20"; fixed): under 1 in 50 (under 2%), 1 in 20 (2-7%), 1 in 10 (7-15%), 1 in 5
  (15-27%), 1 in 3 (27-42%), 1 in 2 (42-62%), 3 in 4 (62-85%), 9 in 10 (above).
- THE THREE PRICES on every place line the player can act on: WIN CHANCE with it ("51%"), STOPPED OR INJURED on that place
  ("1 in 3"; a guessed weapon shows its range: "1 in 20 to 1 in 2"), and IF IT GOES ("21 days, misses 2 shows").
- Numbers on screen only under 55 (settled S419): a sore place shows word, date and the three prices, never "forecast 70".
- KNOCK = a training session takes 25 off a sore or hurt place. Staff by role: Coach, Physio, Cutman, Doctor.

## 3. The mechanic
### 3.1 The morning after (kept)
Ribs get back 10% of what this bout took; a rib still hurt may crack (10 in 100 x (56 - number) / 20). An eye swells: it loses
a further 25% of what this bout took (the cutman the morning after stops that, 4.6). The nose stays as at the bell. An injured
place rolls light or serious (30 in 100 from the critical band, 70 from the doctor band; an open cut on an eye is serious).

### 3.2 Healing (T2; the round-2 hidden multipliers are now stated)
| Place | Points a day: sore / hurt | Sore 75 -> fine | Sore 60 -> fine | Light injury 25 -> fit (56) | Serious injury 25 -> fit (56) |
|---|---|---|---|---|---|
| eye | 2.0 / 3.20 | 8 | 15 | Swollen eye: x1.60 = 3.20 a day, 10 days (real 5-10) | Cut eye: x0.75 = 1.50 a day, 21 days (real 14-21) |
| nose | 2.4 / 3.12 | 7 | 13 | Bloodied nose: x1.30 = 3.12 a day, 10 days (real 5-10) | Broken nose: x0.50 = 1.20 a day, 26 days (real 21-35) |
| ribs | 1.4 / 1.96 | 11 | 22 | Bruised ribs: x1.40 = 1.96 a day, 16 days (real 10-21) | Cracked rib: x0.40 = 0.56 a day, 56 days (real 42-56) |
One rule in two parts: a HURT place heals at the light-injury pace (the same swelling, so a hurt place is never slower than an
injured one: asserted, the cost never drops as the number drops); a SORE place at the sore pace; a named injury at its own pace.
Physio hired x1.33 (built, StaffRoles.gd:19), a rest week x1.5, capped x2.0. Dates are whole days rounded up.

### 3.3 Four jobs per place (the ribs AND the face)
| Job | Ribs: what she does | Face: what she does | Heals on a worked day | Knock odds | Keeps of the work |
|---|---|---|---|---|---|
| Train | as planned | sparring as planned (headguard) | 40% | full | all |
| Protect | body protector in sparring, pads to the head mitts, bag at half pace ($75 once) | body-only sparring | 65% ribs / 75% face | a quarter | ribs 90/80/90% pads/bag/spar; face 60% of sparring |
| Spare | no body work: head-only sparring; pads and bag -> shadow and roadwork (combinations wait) | no sparring (technical bag rounds) | 100% | none | ribs 45/60/75%; face 30% of sparring |
| Rest | the whole fighter, one week off, then Spare | the same | 150% | none | 25% (built), burns 20%, morale +4 (built) |
Loads: an eye or the nose is worked by sparring only; the ribs by sparring, pads and the bag. The S428 fight week is light and
has no sparring, so a face is never worked in the last 7 days. Knocks a session: sore rib 3 in 100 sparring, 8 in 1,000 pads or
bag; hurt rib 10 / 3 in 100; sore eye 4 in 100 sparring, hurt 12. Chin under 55 x1.3, 70+ x0.7; overreached x3 (pack 4.1).
TRAIN ON A HURT PLACE is the best order in 17% of hurt cases: against a head hunter, or when her goal or her weight needs the work.

### 3.4 The bout from a carried place (T3b, 500 bouts a cell: stopped or injured on that place / days out if it goes)
| Place | start 100 | start 90 | start 80 | start 70 | start 60 | start 50 | start 40 |
|---|---|---|---|---|---|---|---|
| ribs vs a head hunter | under 1 in 50 / 0 | under 1 in 50 / 0 | under 1 in 50 / 0 | under 1 in 50 / 14 | 1 in 20 / 20 | 1 in 3 / 21 | 9 in 10 / 25 |
| ribs vs a mixed puncher | under 1 in 50 / 14 | under 1 in 50 / 14 | 1 in 20 / 23 | 1 in 10 / 19 | 1 in 3 / 21 | 3 in 4 / 29 | 9 in 10 / 41 |
| ribs vs a body puncher | under 1 in 50 / 19 | 1 in 10 / 22 | 1 in 3 / 22 | 1 in 2 / 23 | 9 in 10 / 26 | 9 in 10 / 43 | 9 in 10 / 64 |
| eye vs a head hunter | 1 in 20 / 14 | 1 in 10 / 14 | 1 in 3 / 15 | 1 in 2 / 20 | 3 in 4 / 23 | 9 in 10 / 27 | 9 in 10 / 32 |
| eye vs a mixed puncher | under 1 in 50 / 14 | 1 in 20 / 13 | 1 in 5 / 13 | 1 in 3 / 17 | 3 in 4 / 20 | 9 in 10 / 25 | 9 in 10 / 31 |
| eye vs a body puncher | under 1 in 50 / 0 | under 1 in 50 / 0 | 1 in 20 / 10 | 1 in 10 / 13 | 1 in 3 / 16 | 3 in 4 / 21 | 9 in 10 / 25 |
"Stopped" = the place reaches the doctor band (15) in the bout: the referee or doctor stops it, a loss and a 28-day stand-down.
The weapon prices the two places the opposite way (asserted): a body puncher threatens the ribs, a head hunter the eye.
THE WEIGH-IN MEDICAL: she fails if a place is injured, or an eye or the nose is under 65. A rib at 56-60 passes, but against a
body puncher it is "9 in 10": the weigh-in modal shows that line in red with Pull out on it (round 2 let "fit" read as safe).

### 3.5 What a bout leaves (T3, 4,000 bouts; landed on her 36/63/90 at 35/40/25%; pool head hunter / mixed / body 35/40/25%)
| Landed on her | Bouts | Ribs sore or worse | Eye or nose under 80 | A place hurt or worse | Place injuries per 100 |
|---|---|---|---|---|---|
| 36 | 1393 | 63% | 64% | 1% | 0.0 |
| 63 | 1607 | 86% | 98% | 34% | 0.5 |
| 90 | 1000 | 94% | 100% | 94% | 14.5 |
| all | 4000 | 80% | 87% | 37% | 3.8 |
Injuries per 100 bouts, counted one by one (round 2 counted bouts): eye 2.4, nose 1.1, ribs 0.4; head knock + hand (InjuryRoll)
3.3; all 7.1 (REAL about 6, Alevras 2022; asserted 4-8).

### 3.6 The price, in TRAINING DAYS (1 = the gains of one full training day; the hidden per-point price of round 2 is gone)
| What | Training days | From the game |
|---|---|---|
| A win instead of a loss | 12 | morale +8 / -12 (FighterProfile.gd:19-20), members +8 / -1, reputation +5 / -2 (pack 4.13; BoutRules.gd:96-97), a ladder place |
| A show missed | 9 | the $450 ticket cut (built) and the bout |
| Pull out / weight missed | 15 | $300 (Injuries.gd:11; BoutRules.gd:88 MISSED_WEIGHT_COST) = 6, plus the show |
| A day out | 1.39 | trains at a quarter (Injuries.gain_mult) and a show every 14 days slips |
| A stoppage on a place | the loss + 28 days out | + 1 member, 2 reputation more (BoutRules.gd:98-99) |
| Her goal line slips | 6 | goal met +10 / missed -20 morale (FighterGoal.gd:29, :31); the line: "Power +0.8 of +1.1, goal missed 1 in 5" |
| Weight | 15 x the chance of missing | the burn a lost session would have made (WeekPlan.gd:69 KCAL_PER_KG, :74 CUT_DEFICIT) |
| Tiredness on the night | 0.4 in 100 win per energy point | BoutRules.gd:34-36 (2 energy a point over 50, at most 20); overreached gains x0.6 (WeekPlan.gd:77-78) |
| No sparring before the fight week | 3 in 100 win | timing (TUNE) |
| PEAK CAMP lost (a spared week misses the stat or tiredness line) | 4 in 100 win | PeakCamp.gd:12 BONUS +1 every stat |
| Rest week morale | -0.8 | rest_week +4 (FighterProfile.gd:24); overruling her ask -5 = 1.0 (:30) |
| Body protector | 1.5 once | $75 at $50 a training day |
The game shows the INPUTS (the three prices, the stat line, the weight line, tiredness, her wish), never a cost or a "best".

### 3.7 Her weapon: a GUESS until it is KNOWN
The style word (built) gives the guess, in 100: Out-boxer head 70 / mixed 25 / body 5; Counter-puncher 55/35/10; Boxer-puncher
25/50/25; Volume puncher 20/45/35; Pressure fighter 10/35/55; Slugger 15/40/45. KNOWN after tape study, the Ex-pro head coach's
tell (built, pack 4.6: the weapon opens first) or her last bout filmed and watched. A guess shows the RANGE of the risk.

## 4. The decisions, judged by regret (all from the script; a season = 3 boxers, 26 weeks, 40 seasons drawn)
### 4.1 How often a carried place meets a Monday (T4; Mondays in 26 weeks, of them real decisions in brackets)
| Place (the worst one) | Bout in 5 days: Mondays (decisions) | Bout in 12 days: Mondays (decisions) | No bout booked: Mondays (no decision: it heals, the next offer prices it) |
|---|---|---|---|
| eye hurt | 0.0 (0.0) | 0.5 (0.5) | 2.4 |
| eye injured | 0.0 (0.0) | 0.1 (0.1) | 0.5 |
| eye sore | 3.4 (3.0) | 2.1 (2.1) | 9.6 |
| nose hurt | 0.0 (0.0) | 0.3 (0.3) | 1.2 |
| nose injured | 0.0 (0.0) | 0.1 (0.1) | 0.5 |
| nose sore | 1.6 (1.5) | 1.1 (1.1) | 5.4 |
| ribs hurt | 0.5 (0.5) | 0.8 (0.8) | 3.1 |
| ribs injured | 0.0 (0.0) | 0.0 (0.0) | 0.1 |
| ribs sore | 7.8 (6.8) | 3.8 (3.8) | 14.6 |
Bouts 23.7 a season; Mondays with a carried place 59.3; real decisions (a bout booked, answers a training day or more apart) 20.7.

### 4.2 The Monday care decision (T5, 829 decision cases)
| Rule | Best answer in | Regret a case (mean +- standard error) |
|---|---|---|
| always Train | 53% | 0.71 +- 0.04 |
| always Protect | 17% | 1.16 +- 0.04 |
| always Spare | 11% | 1.50 +- 0.06 |
| always Rest | 19% | 5.17 +- 0.20 |
The best ONE-THING rule per visible thing (for each value, the answer cheapest across its cases; fitted on these very cases):
| Reads only | Regret a case |
|---|---|
| protector owned | 0.50 +- 0.04 |
| place number (5s) | 0.53 +- 0.03 |
| place | 0.56 +- 0.03 |
| her wish | 0.59 +- 0.04 |
| goal chip | 0.66 +- 0.04 |
| her weapon (or style word) | 0.70 +- 0.04 |
| tiredness, days to the bout, weight, chin, camp, physio hired | 0.70-0.71 +- 0.04 |
Two-thing rule (place number x her weapon or style word): 0.41 +- 0.03. BARS: one-thing 2.5, always-the-most-common 3, every
answer 15%+: NOT MET. The script gates it: `CARE_CARD_IS_A_DECISION` may only be True if the bars pass (asserted).
GUESS vs KNOWN (T5b): 69% of decision cases are a guess. Knowing the weapon changes the best answer in 19.8% of them (bar 20%:
not met) and saves 0.13 +- 0.02 a case; Watch the tape costs a pad night (0.88), so on the damage alone it does not pay (-0.74).
The tape's value stays where it is built: the tells in the fight plan. `TAPE_PAYS_FOR_DAMAGE` is gated the same way.

### 4.3 Redesigns tried before cutting (each re-run by the script; the best one-thing rule's regret, bar 2.5)
| Change | Best one-thing rule: regret a case |
|---|---|
| the care answer and the bout action as ONE plan (16 plans, 886 cases) | place number (5s): 0.73 +- 0.04 |
| every weapon KNOWN (tape on every opponent) | place number (5s): 0.61 +- 0.06 |
| every stake doubled (a win, a show, the goal line) | place number (5s): 0.88 +- 0.07 |
The goal and weight costs are already sharp lines (met or missed), not weights. The cause is physical, not a wording: 5-12
days move a place a few points whatever the answer, and where the stakes are big the place number alone says what to do.

### 4.4 What replaces the card: STANDING ORDERS (T5c), written once on the Coach card
One order per situation: place word x days to the bout x her weapon or style word (97 situations), e.g. "hurt ribs, bout in 5
days, Pressure fighter -> Spare". Pre-filled with each situation's best order. The best orders cost 0.44 +- 0.03 a case against
reading every case; leaving the coach's "Train" everywhere instead costs 0.27 +- 0.04 a case more (5.6 training days in 26
weeks): writing orders is a small decision with a real number. With an order everywhere the Monday board never opens; a player
who clears every order meets it 20.7 times in 26 weeks and gains 9.0 training days a season. The week review says what each
order did ("Spare on the right ribs: 66 -> 81 by fight night; Power +0.8 of +1.1").

### 4.5 Fight prep (T7, the last Monday, opens at a night's risk of 1 in 5+ or a likely weigh-in fail: 3.5 times in 26 weeks)
| Action | Best in | Regret a case if always taken |
|---|---|---|
| Keep | 21% | 1.03 +- 0.20 |
| Ask to move 14 days (yes 6 in 10; a NO tells their corner) | 20% | 1.27 +- 0.14 |
| Ask for another opponent, same show (yes 4 in 10) | 58% | 0.43 +- 0.20 |
| Pull out ($300 + the show) | 1% | 7.22 +- 0.20 |
Best one-thing rule (place number): 0.15 +- 0.03 a case. BARS NOT MET: "Ask to move" and "Ask for another opponent" are CUT
(`FIGHT_PREP_ASKS` gated). Fight prep keeps Keep / Pull out (built), now with the three prices, and the Aim line (section 7).
The offer keeps Accept / Pass (built) with the three prices.

### 4.6 The cutman the morning after ($40 a call; the eye skips its overnight swelling) (T10)
| Eye cases (the morning after) | Cases | Worth its $40 |
|---|---|---|
| a bout booked | 69 | 57% |
| no bout booked | 277 | 37% |
So it is an order line, on by default when a bout is booked ("call the cutman for an eye when a bout is booked").

## 5. A Monday, played (T6; read this to see what the player sees)
Ana boxed Saturday. Monday morning her right ribs read 66: sore. Her next bout is in 12 days against Mensah. Mensah is a
"Pressure fighter"; nobody has seen her box, so her weapon is a GUESS: of 100 Pressure fighters about 55 go to the body. Ana is
cutting weight with 0.3 kg to spare, her goal "Power +2 by month's end" is on track, and she is tired (64). The four jobs, as
the order editor shows them for her (the three prices first, then what each costs her elsewhere):
| Answer | Win chance | Stopped or injured on the ribs (the guess's range) | If it goes | Power by fight night | Weight on the day | Tiredness on the night | Ribs on the night | Cost on the guess | Cost if KNOWN head hunter / mixed / body puncher |
|---|---|---|---|---|---|---|---|---|---|
| Train | 51% | 1 in 3 (1 in 20 to 1 in 2) | 21 days, 2 shows | +1.1 of +1.1, goal missed under 1 in 50 | 0.30 kg under | fresh | 73 sore | 9.7 | 1.1 / 3.5 / 15.2 |
| Protect | 53% | 1 in 3 (under 1 in 50 to 1 in 2) | 22 days, 2 shows | +1.1 of +1.1, goal missed under 1 in 50 | 0.30 kg under | fresh | 77 sore | 10.4 | 2.5 / 4.0 / 15.9 |
| Spare | 54% | 1 in 5 (under 1 in 50 to 1 in 3) | 22 days, 2 shows | +0.8 of +1.1, goal missed 1 in 5 | 0.23 kg under | fresh | 81 sore | 9.8 | 3.8 / 4.5 / 14.2 |
| Rest | 8% | 1 in 10 (under 1 in 50 to 1 in 5) | 22 days, 2 shows | +0.5 of +1.1, goal missed 9 in 10 | 0.13 kg OVER | fresh | 86 sore | 23.6 | 23.0 / 23.1 / 24.0 |
Reading it: Rest heals the ribs most, but a week without training leaves her 0.13 kg over the limit, so she would likely miss
weight and not box at all (win chance 8%). Spare heals the ribs to 81 and halves the risk, but loses combination work, so her
goal may slip. Train keeps everything and leaves the ribs at 73. On the guess, Train and Spare cost the same within a tenth of
a day (9.7 and 9.8); if the tape showed a body puncher, Spare would be right; if mixed or a head hunter, Train. That is the whole
decision and its size: about one training day either way. The cost columns are the script's, never on screen.

## 6. The menu table (every screen the place appears on, what each is wired to)
Body pictures: the place is the TINTED MUSCLE on the game's own figure with a HOOKED LEADER LINE out of the body to its word and
date (BodyCallouts.gd, CalloutLine.gd); never blobs on the chest. New pure module: `scripts/rules/PlaceCare.gd`.
| Screen | Element | Wired to | The act | Test |
|---|---|---|---|---|
| Result page, DAMAGE tile | figure: carried places tinted, hooked line "Right ribs: sore, fine Mon 30"; an injury names itself and its fit range | AfterFight.gd -> PlaceCare.morning(map) -> f["places"] | "Her care orders" opens the Coach card at her line | place_care_test, golden |
| Coach card > Care orders (new tab) | one line per situation, pre-filled; picking a line shows the four jobs with the three prices for her place now (section 5's columns 1-8) | PlaceCare.orders on Career; PlaceCare.prices(f, job, opp_dist) | edit an order; "Call the cutman" line | care_orders_test |
| Fighter page > Week | sessions that work a carried place tagged "works the right ribs"; the order's swaps shown | PadWeek / WeekPlan read PlaceCare.session(f, dow) | edit the week as today | week_spare_test |
| Week review (modal) | "Order: Spare on the right ribs (sore, bout in 12 days, Pressure fighter): 66 -> 81; Power +0.8 of +1.1"; a knock: "Sparring Thu: right ribs knocked, 51 -> 26" | WeekActual log <- PlaceCare | none (cause shown) | place_care_test |
| Fighter page > Overview, BODY row | figure with hooked lines, word, fine date; hover: the three prices vs the booked opponent | f["places"], PlaceCare.prices | opens her order line | golden |
| Roster cards, Condition tile | the worst place: "Right ribs sore, fine Thu 12" | RosterCards.gd <- f["places"] | opens her page | roster_tile_test |
| Fights > offer card | "Right ribs on the night: win 51%, 1 in 3 (1 in 20 to 1 in 2: weapon a guess), if it goes 21 days"; her carried place if her last bout was filmed: "Mensah: right eye sore, cut 9 days ago" + "Write it in the plan" | OfferCard.gd <- PlaceCare.prices(f, bout_day, opp_dist); rival record | Accept / Pass (built); write the Aim line | offer_prices_test |
| Fight prep | the three prices per carried place; Keep / Pull out ($300, built); "Aim: her right eye" plan line | FightPrep.gd <- PlaceCare.prices; Injuries.pull_out; Playbook | decide; write the line | bout_prices_test |
| Weigh-in modal | THE MEDICAL: pass, "fails: right eye 61", or "PASS - right ribs 9 in 10 vs her" in red with Pull out | WeighIn.gd <- PlaceCare.medical(f) | Pull out or box | golden |
| Club > Money | body protector $75 (once); cutman calls this month | GymSpend.gd lines | buy | money_lines_test |
| Fight (first bell) | each place starts from its carried number | the fight half reads f["places"] | (fight half) | one_map (fight half) |
| History | per bout: places that ended hurt or worse, any injury, the order that ran | BoutHistory.gd <- the saved morning map | none | golden |
Removed: the "Fight hurt" button and its flat energy (Injuries.gd:33, :93), once his yes (section 10, item 2).

## 7. The hand-over to the fight half
IN at the final bell: each place's number (0-100), cut flags, the head-stoppage flag, the HEAD place, places that ended hurt or
worse. OUT at the next first bell: f["places"] = {place: {v, word, injured, sev, known}}; the fight starts each place at v.
Aim her carried place (T9, the fight half to measure who wins), a "Write it in the plan" line from the offer or the rival file:
| The opponent | Injured at the bell, our own game | Aim: her right eye (plan line) |
|---|---|---|
| her right eye starts 85 | 12 in 100 | 35 in 100 |
| her right eye starts 75 | 31 in 100 | 55 in 100 |
| her right eye starts 65 | 56 in 100 | 73 in 100 |
FINDINGS FOR THE FIGHT HALF: (1) the carried round cap (25 from 100 down to 15 from 60) keeps T3b near real; if it moves, T3b
moves. (2) The three win-chance terms here (4 in 100 a peak camp, 3 in 100 sharpness, 0.15 in 100 a point under 90 for guarding a
place) are guesses until the fight half measures them. (3) Her weapon must be handed over as a body share (10 / 22 / 45%).
(4) Elbows in is the fight half's ONE CHANGE; this half no longer prices it (round 2's face-cost line was a sampling artefact).
(5) Rib injuries per 100 bouts are 0.4 against a real share nearer 0.6.

## 8. Numbers (TUNE ranges)
| Constant | Value | Range | Src |
|---|---|---|---|
| Ladder; face medical | fine 90, sore 56, hurt 36, doctor 15; face under 65 fails | 60-70 | settled 55/35/15; SHAPED |
| Points a day sore eye / nose / ribs; hurt and light injury x | 2.0 / 2.4 / 1.4; 1.6 / 1.3 / 1.4; serious 0.75 / 0.5 / 0.4 | +-20% | REAL layoffs (T2 asserts) |
| Heal on a worked day: Train / Protect | 40% / 65% ribs, 75% face | 30-50 / 60-85 | TUNE |
| Knock: sore spar / pads-bag; hurt; drop | 3 / 0.8 in 100; 10 / 3; 25 | +-50% | TUNE |
| A win; a show; a day out; goal line; a training day | 12; 9; 1.39; 6; $50 | 8-20; 6-12 | game values (3.6) |
| Stand-down after a stoppage on a place | 28 days | 21-30 | REAL amateur RSC |
| Weight line wobble; goal line wobble | 0.05 kg; 0.5 units | | TUNE |
| Ex-pro coach; other known; last bout filmed | 25% / 7% / 50% | | pack 4.6; TUNE |

## 9. Build order (pure module + unit test first, one screen per task, files under 500 lines, boxing only)
| # | Task | Seat | Owns | Test (red on main first) | After |
|---|---|---|---|---|---|
| 1 | PLACECARE1: words, morning, pace, the four jobs, knock, the three prices vs a weapon or a guess, medical, orders | Qwen | scripts/rules/PlaceCare.gd (new, <400) | tests/place_care_test.gd copies T1, T2, T3b rows, the medical, the monotone cost, the order lookup | none |
| 2 | CARRY1: f["places"] written every bout, healed daily by the order, knocked in end_week; InjuryRoll keeps head and hand only | Arena | state/Injuries.gd, InjuryRoll.gd, one call in Injuries.day_tick | tests/carry_places_test.gd: a hurt rib on Saturday is sore on Wednesday and starts the next bout below 100 | 1, the fight half's ONEMAP |
| 3 | Coach card > Care orders + week tags + week review lines | Cursor | ui/CoachOrders.gd, WeekDay.gd / PadWeek.gd reads | care_orders_test, week_spare_test | 2 |
| 4 | Offer prices + Fight prep prices + weigh-in risk line + rival places + Aim line | Cursor | OfferCard.gd, FightPrep.gd, WeighIn.gd, rival file | offer_prices_test, bout_prices_test | 2 |
| 5 | Result DAMAGE tile, Roster tile, Money lines, History | Cursor | AftermathTiles.gd, RosterCards.gd, GymSpend.gd, BoutHistory.gd | roster_tile_test, money_lines_test | 2 |
| 6 | GOLDEN: a body puncher leaves the right ribs hurt, the order Spares them, the offer shows the three prices with a guess range, Keep, the weigh-in shows the line, the next bout starts the ribs at their number, History names the order | Grok Dev | tests/golden_care_path.gd | itself, then the .exe | 3-5 |
Every screen task starts from a drawn 1920x1080 mockup (the order editor first); Claude opens every still. New features ship ON
(GameSwitches.GAME_ON); plain --script tests stay the OFF arm. Before 2: John sources rib layoffs and England Boxing's medical rule.

## 10. Needs the owner's yes (on the board with --attach before task 2; nothing here is built as fact before his answer)
| # | Reopen or add | One-line reason |
|---|---|---|
| 1 | A fourth word, SORE (56-89), inside the settled "fine over 55" band; fine narrows to 90+ | without it a bout leaves nothing to carry |
| 2 | "Fight hurt" (Q-S294-46, flat 10/15/20 energy) replaced by the carried number + the weigh-in medical | the place itself starts the bout |
| 3 | The 6% bout roll stops deciding eyes, nose and ribs (head and hand keep it) | the place watched is the place injured |
| 4 | Money lines: body protector $75 once; cutman morning-after call $40 | new spending |
| 5 | Care orders on the Coach card: a new kind of player rule (set once, the coach acts) | replaces a weekly card that measured as a lookup |
| 6 | The weigh-in doctor fails an eye or the nose under 65 (today: under 56); a passing place shows its risk with Pull out | stricter medical; real doctors stop a closing eye |
| 7 | The lead's "Ask to move" and "Ask for another opponent" are NOT built: measured as lookups (4.5) | the bar wins over the brief |
| 8 | The after half is judged with the fight half, not as its own 7+ mechanic | measured: its decisions are worth under a training day each (4.2-4.5) |

## 11. Left for later (named so no one builds it by accident)
Hands as places; the BJJ athlete's strains; the habit "hides pain"; per-day exceptions inside an order; choosing the sparring
partner for a carried place; heal pace by age; scars; healing faces in 3D and portraits; headguard modelling; repeat injuries
to the same rib; pro camps (re-run T5 before: a 6-8 week camp may give the care decision the stakes an amateur fortnight lacks).
For the critics: score depth and clarity for the AFTER half; check any table with `python tools/damage_after_numbers.py`.

## Changed in round 3
- Every decision is judged by regret in training days with standard errors; the share asserts are gone; the bars are gates.
- Every answer carries three prices: win chance, stopped or injured on that place, days and shows missed if it goes.
- Her weapon is a GUESS from the style word (a range of risk) until tape, the Ex-pro coach or a filmed bout makes it KNOWN.
- Four jobs per place on the ribs AND the face (Protect = body protector / body-only sparring; Spare = no work on the place).
- The cost counts the game's own lines by file: goal met/missed morale, weight and the $300, tiredness, peak camp, rest-week morale.
- Risk words start at "under 1 in 50"; T2 states the injury paces; a hurt place heals at the light-injury pace; the night's
  cost never drops as the number drops (round 2's medical-fail error, asserted on every number).
- Injuries counted one by one; small samples gone (Fight prep 138 cases); Elbows in handed back to the fight half.
- CUT after three redesigns: the weekly care card (now standing orders), Ask to move, Ask for another opponent, the check
  (guess / look / X-ray, met under once a season), the physio session and its clinic slots.
- Added: the weigh-in's risk line with Pull out; the cutman the morning after as an order line; "A Monday, played".

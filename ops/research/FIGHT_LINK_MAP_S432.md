# FIGHTLINK3: from the build to the fight - map v2 (S432)

The operator's ask (S432): "do the same for the most important aspects of the game that affect the loop like building the fighter and the coach, playbook,
training and how these 2 impact fight, need reviewed them all and properly strenghen and add mechanics".
This map is the LINK: how the fighter you build (attributes, punches, traits, habits, perks, style) and the week you run (training, tiredness, pads) become
the result of a bout, and how the player SEES which choice won or lost it. It does not redesign its neighbours; it hooks into them:
- the week and the fight week: `CLUBWEEK_MAP_V41_S432.md` (pad places, the Legs, the bill's one number, the habit pull, LeverSize)
- coach growth, perk versions, traits, build direction, the ledger of picks: `RPG_LAYER_MAP_S432.md` (sections 2, 5, 6, 12, 13)
- training sessions and their value: `TRAINING_MAP_S432.md` (in progress; this map only names the hooks it needs)
- the plan's line table, FireLevel, Plan B, the opponent adapting: the Playbook map in progress (critics `pb_coach`, `pb_tactics`)
- hype and the night's word (Entertain / Box smart / Safe): `HYPE_MAP_S432.md` section 4.4
Read for this map: CRITIC_PACK, CRITIC_ACCESS, both critic reviews (`docs/mockups/s432/critics/fl_judge_review.md` 5.5, `fl_simdesign_review.md` 6), the
code (LiveRound.exchange, RingDuel, Duels, Attrs, Exchanges, PlanFight, FireLevel, HabitFix, PerkFight, PaceAim, TheRead, CornerJobs, BoutRules, BoutNight,
FightWhy, Data), RULE4_PARKED_S398, the real result screen (`critic_pack/screens/21_result_real.png`). Nothing was run. Numbers marked (code) are read from
constants; (measured) are from earlier probes in the research notes; ESTIMATE is a design value a probe must set before a screen shows it.
Drawing: `docs/mockups/s432/fightlink_v2.html` / `.png` (the result page with the scales, the judges and the three places).

## 0. What the two critics found, and the answer here
| Critic point (both unless named) | Answer in this map |
|---|---|
| The player cannot tell which choice won or lost; the Why grades only the plan; "What decided it" is canned | M1 THE SCALES: every part of every exchange stored, replayed on the same dice with each group taken out, ranked, one button a row |
| The cards are a formula (every 2-1 is a split; out-landed 61 to 56 and lost all three cards); the count line is false | M2 THE JUDGES: rounds scored from clean punches, big shots and ring control; a count is 10-8; three leans |
| One plan fits almost everyone (RULE4 open since S397) | M4 LINES THAT SUIT (the build's half) + the Playbook map's line table (its half); one shared gate |
| The style dials decide where the fight happens and no screen shows or sets them | M5 THE NIGHT'S AIM: Where and How busy, each one step of 15 around the fighter's own |
| Form on the night: spread about 7, hidden, as big as 5 points of training | M6 THE NIGHT, EARNED: readiness moves it, the spread halves, it is shown before the bell and named after |
| No matchup read that names the punch and the answer | M3 THE THREE PLACES strip, on every screen of the fight's road |
| Corner has no read of the cards before round 3 (judge) | M7 THE CORNER'S CARD, right as often as the coach is good |
| Pads are the biggest week lever but "Hook 33" is never set against "their guard 58"; uppercut starts at 0 | M8 WHAT THE WEEK BUYS ON SATURDAY |
| Camp night edge, weapons count, combinations known, peak camp: each under 1 point, listed as reasons | M9 HONEST SMALL LEVERS (cut, merge or size them) |
| Every "worth about" should come from one measured table | M10 LEVERS1 and the Handbook page "What wins a bout" |
| The BJJ match needs the same receipt | M11 THE SCALES ON THE MAT |

## 1. The idea in eight lines
1. Every exchange already is one number (the edge) plus dice. Keep it; store each part of that number.
2. After the bout, take each group of parts out in turn on the same dice (as `plan_swing` does today) and show what each turned: exchanges, rounds, the result.
3. Four groups the player reads at a glance: YOUR WEEK, YOUR NIGHT, WHO THEY ARE, LUCK. Each row has one button that acts on it.
4. Rounds are scored the way a judge scores them, so "who landed cleaner" and "who kept the ring" mean something, and a step back can lose a round.
5. Before the bout the same parts are shown as a forecast: the three places, your tool against their answer, and what this week can move by Saturday.
6. The plan's lines are worth more when they take the fight where YOUR fighter wins (the build shapes the plan).
7. The night's aim (where, how busy) is the player's, priced by the duel's own costs; form is earned by the week, not rolled in the dark.
8. Anything that moves less than 1.5 wins in 100 over a season is cut or merged, and every size on screen reads from one lever table.

## 2. How the build decides the fight today (traced in the code)
One exchange (30 s; 18 a 3-round bout): `LiveRound.exchange` sums the edge `d`, then `Exchanges.settle(d, roll_a, roll_b)`: margin = d + (roll_a - roll_b) x 66
(code EX_SPREAD). Each side's dice is flat, so the luck in one exchange is a triangle from -66 to +66 (spread about 27). An edge of +5 wins about 57 exchanges in 100.
| Part of d | Code | Size in one exchange | Fed by | Verdict |
|---|---|---|---|---|
| The duel at the place it is fought | RingDuel.step -> Duels.at, K 0.5 | +5 for a fighter 5 better everywhere (measured: +5 wins 72 in 100, +10 about 95) | 14 abilities + 4 punch levels (= move mastery, Attrs._punches) + pace and forward dials, reach, height, stance; tired and hurt copies | THE BACKBONE. Shown as one line of words on the round report; not on the result |
| Form on the night | RingDuel.form, FORM_SD 5 | gap spread about 7, fixed for all 18 exchanges | nothing | LUCK, HIDDEN, too big |
| Corner shout | Exchanges.call_edge: best 17, ok 5, wrong -10 x can-do (1.0 / 0.6 / 0.3) x uptake (coachability 0.7-1.0, halved after 2 shouts) x trust (morale 0.7-1.05) | +12 to +14 right, about -15 wrong | Fight IQ, punches, coachability, morale, Ring general x1.25 | REAL, the biggest single lever |
| Plan line | PlanFight.edge best 9, ok 3, wrong -7, less the card's mean; PlanRead +3.5 x2; PlanPressure +3 | up to about +16 stacked | ANSWERS (opponent's game only), drilled or not | REAL, but one plan fits most (RULE4) |
| Open habit | HabitFix 6 x HABIT_BOUT 1.75 | about -10.5 when punished | the habit list; the corner's fix x uptake | REAL, never sized after the bout |
| Pace and aim | PaceAim: Push +6 (to -12 on an empty tank), Save -4, hurt aim +4, body on a tired opponent +3 | 3 to 6 | shouts | REAL |
| The Read, the set-up | TheRead +7 / -5; CornerJobs set-up +14 / -9 | one exchange each | Fight IQ, film, temperament; combination mastery | REAL |
| Legs (week tiredness) | BoutRules.stale_energy: -2 energy a point over 50, max -20 | through the duel's tired copy: legs and guard -12 at empty | the week | REAL, the week's best link |
| Camp night edge | PROTOCOLS 0.25 / 0.6 / 1.0; NO_CAMP_EDGE -1.5 | under 1 (no camp: -1.5) | camp (pros) | DECORATION as a number; see defect 4 |
| Film | FILM_PER_ANSWER 0.4, max 1.2 | about 1 | tells the plan answers | small; its real value is the plan and The Read |
| Weapons count, combinations known | WEAPON_EDGE 0.3 per weapon over 4, max 0.9; Combos.edge max about 0.6 | under 1 | moves at 30+, combos | DECORATION, counted twice (punches are already in the duel) |
| Peak camp | PeakCamp +1 every stat | about 0.5 | camp lines met | near decoration |
| Perks | PerkFight: Stiff jab +3, Ring general x1.25, Counter sense 3 in 10 a +12 counter, Second wind +10, Finisher x1.5, Fast hands x1.4 | 1 to 4 when they fire | thresholds (PerkRoad) | REAL, small; one round line |
| Traits | coachability, morale as trust, heart at the count and the fade, temper / confidence / discipline in the talk and the read | a few points | personality | REAL, hover only |
| Style dials | FighterProfile.style_dials -> Attrs pace / forward -> Duels (FWD_GUARD 0.28 a point, FORWARD_CLOSE 0.55, PACE_WORK 8, PACE_GUARD 6, PACE_COUNTER 15) | decide WHERE the fight happens | rolled at signing | REAL and HIDDEN: no screen reads or sets them |
Then `Exchanges.round_of`: the round goes to whoever won more of its six exchanges; `BoutRules.scorecards(rounds_won)` writes three cards from that count.
The shown chance (BoutRead) walks the same duels and stayed within 6 in 100 of played bouts in the eight checked cases (FIGHTER_MODEL_S397).

DEFECTS FOUND IN THE CODE (fix first, whatever else is built):
1. `BoutRules.why` writes "The camp: conditioning held up when it mattered" for every Standard or Hard camp, won or lost. Canned.
2. `BoutRules.scorecards` builds cards from rounds won only: every 2-1 is a split by formula, every 3-0 unanimous, and FightWhy's "a standing count: that round
   went wide on the cards" is false (a count never changes a card). Rounds go to the side that won more 30-second exchanges, not to cleaner punching, so on the
   real result screen the side that landed 61 to 56 lost all three cards with no reason given.
3. `FireLevel` is built and off (no bout sets `fire_level`): Sharp and Signature change about 1 win in 100 on plan lines.
4. `BoutRules.night_edge` gives -1.5 an exchange (NO_CAMP_EDGE) to any bout with an empty camp, and `why` prints "No camp: <name> looked a step slow from round
   2". The S428 scope makes amateur bouts camp-free. If the fight week leaves `camp` empty, every amateur bout pays -1.5 an exchange (larger than the camp edges
   it replaced) with a false line. Not checked whether the fight week fills `camp`: check before building anything here (task NOCAMP1).
5. `Data.START_MOVE_SHARE` starts Uppercut and Check hook at 0, so a new fighter's uppercut punch level is 1 (Attrs clamps at LO) against an opponent's ~58.
   That is a real hole in the pocket that no screen names.

## 3. The chain, one picture (each arrow is a hook that exists, or a mechanic below)
| The week (CLUBWEEK, TRAINING) | -> the build | -> the plan (Playbook) | -> the night | -> the result | -> next week |
|---|---|---|---|---|---|
| mornings, pad places, sparring, the habit pull, rest | abilities, punch levels (mastery), habits gone, perks open (PerkRoad) | lines, now valued by where YOUR fighter wins (M4) | the aim (M5), readiness (M6), Legs, the corner, the judges' panel (M2) | THE SCALES (M1): what each group turned, judges' reasons | each row's button puts the fix on the next week's board |
| sizes on each card (M8, from LEVERS1) | the three places strip (M3) moves with each card | "suits" chip on each line | the corner's card (M7) | the three places: fought and won | Monday: "your choices this month" |

## 4. The mechanics

### M1 THE SCALES (what turned it) - NEW, the receipt
WHAT THE PLAYER DECIDES: nothing here; it is what every other decision is read by. Every row carries one button that IS the next decision.
WHERE: the result page (replaces "What decided it" and the plan-only headline), fight night's round report (its rows so far), History (each bout), the Monday
review (the month's sums), RPG Character tab (that fighter's lines, joined to RPG section 13 LEDGER).
WHAT IT CHANGES (code): `LiveRound.exchange` stores `rec["parts"]`, one number per term it already adds: duel (without form), form gap, the last four weeks'
training (see below), legs, call, pace and aim, The Read, set-up, talk, habit, plan, reads and pressure, film, week on their game (WeekOpp), clinch, perks, the
base (stance, fade, lefty week). Test PARTS1: the parts sum to d within 0.01 on every exchange.
After the bout, for each GROUP, settle every exchange again with that group's parts removed and the SAME rolls (roll_a, roll_b, as `plan_swing` does), re-score
the rounds with the judges (M2), and count: exchanges turned (won with it minus won without it), rounds turned (named), and whether the RESULT turns.
| Group (colour) | Row | Parts | Its button |
|---|---|---|---|
| YOUR WEEK (green) | THE LAST 4 WEEKS OF TRAINING | the duel now minus the duel with this fighter's abilities and punches of 28 days ago (read through Sim._as_of, built; a Monday snapshot of the 14 abilities and 6 moves is stored if none is kept today), same place and tank | Open the week |
| | LEGS | the duel and Push at this tank minus at the tank without the Legs' cost (stale, eaten weight, last bout; CLUBWEEK 4) | Rest up (the fight-week shape) |
| | HABIT (one row per open habit) | HabitFix cost paid | Train it out (6 pad places, CLUBWEEK 3.2) |
| YOUR NIGHT (gold) | YOUR PLAN | plan + reads + pressure + film (today's plan_swing, kept) | Open the plan |
| | YOUR CORNER | shouts, pace and aim, The Read calls, set-up, talk, the fix's held share | See the rounds |
| | THE AIM | the duel with the night's aim minus with the fighter's own dials (M5) | Change the aim next time |
| WHO THEY ARE (blue) | THE BUILD GAP | the duel without the last 4 weeks' part: who the two fighters were before this month | the weakest place's card on the pads |
| | PERKS | each perk that fired (both sides) | Perk road |
| LUCK (grey) | THE NIGHT | the form gap (M6's leftover dice) | none: "luck, named" |
THE HEADLINE (one line above the rows): the row that turned the RESULT, if any ("Without the open habit, Lucy wins round 2 and the bout"); else "No single part
turned the result: the build gap and the plan decided it together".
REAL BASIS: a corner's post-fight review (what worked, what did not, what to drill); the replay on the same dice is what `plan_swing` already does (S388).
SHOWN AS: a diverging bar per row from 0 (exchanges turned), the rounds it turned as chips (R1 R2 R3), the result flip as a gold flag. Eight rows at most;
rows under 1 exchange fold into "small things: +1". No "in 100" on one bout: one bout has no probability (REJECTED). The season's sums turn into "in 100"
through LEVERS1 on the Monday review and Character tab.
FIRST-ORDER, SAID PLAINLY: the replay keeps the same places, tanks and opponent games (path effects ignored), like plan_swing. SCALES1 checks the season sums
against true switch-off probes; if a group is off by more than 1.5 in 100, that row shows exchanges only, never a season number.
DELETED BY IT: BoutRules.why's canned lines, the "worth about +X%" on one bout, "GOOD PLAN" as the headline of a lost bout (the plan row carries its grade).
The Why's three lines stay below the scales: YOUR PLAN (the grade, from FightWhy), AGAINST YOU (now names the biggest red row), NEXT (the biggest red row's
button in words).

### M2 THE JUDGES - CHANGED (scoring like a judge; the agreed "judges with taste" brought forward as scoring only)
WHAT THE PLAYER DECIDES: the night's aim and plan against the panel. The panel's three leans are shown at the weigh-in (fight day) and on fight night's tale of
the tape; the aim can still change (M5).
WHAT IT CHANGES: each round is scored by each judge from what the exchanges already record:
- CLEAN PUNCHES landed (rec["landed"], from the exchange's margin band), the base for every judge;
- BIG SHOTS: a landed set-up, a landed Read, a Counter sense counter, an exchange that left the opponent hurt (rec, settle) count 2 extra each;
- RING CONTROL: per exchange, the side that kept the place it wanted (rec wa / wb against place) AND won the exchange takes 1. Backing off while losing gives
  control away; boxing at range while winning keeps it (ring generalship), so a step back is right only for a fighter who wins at range (M4).
- WORK: the busier side's pace dial gap (M5) / 10 an exchange.
Three leans (ESTIMATE weights, set by JUDGES1): CLEAN (big shots x2), WORK (work x2), RING (control x2). The round's higher total gets 10, the other 9; a count
is 10-8 (two counts 10-7) on every card, so the count line becomes true. A round level on a judge goes to that judge's lean. A show's panel is three judges,
each lean drawn (repeats allowed): "Judges tonight: Clean, Clean, Ring". Split decisions then come from close rounds, not a formula.
REAL BASIS: amateur 10-point must (England Boxing / IBA): number of quality blows on target, domination by technical and tactical superiority,
competitiveness; professional criteria: clean punching, effective aggression, ring generalship, defence. Judges differ in what they weigh; that is why splits
happen. Names and records of judges wait for the small world (LEFT FOR LATER).
LINKS: plan lines (step back, tie up) now cost or earn control; the aim (M5) moves work and control; the corner's card (M7) reads the cards; HYPE's ENTERTAIN
gains with Work judges; the RPG "judges with taste" later only adds names and history.
SHOWN: three cards with the lean and ONE reason each ("Ring: Priya kept the pocket in rounds 2 and 3"), the round-by-round marks on hover.
PROBE JUDGES1 (gate): (a) the exchange-winner still takes the round in 80 to 90 in 100 rounds (ESTIMATE band); (b) "out-landed and lost the card" in under 15
in 100 decisions, and every one names the judge and reason; (c) split decisions inside a band John's research sets (ESTIMATE 10 to 25 in 100 decisions);
(d) BoutRead within 6 in 100 of played bouts on the eight cases; (e) plan_effect_probe's spread (good to wrong) kept. Ripple: plan_templates_test, CoachPlan,
BalanceHarness (uses scorecards), the career harness's records.

### M3 THE THREE PLACES - NEW (the matchup read, before, during and after)
WHAT THE PLAYER DECIDES: where to aim (M5), which lines to bring (Playbook), which pad card and morning to buy this week (M8).
WHAT IT SHOWS: AT RANGE / IN THE POCKET / INSIDE, each with:
- the share of exchanges you would win there tonight: from `Duels.at(a, b, place)` -> P(win) = 1 - (66 - d)^2 / (2 x 66^2) for d >= 0 (mirror below), printed as
  "wins 6 in 10 here";
- the tool against the answer with both numbers: "Lucy's jab 60 against Priya's feet 54" (Duels.TOOLS, TOOL_WORD / ANSWER_WORD, a_best / b_best);
- where THEY want it (RingDuel.mode_bias / wins_breaks: "Priya wants the pocket");
- what moves it by fight night: the pad card or morning with its forecast ("Lead hook 41 -> 48 by Sat: pocket 4 -> 5 in 10").
An unscouted opponent shows each place as a range (AttrGen's scouted range), narrowing with the file (OppFile, film).
WHERE: Fights > the bout sheet card (one line: "wins at range, loses in the pocket"); the bout page's Full report (replaces the old seven-stat rows; the duel
never reads Technique); Fighter > Fight prep (the strip + "moves it by Saturday"); Playbook > Fight plan header; fight night's corner minute (live: tank and
hurt included, Duels.effective); the result (fought and won per place, M1); the Monday review ("at range +1 in 10 since last month").
REAL BASIS: a coach's matchup read: "beat them on the outside, don't stand in the pocket with them".
PROBE PLACES1: the strip's "wins N in 10" per place within 1 in 10 of played exchanges at that place (600 bouts, 4 matchups).

### M4 LINES THAT SUIT THE FIGHTER - NEW (the build's half of RULE4; the Playbook map owns the line table)
WHAT THE PLAYER DECIDES: which lines to write, now for THIS fighter against THIS opponent.
WHAT IT CHANGES: a line's positive worth is multiplied by how well this fighter does at the place the line takes the fight to:
`suit = clamp(1 + E / 10, 0.5, 1.5)`, E = Duels.at edge at that place (the step back takes it long; slip 2-3, 2-3, 3b-3, 1-2-3b, 1-6-3 stay in the pocket; tie up,
push off, herd, cut off, step in go inside; jab lines stay long). A wrong line keeps its full cost. With M2, a retreating line that loses at range also gives away
ring control. So step back beats a presser for the out-boxer who wins at range, and walks the slugger into lost rounds.
SPLIT OF WORK: the Playbook map rewrites ANSWERS so each card's games have conflicting best answers, switches FireLevel on and adds Plan B; this map adds `suit`
in PlanFight.edge / value, CoachPlan, BoutRead and FightWhy, and the PLACE_OF table. One gate for both, from RULE4_PARKED_S398.
SHOWN: on each line, beside Beats it / Works / Walks into it: "suits Lucy +4 at range" or "Lucy loses there -3" (a chip, colour = sign).
LINKS: RPG build direction moves the dials over weeks, so the lines that suit a fighter change as the style changes; M3's strip is the same number.
GATE RULE4 (with the Playbook map): a reader beats a fixed universal plan and a board-top headline bot by 3 in 100 or more on each of four opponents, N = 600,
on equal information. If `suit` alone does not move the gap by 1.5 in 100 on any opponent, it is cut and the chip goes.

### M5 THE NIGHT'S AIM - NEW (the agreed Aggression slider, as two choices of three)
WHAT THE PLAYER DECIDES: on the Fight plan header and the bill, two picks:
- WHERE: KEEP IT LONG (forward dial -15) / MID-RING (the fighter's own) / WALK THEM DOWN (+15);
- HOW BUSY: PATIENT (pace dial -15) / OWN PACE / BUSY (+15).
The duel's caps stay (FWD_CAP 26 over 50, PACE_HOT 72 past which pace misses). In the corner minute, ONE CHANGE may move one of them one step (it competes with
the habit fix and Elbows in / Gloves high: a real choice).
WHAT IT CHANGES (code constants, sizes ESTIMATE until AIM1): Walk them down = guard -4.2 (FWD_GUARD 0.28 x 15), closing +8 (FORWARD_CLOSE 0.55 x 15) once the
feet can use it; Keep it long the reverse. Busy = own guard -0.9 (PACE_GUARD), the opponent's counters +2.3 (PACE_COUNTER), close exchanges +1.2 (PACE_WORK) and
more work for a Work judge (M2). The corner's default place (RingDuel.CALL_PLACE) and the plan's opening card (PlanFight GAME_CARD) follow WHERE.
PRICE SHOWN BEFORE THE PRESS: "Walk them down: guard -4, pocket 4 -> 5 in 10, range 6 -> 5 in 10" (from M3's strip recomputed with the dial).
LINKS: RPG section 12's build direction moves the fighter's own dials 2 a week (the band moves; the aim stays one step around it); RPG's None "Switch it up"
stays that direction's bigger move. HYPE 4.4 keeps its three words and maps onto this: ENTERTAIN = Busy and Push in rounds 1 and 2; SAFE = Patient and Save.
REAL BASIS: corners set the night's tactic and change it ("box him" against "walk him down"); a rematch won by changing the aim is a boxing commonplace.
SHOWN AFTER: THE AIM row in the scales; the places strip shows where the fight went.
PROBE AIM1: each WHERE and each HOW BUSY wins 1.5 in 100 or more against some matchup and loses against another (no pick dominant on all four); else that
choice is cut to two options, or to none.

### M6 THE NIGHT, EARNED - CHANGED (form readable and moved by the week)
WHAT THE PLAYER DECIDES: nothing new on the night; the week's choices that set readiness (the fight-week shape, weight, rest, mood) now carry a visible night.
WHAT IT CHANGES: the form roll's mean = READINESS (power points, -3 to +3) and its spread drops from 5 to 3 (FORM_SD 5 -> 3, watched bouts; world bouts keep 8).
| Input | Readiness | Source |
|---|---|---|
| Fight-week shape (CLUBWEEK 4): Tick over sharp, Train through sharp | +1 | the last five days' pad place |
| Rest up | 0, and its slow start in round 1 (CLUBWEEK) | |
| Mood: Fired up / Steady / Flat / Low | +1 / 0 / -1 / -2 | morale (FighterProfile) |
| Weight eaten off on the day over 0.5 kg | -1 | the scale (CLUBWEEK 4) |
| A pro's peak camp (all three lines met) | +1 (replaces +1 to every stat) | PeakCamp |
| Nerves: heat Hot and confidence under 45 | -1 | HYPE 2.2, RPG 5 |
| Over 8 weeks since the last bout | -1 | ring rust (real) |
The opponent's readiness follows the same rules from their file (their Legs, CLUBWEEK "the other corner has a week").
SHOWN: the tale of the tape before "Begin fight": "Lucy: SHARP tonight (+1 to +3)" with its causes on hover; the opponent's is "?" unless shared on a card.
Pace for round 1 (Push / Steady / Save, built) is chosen after seeing it. After the bout, THE NIGHT row names both sides' form ("Lucy normal +0.4, Priya sharp
+2.6").
REAL BASIS: day-to-day variance is real but mostly explained (sleep, the cut, freshness; a taper improves performance by a few per cent).
PROBE FORM1: (a) a player who manages readiness (shape, rest, weight) wins 1.5 in 100 or more over a season than one who ignores it; (b) BoutRead within 6;
(c) the leftover luck row is under 1 exchange on average. Else readiness is cut to the Legs only.

### M7 THE CORNER'S CARD - NEW (the coach reads the cards)
WHAT THE PLAYER DECIDES: round 3's pace, aim and fix, now with a read behind them (the Push that turns against an empty tank, -12, is a real gamble).
WHAT IT SHOWS: in each corner minute after round 1, one line: "We're a round up / level / a round down", with how sure ("sure", "think so").
RIGHT AS OFTEN AS THE COACH: right in 60 + 0.3 x the cornering coach's rating in 100 (ESTIMATE: Luke Reid about 75, Marcus Hale about 82; you by your coach
level, RPG section 2). Coach's corner (CLUBWEEK "on the night") gives it too.
LINKS: M2 (the cards it reads), RPG 2 level 4 picks (Ringside voice / The minute), RPG 11 (the hired coach's areas rise: the read improves).
SHOWN AFTER: when it was wrong, the YOUR CORNER row says so ("your corner had round 2 as Lucy's; the Ring judge gave it to Priya").
PROBE CARDREAD1: on bouts level after two rounds, a bot that follows the card beats always-Push and always-Steady in round 3 by 1.5 in 100 or more; else the line
shows only after round 2 (one minute), or is cut.

### M8 WHAT THE WEEK BUYS ON SATURDAY - CHANGED (sizes where the week is planned)
WHAT THE PLAYER DECIDES: the mornings and pad places of the week (CLUBWEEK), now against the booked opponent.
WHAT IT CHANGES: nothing in the fight; it puts the fight's numbers on the cards:
- PAD CARDS: "Lead hook 41 -> 48 by Sat (Priya's guard about 61): pocket 4 -> 5 in 10" (MoveMastery forecast + Duels.at). The pads give 2.1 mastery an hour, the
  fastest week-to-night link: the card says so in its own numbers.
- MORNING CARDS: the attribute's forecast and its place on the strip; the wins-in-100 range only from LEVERS1 (CLUBWEEK's rule: no size before its probe). The
  Training map decides the second uses of Flexibility (training injury risk) and Recovery (the minute's refill, tiredness cleared by Monday); this map asks
  only that each morning's fight value is printed or the morning is folded away.
- START LEVELS (fix defect 5): an untaught punch fights at a RAW floor, 40% of the fighter's Accuracy-and-Timing mean (ESTIMATE), not 1; its mastery stays 0 for
  plans. The card says "Uppercut: raw (22), not yet a weapon". PUNCHFLOOR1: starting win chances move under 3 in 100.
- THE HABIT (CLUBWEEK 3.2 owns the training: 6 of your own pad places; RPG gives +3 experience): the fight half is here: half-way (3 pad places) halves the
  HabitFix cost, done removes it. The pull's chip and the scales' HABIT row print the same number ("cost 3 exchanges last bout").
HABITDRILL1: a fixed habit is worth 1.5 in 100 or more against opponents who punish it; half-way about half that.

### M9 HONEST SMALL LEVERS - CUT, MERGED or SIZED
| Lever (code) | Today | Change | Gate |
|---|---|---|---|
| Camp intensity night edge (PROTOCOLS 0.25 / 0.6 / 1.0, pros) | under 1, listed as a reason | removed from the night; the camp card says what it does: "Hard: camp stat x1.35, Legs about -8 at the bell" | CAMPNIGHT1: if a step reaches 1.5 in 100 on its own, keep and print it |
| NO_CAMP_EDGE -1.5 | every camp-free bout | pros only (a pro with no camp); never an amateur fight week | NOCAMP1 (defect 4) |
| Weapons count (WEAPON_EDGE, max 0.9) and combinations known (Combos.edge) | counted twice | removed from the base; punches stay in the duel, combinations in the plan and the set-up | WEAPONCUT1: under 1.5 in 100, then cut and never listed |
| Film (0.4 a tell answered, max 1.2) | a separate reason | kept, counted inside YOUR PLAN (a tell only counts when a line answers it, S381) | in LEVERS1 |
| Peak camp (+1 every stat) | a reason line | +1 readiness (M6) | FORM1 |
| "What decided it" canned lines; the false count line | on every result | deleted; the count line is true under M2 | PARTS1, JUDGES1 |
| HabitBeats (picture only) | could be read as cause | stays picture; the scales carry the real habit cost | none |

### M10 LEVERS1 - NEW (one measured table; every "worth about" reads from it)
A probe tool beside plan_effect_probe / train_effect_probe / fire_level_probe: four matchups (an out-boxer, a presser, a counter-puncher, a slugger), 600 played
bouts a cell, paired dice, populations named in the output, no identical fighters. Rows: +5 on all abilities; each punch +10; each mastery tier; good / wrong
plan; suit on and off (M4); reading the clue / Coach's pick / silence; each aim (M5); readiness -2 / 0 / +2 (M6); the corner's card (M7); each camp level; film;
each perk version (RPG 6); a fixed / half / open habit; the Legs at 0 / 12 / 25 off. Output: wins in 100 per row per matchup, written to
`ops/AgentComms/levers.json`, read by LeverSize (CLUBWEEK), the Handbook and the cut rule. Runs weekly in the 05:00 slot or when a lever changes, never in a
session (heat rule).
HANDBOOK > "What wins a bout": the table in plain words, with the groups of M1, refreshed from levers.json.
THE CUT RULE (applied from this table): a player's choice that moves less than 1.5 wins in 100, averaged over the four matchups (or on the bouts where it
applies, over a season), is cut, merged, or shown without a size.

### M11 THE SCALES ON THE MAT - NEW (BJJ, the same receipt; Ana)
The BJJ match runs on beats (BjjMatch, BjjClash, BjjBeat). Same method: each beat stores its parts (BjjClash.factors already lists them for the reason line),
replayed with each group out on the same dice. Groups: THE BELT GAP (who they are), YOUR WEEKS (drilled moves owned, classes), YOUR CALLS (when the player fights
it: the picks on the move graph), THE REFEREE (stall counts), LUCK. Shown on the open's result and Ana's record. BJJSCALES1: parts sum per beat; season sums
match switch-off probes within 1.5 in 100 of matches. The judges (M2) do not apply: BJJ scores points.

## 5. Every decision (B before the bout, D during, A after). The last column is the designer's test, never printed on a screen.
| When | Decision | Options and what each costs and gives | Right when (never on screen) |
|---|---|---|---|
| B, the week | Pad card for a punch | mastery 2.1 an hour; the punch level in the duel; the strip moves (M3, M8) | the place the opponent wants is the one this punch decides |
| B, the week | Habit pull (CLUBWEEK) | 6 of your pad places; half-way halves the cost (M8) | the booked opponent's game punishes it |
| B, the week | The fight-week shape (CLUBWEEK) | Rest up: full Legs, slow round 1; Tick over: sharp +1, Legs about -8; Train through: sharp +1, Legs about -12, all training kept | Rest up after a hard bout; Tick over against a slow starter; Train through with a long road to the target |
| B, the plan | Which lines | Beats it / Works / Walks into it, now x suit (M4) | the line takes the fight where this fighter wins |
| B, fight day | WHERE (M5) | Long / Mid-ring / Walk them down: guard against closing | long when the strip wins at range and the panel has a Ring judge; walk down when the pocket or inside is yours |
| B, fight day | HOW BUSY (M5) | Patient / Own / Busy: guard and counters against work and the Work judge | busy against a waiting counter-puncher only with the tank for it |
| B, the bell | Round 1 pace, after the readiness read (M6) | Push / Steady / Save (built) | Push when SHARP and the opponent starts slow |
| D, each 30 s | Shout, pace, aim, NOW, Wait / Take (built) | as built | as built |
| D, the minute | ONE CHANGE: habit fix, Elbows in / Gloves high, or one step of the aim (M5) | one only | the step when the strip has turned; the fix when the habit was paid twice |
| D, before round 3 | Push or save, read from the corner's card (M7) | Push +6 (to -12 on an empty tank) / Save -4 | Push when a round down with half a tank; Save when ahead |
| A, the result | Each scales row's button | Open the week / Rest up / Train it out / Open the plan / See the rounds / Change the aim / Pads card / Perk road | the biggest red row the player can act on |

## 6. Every menu it appears on, and what each is wired to (only what the player can act on; a graphic before any words)
| Menu | Shows | Wired to |
|---|---|---|
| Fights > the bout sheet card (CLUBWEEK) | one line from the strip ("wins at range, loses in the pocket") | Duels.at, RingDuel.wins_breaks, AttrGen scouted range |
| Bout page > Full report | THE THREE PLACES (replaces the seven-stat rows); the opponent's readiness "?" or their Legs | Duels, BoutCompare (rewired), OppFile |
| Fighter > Fight prep | the strip, "moves it by Saturday" per place with the card's button, the aim | MoveMastery forecast, WeekPlan forecast, Duels, new Aim rule |
| Fighter > Week (and Club week) | on each pad card the punch level against their answer; on each morning its strip move; sizes only from LEVERS1 | Duels, MoveMastery, LeverSize, levers.json |
| Playbook > Fight plan | header: the strip and WHERE / HOW BUSY with prices; each line's "suits" chip | PlanFight (suit), Duels, Aim |
| Weigh-in (fight day) | the judges' panel leans | new Judges rule |
| Fight night > tale of the tape | readiness word and range, both panels' leans, the aim, Begin fight | new Readiness rule, Judges, Aim |
| Fight night > the round | the live strip on the corner card (tank and hurt included) | Duels.effective, RingDuel |
| Fight night > corner minute | the corner's card (M7), ONE CHANGE incl. one aim step, the strip | Judges, coach rating, Aim |
| Fight night > result | THE SCALES (8 rows, buttons), the three judges with one reason each, the places fought and won, the rank earned, the Why's three lines | new Scales rule, Judges, FightWhy, RankLine |
| History | each bout's scales | the stored scales |
| Monday review | "Your choices this month: +N exchanges, R rounds, B bouts turned", the strip's change | sums of the scales, LEVERS1 |
| Character tab (RPG) | that fighter's rows joined to the ledger of picks (RPG 13) | Scales + LEDGER |
| Handbook > What wins a bout | the lever table in words | levers.json |
| Ana's open result and record | the mat scales | BjjClash factors, new BjjScales |

## 7. The numbers (code or ESTIMATE; each ESTIMATE is set by its probe before a screen shows it)
| Number | Value | Source |
|---|---|---|
| Exchange luck | each dice x 66, triangle -66..66 | code EX_SPREAD |
| Form | mean = readiness -3..+3; spread 3 (was 5); world bouts 8 | ESTIMATE, FORM1 |
| Aim step | 15 dial points; caps FWD_CAP 26, PACE_HOT 72 kept | ESTIMATE, AIM1; caps code |
| Suit | clamp(1 + E / 10, 0.5, 1.5) on positive line worth only | ESTIMATE, RULE4 gate |
| Judges | clean x1 base; big shots +2; control +1 an exchange; work = pace gap / 10; the lean doubles its part; count 10-8 | ESTIMATE, JUDGES1 |
| Corner's card | right 60 + 0.3 x coach rating in 100 | ESTIMATE, CARDREAD1 |
| Raw punch floor | 40% of the Accuracy-and-Timing mean | ESTIMATE, PUNCHFLOOR1 |
| Habit half-way | HabitFix cost x0.5 after 3 of 6 pad places | ESTIMATE, HABITDRILL1 |
| Cut rule | 1.5 wins in 100 | operator rule |

## 8. To be measured before the build (on the played bout, never the harness's average; populations named; no screen before its table)
PARTS1 (test: parts sum to d within 0.01), NOCAMP1 (amateur fight week pays no camp penalty; a probe on 400 bouts before and after), JUDGES1, SCALES1 (season
sums against switch-off probes, 600 bouts x 4 matchups, within 1.5 in 100), PLACES1, RULE4 (with the Playbook map), AIM1, FORM1, CARDREAD1, PUNCHFLOOR1,
HABITDRILL1, CAMPNIGHT1, WEAPONCUT1, BJJSCALES1, LEVERS1 (the table itself). Each prints its control arm first (today's game to the decimal, as
fire_level_probe does).
GOLDEN PATH (Grok Dev): one test walks the build to the fight: sign a fighter, two weeks of mornings and pads (a hook card), a plan with two lines, the aim, a bout;
it asserts the scales name THE LAST 4 WEEKS OF TRAINING with a non-zero row, YOUR PLAN equals plan_swing, the judges' cards carry reasons, and the result's
buttons open the week, the plan and the pads.

## 9. Build order, in small tasks (each under 500 lines, one owner, one test command)
1. NOCAMP1 and the canned lines (Claude, small): the defect first.
2. PARTS1 (Claude: LiveRound.exchange stores rec["parts"]; core file, careful) -> SCALES1 pure module `scripts/rules/Scales.gd` + test (Qwen).
3. Judges.gd pure module + test (Qwen), wired in BoutNight.outcome_of / _finish (Claude); JUDGES1 probe (Arena, cloud).
4. LEVERS1 tool (Arena), first table before any size goes on a screen.
5. Readiness.gd + FORM_SD (Qwen); FORM1.
6. Aim rule (Qwen) + AIM1; suit in PlanFight with the Playbook map's ANSWERS rewrite (one task pair, one gate).
7. Screens, one per task from this map's drawing (Cursor; Claude checks the stills): result page, the strip component, Fight plan header, tale of the tape.
8. Corner's card (Qwen) + CARDREAD1; punch floor + PUNCHFLOOR1; BJJ scales.
9. Golden path test (Grok Dev); Handbook page.

## 10. Risks, said plainly
- The judges change who wins rounds, so every balance number moves (plan_templates_test, BoutRead, CoachPlan, the career harness). JUDGES1 runs before the
  screens and the ripple list is re-measured in one pass.
- The replay is first-order: a habit that cost an exchange early also changed the tank later. SCALES1 compares with true switch-off probes and demotes a row
  to "exchanges only" when it disagrees.
- A result page with eight rows can bury the one that matters: the headline names the row that turned the result; rows under 1 exchange fold.
- Readiness can snowball (win -> mood -> sharper): capped at +3 and mood already moves both ways.
- The aim could become a solved pick: AIM1's rule is that no pick wins on all four matchups.
- `suit` alone may not open RULE4: it ships only with the Playbook map's line table, under one gate.

## REJECTED (and why)
- "Wins in 100" per row on one bout's result: one bout has no probability; it would be a fake precision. Exchanges and rounds on the bout, "in 100" on the season.
- Showing the opponent's form before the bell: it turns the night into a gamble the player cannot answer. Their Legs show (CLUBWEEK); their form is named after.
- Removing form altogether: a fight with no night-to-night variance reads scripted, and upsets are part of boxing. It is shrunk and earned instead.
- A free Aggression slider 0-100: one step of 15 around the fighter's own keeps the build in charge; a free slider makes the style dials meaningless.
- A momentum meter: nothing the player does drives it; decoration.
- Per-punch selection sliders (how many jabs, hooks): the plan's lines and the aim already say it, in boxing words.
- Named judges with records now: the small world's job (S425); scoring honesty is the defect and comes first.
- A "best plan" button: the game would play itself; the coach already writes a plan when none is written.
- Keeping the exchange-count cards with a better text: the text would still lie when the cleaner puncher loses.
- A separate hype slider beside the aim: HYPE's Entertain and Safe map onto HOW BUSY and the pace, one control.

## FROM THE BUILD TO THE FIGHT FOR THIS VERSION
1. THE SCALES on the result, History and the Monday review: every part of every exchange stored and replayed on the same dice, four groups, eight rows, one
   button each, the row that turned the result named. The canned "What decided it" goes.
2. THE JUDGES: rounds scored from clean punches, big shots, ring control and work; three leans shown at the weigh-in; a count is 10-8; one reason per card.
3. THE THREE PLACES strip on the bout page, Fight prep, Fight plan, the corner minute and the result, with the punch against the answer and what moves it by
   Saturday.
4. LINES THAT SUIT the fighter (with the Playbook map's line table, one RULE4 gate).
5. THE NIGHT'S AIM: Where and How busy, one step around the fighter's own, priced before the press, one step in the corner minute.
6. THE NIGHT, EARNED: readiness from the fight week, mood, weight, peak camp and nerves; the luck halved and named.
7. THE CORNER'S CARD before rounds 2 and 3, right as often as the coach is good.
8. The week's cards priced against the booked opponent; untaught punches at a raw floor; the habit's fight half.
9. Honest small levers: NO_CAMP_EDGE off amateur bouts, the camp night edge and the weapons and combinations counts cut or sized, film inside the plan.
10. LEVERS1, the one lever table, with the cut rule and the Handbook page; the same receipt on Ana's mat; one golden-path test from the build to the fight.

## LEFT FOR LATER
- Named judges with taste and history, and judges a promoter can lean on (the small world, S425).
- The professional's longer fights: judges' leans by commission, 10- and 12-round pacing in the corner's card.
- Opponents who read YOUR scales (a rival corner that saw your habit cost you, the Playbook map's R25 adapting, in full).
- A season-long "style report" comparing the fighter's places month by month as a chart on History (held back: the progress chart is on the held list).
- MMA's places (range, clinch, ground) on the same strip, after the first update.

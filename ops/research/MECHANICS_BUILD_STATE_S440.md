# Mechanics: what is built, what the critics think, and who finishes it (S440)

Your question: "have these mechanics been proposed by the critics? higher rated mechanics that deepen the simulation and
gaming experience get priority". And: "why not use dola, grokbot, arena, goose and other free agents to finish them?"

Sources: the Miro MECHANICS LIST checked row by row against the code today (file and line for every claim), and two
fresh critics who rated all 103 rows: a simulation veteran (SV) and a boxing fan who plays (Fan), each giving DEPTH (how
much the mechanic ties into the rest of the game) and PLAY (how much a player feels it), 0 to 10.

## 1. The short answers

**Were they proposed by the critics? Mostly not.** Of the 83 rows you or I approved (the other 20 are LATER or OUT, section 3):
- 9 came straight from a critic: R31, R32, R37, R41, R57, R70 (the overdraft), R87, R92, R93.
- 5 came partly from critics: R07 (the fix), R58, R59, R85, R89.
- 13 were Miro ideas that both or one critic voted "try": R11, R21, R25, R27, R28, R29, R33, R46, R55, R60, R72, R73, R74.
- The rest came from you (the three core mechanics), my structure design (P1-P17), Kalli, or the gym list.

The surprise: what the critics proposed outright is mostly comfort and display (skip the fight, simulate to the next
stop, the Monday page, faces on cards, risk shown per camp card). Those average 3.3 to 4.3 because they add no decisions.
The deepest mechanics (the plan that bites, fighters who fight differently, the corner minute, a fighter poached) came
from you and the design, and the critics rate them highest. So the priority below follows the critics' SCORES, and
"proposed by a critic" only breaks ties.

**Can free seats finish them? Yes, a lot of it, with three limits:**
1. A mechanic that is NEW (not built at all) needs a design page scored 7+ by two fresh critics first (your S425 rule).
   Eight high-rated rows are stuck there (R58's poaching, R37, R28, R44 defences, R60, R33, R72, R87). Free seats can
   be those critics: John, Dola and a Grok bot cost nothing, where my critic rounds cost real money (CRITICMONEY).
2. Most finishing work waits for the foundation fixes (Step 0: twelve fixes in today's code; the branch is built in
   E:/FightCamp/wt/LEAN_FOUNDATION_S433 and waits for my collect). The measuring jobs run after it merges; the pure
   rule modules below can start now.
3. The real limit is my review, not the seats: every seat delivery in S438 was wrong somewhere, so each one gets a blind
   review before it merges. About 6 to 8 collects a session.

**Low-rated ones are listed but NOT delegated.** Every approved row with a critics' average under 5 stays on the list
with its scores, and no seat gets it (section 4).

## 2. Every approved mechanic, best rated first

Approved by: "you" = your call IN on the board; "you Q-n" = your ruling; "rec" = only my recommendation IN (your note
empty). Avg = the four scores averaged. Critic files are in ops/research/S400_REVIEW/ unless a path is given.
Next step: FINISH (a seat can do it now or after Step 0) / MAP (needs a design page to 7+ first) / HIM (waits on you) /
WAIT (waits on another build) / DONE (built; nothing needed now).

| R | Mechanic | Approved | SV d/p | Fan d/p | Avg | Proposed by critics? | State | What is missing | Next step | Seat |
|---|---|---|---|---|---|---|---|---|---|---|
| R18 | The plan must bite | you | 9/8 | 8/7 | 8.0 | no (my structure design); critics gave the fixes | partly | Good plan beats none by 16 points, target 30; FireLevel and ReadBack switched off; not re-measured since S396 | FINISH: measure (LEVERS1, FIRELEVEL2), then LineGrade / LinePrice | Arena, Goose |
| R24 | Fighters who fight differently | you | 9/8 | 8/7 | 8.0 | no; trait upsides from RPG critics | partly | The body never changes which plan answer is right (no LineGrade); no trait upsides | FINISH: LineGrade, TraitLine | Arena, Qwen |
| R26 | Corner minute: three fixes, time for two | you | 8/9 | 7/8 | 8.0 | no; towel asked by critics (docs/mockups/s432/critics/rpg3_clubcoach_review.md) | built | Towel card, the line that lost most with two rated replacements, the adapted note | FINISH: Towel, LineSwap | Qwen |
| R58 | A fighter leaves for a bigger gym | rec | 8/8 | 8/8 | 8.0 | partly: CORNER_KING_REFINED_S401 (player critic's no. 1), GYM_IDEAS_VERDICT_S401, ops/research/MONEY_BITES_S397_R2_REVIEWS.md | pieces | Loyalty 0-100, the approach, four answers; map scored 5 and 6 | FINISH the Loyalty module now (club week map passed 7,7); the poaching itself = MAP | Goose; critics free |
| R17 | Game plan on a board | you | 8/9 | 7/7 | 7.75 | no (your core mechanic 3) | built | A price on each line, phases (ahead/behind), where the fight goes, per-line receipt | FINISH: PlanPhase, OwnLine (Playbook map 7,7) | Goose, Arena |
| R85 | A living world | you Q-113 | 9/8 | 8/6 | 7.75 | partly: CORNER_KING_REFINED_S401 menu 12, ops/research/CRITIC_WORLD_S408.md | partly | Year-end results are thrown away (nobody sees a boxer retire or arrive); amateur rivals never age | FINISH the news of what the built world does; ageing amateurs waits (your S425: small world after the week) | Grok bot |
| R28 | Cutman: a closing eye, stop or go on | rec | 7/8 | 7/8 | 7.5 | try vote, both S400 critics (IDEAS_VERDICT.md) | partly | The decision itself; closing the cut changes nothing; map scored 3,2 then 5 | MAP, then HIM (Part B is one new rule needing your yes) | free critics |
| R37 | Ask for a fight (refusal gives a reason) | rec | 8/8 | 7/7 | 7.5 | YES: CORNER_KING_REFINED_S401 (menu 7) | pros only | The whole amateur ask; map round 2 scored 5 and 6 | MAP (round 3 running in my workflow) | free critics |
| R25 | Opponent adapts by round 2 | you | 8/7 | 7/7 | 7.25 | try vote, both S400 critics | rule only | Nothing sets it in a real bout; measured: the corner wins nothing back (-6.5) | FINISH: the ADAPT1 probe decides if it switches on | Arena |
| R30 | Why screen | rec | 7/8 | 6/8 | 7.25 | no | built | The redraw (one-line Why, three judges with reasons) | WAIT: RESULTLOOK1 (mine, in flight); Judges module feeds it | Arena (Judges) |
| R44 | Pro ladder, belts, defences | rec | 7/8 | 7/7 | 7.25 | no | partly | A champion you manage has no defence duty. (The 8 pro tables are DONE: PROTABLES1, 3305bc5b) | MAP; the national ladder waits for after the week | Kalli numbers, free critics |
| R50 | Recruit as an RPG card, trial first | rec | 7/8 | 5/7 | 6.75 | no | built | Trait upside lines, reveal spread | FINISH: TraitLine | Qwen |
| R55 | Two fighters, one coach: who gets the pads | rec | 8/8 | 6/5 | 6.75 | try vote both S400; CORNER_KING_REFINED_S401 menu 14 | not built | Coach's evenings as a shared pool; inside the club week map (7,7) | FINISH the ClubDeal module; screen WAITs for four fighters (FOURSTART1) | Arena |
| R59 | A named rival gym | you Q-120 (my rec later) | 7/7 | 6/7 | 6.75 | partly: MONEY_BITES_S397_R2_REVIEWS.md | name only | All of it | WAIT: small world after the week; then MAP | none now |
| R60 | Career clock: retirement talk | rec | 7/7 | 6/7 | 6.75 | try vote, S400 design critic | world only | Our fighters never age; no forecast or talk | MAP (John: real career-length numbers first) | John |
| R73 | Coach-hours timetable | rec | 8/7 | 7/5 | 6.75 | try vote, gym critic (GYM_IDEAS_VERDICT_S401) | not built | One pool of coach hours; in the club week map (7,7) | FINISH: same ClubDeal module as R55 | Arena |
| R01 | Mornings add up to the camp goal | you | 7/7 | 6/6 | 6.5 | no (your core mechanic 1) | built | Training map v6.1 parts (Sharpen, detraining, the week's buy panel) | FINISH after Step 0: Detrain now, the rest after the foundation's WeekPlan work | Goose |
| R19 | Scout the opponent: file and tape room | you | 7/7 | 6/6 | 6.5 | no (Miro idea) | built | A hidden tell shown as a range of worth; opponents who adapt (R25) | FINISH: TellWorth | Grok bot |
| R39 | Offers pull four ways | rec | 7/7 | 6/6 | 6.5 | no | built (pros) | The amateur side belongs to R37 | DONE for pros; amateur = R37 | none |
| R43 | Turn pro | rec | 6/7 | 6/7 | 6.5 | no (Kalli) | built | Three answers with forecasts; map round 1 scored 4,4 | WAIT: TURNPRO1 (mine, round 2 running) | none now |
| R64 | Weekly bills, runway, closing | rec | 7/7 | 6/6 | 6.5 | no | built | Board row says 4 weeks, code says 8; the overdraft rule can never fire (R70) | DONE; I fix the board row | none |
| R04 | Hard weeks vs injury risk | you | 7/7 | 6/5 | 6.25 | no | built | A warning before an injury (Niggle); risk as "N in 100" beside the gain | FINISH: Niggle, then the risk line on screen | Qwen, Cursor |
| R16 | Combo lab | you | 6/8 | 5/6 | 6.25 | no (your core mechanic 2) | built | Own combos do not become plan lines | FINISH: OwnLine | Arena |
| R29 | Scorecards after each round | rec | 6/7 | 5/7 | 6.25 | try vote both S400; asked again in ops/research/RESULT_PAGE_CRITICS_S439.md | end only | Judges who score with a taste; the running card | FINISH: Judges module (fight-link map 7,7); "your card" in the corner waits on you (cutman question 2) | Arena |
| R99 | Belt match: you call her next move | rec | 6/7 | 6/6 | 6.25 | no | built | Live choices redesign never reached 7 (4,5 to 5,6) | MAP (BJJ7 parked: your call) | none |
| R33 | Sponsor wants a fight before camp is ready | rec | 6/6 | 6/6 | 6.0 | try vote, both S400 critics (top 8) | pieces | The mechanic itself; meant for the Monday docket | MAP | free critics |
| R42 | Amateur nationals road | rec | 6/7 | 5/6 | 6.0 | no | built | Nothing core | DONE | none |
| R69 | Club show | rec | 6/7 | 5/6 | 6.0 | no | money built | Our boxers cannot fight on our own show; HOSTSHOW map round 2 running | WAIT: HOSTSHOW map (mine) | none now |
| R86 | Rankings by taking places | rec | 6/7 | 5/6 | 6.0 | no; arrows asked in ops/research/CRITIC_WORLD_S408.md | built | No trend arrow, no rank history; amateur ladder ignores opponent quality (that part is R37's LADDER1) | FINISH: RankTrend | Grok bot |
| R102 | BJJ on the same week, plan and Why | you Q-115 | 7/6 | 6/5 | 6.0 | no | separate path | Mat plan modules (map 7,7); MatLines LANDED, waits my collect | FINISH: MatReceipt now, MatPrice after the MatLines collect | Qwen, Goose |
| R20 | Test it: sparring nights | you | 6/6 | 5/6 | 5.75 | no | built | A fix button from the result; pair picker waits for club week | WAIT: after Carry (R31) | Cursor later |
| R03 | Camp goal lines, peak-camp bonus | you | 6/6 | 5/5 | 5.5 | no | built | Readiness; the free camp protocols retired (that part is foundation F14, mine) | FINISH: Readiness module | Goose |
| R10 | Injuries and suspensions | you | 6/6 | 5/5 | 5.5 | no | partly | Rest is forced; no train-around | FINISH: TrainAround | Qwen |
| R23 | Habits you discover and fix | you | 6/6 | 5/5 | 5.5 | no | built | Training a habit out over weeks | FINISH: HabitWork | Qwen |
| R31 | One change after the Why, carried into the plan | rec | 5/6 | 5/6 | 5.5 | YES: CORNER_KING_REFINED_S401 (menu 9) | text only | No accept button; nothing carries | FINISH: Carry module; button after RESULTLOOK1 | Arena |
| R68 | Stipend or day job | rec | 6/5 | 6/5 | 5.5 | no | partly | Fighter page always says "stipend"; the -15% pace is hidden; a pro keeps the day job (foundation F14, mine) | FINISH: the screen lines | Cursor |
| R72 | Who we recruit: white-collar or estate kids | rec | 6/5 | 6/5 | 5.5 | try vote, gym critic | not built | All; could fix the dead dues choice (R65) | MAP | free critics |
| R96 | Belt road and stripes | you Q-115 | 6/6 | 5/5 | 5.5 | no | built | Nothing core | DONE | none |
| R11 | Every random swing gets a reason | you | 5/7 | 3/6 | 5.25 | try vote, both S400 critics | partly | R11F never delivered; 36 swings with no reason (census from S403, line numbers stale) | FINISH: R11F, then a fresh census cut into small tasks | Qwen, Goose |
| R15 | Move book with mastery tiers | you | 5/7 | 4/5 | 5.25 | no | built | Mastery barely matters (FireLevel off) | FINISH: same measure as R18 (FIRELEVEL2) | Goose |
| R36 | Amateur bout offers | rec | 5/6 | 4/6 | 5.25 | no | built | Your S428 change (offers 1-2 weeks out, no camp); map scored 5,5 | WAIT: AMATEURWEEK1 (mine) | none now |
| R27 | Wrong corner calls cost trust | rec | 5/5 | 5/5 | 5.0 | try vote, both S400 critics | built | No end-to-end walk proving a Low fighter ignores a shout | FINISH: one walk test | Qwen |
| R46 | Sparring supply: pay or club members | rec | 6/5 | 5/4 | 5.0 | try vote, gym critic + S400 design critic | partly | Partner pool, the club-member option; club week map has it | FINISH: SparSet module | Goose |
| R52 | A fighter's goal with a deadline | rec | 5/6 | 4/5 | 5.0 | no | built | Goal in four bands; dead trust line | WAIT: after foundation F3, then GoalBand | Qwen |
| R54 | Coach runs it, per fighter | rec | 4/7 | 3/6 | 5.0 | no; critics keep asking (ops/research/S405_CRITICS) | not built | Three buttons in the club week map (7,7) | WAIT: four fighters + week v4 first | none now |
| R87 | Year review and three club goals | rec | 5/6 | 4/5 | 5.0 | YES: STRUCTURE_CRITIC_PLAYER.md, STRUCTURE_CRITIC_UX.md | not built | All | MAP | free critics |
| R95 | First hour: first offer, first show | rec | 5/7 | 3/5 | 5.0 | no | built | Your four-fighter start (map scored 5,5) | WAIT: FOURSTART1 (mine) | none now |
| R97 | The stripe as a choice | rec | 5/5 | 5/5 | 5.0 | no | built | Nothing in wiring | DONE | none |

## 3. Not approved yet (your call open, or LATER / OUT)

| R | Mechanic | Your call / my rec | SV d/p | Fan d/p | Avg | Proposed by critics? | Note |
|---|---|---|---|---|---|---|---|
| R47 | Rematches and rivalries | rec LATER | 7/8 | 6/8 | 7.25 | YES: STRUCTURE_CRITIC_PLAYER.md | Rated high; needs the running world (after the week). Worth your yes then. |
| R48 | Weight class moves | rec LATER | 6/5 | 6/5 | 5.5 | no | Weight map passed depth 8,7 in S434; clarity round running |
| R61 | Retired fighters as coaches | rec LATER | 5/6 | 4/6 | 5.25 | no | Needs careers to end (R60) |
| R12 | Scars raise injury risk | you LATER | 6/4 | 5/3 | 4.5 | no | |
| R49 | Away shows | rec LATER | 5/5 | 4/4 | 4.5 | no | Inside the HOSTSHOW map |
| R62 | Prospects with a deadline | rec LATER | 5/5 | 4/4 | 4.5 | YES: CORNER_KING_REFINED_S401 menu 14 | The trial mat in the club week map replaces it |
| R13 | Money pushes on training | you LATER | 4/3 | 5/4 | 4.0 | no | |
| R81 | Sponsor line, per-fighter costs | rec LATER | 4/4 | 3/4 | 3.75 | YES: CORNER_KING_REFINED_S401 menu 10 | |
| R76, R79 | Sparring policy; coach course | rec LATER | 4/3, 4/4 | 4/3, 3/3 | 3.5 | no | |
| R75, R84 | Volunteer coach; visible-gym ideas | LATER; OUT | 3/3, 2/4 | 3/3, 2/4 | 3.0 | partly (R75) | |
| R14, R80, R78, R63, R82, R77, R103, R83 | Tease twist, January course, changing rooms, Camp Board card game, static gym picture, dust period, removed ideas, four small gym choices | LATER / OUT | | | 2.5 to 1.0 | no (R82: the gym critic said no) | R63 still waits on your close; R82 is in fact built as the gym hub menu (board row out of date) |

## 4. Approved, but under 5: listed, NOT delegated

These stay as they are. No seat gets them. Scores are (SV d/p, Fan d/p, avg).

R02 the phase writes the week (4/5, 4/6, 4.75); R05 Monday twist card (5/5, 4/5, 4.75); R06 she pushes back (5/5, 4/5,
4.75: it gains from the Loyalty module of R58 anyway); R07 week review (4/6, 3/6, 4.75); R100 BJJ opens (5/5, 4/5,
4.75); R51 coach and starting club (4/6, 3/5, 4.5); R53 roster up to 8 (5/4, 4/4, 4.25); R92 Home with one next
action (2/7, 2/6, 4.25); R93 simulate to the next stop (1/8, 1/7, 4.25); R38 paid scout (4.0); R40 the whole road
(4.0); R45 pro contract talks (4.0); R67 upgrades and premises (4.0); R74 the 90-day cliff (4.0); R32 watch,
highlights or skip (1/7, 1/6, 3.75); R89 record book (3.75); R98 BJJ classes drill (3.75); R21 test accuracy follows
scouting (3.5); R57 faces and a members panel (3.5); R71 youth section (3.5); R08 perk road (3.25); R22 coach writes a
plan (3.25); R41 camp risk per choice (3.25); R56 staff roles (3.0); R70 overdraft and grants (3.0); R88 club tiers
(2.75); R65 dues bands (2.5); R94 autosave, settings, handbook (2.5); R35 press card (2.5); R34 commentary line (2.25);
R66 kit budget (2.25); R101 BJJ classes as a business (2.25); R90 world in open files (2.0); R91 world editor (1.75);
R09 test day (1.5).

Note on R32 and R93: both have no depth but high play (7-8). A long career is a chore without them. By your rule they
are not delegated; if you want them anyway, say so and they go to Cursor.

**Defects seen while checking (not mechanics work; I fix these myself, as the "a defect you see, you fix now" rule says):**
R22: the Game plan page shows a different plan from the one the coach uses at the bell. R32: highlights are built and
nothing reaches them. R70: the overdraft can never be switched on, so the closing rule's overdraft part is dead. R68:
the fighter page says "Club stipend, $250 a week" even on a day job (also in the R68SHOW1 task below). R53: four
starting fighters would be over the first premises' three places. R64 and R82: the board rows are out of date.

## 5. The delegation plan

Ordered by the critics' average, highest first; at the same score, the one the player feels sooner goes first.
Partly built high scorers come before built ones. One pure module or one screen per task. Every brief
(ops/research/TASK_<id>.md) will carry: owned files with line counts, the one test command, plain game words, files under
500 lines, a test that goes red on main first, a Discipline line, "## Prior research", "## What would a human do?" and
"## Prefab check". Plain `--script` tests stay the switched-off arm; new rules go into GAME_ON.

Test command form: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path
. --script res://tests/<name>.gd` (the brief also adds the test to tools/run_tests.sh).

Files at the 500-line cap (Sim.gd 499, GamePlan.gd 499, Duels.gd 488, PadWeek.gd 482, BoutNight.gd 479): no task adds
lines there. The wiring of each new module goes through a new file, done by me after the collect.

Nothing here is briefed twice: in flight or landed today are CALLSPREAD1, CLIPFIX2-4, MATLINES1, PAGES2B, PUNCHSNAP1,
the foundation branch, the critic rounds for R37, R58, HOSTSHOW, TURNPRO, WEIGHT and CUTMAN, and my RESULTLOOK1,
DAMAGESHOW1, TURNPRO1, FOURSTART1, AMATEURWEEK1.

| # | Task | Seat | Avg | Owned files (new unless a line count is given) | What it does, in game words | Starts |
|---|---|---|---|---|---|---|
| 1 | R18LEVERS1 | Arena | 8.0 | tools/levers_probe.gd, ops/AgentComms/levers.json, tests/levers_json_test.gd | The one measured table: of every 100 exchanges, how many the preparation turns, how many the night, how many luck (target 55-70 / 20-30 / 10-20) | after the foundation merge |
| 2 | R18FIRE2 | Goose | 8.0 | tools/fire_level_probe.gd (123), ops/research/FIRELEVEL2_RESULT.md | Measures what a Sharp or Signature move is worth with FireLevel on (today Sharp over Usable is about 1 win in 100); decides if it goes on in the game. Also R15 | after the foundation merge |
| 3 | R24GRADE1 | Arena | 8.0 | scripts/rules/LineGrade.gd, tests/line_grade_test.gd | Each move is graded from the two abilities it is done with, so a boxer's body changes which plan answer is right (Playbook map 4.1) | now |
| 4 | R58LOYAL1 | Goose | 8.0 | scripts/rules/Loyalty.gd, tests/loyalty_test.gd | Loyalty 0-100 with dated reasons, bands and a forecast (club week map, passed 7,7). Feeds R58, R06, R27, R55 | now |
| 5 | R85NEWS1 | Grok bot | 7.75 | scripts/world/WorldNews.gd, tests/world_news_test.gd | Turns the world's year end (who retired, who arrived, who was crowned) into news lines and a "new face" / "retired" mark. Only shows what the built world already does | now |
| 6 | R25ADAPT1 | Arena | 7.25 | tools/adapt_probe.gd (existing), ops/research/ADAPT1_RESULT.md | Can the corner win back a fight against an opponent who adapts? If not, the adapting opponent stays off (it would only punish) | after the foundation merge |
| 7 | R26TOWEL1 | Qwen | 8.0 | scripts/rules/Towel.gd, tests/towel_test.gd | The towel card in the corner minute: when throwing it in saves her, and what it costs (fight-link map M13) | now |
| 8 | R17PHASE1 | Goose | 7.75 | scripts/rules/PlanPhase.gd, tests/plan_phase_test.gd | Rounds on lines: a plan for when she is ahead and one for when she is behind (Playbook map) | now (numbers re-set from levers.json later) |
| 9 | R29JUDGES1 | Arena | 6.25 (feeds R30 7.25) | scripts/rules/Judges.gd, tests/judges_test.gd | Three judges who each score clean punching, ring control and work with their own lean, 10-8 rounds, a running card after each round (fight-link map M2) | now |
| 10 | R26SWAP1 | Qwen | 8.0 | scripts/rules/LineSwap.gd, tests/line_swap_test.gd | In the corner minute: the plan line that lost most this fight, and two rated lines to swap in | now |
| 11 | R73DEAL1 | Arena | 6.75 | scripts/rules/ClubDeal.gd, tests/club_deal_test.gd | The club week's coach hours: 8 pad places, 6 coached mornings, each of Coach's evenings pads or a beginners' class (+$117, about one member in 4 weeks), who goes short. R73 and R55 | now (screen after FOURSTART1) |
| 12 | R50TRAIT1 | Qwen | 6.75 | scripts/rules/TraitLine.gd, tests/trait_line_test.gd | Every trait gets an upside line as well as its downside (RPG map v3) | now |
| 13 | R19WORTH1 | Grok bot | 6.5 | scripts/rules/TellWorth.gd, tests/tell_worth_test.gd | A tell not yet found on tape shows as a range of worth in exchanges, so the player knows what the next film buys | now |
| 14 | R01DETRAIN1 | Goose | 6.5 | scripts/rules/Detrain.gd, tests/detrain_test.gd | An ability not trained for weeks slowly fades (training map v6.1) | now |
| 15 | R04NIGGLE1 | Qwen | 6.25 | scripts/rules/Niggle.gd, tests/niggle_test.gd | A niggle warns a week before an injury, so pushing on becomes a gamble you can see | now |
| 16 | R16OWNLINE1 | Arena | 6.25 | scripts/rules/OwnLine.gd, tests/own_line_test.gd | A combo you built becomes a plan line, its fit worked out from how it is built (Playbook map 4.6) | now |
| 17 | R04RISKLINE1 | Cursor | 6.25 | scripts/ui/WeekCamp.gd (319) | The injury row shows "N in 100" with the gain beside it, and the niggle | after R04NIGGLE1 |
| 18 | R86TREND1 | Grok bot | 6.0 | scripts/rules/RankTrend.gd, tests/rank_trend_test.gd | Weekly rank history and an up/down arrow on the rankings | now |
| 19 | R102RECEIPT1 | Qwen | 6.0 | scripts/rules/MatReceipt.gd, tests/mat_receipt_test.gd | BJJ: what each of Ana's plan lines won or lost in the match (mat plan map M7). Discipline: BJJ | now |
| 20 | R102PRICE1 | Goose | 6.0 | scripts/rules/MatPrice.gd, tests/mat_price_test.gd | BJJ: what each mat line costs, with the defender's answer (mat plan map M3). Discipline: BJJ | after my MATLINES1 collect |
| 21 | R03READY1 | Goose | 5.5 | scripts/rules/Readiness.gd, tests/readiness_test.gd | Readiness for the night, with nerves; a peak camp gives +1 (core loop C15, C16) | now |
| 22 | R10AROUND1 | Qwen | 5.5 | scripts/rules/TrainAround.gd, tests/train_around_test.gd | An injured fighter can train around the hurt part, at a price, instead of forced rest | now |
| 23 | R23HABIT1 | Qwen | 5.5 | scripts/rules/HabitWork.gd, tests/habit_work_test.gd | A habit trained out over weeks: 3 pad places to half fixed, 3 more to gone, faster for a coachable fighter | now |
| 24 | R31CARRY1 | Arena | 5.5 | scripts/rules/Carry.gd, tests/carry_test.gd | The Why's one change, once accepted, is put on next week's board and marked on the plan | now (button after RESULTLOOK1) |
| 25 | R68SHOW1 | Cursor | 5.5 | scripts/ui/areas/FighterPage.gd (280), scripts/ui/MoneyPanels.gd (380) | The fighter page says "day job" when she works; the stipend switch shows "-15% training pace" | now |
| 26 | R11F | Qwen | 5.25 | brief exists (ops/research/TASK_R11F.md) | The result page names the members who leave after a loss | now |
| 27 | R11CENSUS2 | Goose | 5.25 | docs/SWING_CENSUS.md | Re-count the random swings that still give no reason, with today's line numbers, cut into small tasks | now |
| 28 | R27WALK1 | Qwen | 5.0 | tests/trust_walk_test.gd | One test that plays a Low fighter ignoring a shout, end to end | now |
| 29 | R46SPARSET1 | Goose | 5.0 | scripts/rules/SparSet.gd, tests/spar_set_test.gd | Sparring partners: a paid visitor or a club member, with fit and injury risk (club week map) | now |
| 30 | R52BAND1 | Qwen | 5.0 | scripts/rules/GoalBand.gd, tests/goal_band_test.gd | A fighter's goal in four bands instead of pass/fail | after foundation F3 |

**Design pages (MAP) and the free critics.** For R58 (the poaching), R37, R28, R44 (defences), R60, R33, R72 and R87,
the next critic round goes to free seats: Dola and one Grok bot as the two fresh critics (each reads
ops/research/CRITIC_PACK.md and CRITIC_ACCESS.md first, scores depth, lists the changes to reach 10/10 and writes its
10/10 page as HTML, which I render). John gets the real-world numbers first (R60: how long careers last; R44: how
often champions must defend), and Kalli the numbers tables. Dola has been parked since S299; your message today brings it
back for this work. The maps already in my critic workflow (R37, R58, HOSTSHOW, TURNPRO, WEIGHT, CUTMAN) finish their
round first.

**How the seats are shared (rules: at most 3 PC agents at once, Goose 3 a day and 2 at a time):**
- Qwen (PC, best record): tasks 7, 10, 12, 15, 19, 22, 23, 26, 28, 30, one at a time.
- Cursor (PC, Auto model): tasks 17 and 25, one at a time, beside Qwen. I open every still (it cannot see images).
- Antigravity or Cline (PC, third seat): takes the next free Qwen task when the watchdog is green.
- Goose (cloud): tasks 2, 4, 8, 14, 20, 21, 27, 29, about 3 a day, so about three days.
- Arena (cloud, free, public mirror): tasks 1, 3, 6, 9, 11, 16, 24, several at once in separate chats.
- Grok bots (xAI API, pure modules with no preloads, no repo test): tasks 5, 13, 18; I run their tests.

Rough timing (estimates, worked out from S433-S439 seat runs: a pure module takes a seat 1 to 3 hours, and my blind
review plus collect about 30 to 45 minutes each): tasks 3 to 5 and 7 to 10 can all land within a day of launch;
collecting all 30 takes about four to five sessions at my review pace. The three measuring jobs (1, 2, 6) start the
day the foundation branch merges.

## 6. What waits on you

- R28 cutman Part B: one new rule (the doctor's stop chance, the second's paid close, the cutman hired per night) needs
  your yes once its map reaches 7.
- R29: "your card" (rounds won) shown in the corner minute: the open cutman question 2.
- R63 Camp Board card game: you asked to see it first; my recommendation is to close it.
- R47 rematches (critics 7.25): currently LATER; worth your yes once the world runs.
- R32 and R93 (skip and simulate to the next stop): under 5 by your rule, but a long career is a chore without them.
  Delegate them anyway?

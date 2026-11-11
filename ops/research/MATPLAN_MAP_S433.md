# MAT PLAN: Ana's own fight plan for the mat (MATPLAN_MAP_S433)

The owner's ruling (S433, Q-188): "Ana's own fight plan for the mat (the grappler's plan rules): this version or the next?" -> "This version".
This map is the grappler's plan, built to sit beside the boxers' plan (PLAYBOOK_MAP_S432, PB): the same page logic (lines on places, each line
rated against the opponent's file, priced, worth a number, a receipt after), the same words (Push / Steady / Save, the Tank, works / fails, Coach's
draft, ON THE MATS beside ON THE PADS), in the mat's own units (points and beats of the match, chances in 100). Ana is the example; the rules serve any
grappler. Game text never says he, she, her or him.
Drawn: `docs/mockups/s433/matplan_v1.html` / `.png` (Ana's Fight plan tab against Rosa Lund, a Guard player, R1 of the London No-Gi Open).
Read whole: CRITIC_PACK, CRITIC_ACCESS, CORE_LOOP_MAP_S432 (CORE), PLAYBOOK_MAP_S432, GAMETREE1_DESIGN_S384, CLUBWEEK_MAP_V41_S432 3.6, TRAINING_MAP_S432 T12
and 8b, FIGHT_LINK_MAP_S432 M11, RPG_LAYER_MAP_S432 6 and 12, BJJ_CRITICS_R6_S398, BJJ_LIVE_CHOICES_V4_S428 and both its critic reviews (s428).
Code read: BjjTree, BjjWalk, BjjBeat, BjjBody, BjjOpp, BjjOpen, BjjRef, BjjMatch, NoGi, TheRead, Grapplers, MatTree, MatTreeInfo, OpenNight,
GrapplerPage, Playbook._mat_book, assets/data/bjj_tree.json (49 nodes, 135 edges, 80 moves, 8 routes).
Tags: CODE = in the game now (file named). NEW = this map adds it. ESTIMATE = a number with no source yet; the probe named sets it.

## 1. The idea in eight lines
- ONE PLAN, FIVE PARTS: the A-GAME (the positions Ana aims for: the goal tile and the route, already built), the OPENING (how the match starts),
  the ESCAPE ORDER (which escape, and when, from each bad position), the FINISH (which submission, and when, from each good position) and THE
  SCOREBOARD (the pace when level, ahead and behind: Push / Steady / Save, the boxers' words).
- BUILT FROM WHAT ANA OWNS: only moves Ana can use (Felt 15+, Owned 30+, Signature 50, BjjTree) can be lines; a Learning move shows ON THE MATS.
- EVERY LINE HAS A PRICE: the Tank it spends, where a miss lands and what it gives, and the read: every scripted line is one more look for the
  opponent (TheRead), so a long script gets read.
- THE FILE MOVES IT: the opponent's style says where the match goes; the tape finds the answers the opponent owns and the holes; each line is rated
  BEATS IT / WORKS / WALKS INTO IT from the code's own answer rule (a miss slides only as far as the defender owns the answer).
- ANA BRINGS ONLY SO MUCH: the A-game plus 3 lines at white, 4 at blue, 5 from purple (the belt's read of the match, BjjTree.IQ).
- THE MATCH RUNS IT: the walk the game plays (BjjBeat on BjjWalk) takes the plan's lines exactly as it takes the route's steps today.
- ANA LEARNS FROM IT: each line gets a receipt (tried, landed, read), a landed move teaches a little, the leak names the next drill.
- THE CORNER GRADES IT: the match replayed on the same dice with Coach's plan in place of yours: points and the result your plan turned.

## 2. What is built (read in the code, S433)
| Part | What it does today | File |
|---|---|---|
| The map | 47 positions + 2 endings, moves as arrows, one mirrored table for both athletes | assets/data/bjj_tree.json, BjjTree |
| Levels | Learning under 15 (never tried in an open), Felt 15-29 (odds x m/30), Owned 30, Signature 50; class time teaches the belt's tree moves (19.5 at Ana's start) | BjjTree.state, mf, class_part |
| The A-game | f["bjj_plan"] = {goal, steps (a route of up to 5 edges), name}; goal tiles Back / Mount / Legs / Points; Coach's fill (best route, one step off once scouted); swap at a fork; Systems (8 routes) | MatTree, MatTreeInfo.fill, BjjTree.plan_of |
| One odds formula | base x level x CHAIN 1.1 x mood / (max(0.9, the answer's level) x (1 + 0.6 x read)), then body, Tank, mat time, form, hand fighting on the logit; clamp 3-90 | BjjTree.odds, BjjWalk._parts |
| A miss | slides to the bad position only as often as the defender owns the answer (answer/30), else a reset (+1 advantage for a missed score or sub) | BjjTree.p_bad, BjjWalk.attempt |
| The read | each plan step shown gives the opponent 3 looks; 16 looks read it at white, 5 at brown (TheRead); plan steps only | BjjWalk.attempt |
| The beat | ~11 s, both sides choose: act, work (hand fighting: +0.15 on the logit a stack, 2 at most) or idle; two idle beats off a pin = the 20-s count | BjjBeat |
| Off the plan | the best p x gain - (1 - p) x slide x loss, rated against the opponent's TRUE answers; PLAN_PULL 1.5 toward the next plan step; 17% second best at white | BjjWalk.choose |
| Late lead | leading in the last 60 s (120 s at aggression 35 or less), on top or neutral: hold; never at aggression 68+ | BjjWalk.choose, BjjBody |
| The pace dial | f["mat_call"]: hunt +25 / steady 0 / hold -20 on aggression; acting x(1 + 0.5 x (aggr - 50)/50), +0.6 x (aggr - 50)/50 on every attempt's worth | BjjBody.CALLS, BjjBeat.act_p, aggr_bias |
| Behind on points | a trailer's scoring attempts at x0.5 whenever behind (SUB_TRAIL), unless far below on mat time; a leader's subs x1.1 | BjjBeat._trail_cut, BjjTree.odds |
| The Tank | gas 1.0 fresh; an attempt costs 4-7 (takedown 7, escape 6, sub 5) x (1.5 - cardio/100), a miss 3 more; equal Tanks cancel | BjjBody.GAS_COST, spend, tank |
| The field | 3 seeded opponents per open, one of five styles (Wrestler, Guard player, Passer, Half-guard player, Leg locker), a go-to route, owned moves by belt band, body by style | BjjOpp |
| After an open | rows with the path, mat_stats [tried, landed] per arrow, the leak (the hole that cost most) with one Drill, 2 classes of belt credit a bout, morale +4 / -3 / -6 | BjjOpen, Grapplers._close |
| Gym roll | every 2nd Sunday a 5-minute walk against Marta Kowal on the current plan: no film, no morale | BjjOpen.roll_week |
| Live bout | "Fight it: you call the moves": a second engine (BjjMatch on GrappleMap), 3 calls, default pick = best expected points | OpenNight, BeltMatch, BjjMatch |

## 3. What the code shows is thin
| Thin | The answer | Section |
|---|---|---|
| The plan is one route. Off it, Ana escapes and finishes by the walk's own pick, which reads the opponent's TRUE answers: improvising knows more than the coach does, so a scripted line can only lose | The KNOWN ANSWERS rule: improvising rates answers at what Ana knows (the file, else an even 30) | 4.5 |
| Under a pin an escape's worth is negative (a miss gives 4), so the walk never tries one: Ana works the hands until the top acts | THE ESCAPE ORDER: AT ONCE / FRAME FIRST / SIT TIGHT, a real choice | 4.1 |
| f["mat_call"] moves aggression, but no screen sets it | THE SCOREBOARD rows set it by the score | 4.1 |
| Behind on points, the code halves the trailer's scoring odds every time: a fitted lever (first scorer keeps ~80%), not a choice anyone made | The halving only while the leader is at SAVE: the leader pays for it with fewer attempts (TRAILFIX1) | 4.5 |
| The opponent's file is one free style word; the tape (GAMETREE stage 2) was never built | THE FILE for the mat: FILM costs one class | 4.4 |
| The live bout ignores the plan | The plan's line tops the call offer, tagged PLAN | 4.5 |
| Nobody has measured what a mat plan is worth (the boxers' was: 59 / 45.8 / 42.8) | MATPLAN0 first, today's game | 8 |

## 4. The mechanics

### 4.1 THE FIVE PARTS (NEW rule MatLines; the A-game is CODE)
WHAT THE PLAYER DECIDES, part by part:
1. THE A-GAME (CODE): the goal tile and the route of up to 5 steps (MatTree). Unchanged: the route is always brought and does not count against the hand.
2. THE OPENING (NEW as a slot; the moves are CODE): the first step from standing: PULL GUARD (BASE, lands 94 in 100, no points, no Tank), SHOOT
   (double leg 2 points, a takedown: Tank -6, a miss leaves Ana in the front headlock bottom if the opponent owns the sprawl), SNAP DOWN (to the front
   headlock, the kimura route's start), or WAIT (no opening: Ana improvises; the opponent's style shoots or pulls first). The A-game route begins where the
   opening lands; the strip shows the join ("Pull guard: closed guard, 94 in 100; a miss: seated guard").
3. THE ESCAPE ORDER (NEW): for each bad position Ana can land in (back taken, mount bottom, side control bottom, knee on belly bottom, north-south
   bottom, turtle, the leg positions from blue), one escape Ana can use, and its timing:
   - AT ONCE: tried on the first beat Ana acts there (the act roll as any pick).
   - FRAME FIRST: two beats of frames before the try (the code's hand-fighting stack: +0.30 on the logit at 2 stacks), so about 22 s under the pin
     in which the top may attack.
   - SIT TIGHT: no try; Ana frames and waits (today's walk), giving the top time and top points for the referee's decision (BjjRef.TOP_W).
   The ORDER is the list sorted worst first (back, mount, side control, knee on belly, turtle): when the hand is short, the lines at the top are the
   ones brought.
4. THE FINISH (NEW): for each good position (the A-game's end and any pin), one submission Ana can use, and its timing:
   - AT ONCE: tried on the first beat Ana acts there.
   - SET IT UP: two beats winning the hands first (+0.30 on the logit), the same stack the escape uses; the bottom has two beats to escape.
   A finish miss lands where the move's arrow says (the rear naked choke misses into half guard bottom when the opponent owns the seatbelt escape).
5. THE SCOREBOARD (NEW rows on the CODE dial): three rows, each Push / Steady / Save: LEVEL (the start), AHEAD, BEHIND. Push = aggression +25
   (acts 1.27x as often as Steady, takes the marginal shot, never holds a lead); Save = -20 (acts 0.82x, holds a lead from 2:00 left, off a pin the
   20-s count can come). Read every beat from the score and advantages. Coach's draft: Steady / Save / Push.
THE HAND (NEW, mirrors PB 4.7's proposal): lines brought besides the A-game: 3 at white (BjjTree.IQ 40), 4 at blue (55), 5 at purple and up (70+).
A line written but not brought plays as improvising there. The scoreboard rows are the coach's shouts and are always brought.
SHOWN: the Fight plan tab (section 5), one row a line; the open card and the open night carry one line each (section 6).
REAL BASIS: a no-gi game plan is exactly this list: where to start (wrestle or pull), the A-game route, the escape priorities ("never give the back"),
the finishing positions, and the score rules ("two up, hold it; behind, go"). "Position before submission" is the set-up; "frames before you move" is
frame first.

### 4.2 HOW THE COACH BUILDS IT FROM THE TREE (CODE fill + NEW lines draft)
- COACH'S DRAFT (NEW, the boxers' "Coach's draft, your changes in gold"): the A-game from MatTreeInfo.fill (CODE: Ana's best owned route, one step off
  once the opponent is scouted); each bad position the field walks Ana into most (MatTreeInfo.leaks, CODE: 200 seeded walks against the next field) gets
  Ana's usable escape with the best chance, FRAME FIRST when a miss slides 1 time in 2 or more, else AT ONCE; the A-game's end gets the best usable
  finish, SET IT UP when the chance at once is under 25 in 100; the scoreboard Steady / Save / Push. Your changes are drawn in gold; "Back to Coach's draft".
- WHAT CAN BE A LINE: only an arrow from that position whose move Ana can use (Felt or better, legal under the open's IBJJF table, BjjTree.legal). A
  position with no usable escape shows the Learning one with ON THE MATS (puts the drill on the week: gdrill / gplan, CODE) and "Felt in 1 Sunday"
  from 3.2 a week (NoGi.DRILL_GAIN).
- A CLICK ON THE MOVE cycles the usable alternatives at that position (the MatTree swap pattern, CODE); a click on the timing chip cycles it; a line is
  dragged in or out of the hand.
- WHAT ANA'S DIRECTION ADDS (RPG 12, a link): GUARD PLAYER drafts PULL GUARD and the back; TOP GAME drafts SHOOT, passes and Mount. Ana's perk picks (RPG 6)
  show on the lines they touch: GUARD RETENTION on the side-control escape row ("passes on Ana 1 in 5 less"), SCRAMBLES on the opening SHOOT ("a miss keeps
  the initiative").

### 4.3 EVERY LINE HAS A PRICE (NEW display MatPrice; every number is the walk's own)
| Chip | What it is | From |
|---|---|---|
| CHANCE | in 100 a try, against this opponent as far as known (a range while an answer is hidden) | BjjTree.odds with the known answer, the body shift, CHAIN on the route |
| POINTS | what a landing scores, and the position it gives | the edge's points, BjjTree.node_value |
| MISS | where a miss lands and what it gives, with how often it slides ("mount, 4: 7 in 10") | edge bad / bad_gives, p_bad |
| TANK | what a try costs, a miss more ("Tank -6, -8 on a miss"); FRAME FIRST and SET IT UP add about 1 | BjjBody.GAS_COST x drain, MISS_GAS, BjjBeat.WORK_GAS |
| READ | each scripted line or step adds 3 looks for the opponent: "read x0.82 by the 3rd scripted try at white" | TheRead.looks_needed, READ_W 0.6 |
| TIME | FRAME FIRST and SET IT UP spend 2 beats (about 22 s) under or on top | BjjBeat beat 11 s |
| WORTH | points a match: the line against improvising there, from seeded walks of this plan against this file (a range until MATLINE1 reports) | MatPrice.worth (NEW), BjjWalk |
So every line trades: AT ONCE is quick and unread-by-time but at the bare chance; FRAME FIRST is +6 to +8 in 100 but gives the top 22 s; a long
script lands its later steps at x0.75-0.82 (read) while a short one gives fewer points; SHOOT scores 2 but spends 6 of the Tank and can hand over the
front headlock; PULL GUARD is free and scores nothing. No line is right against every style (gate in MATLINE1).
GRADE (NEW word on a CODE number): "Ana does it: Good / OK / Poor" from the body shift the walk already adds (BjjBody.shift, Ana's attributes against
the opponent's on what the move reads, capped +-0.25 on the logit): Good at +0.08 or more, Poor at -0.08 or less (ESTIMATE cut points, the words only;
no new multiplier). "OK (Flexibility 56 against Rosa's 61)".
LEVEL: Felt (x level/30), Owned, Signature (CODE), with the Sunday it moves ("Owned in 2 Sundays" at 3.2 a week).

### 4.4 THE OPPONENT'S FILE (NEW for the mat; the field is CODE)
- FREE AT THE DRAW (CODE): name, belt, style word for the three bracket opponents (BjjOpp.field, drawn at entry).
- WHERE THE MATCH GOES (NEW display, CODE walks): of the match's beats (27 at white, 5:00 / 11 s), about how many Ana spends standing, in guard
  (bottom), on top, pinned underneath, in a scramble: from the seeded walks MatTreeInfo already runs for the leaks, marked "about" until a bout is
  fought. This is the line budget's price list: a Guard player keeps Ana in guard, so the closed-guard finish matters and the takedown less.
- THE TAPE (NEW): FILM is a class kind on Ana's week (proposed to TRAINING T12 beside Drill / Positional / Hard rolls; its call): one class, one file
  entry on the next opponent, in this order: (1) the go-to route (the opponent's own plan, BjjOpp route, CODE), (2) the answer to the A-game's first
  scoring step, (3) a hole Ana's game can reach (BjjTree.holes on the opponent), (4) the answer to each brought line in hand order. Between bouts at the
  open, WATCH THE OTHER SEMI opens one entry on the next opponent (GAMETREE 5.3).
- WHAT A FOUND ENTRY CHANGES: the line's READ chip turns from "vs the field" to "vs Rosa": BEATS IT (the opponent owns no answer: the odds divide by
  0.9 and a miss resets, never slides), WORKS (an answer under 30: a miss slides that share of the time), WALKS INTO IT (an answer owned: the odds
  divide by its level and every miss slides). And it changes the match through KNOWN ANSWERS (4.5): a found answer or hole is what Ana's own picks
  play to. The truth never changes: a hole works whether found or not; the file decides whether the PLAN uses it.
- THE SWAP HINT (the boxers' amber line): "Kimura grip from closed guard beats Rosa (no kimura defence found): 48 in 100 against the armbar's 14.
  Swap." One click.
REAL BASIS: no-gi teams scout the bracket on match footage: what the opponent opens with, which escapes they own, where they get stuck.

### 4.5 HOW THE MATCH READS IT (wired into the rules the code runs: BjjBeat.walk -> BjjWalk.choose / attempt)
| Plan part | Where it enters | What changes |
|---|---|---|
| A-game, opening | f["bjj_plan"].steps via BjjTree.plan_of (CODE); the opening is the route's first step | as today: on the step's position the walk takes it; PLAN_PULL steers to it |
| Escape and finish lines | NEW MatLines.pick(ctx, st, s) called first in BjjBeat._choose for side 0 (and any side with lines) | on a lined position the pick is the line (why "line"); it is read like a plan step (3 looks) and keeps the CHAIN only on the route |
| FRAME FIRST / SET IT UP | BjjBeat.walk, the intent step (NEW, about 6 lines) | while the side's hand-fighting stack is under 2 on that line's position, intent is WORK; at 2 it acts |
| SIT TIGHT | MatLines.pick returns no attempt there | WORK every beat (never IDLE, so never the 20-s count under a pin, CODE) |
| THE SCOREBOARD | BjjBeat.walk, top of each beat (NEW, 3 lines) | ctx body aggression = Ana's own + CALLS[the row for the score now] (CODE values), so act_p, aggr_bias and the late hold follow it |
| KNOWN ANSWERS | BjjWalk.choose: the answer level used to RATE an off-plan pick (NEW, about 6 lines) | an improvised pick is rated against the answer the side knows (the file's entry, else 30, an even owned answer); the roll still uses the TRUE answer. Both sides, so the opponent improvises on the same terms |
| TRAILFIX | BjjBeat walk, the SUB_BEHIND step (CHANGED) | the trailer's x0.5 on scoring applies only while the leader's scoreboard row is SAVE; the opponents' default when ahead stays the code's late hold (TRAILFIX1 refits SUB_TRAIL so the first scorer still keeps 80-87%) |
| Gym roll | BjjOpen.roll_week (CODE) passes f, so the lines run in Sunday's roll too | "Test it" for free: every 2nd Sunday against Marta, no film, no morale |
| Live bout | BjjMatch.offers (NEW tag, MATLIVE1) | when a call comes in a position class the plan lines (guard, half guard, side control, mount, back: BjjClash.WHERE), the plan's move tops the offer tagged PLAN; the default pick (no call) is the plan's move when offered |
Nothing else in the walk changes: the odds formula, the slide, the referee, the Tank, the beat.
REAL BASIS: a grappler under a pin does not know whether the top owns the counter until they try; a coach who filmed the opponent does.

### 4.6 WHAT ANA LEARNS FROM THE MATCH
- THE RECEIPT PER LINE (NEW display on CODE data: the path [edge, actor, hit|miss|reset, t] and mat_stats [tried, landed]): "Frame and recover guard:
  2 of 3 (framed first), one miss into mount at 3:40". Across opens the verdict words of the boxers' record (PlanRecord.verdict, CODE: works at 55%+,
  fails at 35% or less, on 6 tries or more; else even or too early).
- BOUTS TEACH (NEW, ESTIMATE, the same size as TRAINING's bouts teach): a move landed in an open +1 level, tried and missed +0.5, at most +3 a move an open;
  a Felt move landed in an open shows "landed in an open" on its arrow. Season effect: weeks to Owned (cut rule passes on a season effect, CORE C27).
- THE LEAK (CODE, BjjOpen.leak_of): the hole that cost most, with its one Drill; when a brought escape line was the one that failed there, the leak
  names the line ("the seatbelt escape line: 0 of 2").
- THE TAPE ON ANA (LATER, GAMETREE 5.4): the field filming Ana's most-used route across opens is not in this version; inside a match the read is (CODE).

### 4.7 THE GRADE THE CORNER GIVES (NEW, one rule with the boxers' Why)
- YOUR PLAN, as a group in the mat scales (FIGHT LINK M11 BJJSCALES1, in this version): the match replayed on the SAME seed with Coach's draft in place
  of your plan (Coach's A-game, Coach's lines, Steady / Save / Push). The difference in points, and whether it turned the result.
- THE WORD (FightWhy's words, CODE): GOOD (your plan scored 2 or more points more than Coach's on the same dice, or turned a loss), WRONG (2 or more
  fewer, or turned a win), MIXED between, NONE (Coach's draft untouched). One line: "Your plan: +3 points against Coach's on the same rolls: the frame-first
  escape held twice. Good."
- Each line row with KEEP, CHANGE (opens the Fight plan on it) and ON THE MATS (the drill on next week, CODE gdrill / gplan).
- Season sum on the Character tab's "what your picks won" (RPG 15): "your mat plans this season: +11 points, 1 match turned".

### 4.8 LINKS (nothing new in these maps; each takes one hook)
- TRAINING (T12, 8b): the class kinds; FILM proposed as a fourth kind (4.4); "THE OPEN: WHAT THIS WEEK BUYS" names the plan line one Sunday from Owned.
- CLUB WEEK (3.6): Ana's row shows the open, the file dots ("Rosa 2 of 4 filmed") and FILM as a class kind; who corners the open (you or the mat coach for
  $100): the cornering side gives the between-bouts change (4.9); the mat coach changes nothing.
- RPG (6, 12): the direction drafts the A-game and the opening; perk versions show on their lines; experience: none for a plan (outcomes only, RPG rule).
- CORE C2: the mat's gas is shown as the Tank (0-100), the one Tank; C13: a choice's effect on a match in points and beats, chances in 100; C1: no bond.

### 4.9 BETWEEN BOUTS AT THE OPEN (NEW, the corner minute's mat version)
One change before each bout after the first: one line (move or timing) or one scoreboard row, priced on the next opponent; or WATCH THE OTHER SEMI
(one file entry). Not both: one press. The last bout's receipt is shown above it. Never a pop-up: it sits in the open night's bout card.

## 5. The key screen: Fighter page (Ana) > Fight plan (drawn: matplan_v1.png)
Drawn: Ana Ribeiro (white, 2 stripes; Strength 52, Cardio 58, Flexibility 56, Explosiveness 50, Composure 45, Aggression 52: CODE NoGi.athlete) against
Rosa Lund, Guard player, white (Rosa's numbers drawn, ESTIMATE). Header: tabs, name, the vs plate "Sat 7 Feb, 5 days: London No-Gi Open, R1 Rosa Lund".
- THE A-GAME (top): goal tiles Back / Mount (on) / Legs / Points; the strip: OPENING Pull guard (94, free) -> Closed guard -> Hip bump sweep (EVEN 50,
  +6) -> Mount -> the finish line. "Coach's draft: Mount. Your changes in gold."
- THE LINES (one row a line): WHERE (the position, "5 of 27 beats" as a bar), THE LINE (move + timing chip), READ vs Rosa, ANA DOES IT, LEVEL, PRICE
  chips, CHANCE, WORTH. Rows drawn: FINISH Mount: Americana, SET IT UP (Works: Rosa's bridge about 35; OK; Owned 30; Tank -5; miss: half guard top, 0;
  20 in 100, 15 at once). ESCAPE Side control: Frame and recover guard, FRAME FIRST (Works: Rosa's step to mount about 21, a miss slides 7 in 10; OK;
  Owned 36; Tank -6; miss: mount, 4; 42 in 100, 35 at once). ESCAPE Back taken: Seatbelt escape, AT ONCE (not filmed: vs the field, a range 20-24; OK; Felt 22: Owned in
  3 Sundays; miss: mount, 4; 24 in 100). The hand line: "Ana brings 3 (white belt) - 4 written". The red swap line under the A-game's guard: "Armbar from
  guard walks into Rosa's posture (38): 14 in 100. Kimura grip beats Rosa (no kimura defence found): 48. Swap". The written-not-brought row: Turtle: Stand up.
- THE SCOREBOARD (under the lines): LEVEL Steady; AHEAD Save ("holds from 2:00 left; off a pin the 20-s count"); BEHIND Push ("tries 1.27x as often,
  never holds").
- RIGHT: ROSA'S FILE (style word free; go-to route found: Closed guard sweep to mount; hole found: no kimura defence; "?" answers to the escapes; FILM
  (1 class) and its date); WHERE THE MATCH GOES (bars, "about"); THE LINE (the selected escape taken apart: base 30, Ana's level x1.03, Rosa's answer
  floor /0.9, frames +0.30, the read by the 3rd try x0.82, Tank, the slide; against SIT TIGHT); THE LAST OPEN (the receipt: three rows with KEEP / ON THE MATS).
- BOTTOM: "Your plan against Coach's: +2 to +6 in 100 a match (about: MATLINE1 sets it)"; buttons Coach's draft, Systems, Test it in Sunday's roll, Save plan.
Worked numbers (CODE formula, MF_CEIL 1.4, D_NONE 0.9, CHAIN 1.1, READ_W 0.6, hand fighting 0.15 a stack; Rosa's levels ESTIMATE):
hip bump sweep 0.52 x mf(32) 1.011 / mf(38) 1.046 = 0.50. Americana from mount after the sweep: 0.16 x 1.0 x 1.1 / (mf(35) 1.029 x read(3 looks of 16)
1.1125) = 0.154; SET IT UP: logit -1.71 + 0.30 = 0.197. Frame and recover guard: 0.30 x mf(36) 1.034 / 0.9 = 0.345; FRAME FIRST: 0.416; miss slide
21/30 = 0.7. Seatbelt escape: 0.30 x 22/30 / 0.9 = 0.244. Armbar from guard: 0.16 x 28/30 / 1.046 = 0.143. Kimura grip (entry 0.42) with no
answer: 0.42 x mf(35) 1.029 / 0.9 = 0.48. Tank: escape 0.06 x (1.5 - 0.58) = 5.5 of 100; a miss 2.8 more.

## 6. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Fighter page (Ana) > Fight plan | the A-game strip, the lines (where, line + timing, read, does it, level, price chips, chance, worth), the hand, the scoreboard rows, the file, where the match goes, THE LINE, the last open's receipt, plan against Coach's, Coach's draft, Test it | NEW MatPlanPanel.gd (MatTree is 499 lines: the lines live in their own scene part), MatTree (strip, CODE), NEW MatLines, MatPrice, MatFile; BjjTree, BjjOpp, MatTreeInfo.leaks / fill |
| Fighter page (Ana) > Playbook (mat book) | the moves list with each move's line chip ("a line: side control escape") and ON THE MATS on a line's Learning alternative | Playbook._mat_book (CODE), MatLines.lines_using(move) |
| Grappler page (record) > next open | "Plan: Closed guard to mount, 3 lines brought, vs Rosa about +4 in 100 against Coach's"; Fight plan button | GrapplerPage (448 lines: one row via MatOpens), MatPrice.vs_coach |
| Fights > Ana's open card (and the sheet tab, CW) | the three bracket names with style words, file dots, "Plan for R1: ready / Coach's draft" | MatOpens.card (CODE), MatFile.depth |
| Club week > Ana's row | the open, file dots, FILM as a class kind with its entry ("Thu: film Rosa") | CW Ana row, NoGi.classes_of, MatFile.film (NEW) |
| Training (Ana) | "THE OPEN: WHAT THIS WEEK BUYS": the plan line one Sunday from Owned; FILM class in the class kinds | TR 8b panel, BjjTree.state, MatLines |
| Open night (modal) | before each bout: the opponent, the three numbers (CODE), YOUR PLAN in one line; between bouts: the last receipt and ONE CHANGE or WATCH THE OTHER SEMI | OpenNight (97 lines), NEW MatBetween.gd, MatLines.set_line |
| Live bout (Fight it) | the call offer with the plan's move first, tagged PLAN; the default pick follows it | BjjMatch.offers (NEW tag), BeltMatch / MatHud (CODE) |
| Open result (OpenNight end) | per line receipts, YOUR PLAN in the mat scales, the corner's word, KEEP / CHANGE / ON THE MATS | NEW MatReceipt.gd, BjjOpen rows (path), FL M11 scales |
| Week review (Monday) | the open's path lines and leak (CODE), the receipt rows, "Seatbelt escape: Owned: the back line now at x1.0" | WeekReview grappler rows (CODE), Grapplers.tree_report, MatReceipt |
| History (Ana's opens) | each bout with its plan word (good / mixed / wrong / none) and the receipt | GrapplerPage record rows, MatReceipt |
| Character (Ana) | "your mat plans this season: +N points, M matches turned" | RPG 15 ledger, MatReceipt season sum |
Not on Home (a plan is never a need: Coach's draft always exists) and not on World (no ranking table: the belt is the ladder, CODE).
GOLDEN PATH (tests/mat_plan_path_test.gd, Grok Dev): open Ana's Fight plan; Coach's draft present; film Rosa once (the go-to route found); take the
swap hint; set the side-control escape to FRAME FIRST; set BEHIND to Push; sim the open; the path shows the frame-first escape tried after 2 work beats;
the receipt names the line; the corner's word is shown; ON THE MATS puts the seatbelt drill on the week; Sunday's roll runs the same plan.

## 7. Numbers: from the code, or ESTIMATE
| Number | Value | Tag | Set by |
|---|---|---|---|
| Levels, odds, slide, read, beat, Tank costs, pace dial, late hold | as section 2 | CODE (BjjTree.T0, BjjBody, TheRead, BjjBeat) | - |
| Hand fighting a stack / stacks for FRAME FIRST and SET IT UP | 0.15 / 2 (+0.30) | CODE (GRIP_W, GRIP_MAX) | MATFRAME1 keeps or cuts the timing |
| The hand: lines by belt | 3 / 4 / 5 | ESTIMATE (on BjjTree.IQ 40 / 55 / 70) | MATCARRY1 |
| Grade cut points on the body shift | +-0.08 | ESTIMATE (words only) | none: display |
| KNOWN ANSWERS default | 30 (an even owned answer) | ESTIMATE (BeltRoad.OWNED_AT) | MATKNOW1 (bars 1, 2, 16 of GAMETREE kept) |
| SUB_TRAIL only at SAVE | x0.5 refit | CHANGED CODE | TRAILFIX1 |
| Bouts teach | +1 landed, +0.5 missed, 3 a move an open | ESTIMATE (TR's bouts teach) | season effect; BOUTTEACH1 counts weeks to Owned |
| Plan against Coach's on the screen | "+2 to +6 in 100" drawn | ESTIMATE | MATLINE1 |
| Where the match goes | drawn bars | ESTIMATE | the walks themselves (MatTreeInfo, 200 a draw) |
| Rosa's answer levels | 21 / 35 / 38 drawn | ESTIMATE (BjjOpp bands: owned 30-45, class share 0.5-0.9) | the seeded field |

## 8. Probes and the cut rule (CORE C27: a choice stays if it moves 1.5 in 100 on the matches where it applies, or has a season effect)
All on the played walk (BjjBeat), 1,000 seeded matches a cell, five styles, three belts (white, blue, purple), never two identical athletes; each prints
today's game first and writes its rows to ops/AgentComms/levers.json.
| Probe | What it must show | If not |
|---|---|---|
| MATPLAN0 | today: Ana's route plan against no route and against Coach's fill, per style (the baseline every other probe reads) | report only |
| MATKNOW1 | KNOWN ANSWERS on: GAMETREE bars 1 (win 0.49-0.59), 2 (leaks) and 16 (first scorer 80-87%) still in band; a file of 3 entries worth 3+ in 100 a match | refit EPS; else improvising keeps true answers and the file only moves the chips |
| MATLINE1 | a drafted plan of 3 lines beats the route alone by 1.5+ in 100; no single line choice best against all five styles; worth ranges for the screen | lines shown as advice only (no match effect): the plan is the route and the scoreboard |
| MATFRAME1 | FRAME FIRST, AT ONCE and SIT TIGHT each best against some style on some position | the losing timing is cut from the chip |
| MATFINISH1 | SET IT UP beats AT ONCE against some styles and loses against others (escape-heavy bottoms) | one timing |
| MATCLOCK1 | BEHIND Push wins back 10+ in 100 of matches trailing with 2:00+ left against Steady; AHEAD Save keeps 3+ more leads than Steady against Push opponents (the v4 critic's bar) | the row is cut to a word on the coach's shout |
| TRAILFIX1 | with the halving only at SAVE, the first scorer still keeps 80-87% (bar 16) and no style leaps past 0.61 | SUB_TRAIL stays as now; Push still adds tries |
| MATCARRY1 | 4 lines against 3 at white move 1.5+ | the same hand for every belt |
| MATLIVE1 (test, not a probe) | the PLAN tag tops the offer only in a matching position class | - |

## 9. Build tasks (each under 500 lines, one owner, its test red on main first)
| Task | What | Files (lines today) | Red test | Seat | Waits on |
|---|---|---|---|---|---|
| M0 MATSPLIT1 | MatTreeInfo (502, over the rule) split: walks and leaks to MatWalks.gd; MatTree (499) gives its plan strip a slot for MatPlanPanel | MatTreeInfo, MatTree, new MatWalks | tests/bjj_tree_ui_test.gd stays green; new tests/mat_split_test.gd: no file over 500 | Claude | none |
| M1 MATPLAN0 | the baseline probe | new tools/mat_plan_probe.gd | prints the table; tests/mat_probe_rows_test.gd red until it writes levers.json rows | Goose | none |
| M2 MATLINES1 | pure MatLines.gd: the plan shape {goal, steps, name, opening, lines[{at, edge, timing}], board{level, ahead, behind}}, validate (usable, legal, the at-position is the edge's from), the hand by belt, Coach's draft, pick(ctx, st, s) | new MatLines.gd (~220) | tests/mat_lines_test.gd: a learning move refused; white keeps 3; draft picks frame first at slide >= 0.5; pick returns the line on its position only | Qwen | none |
| M3 MATPRICE1 | pure MatPrice.gd: chance (with the known answer), points, miss, Tank, read, time, grade, level, chip words; worth from seeded walks | new MatPrice.gd (~200) | tests/mat_price_test.gd: the worked numbers of section 5 (0.50, 0.154, 0.197, 0.345, 0.416, 0.244, 0.143, 0.48) to 0.005 | Qwen | M2 |
| M4 MATWALK1 | wiring: BjjBeat._choose calls MatLines.pick; FRAME FIRST / SET IT UP in the intent step; the scoreboard sets aggression each beat; BjjWalk.attempt reads "line" picks as plan picks for the read | BjjBeat (227), BjjWalk (488: +4 lines) | tests/mat_plan_walk_test.gd: a seeded walk with an escape line tries it from side control; FRAME FIRST works two beats first; BEHIND Push raises Ana's attempts; no line = today's path exactly (seed for seed) | Claude | M2 |
| M5 MATKNOW1 + TRAILFIX1 | KNOWN ANSWERS in BjjWalk.choose; SUB_BEHIND only at SAVE; both behind T keys so the probe can switch them | BjjWalk, BjjBeat, BjjTree.T0 | tests/bjj_beat_test.gd bars re-run; new tests/mat_known_test.gd: an improvised pick ignores an unfound hole | Claude, probes Goose | M1, M4 |
| M6 MATFILE1 | pure MatFile.gd: entries in order, film(f, opp) one entry, the other semi, depth, found answers per line; FILM class kind hook in NoGi.classes_of | new MatFile.gd (~160), NoGi (312) | tests/mat_file_test.gd: entry order route, answer, hole, lines; a film class opens one; NoGi classes drop by one | Qwen | M2 |
| M7 MATRECEIPT1 | pure MatReceipt.gd: per-line receipt from the path, verdict words, the YOUR PLAN replay group (same seed, Coach's draft), the corner's word; BOUTTEACH in Grapplers._close | new MatReceipt.gd (~180), Grapplers (263) | tests/mat_receipt_test.gd: a replay with the same plan gives 0; a turned loss is GOOD; +1 / +0.5 teach, capped 3 | Qwen, wiring Claude | M4 |
| M8 MATPLANUI1 | the Fight plan tab for a grappler: MatPlanPanel (lines, chips, hand, scoreboard, file, THE LINE, receipt) from matplan_v1 | new MatPlanPanel.gd (~420), Playbook (tab entry) | tests/mat_plan_ui_test.gd: rows exist per brought line; a click cycles the move; no he/she text | Cursor (Claude checks the stills) | M2, M3, M6 |
| M9 MATOPEN1 | open night: YOUR PLAN line, between-bouts ONE CHANGE or the other semi, the result's receipts and word; GrapplerPage / MatOpens lines; Club week and Training hooks | OpenNight (97), new MatBetween.gd (~150), MatOpens (72) | tests/bjj_open_night_test.gd extended: one change only; the receipt rows match the path | Cursor | M7 |
| M10 MATLIVE1 | the live bout's offer: the plan's move first, tagged PLAN, by position class | BjjMatch (356: +20) | tests/bjj_match_test.gd extended: PLAN tag only on a matching class | Claude | M2 |
| M11 golden path | section 6 | tests/mat_plan_path_test.gd | red until M2-M9 land | Grok Dev | M9 |
Order: M0, M1 and M2 at once; M3, M4, M6; probes MATKNOW1, TRAILFIX1, MATLINE1, MATFRAME1, MATFINISH1, MATCLOCK1, MATCARRY1 on M4; M5 by their
results; M7; then screens M8, M9 (Claude opens every still); M10; M11 last. No size on any screen before its levers.json row exists.

## 10. Rejected, and why
- A line on every position (a full script): white belts read 3; a 47-position script is the spreadsheet the mat page exists to avoid (GAMETREE 5.1).
- IF READ on mat lines (PB 4.4's slot): the mat's read is gradual (TheRead looks), not a trigger; the price chip shows it and the answer is a shorter script.
- The v4 live layer (hidden rival modes, the ear, predict, bait): both s428 critics scored it 5.5-6 and found four dominant strategies; this map is the
  plan BEFORE the match; the live bout gets only the PLAN tag. The v4 critic's own top request ("make the plan move the Playbook's lines ... a STANCE
  that rewrites the plan move by score and clock") is what this map builds.
- A new mat pace dial or a "stance" meter: the code's aggression dial (mat_call) under the boxers' words Push / Steady / Save does it.
- A third finish timing "only when ahead": the AHEAD row (Save holds) and the BEHIND row (Push) already decide when the finish is worth the risk.
- "Work the grips" as a screen word: no-gi words are FRAMES (underneath) and HANDS (on top) (s428 critic).
- A separate mat grade letter: the Why's words (good / mixed / wrong / none) and the record's (works / fails / even / too early).
- The field filming Ana across opens (GAMETREE 5.4) and rematch memory: later, with the small living world.
- Reading the whole plan in the live bout: needs the GrappleMap-to-tree map (GAMETREE 8 "Later"); the PLAN tag is the honest part.
- Experience for writing a plan: the RPG rule pays outcomes only.

## 11. Risks
- TWO FILES ALREADY AT THE LIMIT: MatTree 499, MatTreeInfo 502 (over), BjjWalk 488. M0 splits first; the walk takes only call lines; logic lives in
  MatLines.
- CALIBRATION: KNOWN ANSWERS and TRAILFIX move the fitted table (S398 critics' bars). Both sit behind T keys; the probes decide; switch-off keeps today.
- THE PLAN MAY BE WORTH LITTLE AT WHITE: Ana owns few escapes (one per bad position except side control and turtle), so at white the choice is mostly
  timing and the scoreboard. MATLINE1 says so if true; the lines then grow with belts (blue's escapes, purple's systems).
- THE GLOBAL T DICT: BjjBeat writes transient keys (SUB_BEHIND, LEAD_FIN) into BjjTree.T; the scoreboard must write ctx, never T; tests call reset_tuning.
- TWO ENGINES: the live bout reads only the PLAN tag; a player who fights live gets less of the plan. Said on the open night button's hover.
- PRONOUNS: move and line strings in data (no_pronoun_test scans assets/data and the new modules).
- USAGE: critic rounds cost money (S428, S431 notes); the brief is this map and the picture, nothing else.

## 12. Left for later
- The field films Ana's most-used route across opens; rematch memory (career.bjj_opps).
- Opponents with their own scoreboard by style (a Leg locker always Push).
- Lines for the leg positions at white (straight ankle lock only under IBJJF): from blue.
- A second line per position (a back-up escape when the first is read).
- The live bout on the tree (one engine).

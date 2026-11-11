# The Playbook: a head coach's review (S432, fresh critic)

Who is judging: a head coach who writes fight plans and drills combinations for amateur boxers before every bout.
What I read: CRITIC_PACK.md, CRITIC_ACCESS.md; the rules PlanLines, PlanFight, PlanBoard, PlanRead, PlanPressure, PlanFile, PlanTemplates,
CoachPlan, PlanCards, PlanRecord, ReadBack, FireLevel, Combos, OwnCombos, ComboFlow, ComboOdds, MoveMastery, TheRead, WeekOpp, FightWhy,
the plan part of LiveRound (where the plan's numbers enter each 30-second exchange); the screens GamePlan, GamePlanRows, ComboBuilder, ComboStrip;
the real screens 23g/23h/23i (Playbook), 19b (corner minute), 21 (result and the Why), 18 (tale of the tape). Linked, not redesigned:
CLUBWEEK_MAP_V41_S432 (the week; "the plan is a hand: a bout takes 4 lines", "a corner that shared a card has seen your winning line"),
RPG_LAYER_MAP_S432 (the coach's growth and style, the extra line), HYPE_MAP_S432. TRAINING_MAP_S432 did not exist when I read.

## Score: depth 6 / 10

One line: the best-wired system in the game and you can see every cause, but the decision is mostly solved: the read is a fixed table shown
as a green chip, the boxer's body never changes which answer is right, and the drilling past Usable buys almost nothing.

## How the Playbook works today (from the code)

- The plan is up to 4-9 LINES (the coach's rating sets how many): a place in the ring (8 places) and, if wanted, a situation ("the opponent presses",
  "boxes at range", "waits to counter", "loads up", "tires", plus our own trouble). Each line is one move from a fixed map of about 30 moves (book
  combinations, steps, defences).
- Each answer is rated against the opponent's game from one fixed table (PlanFight.ANSWERS): Beats it (+9), Works (+3), Walks into it (-7), minus
  what the boxer does on that spot with no plan. A combination under 30 on the pads plays at 80%.
- In the fight: every 30 seconds the bout puts the exchange on a place; the line there fires. A right answer that wins builds a READ (+3.5 an
  exchange, up to 2, for the round) and PRESSURE that cuts the opponent's landed punches for the whole bout; a wrong answer that is punished shrinks
  our boxer's tank for good. Leaning on one right answer loses 30% a use after two uses in a round. Round pace (Push / Steady / Save) and a go-to
  own combination (thrown more while the tank throws it whole) sit on the same page.
- The tape opens the opponent's tells; the plan page lists each with the line that fires on it and a one-click better answer.
- Test it spends a sparring night: 20 quick bouts, a range of wins, the round it breaks in and the weakest line.
- With no plan the hired coach writes a safe one (one or two cards, never a wrong answer, never as good as the player's).
- In camp the pad tray turns into the plan's cards (opener, answers), stamped "not usable by fight night" when the pad time cannot reach 30.
- Corner minute: change one line from a drop-down, see each line's won/used; a set-up "NOW" fires a drilled combination into a gap.
- After: the Why grades the plan against no plan (GOOD / MIXED / WRONG, right and wrong answers, worth about +X%), pressure taken off, the tank lost,
  NEXT names the drill; each line carries "In bouts: 7 of 11 won, works".
- Combos tab: build a chain from punches, defences and steps; coach's flow rules score it; it gets its own pad mastery; Signature at 85 may run one
  punch past the hand-speed cap.

## What is good

- Every number the plan page shows is the number the fight uses. Beats it / Works / Walks into it and the edge are the bout's own sums; the combo lab's
  odds are the bout's own dice. This is honest design, and rare.
- Cause and effect is readable at every step: line rating before, per-line won/used in the corner minute, the Why's graded plan after, the per-line
  record across bouts. A player can learn boxing from it.
- The plan bites without deciding: reads and pressure reward a right answer over the round and the bout; a wrong answer costs the tank for the rest of
  the night. A good plan is worth about +15 to +24 in 100 bouts, training still wins (the pack's rule holds).
- The tape and the plan are one loop: a found tell names its situation and the answer is one click; an unfound tell says how to open it.
- Test it costs a real sparring night and narrows with a matching partner and film: a real price on information.
- The coach's own plan is safe but weaker than yours: the player is always the better reader, a good hook for "the plan is the star".
- Camp mode of the pad tray links the plan to the week: the plan's lines become the week's drill cards with a "too late" stamp.
- Real fight plans as templates teach real boxing and fill a board in one click.

## What is missing (options a coach would reach for and cannot)

1. HOW THIS BOXER DOES IT. A line's worth ignores the boxer's body. Pivot off the ropes is "Beats it" for a boxer with Footwork 47 the same as for one
   with 80; Stand your ground (the Holyfield template) says "strong, durable boxers only" and nothing checks it. The corner calls already have this
   (Exchanges.grade: Good / OK / Poor and COMMIT), the plan lines do not. This is the missing link between building the fighter and the plan.
2. A REASON TO DRILL PAST USABLE. A line fires every time from 30; Sharp is worth about 1 win in 100 over Usable. The fix exists and is measured
   (FireLevel: 1 in 2 at Usable, 3 in 4 at Sharp, always at Signature: +2.8 and +2.7 wins in 100) but is switched off.
3. AN OPPONENT WHO ANSWERS BACK. Opponents switch "games" by style only; nobody reads your plan. The per-round fade on a reused answer is the only
   counter. The waited line (ReadBack: waited for, thrown behind another line, the cost to the corner's other lines) is in the code and off; the
   "adapted" note (R25) is agreed, not built.
4. ROUNDS IN THE PLAN. Real plans are phased: establish the jab, invest in the body, cash in late. Lines cannot carry a round; only pace can. The tape
   already knows round habits (slow starter round 1, fades in round 3) and the body cost already makes body work pay late; the plan cannot say it.
5. YOUR OWN COMBINATIONS AS LINES. A chain built in Combos is never a line on a place or a situation; it only enters as the go-to, a flat bonus blind
   to the opponent. The builder teaches "end on a slip or a step" and "open with a feint", and the fight never asks whether a chain ends on a step
   against a counter-puncher. The craft the owner loves (build, then use it) stops at the door of the plan.
6. SET-UPS. "Jab to the body twice, then the hook upstairs" is the heart of a plan. No line can be thrown "behind" another (ReadBack's set_up rule is
   exactly this, off).
7. HOW MANY LINES THE BOXER CARRIES. Only the coach's rating limits lines. A novice carries two or three instructions, a clever boxer more. The week
   map adds "a bout takes 4, walked for it" - link the number to Fight IQ and bouts fought.
8. A DRILL BUTTON ON THE LINE AND ON THE WHY. NEXT says "drill it on the pads" in words; it should put the card on a pad night.

## What is useless or doubled (cut, merge or wire)

- "Open the map" and "See the flow" both re-draw the same lines; keep one (Flow), with the round phases on it.
- The combo lab's SPEED (seconds first punch to last: "the longer it runs, the longer the boxer stands there to be hit") and DAMAGE tiles: as far
  as I can read, the bout never uses a chain's time or its damage. Wire them (item 5 below) or cut them.
- The empty "Hover an answer and it plays here" panel takes a third of the plan page; make it the line's evidence (what the worth is made of).
- Escapes as a fourth tab (already agreed folded into Moves).
- The "Answer: <best>" button with green-first sorting: once the boxer's grade exists, keep it but rank by worth, not by the read alone, or the page
  plays itself.

## New mechanics (only where the decisions are thin without them)

- LINE EXECUTION (the boxer's grade on each line): each move names the attributes it is done with (pivot and step back: Footwork; tie up and push
  off: Strength and Durability; body hook combinations: Power; slip counters: Timing and Defence; jabs: Speed; feints: Fight IQ). Good / OK / Poor,
  as the calls already grade, times the line's worth on a plus and COMMIT on a minus. The read and the boxer now pull against each other.
- THE OPPONENT'S PLAN AND ADAPTATION: the file shows the opponent's own plan as 3-4 lines, one per tell; from round 2 the opponent waits for your
  most-won line (ReadBack on); a line thrown behind a different line that won this round is not waited for. The corner minute names it in 14 words.
- ROUND PHASES ON LINES: a line can be marked R1, R1-2, R3 or all; a phased line counts against the lines carried only in its rounds.
- OWN CHAINS AS LINES with a fit derived from what the chain does: opens with a feint (beats a counter-puncher), ends on a step or slip (removes "walks
  into it" against a counter-puncher, works against a presser), body first (beats range and tiring), over 1.2 s first punch to last (walks into a
  counter-puncher). Read through the same answer table, so the lab, the plan and the ring agree.

## To reach 10/10 (most important first, each buildable)

1. Line execution: add Exchanges.grade to every plan line (PlanFight.value x GRADE on a plus, x COMMIT on a minus), a "Boxer does it: Good /
   OK / Poor (Footwork 47)" chip on each line, in the line picker, on the corner minute's change list, and a swap hint when a Works line done Good beats
   a Beats it line done Poor. Measure: a Poor best answer must lose to a Good ok answer in at least 55 of 100 close bouts.
2. Switch on FireLevel (usable 0.5, sharp 0.75, signature 1.0) and show "fires 3 in 4 (Sharp 64)" on each line, with "2 pad places take it to Sharp by
   Thursday" when the week can reach it. Re-run the plan_effect_probe so a good plan still reads +15 or more.
3. Opponent adapts: turn on ReadBack for every bout (the most-won line is waited for from round 2, set_up on, wait_cost tuned so the set-up answer wins
   back at least 5 of the 7 lost in 100); show it on the file ("Adapts: waits for your most-won line"), on the corner minute (the adapted note
   replaces the coach's line, R25) and in the Why ("Priya waited for the double jab from round 2; behind the feint it still won 3 of 4").
4. Set-up lines: a line may be marked "behind <line>"; thrown only after that line won an exchange this round, never waited for, +full edge. Drawn as
   an arrow between the two lines on the board and on the Flow.
5. Own chains as lines: an own combination appears in the line picker on the place its first move starts from, with a fit from its features (list
   above), and the lab's SPEED and DAMAGE feed it (exposure time against a counter-puncher, damage to the body map when it lands whole). The lab
   prints the same Beats it / Works / Walks into it rows for own chains as for book ones.
6. Round phases: a round tag on each line (R1, R1-2, R3, all); the plan page gets a ROUND BY ROUND strip (pace + the lines live that round + what
   the tape says about that round); PlanFile's round habits fill it; body lines in rounds 1-2 show "pays in round 3" from the body cost already in
   the bout.
7. Lines the boxer carries: from Fight IQ and bouts fought (for example 3 at Fight IQ under 50, 4 at 50-64, 5 at 65+, +1 after 10 bouts), shown on the
   plan head beside the coach's number; it is the "bring 4 of 6" of the week map (link, same number). A line left home: not in round 1, 80% after
   (the week map's rule).
8. Evidence panel: the right-hand panel shows what a line's worth is made of (the read, the boxer's grade, the fire share, the boxer with no plan,
   waited or not, behind what), each row with its number. No hidden sums.
9. Drill from the plan and the Why: a "Put it on the pads" button on each line under Sharp and on the Why's NEXT, placing the card on the next pad
   night (the pad tray's drill_it), priced in pad places as the week map prices "walk a line".
10. Templates that fit the boxer: Real fight plans show "fits Sam: 3 of 6 lines Good" and load only lines the boxer can throw; the coach's style (RPG
   layer map) decides which templates the coach knows.
11. Cut "Open the map" (keep Flow with phases and set-up arrows), fold Escapes into Moves, and replace the empty hover panel with the evidence panel.
12. The 3D fight and the round screen caption the line that fired each exchange ("Plan: Double jab, behind the feint - it worked"), so the player
   sees the plan in the ring, not only in the minute.

Menus each item shows on (the operator's rule: wired and shown): Playbook > Game plan (lines, chips, phases, evidence, carry count), Playbook >
Combos (own chain fit rows), Fight prep (what your plan should answer: grade and adapt), Fights bout page (lines carried), Training pad tray
(fire share and the Sharp-by date), fight night round and corner minute (adapted note, grades in the change list, captions), the Why (adapted line,
per-line won/used, drill button), the week review (a line reached Sharp: "now fires 3 in 4"). One golden-path test: write a plan, drill one line to
Sharp, fight, see the adaptation in round 2, change the line behind another, read it in the Why.

## Complete for this version?

Yes, with the list applied: four fighters (three boxers share the boxing Playbook), amateur bouts with no camp (the plan is walked in fight week, as
the week map says), to a first professional fight (more rounds make the round phases and the tank matter more, not less). Nothing in the list needs
the living world. One caveat outside my brief: the BJJ fighter's mat book (game tree, systems) is its own Playbook and needs its own critic.

## The drawing

docs/mockups/s432/critics/pb_coach_10.html, rendered to docs/mockups/s432/critics/pb_coach_10.png (1920x1080): the plan for one bout with the
four lines the boxer carries, each with the read, the boxer's grade, the fire share and the worth; the opponent's own plan and adaptation; the last
test; the evidence panel for one line; the round-by-round strip; the Why's NEXT as a pad-night button; your plan against the Coach's.

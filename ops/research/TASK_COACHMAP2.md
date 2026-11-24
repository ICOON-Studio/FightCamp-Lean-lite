# TASK COACHMAP2 - coaches: probe Kalli's three changes (S550)

Kind: probe (rules measured on real seasons and bouts with switches that live in `tools/`; nothing under scripts/ or
tests/ changes). Model: claude-opus-5-5. Discipline: boxing (demo path). Seat: Claude worker in a console tab.
Estimate: about 4 hours. START ONLY AFTER `docs/PLANIMPACT2_RESULT.md` exists: change 1 depends on it.

## Why
The coach map as cut (`ops/research/DESIGN_COACHMAP1.md`: no trial week, chemistry on the hire card) scored depth 5,
play 5, general 6 with Kalli (`ops/research/CRITIC_COACHMAP1_BRIEF_KALLI.md`); the bar is 8. The owner was asked
(board Q-334, S550): "Coaches scored 5 of 10. Probe her three changes, or cut back to today's two hire cards?" He
answered: **"Probe the changes"**.

## METHOD (quote in your first message)
- MECHANICS NEED 8, PROBE FIRST (owner S534). Nothing lands in the game here.
- COACHES: NO TRIAL WEEK, CHEMISTRY ON THE HIRE CARD (owner Q-329, S548: "Cut it, show chemistry"). The page to read
  is DESIGN_COACHMAP1 (DESIGN_COACHDEEP9 is history). It is a staff game: a few decisions a season (interview I 1).
- A WORKER'S NUMBERS CAN BE RIGHT AND ITS WHY WRONG: open the code lines first; CONTROL FIRST - with every change off
  the probe reproduces COACHDEEP9's full run (`tools/coachdeep9.gd`, `coachdeep9_rules.gd`, `coachdeep9_sum.py`,
  `docs/COACHDEEP9_RESULT.md` section 3) cell for cell.
- A CRITIC'S RULE IS MEASURED BEFORE IT GOES ON, each change alone and then together; no balancing number - each at
  the strength written, plus one half-strength arm.
- ONE RULE IS NOT SOLD TWICE: PLANIMPACT2 measures "the plan sharpens the corner where it was drilled for this
  opponent". Change 1 below is the same lever owned by the coach. Read `docs/PLANIMPACT2_RESULT.md` first and write,
  before any run, how the two stack (both raise a command's grade? one cap of one grade for both?) and why.
- NEVER TEST IDENTICAL FIGHTERS; rosters with varied tempers (bar 1 below asks for 10 rosters a gym type).

## The three changes (write each rule in `ops/research/DESIGN_COACHMAP2.md` and commit it BEFORE any run)
1. THE CORNER COACH IS WIRED (Kalli 1; `docs/COACHDEEP9_RESULT.md` section 7 (a) to (d)). Live: his tactics decide how
   often the corner's clue is right and which calls are offered; the pair's bond decides how much of the call she
   hears (1 + 0.4 x chemistry; a warned boxer 0.85; a clash ignores one call); his cutman rating sets recovery between
   rounds. Simmed: the coach makes the calls. CORNERBASE1 found a rating buys 0 in a simmed bout today and the FILE
   coach (rests her when tired, "hands up" when hurt) is worth +2.6 / +6.2: start from the FILE coach and let the
   ratings move how well he does those two things. Cap from Kalli: the best simmed coach 4 or more wins in 100 over
   the worst, and never over 8.
2. A COACH LIMIT (Kalli 2). A coach is the main coach of at most 2 boxers, 3 at teaching 15 or more. With four boxers
   and up to four coaches, chemistry then forces a trade: the best coach cannot have everyone.
3. THE BARS MEASURED AGAIN, HARDER (Kalli 3 and her "bars that pass while the mechanic is still shallow"):
   bar 1 with the chemistry word visible at hiring, on 10 rosters a gym type; the careless owner ignores the word and
   the limit instead of hiring blind.
Not in this probe (named so nobody assumes it): merging the rival's offer into the raise, contract length, coaches who
grow, film and weight wiring. List them in the result as "next, if this passes".

## The bars (written here before any run)
1. NO ONE-FACT HIRE: the rule "a pro on the roster means the known name, else the film-room coach" loses 10 or more
   lines over two years to the best hire in 3 or more cells.
2. THE KNOWN NAME pays with a pro and loses without (as COACHDEEP9 bar 2).
3. NO ONE-SPLIT MOMENT: for each moment left (raise, style push) a single visible fact predicts the best answer in
   no more than 80% of cells.
4. THE CORNER PICK IS A CHOICE: with change 1 on, the tactician and the bonded coach are each the right corner in 25%
   or more of bouts, measured with the live corner bot calling (CORNERBASE1's reader), not the simmed price.
5. A CARELESS OWNER LOSES, A CAREFUL ONE DOES NOT (careless = ignores the word and the limit).
6. THE LIMIT BITES AND DOES NOT TRAP: with change 2 on, the week plan differs from the no-limit plan in half the
   gyms or more, and no gym with two coaches is worse off than with one.
7. NOTHING RUNS AWAY (COACHDEEP9 bar 7), and THE CORNER IS NOT JUST BUFFED: the live corner over the FILE coach stays
   between +6 and +15 with change 1 on (and with PLANIMPACT2's rule on too, if that rule passed).
8. PLAY: count the coach moments that reach the player a season in each gym (target 2 to 4) and the share of
   fight-result "why" lines that could credit a coach.
Report the eight bars for: all off (control), each change alone, all on. Then the verdict for the owner: keep with
these changes, or cut back to today's two hire cards - never removed silently, his call.

## Not allowed
No change under scripts/ or tests/. One Godot process at a time through
`python ops/Tools/godot_slot.py run --who COACHMAP2 -- <command>`; watchdog before each job
(`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait). The owner's game
may be open: never more than ONE Godot, runs in slices of 20 minutes or less, long runs write to a file under
`E:/FightCamp/tmp/coachmap2/`; headless, `--audio-driver Dummy`, never the `_console.exe`. Another Claude session
works in this checkout: commit ONLY your own paths.

## Feedback loops
- Change 1: better coach -> more wins -> reputation and pro fees -> money for a better coach. Capped by the hire list
  (three a month), four coaches, the wage rule and the 4-to-8 cap on a simmed coach. Print wins and cash per year; stop
  if the best-coach gym's cash doubles the median's by year two.
- Change 1 and PLANIMPACT2's rule both raise a command's grade: capped at ONE grade in total unless you write a boxing
  reason for two; print the share of commands raised.
- Change 2: the limit moves boxers to worse-fitting coaches -> clashes -> warnings -> a person lost -> fewer coaches
  -> a tighter limit. Capped by the two-warning rule and by a new hire each month; print people lost per gym and stop
  if any gym loses more than two coaches in two years.
- Chemistry is one-way (results and money never move it): confirm in the code before the run.
- One-rep trial before the full run: two gym types, two rosters, one year, all arms. Stop if two arms print identical
  seasons (an arm not wired) or the control does not match COACHDEEP9.

## Prior research
`ops/research/DESIGN_COACHMAP1.md`, `ops/research/CRITIC_COACHMAP1_BRIEF_KALLI.md`, `docs/COACHDEEP9_RESULT.md`,
`docs/CORNERBASE1_RESULT.md`, `docs/PLANIMPACT1_RESULT.md`, `ops/research/PLANIMPACT1_CHECK_S549.md` (point 4),
`docs/PLANIMPACT2_RESULT.md`, `ops/research/COACH_INTERVIEW_S542.md`, `ops/research/COACHDEEP_GRILL_S539.md`,
`ops/research/topics/plans_corner.md`. Run `python ops/Tools/prior_research.py coach corner chemistry hire` and name
the study each change follows.

## What would a human do?
He would ask first whether a limit of two boxers a coach changes anything in a gym of four boxers and two coaches -
on paper, with three example rosters - before running two simulated years.

## Prefab check
COACHDEEP9's probe, rules and summary scripts and CORNERBASE1's reader are the harness: preload them, add switches.

## Contract
OWNS: tools/coachmap2.gd, tools/coachmap2_rules.gd, tools/coachmap2_sum.py, ops/research/DESIGN_COACHMAP2.md, docs/COACHMAP2_RESULT.md
RED_TEST: tools/coachmap2.gd
REGRESSION: none under tests/ (nothing in scripts/ changes): the control arm is the regression
VISUAL: none

## Result
`docs/COACHMAP2_RESULT.md`: the verdict in four lines for the owner first (plain words); the control; each rule as
written before the run; the eight-bar table for each arm; the menu table (every menu the mechanic shows on and what
it is wired to) if it passes; honest limits; how to reproduce. Commit ONLY your own paths with
`git commit -m "..." -- <paths>`; do not push; do not ask questions: decide, and write what you decided.

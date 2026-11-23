# COACHDEEP7 - coaches v7: the owner's design (a staff game), one clean map and a quick greybox probe (S542)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -m "..." -- <files>`), do not
push. Godot only through `python ops/Tools/godot_slot.py run --who COACHDEEP7 -- <cmd>` (headless, Dummy audio), ONE run at a
time, output to a file, wait on its done line. Before each run: `powershell -NoProfile -ExecutionPolicy Bypass -File
ops\Tools\pc_watchdog.ps1 -Once`; RED = wait; the owner's game (ArcheAge) in the top list with memory AMBER = wait.
Estimate: 2-3 hours. A QUICK probe: size the full run to finish in under 40 minutes on one slot (time one cell first), and
run the FULL size before any verdict (S542: a 300-career check read a 2,000-career pass as a fail).

## Why
Six probe rounds failed the 8 bar (COACHDEEP1-6; v6 FAIL 7/9, `docs/COACHDEEP6_RESULT.md`): the weekly who-coaches-whom is
solved by one rule; hiring measured real. The owner was interviewed (S542, 17 answers, all yes):
`ops/research/COACH_INTERVIEW_S542.md` is the spec; where it and `ops/research/COACHDEEP_GRILL_S539.md` differ the interview
wins (it replaces the grill's Q13 and Q14; the other 22 answers stand). v7 is NOT a patch of v6: coaches are a staff game -
who you hire, when, what they cost, how they get on with your boxers - with a few decisions a season. Layers get removed.

## Do
1. `ops/research/DESIGN_COACHDEEP7.md`: one clean document from the two pages above. It holds:
   - THE HIRE (interview 6, 11; grill 15-17): a monthly list of three candidates; each card with exact ratings (the grill's
     eight, 1-20), wage by band, playbook style, personality (five traits) and the plain line "pays for itself at about N
     members" - say how N is computed from what the game has (dues, class nights the catchment wants, his evenings). A known
     name ($800-1,100 a week) pays only with a pro or a title boxer (what he lifts, by how much, capped) and his card says so.
   - THE TRIAL WEEK (interview 7): its price; it shows the chemistry word with each boxer before signing; without it the
     word shows two weeks after he starts.
   - THE WEEK PAIRS ITSELF (interview 2, 14): by best fit, with a free "change"; class nights fill the free evenings, a
     shown fact. The built "class nights against pad minutes" rule (`scripts/rules/CoachRoles.gd`, S515) is CUT: a table of
     what is deleted, what shrinks, what stays (the four staff jobs in `StaffRoles.gd` stay until rated coaches replace them).
   - CHEMISTRY as built in the earlier maps (traits + weeks together, a word: bond / fine / clash, shown after two weeks).
   - FOUR MOMENTS (interview 8, 13, 15), at most one a month: a falling-out (back the coach / back the boxer / split them
     up); a raise or a rival offer (match / let go); a style push (allow / refuse); a course (send / not now). For each:
     when it fires, what every answer changes, the two warnings on the card, and when someone is lost for good.
   - THE CORNER PICK (interview 9): before a fight the player picks the coach in the corner; tactics rating v bond; a
     clashing coach gets one call ignored a fight. Say which existing corner rule each reads.
   - Every number tagged ESTIMATE with its real-world reason. No new money rule beyond the wage, the trial and the course.
   - A table of every menu it appears on and what each is wired to (interview 12; owner S425). Plain game words; names only
     in headers; no he/she in game text. Your own coaches only (interview 5).
   - The build order of interview 16, each step a build the owner plays.
2. Bars, written in the map BEFORE any run, never loosened (the owner, interview 4 and 17: bots only check nothing is
   broken; depth and fun are his play + two critics at 8). TEN CELLS: club sizes and rosters that differ (small / big;
   with and without a pro or title boxer; different boxer mixes), named in the output:
   - (1) No candidate is the best hire in more than 6 of the 10 cells.
   - (2) The known name beats no-hire by more than 2 standard errors in the cells with a pro or title boxer and loses or
     ties in the cells without.
   - (3) In each of the falling-out, the raise and the style push, no single answer is best in more than 6 of 10 cases.
   - (4) In the corner, the best tactician is the right pick in at least a quarter of fights and the bonded coach in at
     least a quarter.
   - (5) People can be lost: the careless line (always back the coach, always refuse the raise) loses a coach or a boxer in
     at least 2 cells; the careful line in at most 1.
   - (6) The trial week is the right buy in at least 2 cells and the wrong buy in at least 2.
   - (7) Nothing runs away (see Feedback loops): members inside the catchment, cash bounded, at most one moment a month,
     chemistry inside its cap.
   One score written before the run, with its reason, its parts printed apart.
3. Probe `tools/coachdeep7.gd` (+ `tools/coachdeep7_rules.gd`, a summary script if needed), a GREYBOX built from
   tools/coachdeep6* where that helps (the catchment ceiling, rank bands, the record line), the game's own numbers read from
   the game's modules, never copied by hand. Never two identical fighters; each boxer boxes their own sex and class; the
   population named in the output. Result `docs/COACHDEEP7_RESULT.md`.
4. PASS -> `ops/research/CRITIC_COACHDEEP7_BRIEF.md`, built like `ops/research/CRITIC_TURNPRO1_V17_BRIEF.md` (the header,
   the whole of `ops/research/CRITIC_PACK.md`, then the map; never an earlier score or our opinion; DEPTH and PLAY at 8;
   the list to reach 10; the critic's 10/10 as a 1920x1080 HTML page). Queue it:
   `python ops/Tools/seat_queue.py add --seat kalli --brief research/CRITIC_COACHDEEP7_BRIEF.md` and the same for dola.
   Write that a code-checked critic is still owed (the coordinator launches it).
   FAIL -> which bar, the one change that would fix it (inside the interview, or say it needs the owner), stop.
Nothing under scripts/ changes in this task: the build comes after the critics.

## Feedback loops
- A hire -> free evenings -> class nights -> members -> dues -> another hire. Caps: the catchment ceiling (v5), class
  nights wanted by the catchment, at most 4 coaches. Print members, class nights run v wanted, cash at week 104 per arm.
- Known name -> purse and name lift -> cash -> affords the known name. Cap: the lift's top, written in the map.
- Bond -> the corner is listened to -> wins -> (loyalty, morale). Chemistry itself must stay one-way (traits + weeks
  together, cap as built); say so, and check wins do not raise it.
- A falling-out -> loyalty down -> someone leaves -> fewer boxers or coaches -> more falling-outs? Cap: one moment a month,
  two warnings, and a left person cannot trigger another. Print the longest run of losses.
- A style push allowed -> faster learning -> wins -> more pushes. Cap: one push a boxer a season; the learning bonus's top.
- A course -> ratings up -> the ceiling (grill 22) stops it.
- ONE-REP TRIAL FIRST: one career per cell per arm, printed in full. STOP and fix the map if members leave the catchment
  band, if every cell converges on the same best hire, or if no arm ever loses a person.

## Prior research
`ops/research/COACH_INTERVIEW_S542.md` (the spec), `ops/research/COACHDEEP_GRILL_S539.md` (22 answers stand),
`docs/COACHDEEP5_RESULT.md` and `docs/COACHDEEP6_RESULT.md` (what measured real: the hire by club size, the right coach
by boxer), `ops/research/DEPTH_AUDIT_S534.md`. Run `python ops/Tools/prior_research.py coach hire chemistry corner` and name
the real-world source behind the wages and the known-name rule.

## What would a human do?
A club owner hires the coach the club can pay for and the boxers will work with, gives each carded boxer to the coach who
suits them, and steps in a few times a year: when two people fall out, when a coach wants more money or another gym calls,
when a coach wants to remake a boxer in his own image. On fight night he decides who goes in the corner.

## Prefab check
None (a rules probe on our own modules).

## Contract
OWNS: ops/research/DESIGN_COACHDEEP7.md, tools/coachdeep7.gd, tools/coachdeep7_rules.gd, tools/coachdeep7_sum.py, docs/COACHDEEP7_RESULT.md, ops/research/CRITIC_COACHDEEP7_BRIEF.md
RED_TEST: tools/coachdeep7.gd
REGRESSION: none
VISUAL: none

Do not ask questions: decide, and write what you decided in the result.

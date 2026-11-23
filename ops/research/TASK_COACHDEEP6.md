# COACHDEEP6 - deep coaches v6: the class-night-or-pads evening trade is CUT, the coach part goes to the probe alone (S542)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -m "..." -- <files>`), do not
push. Godot only through `python ops/Tools/godot_slot.py run --who COACHDEEP6 -- <cmd>` (headless, Dummy audio), one run at a
time, output to a file, wait on its done line. Before each run: `powershell -NoProfile -ExecutionPolicy Bypass -File
ops\Tools\pc_watchdog.ps1 -Once`; RED = wait; the owner's game (ArcheAge) in the top list with memory AMBER = wait.
Estimate: 2 hours (v5's full run took 63 min beside three other jobs, 6 min alone).

## Why
COACHDEEP5 FAILED 7 of 10 (`docs/COACHDEEP5_RESULT.md` section 5): a, b, c, d, e, g, i pass together for the first time; f, h,
j fail, all three because of ONE thing - the "class night or pad evening" trade. Bar h has failed in v3, v4 and v5 in both
directions (the boxer's side right 0 of 45 and 0 of 117); f2 and j fail because the CLASS plan sheds two boxers to turn their
evenings into classes. DECISION (Claude S542, the owner's S534 free hand: "you can remove, add from scratch or interconnect"):
the evening trade is CUT as a choice and as a depth claim. The owner's 24 grilling answers
(`ops/research/COACHDEEP_GRILL_S539.md`) stay binding; Q-311 "Bouts pay by rank" stands; the stipend stays $250.

## Do
1. `ops/research/DESIGN_COACHDEEP6.md` = v5 with exactly these changes, written BEFORE any run:
   - CLASSES TAKE THE FREE EVENINGS: a boxer on the roster keeps her pad evenings (her places with her coach); class nights run
     only on the coach evenings no kept boxer needs. It is a timetable fact the week plan shows, not a decision. Real-world
     reason in the map (a club runs its classes around its carded boxers' sessions, not instead of them).
   - THE CLASS ARM IS GONE: no plan may shed a boxer to free her evenings. Letting a boxer go stays what it is today, a
     separate act priced by the departure price (v4/v5 item, unchanged).
   - BAR h IS DROPPED, in writing, with this reason. Bars a, b, c, d, e, f, g, i, j stay word for word (v5 map section 4);
     bar a's arm list simply no longer holds CLASS. PASS = all nine.
   - The catchment ceiling, the rank bands, the record line, ties printed and the chemistry size 0.15 from v5's sweep stay.
     Re-run the sweep only if CHEM is best in more than 5 of 10 at 0.15 (then 0.10, as v5's written list allows).
   - A table of every menu the coach mechanic appears on and what each is wired to (owner S425), with the class timetable
     shown as a fact on the week plan.
2. Probe `tools/coachdeep6.gd` (+ `tools/coachdeep6_rules.gd`), built from tools/coachdeep5*. Result
   `docs/COACHDEEP6_RESULT.md`: the nine bars, and one honest paragraph on WHAT IS LEFT TO DECIDE now the trade is gone
   (who coaches whom, the plan, the hire by club size) - with the measured size of each choice.
3. PASS -> `ops/research/CRITIC_COACHDEEP6_BRIEF.md`, built like CRITIC_COACHDEEP1_BRIEF.md: opens with
   `ops/research/CRITIC_PACK.md` and `ops/research/CRITIC_ACCESS.md`; never our proposal's earlier scores; asks for DEPTH and
   PLAY out of 10 (the bar is 8 on both), which options are missing or useless, the list of changes to reach 10, and the
   critic's own 10/10 drawn as a 1920x1080 HTML page. Queue it for kalli and dola:
   `python ops/Tools/seat_queue.py add --seat <seat> --brief research/CRITIC_COACHDEEP6_BRIEF.md`. Write in the result that a
   code-checked critic (Arena) is still owed - the coordinator launches it.
   FAIL -> say plainly whether the coach mechanic can reach 8 without the trade; it becomes the owner's cut-or-keep. Stop.

## Feedback loops
- Class nights -> members -> class nights wanted: capped by v5's catchment ceiling (66 small / 96 big). Check in the trial:
  members at week 104 inside catchment + 5 in every arm.
- NEW in v6: free evenings -> class nights -> class cash -> a hire -> more coach evenings -> more free evenings -> more class
  nights. Cap: class nights wanted by the catchment (6 small / 9 big in v5) - a class night past that earns nothing. Print
  class nights run v wanted and cash at week 104 per arm.
- Rank bands: wins -> rank -> purse -> keeps the boxer -> more wins. Cap: the band top and the ladder's fixed size.
- Chemistry -> line gain -> wins -> rank: one-way in the code (v5 checked); say so again if v6 touches it.
- ONE-REP TRIAL FIRST: mode=full reps=1 before the full run. STOP and fix the map if members leave the band, if class nights
  run past wanted, or if every cell converges on the same best arm.

## Prior research
`docs/COACHDEEP5_RESULT.md` (sections 4.3 and 5), COACHDEEP1-5 designs and results, `ops/research/COACHDEEP_GRILL_S539.md`,
GymBills.gd, BoutRules.gd, StaffRoles.gd. Run `python ops/Tools/prior_research.py coach chemistry class night` first.

## What would a human do?
A head coach gives each carded boxer her sessions first and fills the rest of the timetable with classes. The interesting
questions are which coach suits which boxer, and whether the club is big enough to pay a second or a known coach.

## Prefab check
None (a rules probe on our own modules).

## Contract
OWNS: ops/research/DESIGN_COACHDEEP6.md, tools/coachdeep6.gd, tools/coachdeep6_rules.gd, docs/COACHDEEP6_RESULT.md, ops/research/CRITIC_COACHDEEP6_BRIEF.md
RED_TEST: tools/coachdeep6.gd
REGRESSION: none
VISUAL: none

Nothing under scripts/ changes until the probe passes and two critics score 8. Do not ask questions: decide, and write what
you decided in the result.

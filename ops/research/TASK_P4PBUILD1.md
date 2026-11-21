# TASK P4PBUILD1 - build the three coaching moments: the visit, then the corner's eye, then the coach's read

Kind: code
Status: OPEN (S533, Claude main). Owner's yes: Q-S294-284 "Yes, build them", and in chat "ok build them in that order , can
you use another console for that , fable if required ?". Discipline: boxing. Model: Fable (claude-fable-5-2), Code Mode
terminal session.

## The design
`ops/research/DESIGN_THREEP4P_V2.md` (written from the code; critics Arena 8/7/7 `DESIGN_THREEP4P_V2_CRITIC_ARENA.md`, Dola
7/8/8 `DESIGN_THREEP4P_V2_CRITIC_DOLA_DOLA.md` - read both critics' "To reach 10/10" lists; take what fits the map, say what
you refuse and why). Section 1 lists faults in today's code that the build must fix on the way (e.g. the coach is handed the
opponent's style and never uses it; the visit's "bigger club" penalty compares wins, not clubs).

## Order (the owner's): one stage at a time, each finished before the next
1. THE VISIT (map section 3): the beaten amateur opponent may ask to join; the chance grows with how well your plan worked
   in that bout (bounded, seeded, never certain); the rival's identity and record move with him on signing; pass / expiry
   gives a 120-day cooldown; Sign now / Pass / Trial first with their real costs shown. Save/load keeps all of it.
2. THE CORNER'S EYE (map section 4): record intended vs fired lines; the ring map marks faint / worked / lost / held; drop the
   win-streak wash; hurt and tired can both show; the corner offers only legal existing calls at their existing timing.
   The fight's result must be identical with the overlay on or off (a test proves it). The 3D fight never decides.
3. THE COACH'S READ (map section 2): WAIT for TURNPRO6 (the Fable session in the other console fixes the offer's win read,
   which today says 50 % where the bouts win 78 %). Check `docs/TURNPRO6_RESULT.md` exists and its read fix is on main before
   you start this stage; if it is not, stop after stage 2 and report.

## Done means (owner S425 rule: WIRED, SHOWN, 7+)
For each stage: every menu in the map's section 5 table shows it in the real game (stills on the hidden desktop via
`python tools/hidden_desktop.py run ... --script res://tools/layout_snapshot.gd` or a small still tool; open each still
yourself), one golden-path test walks it end to end, and the tests of every module you touched pass. New features ship ON
(GameSwitches.GAME_ON). Names only in headers; card text says "your boxer", "the opponent"; tooltips through Tip.gd (explain
what, why this value, what moves it, what you can do). The meter is called Fatigue (S533).

## Rules
- Godot ONLY through `python ops/Tools/godot_slot.py run --who p4pbuild -- <godot.exe> --headless ...`; windowed stills only
  on the hidden desktop. Nothing opens on the owner's screens. Never `_console.exe`.
- Other work in this checkout - do NOT edit these files: TURNPRO6 (Fable console: BoutRead, ProOffer*, ProDebut, ProCall,
  Matchmaking, tools/turn_gap_probe.gd), TIPFIX1 (Grok Dev, tooltips in scripts/ui - pull before each commit; if you must
  touch the same file, keep your change small and say so), the main session (StepEffect, RingDuel, tools/treevalue_probe.gd).
  scripts/fight3d: no animation or body changes (METHOD: no new correction layer until fight player v2); the corner's eye may
  touch only FightOptions' overlay/menu code - check `git log -5 -- scripts/fight3d/FightOptions.gd` first.
- Small files (no script over 500 lines; split if needed). Read ops/research/GDSCRIPT_TRAPS.md before writing GDScript.
- Commit each stage to main with explicit paths, `git pull --rebase` before push, Co-Authored-By line at the end.
- Tests: only those your change touches (`TESTS="a_test b_test" JOBS=2 sh tools/run_tests.sh`), never the full suite.

## Deliverable
Per stage: the commits, a short `docs/P4PBUILD1_STAGE<n>.md` (what changed, the stills, the tests and their pass lines),
and one line in roadmap.json `plan` (row P4PBUILD1). Final message: per stage one sentence + the tests run.

## Contract
OWNS: scripts/rules/CardAsk.gd, scripts/rules/CoachRead.gd, scripts/rules/PlanRecord.gd, scripts/rules/RingMap.gd,
scripts/state/BoutFinish.gd, scripts/state/LiveRound.gd, scripts/ui/RingTopDown.gd, scripts/ui/OfferCard.gd,
scripts/ui/modals/Interview.gd, scripts/ui/RosterActs.gd, (and the files the map names for each stage), tests/, docs/P4PBUILD1_*
RED_TEST: a new tests/p4p_visit_test.gd (stage 1) that fails on main
REGRESSION: the tests of every module touched + the golden path
VISUAL: stills of each menu in the map's table

## Prior research
DESIGN_THREEP4P_V1/V2 + critics; the owner's P4P playtest notes (S531, memory project_s531_p4p_three_mechanics).
## What would a human do?
A coach watches the tape with the beaten kid's dad in the room, and only then says "he'd do well here".
## Prefab check
None (our own mechanics).

## S533 ADDENDUM - a third critic (John, 5/6/6, pack only) found dominant picks: fix them while building
Read `ops/research/DESIGN_THREEP4P_V2_CRITIC_JOHN_JOHN.md` before each stage. Build-time fixes (no owner question needed -
they make the approved mechanics deeper, not different):
- THE VISIT: no dominant pick. "Sign now" must not be always right when a place is free, and "Trial first" must not beat it
  for free: give each a real price in the game's own numbers (stipend, a place, the visitor's interest cooling, a rival club).
- THE CORNER'S EYE: say WHY a line failed (not ready / read by the opponent / wrong situation / tired legs) - each cause has a
  different answer, and that answer is the choice.
- THE COACH'S READ (stage 3): price Accept / Pass / Later in the game's terms (morale for a booked bout and a month without
  one, the goal deadline, ducked/owed, rest days).

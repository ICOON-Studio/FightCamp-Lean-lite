# S332 - next session (written S331, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 34 is exported (Builds/, WHAT_TO_TRY.txt).
- Update 33 (S331), his Q-S294-48 "Too long to reach": the nationals' 3 months count from her England Boxing
  registration (Roster.registered_day), entries close week 10 (SeasonPath.ENTRY_CLOSE_DAY 70), NATIONALS_GAP 21.
  Lucy enters week 5 (was 14), national final week 18 (was 29).
- Update 34 (S331, INSIDEMISS1): PunchReach.settle() re-lands the glove after GloveClear's head lean (control
  `-- nosettle`); hit_gap_probe far misses 2/26 -> 0/26.
- His answers in S331: Q-S294-49 "Yes, both right" (debut costs stay); Q-S294-50 "Change the look first".
  -> three HOME looks as HTML mockups (Game Godot/research/S331_looks: a_fightbill, b_whiteboard, c_broadcast; source
  .html beside the .png, rendered with headless Edge, own --user-data-dir) on the board as Q-S294-52.
Digest: Game Godot/research/S331_DIGEST.md (parts 1 and 2).

1. Board: Q-S294-52 (which HOME look), 51 (nationals soon enough), 53 (inside punches land), 47 (update 29).
2. On a look pick: build it in Godot on HOME first - one Theme + the shell (top bar, nav) + HOME - before/after stills
   with tools/pages_now_still.gd, board question; then GYM, MONEY, FIGHTS, her page one per commit (500-line rule).
   All three looks show faces: FightCast._class_body(limit) picks the body by weight class, only 3 bodies exist (two
   lightweights share a face) - give each fighter her own body/look before pages show faces (portrait crops from
   assets/ui/body/mh_boxer_*_red.png, top 42 % width x 1.15).
   "None - mark what is wrong": read his markup (Feedback/<date>/README.md) and redo.
3. If Q-S294-51 says still too long / too easy: SeasonPath.ENTRY_CLOSE_DAY / NATIONALS_GAP.
4. Not on the plan yet: CORNERCUT1 (corner card cut to the pit stop, S323 plan) - check what S310/S318 already built.

Traps: Career.seed is randi() per career - dice tests fix c.seed; PowerShell Set-Content utf8 writes a BOM;
roadmap.json is json indent=1; champs_test's days follow SeasonPath (close 70, semi 84, final 91, nationals 112);
headless Edge screenshot: an escaped `\$f` in a bash path writes a literal file - use cygpath -w on the full path.

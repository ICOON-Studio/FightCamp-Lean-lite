# TASK U213 - the empty-gym first hour reads true (PLAYTEST S144 P9, P6, P29, P35, P23, P36, P37, P44, P40, P10)
Model: Grok Build default (grok_task.ps1). Owner: GROK (S144: Codex weekly budget 65%, U213 moved to Grok). Worktree `E:/FightCamp/wt/U213`, branch `grok/u213-empty-gym-first-hour`.
Icons over text, with tooltips (GLOSSARY 'Icon with tooltip'); every new control carries a tooltip.

## Fix, each verified by a still you OPEN (as_game, empty gym - tools/s144_live_walk.gd -- as_game)
1. HOME with 0 fighters: the primary card says "Sign your first boxer" -> opens Scouting (FIGHTERS tab). With fighters and no
   coach: "Hire a coach" -> Scouting STAFF tab. (P9, P21)
2. STAFF ROOM with no coaches: a "Hire a coach" button -> Scouting STAFF. Fix "0 OF 0 FIGHTERS HAVE A COACH" and
   "1 need a coach" counts to the real roster/assignments. (P23, P22, P41)
3. Creation step 3 (THE GYM): when GameState.empty_gym_start() the STARTER ROSTER panel says "No fighters yet - you sign your
   first boxer in Scouting" instead of listing three. (P6)
4. Offers desk: remove the developer counter line ("175 COUNTRIES · 423 ATHLETES ..."), and the PROMOTIONS wording
   "THE GAME IS GUESSING" -> player words. (P29, P35)
5. WEEK REVIEW (WeekReviewPanel.gd, 468 lines): fix the overlapping title/empty bars layout; one row per fighter with the
   week's real stat changes; payroll shown as "accrued this week / due <date>" when it is billed monthly. Monday report must not
   repeat identical gains every week - show the real delta. (P36, P37, P44, P40)
6. ICONS: every in-game icon renders as an empty square in the EXPORTED build (python Tools/build_playable.py, then the live
   walk through Builds/FightCamp_Godot/FightCamp_console.exe --main-pack FightCamp.pck). Find why (font or texture not in the
   pack / raw path) and fix; compare a still from the editor run and the exe run. (P10)
## Owned files
`Godot/scripts/CareerRoot.gd` (333), `Godot/scripts/WeekReviewPanel.gd` (468), `Godot/scripts/ScheduleHubPanel.gd` (3,477 - windows
only), the home/staff/creation scripts you find by grep for the quoted strings, `Godot/export_presets.cfg` if icons need it.
## Gates
Parse every touched .gd. `python Godot/tools/run_tests.py --only home,staff,creation,week_review,schedule,ui --jobs 2`. Stills
of each fixed screen from the EXE, opened with your file tool. Watchdog -Once before each Godot run; one at a time; wait on RED.
## Prior research
PLAYTEST_S144_PASS1.md + _NOTES.md (stills in E:/FightCamp/playtest/s144_p1/); J52_TOOLTIPS_AND_TUTORIAL.md (progressive
disclosure, context tips); M32_MENU_ART_DIRECTION.md.
## What would a human do?
Make the first screen point at the first job, and make every number on screen agree with every other.
## Prefab check
n/a.
## The one trap
Headless --script runs keep the 3 starters (the control arm) - test the empty gym with `-- as_game` or by clearing the roster.
Never open a viewer or window. Never edit HANDOFF.md. git add by explicit path, commit, push -u origin grok/u213-empty-gym-first-hour.

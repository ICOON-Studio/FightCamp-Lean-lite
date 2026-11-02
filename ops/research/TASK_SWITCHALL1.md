# TASK SWITCHALL1 - every switch the game ships OFF goes ON (one registry), tests keep the OFF control arm

Model: Codex gpt-6-luna, reasoning medium. Worktree E:/FightCamp/wt/SWITCHALL1, branch codex/switchall1 (cut from master).
Operator S207, verbatim: "switch on everyhting that is switched off".

## The rule you implement
The GAME (no `--script`, or `--script ... -- as_game`) runs with every feature switch ON. A `--script` test run keeps
every switch OFF unless it sets it - tests are the control arm (CLAUDE.md s6). That split already exists in three
scattered helpers; you make it ONE registry and flip every switch that is still OFF in the game.

Existing mechanisms (read, do not reinvent):
- `Godot/scripts/FightRealtime.gd` (9,487 lines - NEVER read whole): `DEMO_SWITCHES` const at line ~1193, `as_game()` and
  `with_demo_switches()` at ~1236-1245. Engine options read with `options.get("<name>", false)`. `sed -n 1180,1300p`.
- `Godot/scripts/FightWorldLiveScreen.gd` (~5,100 lines): `demo_switches_on()` at ~5024; ~30 `var _x: bool = demo_switches_on()`
  lines at 271-873 (room switches, already ON in game). Find the ones initialised `= false` or behind a user arg instead.
- `Godot/scripts/club_look/GymLook2.gd` `switch_on()` (career key or user arg, OFF in game) and
  `Godot/scripts/club_look/GymPack.gd` `switch_on()` (ON in game - the pattern to copy).
- `Godot/scripts/ProfileRevampPanel.gd` `_career_wear_switch_on()` ~577; FightStagePlayer `anim_*` options;
  `Stage.metahuman_bodies(...)`; `broadcast_autocut` (BROADCASTCUT1B, OFF); hud2, club_zones, gym_look2, metahuman_staff.

## Owned files
- Godot/scripts/GameSwitches.gd (NEW), Godot/tests/game_switches_test.gd (NEW), research/SWITCHALL1_INVENTORY.md (NEW)
- Godot/scripts/FightRealtime.gd, Godot/scripts/FightStagePlayer.gd, Godot/scripts/FightWorldLiveScreen.gd, Godot/scripts/FightWorldStage.gd,
  Godot/scripts/GameState.gd, Godot/scripts/GymClub3D.gd, Godot/scripts/GymHall3D.gd, Godot/scripts/club_look/GymLook2.gd,
  Godot/scripts/club_look/GymPack.gd (switch reads only)

## Steps
1. INVENTORY. `grep -rn` the scripts for switch reads: `options.get("...", false)`, `OS.get_cmdline_user_args().has("...")`,
   career-key switches `career.get("...", false)` / `.has("...")`, `demo_switches_on()`, `as_game()`, `switch_on()`.
   Write `research/SWITCHALL1_INVENTORY.md`: one row per switch - name, file:line, what it does (one plain line),
   game value BEFORE, game value AFTER, tests that pin it.
2. REGISTRY. New `Godot/scripts/GameSwitches.gd` (pure, `extends RefCounted`, no preloads of game scripts):
   `const GAME_ON := {...}` (every switch, value true or the string value like `"ground_arm": "both"`),
   `static func in_game() -> bool` (= FightRealtime.as_game() logic: `not --script or user arg as_game`),
   `static func on(name: String) -> bool` (career key wins if GameState.career has it - copy GymPack's guarded lookup with
   `get_node_or_null("/root/GameState")`; then a user arg `<name>` forces ON; then `in_game() and GAME_ON.has(name)`).
   Point `FightRealtime.DEMO_SWITCHES`/`with_demo_switches`, `FightWorldLiveScreen.demo_switches_on`, `GymLook2.switch_on`,
   `GymPack.switch_on` and every OFF-in-game switch you found at it. Keep the old names as thin wrappers so no caller breaks.
3. FLIP. Every switch whose game value was OFF becomes ON - INCLUDING `anim_inside_uppercut_ik` (harmless: the move is not in
   `assets/data/certified_moves.json`), `broadcast_autocut`, `gym_look2`, `metahuman_bodies`, `metahuman_staff`, hud2.
   Only these stay OFF, each with its reason in the inventory: (a) dev/debug instruments (overlays, probes, recorders, census
   tools under tools/); (b) a switch that only selects MPFB/Tripo bodies (operator S207: "i do not want to see mbfb model
   anywhere again"); (c) one of two mutually exclusive alternatives - keep the newer one ON, name the other.
4. TESTS. A `--script` run must stay byte-identical: no test changes its expected numbers. Run the dependent tests for every
   file you touched, plus the as_game set:
   `python Godot/tools/run_tests.py --jobs 2 --only playable_loop --only club_on_in_game --only day_feed_wire_fit --only new_career`
   (check `run_tests.py --help` for the multi-filter syntax; run them one `--only` at a time if needed) and
   `--only switch_gate --only fight_realtime --only gym --only profile`. Then a headless game boot (switches ON):
   `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --quit-after 1200 > E:/FightCamp/tmp/switchall1_boot.log 2>&1`
   - zero `SCRIPT ERROR` / `Parse Error` lines. List every red test in the inventory with the switch that broke it; fix the
   ones a flip broke when the fix is small, otherwise leave that one switch OFF and say why.
5. New test `Godot/tests/game_switches_test.gd` (extends SceneTree, prints PASS/FAIL, quit(0/1)): under `--script` every
   `GameSwitches.on(x)` is false; with a user arg `x` it is true; every name in GAME_ON is read somewhere in scripts/ (scan the
   files - an unread switch is a FAIL); DEMO_SWITCHES equals the engine subset of GAME_ON. Prove it goes red: delete one name
   from GAME_ON that a script reads and watch the test fail, then restore.

## Gates
- Parse gate before any test: `python Godot/tools/check_scripts.py <every touched .gd>` (a parse error hangs a headless run).
- One test: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/game_switches_test.gd`
  (NEVER `_console.exe`). Exit code alone is not a pass: no SCRIPT ERROR, no FAIL line.
- `run_tests.py` `--jobs 1` if `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` is not GREEN, else `--jobs 2`. Never the full suite.
- Commit on codex/switchall1 with `git add -- <files>`, push the branch. Do not merge to master.

## The one trap
`FightRealtime.gd` and `FightWorldLiveScreen.gd` are huge: read them in `sed -n` windows only. And do NOT change any test's
expected numbers to go green - a test that moved under `--script` means your registry leaked into the control arm; fix the
registry instead.

## Prior research
`python Tools/prior_research.py switch default` - the S115 rule (operator 2026-09-27 "turn them all on for the demo build"),
S117 as_game guard, S160 R16 lesson (cut_off_derived got its own switch because it moved 8 nightly reds). G158 room-switch
gates in `Godot/tools/switch_gate_common.gd` list the 18 room switches.

## What would a human do?
A lead programmer keeps one feature-flag table (name -> shipped value) and one lookup function; the build flips the table, the
test harness runs with flags off unless the test sets them. That is this task.

## Prefab check
Godot has no built-in feature-flag system beyond ProjectSettings; a 60-line static registry is lighter than an addon. No prefab.

## Rules
Nothing opens on the operator's screens: no windowed Godot, no image viewers, no browser. Godot only headless. IDLE priority
is set by the launcher - never change it.

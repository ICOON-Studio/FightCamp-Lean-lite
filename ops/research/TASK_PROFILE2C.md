# TASK PROFILE2C (v2, S206) - the fighter profile's tab host + TECHNIQUES, MEDICAL, TRAINING PLAN tabs (behind switch `profile2`)

Model: Cursor (composer). Supersedes the S204 PROFILE2C brief (never started). Companion task PROFILE2D builds FIGHT RECORD,
CONTRACT and CAMP in a separate file - do not touch those three.
Operator S206 (verbatim): "this session i want to see a proper player profile card with its subtabs fully completed and showing
everything that they should show". Design: Ludo round 41 TEXT spec (the image model could not draw dense screens):
`research/LUDO_ROUND41_S206_reply1.txt` (global shell, s1 TECHNIQUES, s2.1-2.2 MEDICAL) and
`research/LUDO_ROUND41_S206_reply2.txt` (s2.3 MEDICAL weight column, s3 TRAINING PLAN). Visual reference: Ludo's OVERVIEW
mockup `previews/s205_ludo_profile/ludo_profile_v2.png` (already built as ProfileOverview.gd).

## THE RULE ABOVE LUDO'S SPEC: build his LAYOUT, bind only REAL data
Ludo's rects, colours, fonts, row anatomy and empty states are the design - follow them. His FIELD VALUES are examples and many
are invented. A field is shown ONLY when a real read below supplies it; otherwise the element is left out (the column closes up)
- never a placeholder number, never a made-up label. Known inventions to leave OUT: technique "Quality 84/100", coach names on
tree rows, per-site facial scars (we store ONE scar level per fighter), named injuries like "tendinitis" (use our injury record's
own words), commission clearance, concussion count, sub-concussive index, sleep efficiency, net recovery vector, acute-fatigue
"sparring penalty %", morning AND afternoon sessions (our week has ONE station + focus per day), daily fatigue deltas, presets.
Pounds: never (kg only).

## Real reads (all exist on master - open each before using it)
- `GameState.get_fighter_card(id)` (GameState.gd:16636 - never read GameState whole: `sed -n 16636,16760p`) - the old profile's
  read model: stats, weight, request, log, record_stats, program, train_clear, compete_clear, rankings...
- Techniques: `res://assets/data/technique_catalog.json` boxing nodes + `athlete["technique_progress"]` + certified list
  `res://assets/data/certified_moves.json` + the week program's technique target. STATES: use `Godot/scripts/rules/TechniqueTree.gd`
  (PROFILE3A, Arena, merging today - its API is in research/TASK_PROFILE3A.md: tree(), summary(), next_to_learn(),
  stage_camera(), can_weight()). If it is not on master when you reach this tab, `git merge master` first; if still absent, build
  against that API and stop the tab there - say so in your summary.
- Clip telemetry on the stage card: `res://assets/data/clip_phases.json` entry for the selected clip (peak_speed_mps = "EXECUTION
  SPEED", contact_s = "IMPACT"); no "STAMINA DRAIN", no "COUNTERS" (not in our data).
- Medical: `FighterReadout.regions(athlete)` (scripts/rules/FighterReadout.gd) for the 6 regions + bands; `GameState.get_body_read(id)`
  (GameState.gd:11114) and `get_athlete_wear(id)` (:17410) for injuries / forecast weeks / career wear / worst region;
  `scripts/rules/CutScar.gd` scar level 0-3 (one line, "reopens easier"); `scripts/WeightCut.gd` status(athlete, limit, family),
  limit_for, family_for, diet_plan(id) for weight now / limit / message / diet plan; stamina/condition from the card.
- Training plan: `GameState.get_week_program(id)` (GameState.gd:6762) - 7 entries, one station + focus per day, fight day marked;
  CHANGE PLAN emits `open_plan` (the caller routes to the existing plan screen); techniques learning this week = the tree rows in
  state "learning".
- The 3D stage (centre of TECHNIQUES): reuse ProfileOverview's portrait SubViewport approach (`_build_portrait`, FIGHTER_GLB) at
  Ludo's rect; clicking a CERTIFIED node plays that clip looped on the stage (AnimationPlayer from the fighter's own library - see
  how FightStagePlayer loads clips: `sed -n 1412,1440p scripts/FightStagePlayer.gd`); a non-certified node shows the idle guard and
  "3D PREVIEW NOT IN THIS BUILD". `load_models` false in headless tests (ctx flag already exists).

## Build
1. `Godot/scripts/ui/ProfileOverview.gd` (498 lines): the tab bar becomes 7 live tabs (OVERVIEW | TECHNIQUES | MEDICAL |
   TRAINING PLAN | FIGHT RECORD | CONTRACT | CAMP) at Ludo's global-shell rects (reply1 top: tab bar rect(16,40,1888,36), active =
   2px bottom border #D69E2E); clicking a tab swaps the body area; OVERVIEW keeps today's content unchanged. Keyboard 1-7 select
   tabs, Esc = back. FIGHT RECORD / CONTRACT / CAMP call `ProfileTabsB.record(athlete, ctx)` / `.contract(...)` / `.camp(...)` from
   `res://scripts/ui/ProfileTabsB.gd` IF that script exists (PROFILE2D builds it), else draw the honest empty state "COMING IN THIS
   BUILD" - do not create that file.
2. NEW `Godot/scripts/ui/ProfileTabs.gd`: static builders `techniques(athlete, ctx) -> Control`, `medical(athlete, ctx) -> Control`,
   `training_plan(athlete, ctx) -> Control`, each at Ludo's column rects inside the body area (y 120..1064 at 1920x1080).
   TECHNIQUES: left 9-bar column + the raw sim keys card, centre stage + telemetry card + LOOP / SLOW-MO buttons, right branch
   chips + scroll list of 68 px rows in the 5 states exactly as reply1 s1.3 + bottom strip (LEARNED x/54, NEXT TO LEARN,
   ASSIGN TO TRAINING PLAN -> emits `assign_technique(id)`, fight-plan weight PRIMARY/SITUATIONAL/SUPPRESSED -> emits
   `plan_weight(id, weight)`, enabled only when can_weight). MEDICAL: three columns per s2 with only real fields. TRAINING PLAN:
   7 day columns (one block each) + right column (techniques learning, CHANGE PLAN).
3. Caller `Godot/scripts/GymHallPanel.gd` (~1015-1060, `_open_profile_overview`): pass the extra ctx keys (catalogue nodes,
   certified, card, week program, body read, wear) - read them there, the builders stay free of GameState.
4. Every tab has Ludo's EMPTY STATE for a new signing (no bouts, no injuries, nothing learned beyond stance).

## Acceptance (tier: new UI scripts + edited scripts)
- NEW `Godot/tests/profile_tabs_test.gd` (SceneTree `_initialize()`): a rich fixture (9 learned incl. stance/jab/cross/one_two,
  one LEARNING with an assignment, a 72% left arm, scar 2, 1.2 kg over the limit with a diet plan, a 7-day program with a fight
  day) and a bare new signing - two DIFFERENT fighters. Check: 7 tabs, each clickable, each body non-empty; TECHNIQUES shows 7
  branch chips and the STRAIGHT branch's 7 rows with the right state per row and "LEARNED 9 / 54"; an uncertified move row says
  NOT IN THIS BUILD under demo; MEDICAL lists 6 regions with the arm in the severe band and one scar line; TRAINING PLAN has 7 day
  columns with the fight day marked and CHANGE PLAN emits open_plan; the bare fighter shows every empty state; NO Label anywhere
  contains: "Quality", "concussion", "Concussion", "Sleep", "Commission", "lb", "Marcus", "Sarah" (invented fields/names).
  Make it RED on master first (missing script), then green.
- Parse: `python Godot/tools/check_scripts.py <every touched .gd>`; then the test with
  `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/profile_tabs_test.gd`
  (never the _console exe); then `python Godot/tools/run_tests.py --jobs 2 --only profile,quick_look,gym_hall`.
- Stills are Claude's job (game camera, `Godot/tools/profile2_stills.gd`) - do not shoot; never open a window, viewer or browser.

## Owned files
Godot/scripts/ui/ProfileOverview.gd, new Godot/scripts/ui/ProfileTabs.gd, Godot/scripts/GymHallPanel.gd (only the profile caller
block), new Godot/tests/profile_tabs_test.gd. Not GameState.gd. Not ProfileTabsB.gd.

## Prior research
LUDO_ROUND41_S206_reply1/2.txt (this design), LUDO_ROUND40_S205_profile.txt (states + empty states), LUDO_ROUND37_VERDICT_S202.md
(no invented numbers), TASK_PROFILE3A.md (tree states API), S205_DIGEST.md (PROFILE2B + 2B_FIX: the full-screen frame).

## What would a human do?
Football Manager's player screen: one frame, one tab per question, every number the game really tracks, honest blanks.

## Prefab check
None - project UI kit (UIKit, ChakraPetch / JetBrains Mono fonts already preloaded in ProfileOverview.gd).

## The one trap
`var x := <call>` fails on a Variant return - type it (`var n: int = ...`). Full-rect Controls: never assign `size` on mount;
`remove_child` before `queue_free` when a tab swap rebuilds the body.

# TASK U201 - GF1 part A: the fighter card, the skill tree and the home card explain every number (Cursor, S133)

Model: composer-2.5 (the launcher default; Cursor quota is low - finish in one run). Worktree `D:/FightCamp/wt/U201`,
branch `cursor/u201-gf1-card-skills-home`.

## Why
Dola's strict review D66 (`research/D66_STRICT_REVIEW.md`) scored the game 5/10: "every panel, number, and icon is
unexplained". Operator 2026-09-30: "add these on the roadmap" / "assign someone to add those features from dolas
report". This is part A of roadmap GF1 (the demo is 2026-10-06). Part B (offers + camp) is Qwen's Q219 - do not touch it.

## Prior research (read first)
- `research/topics/ui_screens.md` (canonical), `J52_TOOLTIPS_AND_TUTORIAL.md` (what stays on screen vs in a tip),
  `S78_DIGEST.md` (menu clarity + tooltip system), `M33_ICONS_AND_TYPE.md` (tooltip look), `D66_STRICT_REVIEW.md`
  weaknesses 1, 2, 5. `python Tools/prior_research.py tooltip glossary attribute skill` for more.

## What would a human do?
A UI designer on Football Manager's attribute screen: keep the numbers, add the scale and a tier word beside each, and
put "what this controls" in a hover - never more text on the screen itself.

## Prefab check
The tooltip system EXISTS - reuse it, build nothing new: `UIKit.tip(node, spec)` (UIKit.gd:205; spec = a Glossary id,
a plain line, or {term, text, title, now}), the `TipLayer` autoload (TipLayer.gd, auto-tips a Label whose text matches
a Glossary alias), `Glossary.gd` TERMS (lines 20-205; entries need name, aliases, short <= 15 words, why <= 12 words -
`tests/menu_clarity_test.gd` enforces it).

## The work
1. Fighter card, overview (`ProfileRevampPanel.gd` 3724 lines - never read whole: `_build_overview` :967,
   `_fill_attributes` :980-1082, STAT_KEYS/STAT_LABELS :47-48, `_grade()` :3650): every attribute row gets a hover that
   says what the stat controls in the fight and the scale ("0-100; grade A 85+, B 70+, C 55+, D 40+, E below" - read
   the thresholds from `_grade`, never retype different ones), and the row's three marks explained once (base /
   fight-ready / ceiling - `UIKit.attribute_row` :2247 draws them). Add Glossary terms for the stats that have none:
   power, speed, defense, grappling (grapple_offense), takedown defence (grapple_defence), top control; reuse the
   existing technique / fight_iq / conditioning / potential terms. Word each "why" from what the ENGINE does with the
   stat - grep `Godot/scripts/FightRealtime.gd` / `FightMoves.gd` for the key (e.g. `"power"`) and say only what the code
   does.
2. Skill tree (`SkillsMovesPanel.gd` 725 lines; `_rebuild_tree` :277; requirement box `_build_schematic` :355-510 shows
   proficiency :435, attributes :438, prerequisites :453, reps/weeks :478-498 ONLY for the selected node; the node
   caption "LOCKED" comes from `UIKit.tree_node` :1877): every LOCKED node carries a hover naming what unlocks it (the
   same data `_build_schematic` reads - `technique_catalog.json` `requires`: discipline, attributes, prerequisites,
   reps, weeks; grep that 26,852-line file, never read it whole). The PROFICIENCY strip (:257-259) gets the scale.
3. Home card (`DayFeedPanel.gd` 991 lines): `_fighter_status` :867-882 ("Ready to book" etc.) gets a hover saying what
   the status means and what to do; the weekly report line from `CoachVoice.gd` :60-86 ("Quiet week") gets a hover on
   what a quiet week is (fatigue below FLAT_FATIGUE). The "Condition" label is ALREADY tipped (S133, `body_condition`)
   - leave it.

## Owned files (edit ONLY these; anything else = send-back)
- `Godot/scripts/ProfileRevampPanel.gd` - ONLY `_fill_attributes` (:980-1082) and helpers you add at the end of the file.
- `Godot/scripts/SkillsMovesPanel.gd` - the tree build and hover code.
- `Godot/scripts/DayFeedPanel.gd` - ONLY `_fighter_status` (:867-882) and `_build_weekly_report` (~:710).
- `Godot/scripts/Glossary.gd` - ADD terms only (Qwen does not edit this file).
- `Godot/scripts/UIKit.gd` (8308 lines - never read whole) - ONLY `attribute_row` (:2247..end of that func) and
  `tree_node` (:1877..end of that func), and only if a hover cannot be attached from the caller.
- NEW: `Godot/tests/gf1_card_skills_tips_test.gd`, `previews/u201/*`, `research/U201_DIGEST.md`.

## Parse gate (before any test)
`python Godot/tools/check_scripts.py Godot/scripts/ProfileRevampPanel.gd Godot/scripts/SkillsMovesPanel.gd Godot/scripts/DayFeedPanel.gd Godot/scripts/Glossary.gd Godot/scripts/UIKit.gd`

## Test (tier: scripts edited)
One: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/gf1_card_skills_tips_test.gd`
Your new test builds the card, the tree and the home card headless and asserts: every attribute row, every LOCKED node
and the status line resolve to a NON-EMPTY tooltip body through `TipLayer.body_for` (the same function the game uses),
and every LOCKED node's text names at least one real requirement from the catalogue. Then:
`python Godot/tools/run_tests.py --jobs 2 --only menu_clarity,profile_revamp,fighter_card,skills_moves_screen,skill_tree,day_feed_screen,gf1_card`
(never serial; wait on the runner's exit).

## Screens (evidence)
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/s64_career_walk.gd -- plan=research/s117_boxer_walk.plan out=docs/previews/u201 as_game`
(needs a window - godot_hidden hides it). Open 13_card_overview, 14_skills_&_moves and 08_home and check nothing
overlaps or overflows. Hover text is checked by the test, not by the stills.

## Acceptance
1. Every number on those three screens has a hover (test green); nothing new is written on the screen itself except a
   scale where a bar had none.
2. All listed tests green, menu_clarity_test included (glossary word limits).
3. Branch pushed; explicit `git add` by path (never `git add .`, never `Godot/.godot`); 10-line `U201_DIGEST.md`.

## The one trap
`ProfileRevampPanel.gd` and `UIKit.gd` are huge and shared - read `sed -n` windows only and keep every edit inside the
named functions. A tooltip must say what the CODE does; if you cannot find what a stat does in the engine, write
"what it controls" from the Glossary text that exists and flag it in the digest - never invent a mechanic.

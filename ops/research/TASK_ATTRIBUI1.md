# TASK ATTRIBUI1 - the 11 attributes on the fighter profile (Cursor). Model: Cursor (default). Discipline: BOXING (demo).
Status: OPEN (S260: Ludo answered with the still - research/ludo_rx/LUDO_ATTRIBUI_S260.txt, 19,561 chars, SPEC-UI-PROF-11ATTR-R01;
verdict below. Inside the approved feature Q-S256-1, so built and reported - CLAUDE.md "build agreed details", S240.)

Operator board Q-S256-1 (S259): "add them all , wire them properly to training and fight". S260 wired them into the save, the
gym day and the bout (commits 9d79a7bf, 3e6c4521, 72e4897a, 2375713d; switch `attributes`, GAME_ON). The profile still shows the
9 old stats (POWER, TECHNIQUE, SPEED, DEFENSE, ... TOP CONTROL), so the player cannot SEE what he trains.

## Prior research
- research/topics/attributes_skill.md, research/topics/ui_screens.md (canonical pages); ATTRIBUTES_S259_VERDICT.md (the table of
  11 with what each shows in the fight); research/ludo_rx/LUDO_ATTRIBUTES_S259.txt section 1 (Level 20 / 50 / 80 words per
  attribute - use them as the row tooltips); UICARDS1_DIGEST.md (profile tokens, tab tween).

## What would a human do?
Football Manager / Fight Night: the profile lists every trained attribute in groups (physical / technical / mental), one bar
each, the innate one marked as such. The player reads "hand speed 62, footwork 48" and knows which station to send him to.

## Prefab check
None needed: UIKit.attribute_row and UIKit.radar already draw rows and the shape chart; this is data + layout only.

## Ludo verdict (S260, LUDO_ATTRIBUI_S260.txt sections 1-6 - build exactly this)
- THREE GROUPS, this order: PHYSICAL = HAND SPEED, FOOTWORK, POWER, CONDITIONING; TECHNICAL = TECHNIQUE, GUARD, HEAD MOVEMENT,
  FIGHT IQ; MENTAL & RESILIENCE = COMPOSURE, RECOVERY, CHIN. Labels exactly as written (all <= 13 chars).
- Group header: 14 px high, transparent, caps muted text with +1.5 px tracking, a 1 px rule from the text's right edge to the card's
  right inset. 4 px gap above each header, 2 px below; rows 20 px with 2 px between rows; 6 px top and bottom inset.
  Ludo's budget (3 x 14 + 11 x 20 + 8 x 2 + 3 x 4 + 12) = 302 px = what 9 rows take today. Our T.STAT_ROW_HEIGHT is 30, not
  Ludo's assumed 28: MEASURE - the DISCIPLINES caption must not move down; if 20 px rows still overflow, shrink the inter-row gap,
  never text below T.SIZE_MIN (12).
- Columns inside the 540 px card: label 132 px, the base / fight-ready / ceiling bar 200 px (8 px high), value, grade badge, trend
  arrow - keep UIKit.attribute_row's own drawing and UITokens colours (one UI bible); pass the 20 px height.
- CHIN (innate): a 10 x 10 px padlock right of the label; NO ceiling track; bar in a bone / silver tone; trend column a static dash.
  After a knockdown / KO loss the chin lost since birth draws as a crosshatched oxblood gap from the current chin to `chin_born`
  (stats key written by AttributeTraining.migrate_fighter, S260) and a red down arrow with the loss ("-1.5", "-5.5") for 14 days.
- RADAR: NOT 11 axes (Ludo: an unreadable starfish) - the 5 derived fight numbers from `Attributes.derived(stats)`: ACCURACY (top),
  DAMAGE MIT, KO LEVERAGE, TRAUMA THRESH, EVASION (pentagon, Ludo's angles 90/18/306/234/162 deg).
- Radar footer line: "PHYSICAL 48 (C+) | TECHNICAL 44 (C) | RESILIENCE 62 (B-)" - each group's plain mean of its attributes, with the
  panel's existing grade function.
- Row tooltips (two lines, Ludo section 6 verbatim), e.g. HAND SPEED: "Reduces punch extension and retraction frames; snaps
  combinations." / "Trained at: Speed Bag, Focus Mitts." - copy all 11 from the file; for station names use the floor's own names
  (pads = Focus Mitts, defence drill, ring sparring, recovery station). Chin line 2: "Innate: cannot be trained. Drops with knockdowns."
- NOT in this task (Ludo section 7, scope calls parked for the operator): the fighter RATING formula (mean of 10 attributes - it moves
  matchmaking), and the record summary SUB -> DQ wording.

## Build
Owned: `Godot/scripts/ProfileRevampPanel.gd` (4,341 lines - never read whole; windows `sed -n 40,70p` constants, `sed -n 1190,1235p`
`_fill_attributes`, `sed -n 1336,1352p` `_fill_shape`, `sed -n 4185,4200p` the stat-key map), `Godot/tests/attribute_profile_test.gd` (NEW).
- When `GameSwitches.on("attributes")` and the athlete's stats carry all 11 (`preload("res://scripts/rules/AttributeTraining.gd").has_all`),
  the attribute list draws the 11 Ludo attributes (`Attributes.ATTRS`) in Ludo's groups and order, chin marked INNATE (no trend
  arrow, no training mark), grouped as the verdict says. Otherwise today's 9 rows, byte-identical (the OFF control arm).
- The list must fit: 11 rows where 9 fitted - the DISCIPLINES caption below must not overlap (S66 trap: count STAT_ROW_HEIGHT per
  row, separation 0). Use the row height / column Ludo gives; never shrink text below T.SIZE_MIN.
- Tooltip per row: Ludo's Level 20 / 50 / 80 words for that attribute + which club stations train it (AttributeTraining.CLUB_TO_LUDO,
  station names as the floor shows them).
- `_fill_shape` radar: the 5 derived numbers (Attributes.derived), labels and order from the verdict; footer = the 3 group means.
- Trend arrows (get_stat_trends) for the new keys only if the 7-day history carries them; else no arrow (never a fake 0).

## Test: `Godot/tests/attribute_profile_test.gd` (NEW, extends SceneTree) - red on master (the panel shows 9 rows)
Build the panel for a migrated boxer (stats from AttributeTraining.migrate_fighter of two DIFFERENT fighters) with
career["attributes"]=true: 11 AttributeRow nodes + 3 group headers, labels in Ludo's order, chin row has no trend mark and no
ceiling, a chin below chin_born draws the loss gap, the radar has 5 axes named as the verdict, the DISCIPLINES caption's top >= the
list's bottom; with career["attributes"]=false: 9 rows exactly as today. Prints `ATTRIBUTE_PROFILE failures=<n>`.
Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/ProfileRevampPanel.gd Godot/tests/attribute_profile_test.gd`.
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/attribute_profile_test.gd` (tier: one script edited -
parse, this test, then `python Godot/tools/run_tests.py --only profile_revamp --jobs 2`).
Plain `--script` tests stay the OFF control arm; `-- as_game` turns the switch on (GAME_ON).
RESULT line for the PR body: `RESULT: tests/attribute_profile_test.gd -> ATTRIBUTE_PROFILE failures=0`

## The one trap
Claude closes this only on a still of the real profile screen (Cursor cannot see images) - the rows must not overflow the frame.

## Ludo question (to send with the current profile still)
"The boxer now has 11 trained attributes (hand_speed, footwork, guard, head_movement, technique, power, conditioning, fight_iq,
composure, recovery, chin-innate) instead of 9 stats. Attached: today's profile (9 rows + radar). Give the exact layout: groups and
order, labels (max 13 chars caps), row height in px inside the 540x(h) frame, how chin shows as innate, and whether the radar shows
11 axes or the 5 derived numbers (accuracy, evasion, KO leverage, damage mitigation, trauma threshold). Longest complete answer."

## Contract
OWNS: Godot/scripts/ProfileRevampPanel.gd, Godot/tests/attribute_profile_test.gd
RED_TEST: Godot/tests/attribute_profile_test.gd -> ATTRIBUTE_PROFILE failures=0
REGRESSION: attribute_profile_test, profile_stage_test
VISUAL: yes

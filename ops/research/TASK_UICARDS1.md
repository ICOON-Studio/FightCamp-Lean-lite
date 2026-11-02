# TASK UICARDS1 (S227) - the fighter profile + quick-look card, rebuilt from Ludo round 68, ONE STEP AT A TIME

Seat: cloud Cursor (label `cursor`) - the UI OWNER (operator S227: "one agent all the sumbenus and tabs inside the cards ... use ludos
huge code output and let it complete everything one at a a time"). Branch cursor/issue-<n>, PR to master; never master.
Operator verbatim on today's screens: "the game cards and the player profile is such a mess". New features ship ON (CLAUDE.md s10).
CI has no LFS: the 3D stage will not render there - layout, text, states and node tests only; Claude renders the stills on the PC.

## THE SPEC (binding): Ludo round 68
- `research/LUDO_ROUND68_REPLY_S227_part1.txt` - PART A (every defect per screenshot) + PART B (layout grid per tab, px at 1080p,
  fonts, colours, states, hover/click, tab transition timings).
- `research/LUDO_ROUND68_REPLY_S227_part2.txt` - end of PART B, PART C (FM / Motorsport Manager / Fight Night references),
  PART D (the 7-step build order + acceptance gates), PART E (GDScript - use it as a starting point, adapt to our UIKit/ProfileTabHost).
- (part3, if present: the rest of PART E.)
- The screenshots Ludo judged: `previews/profile2e/ludo_r68_sheet1.jpg`, `ludo_r68_sheet2.jpg`.

## Claude's corrections (win over Ludo)
1. DATA IS REAL. Show only what the game has (GameState / athlete dict: attributes, record, techniques + prerequisites, camp, injuries per
   region, contract terms, bout history). A block Ludo designs for data we do not have (hometown, ape index, personality traits, purse per
   bout, trophies) HIDES when the field is absent - never a placeholder, never an invented value. List every hidden block in your report.
2. No art swaps here: trunks/gloves/wardrobe are WARDROBE1/MH5, not this task. The 3D stage stays ProfileStage.gd (PROFILE2F just made it
   face the camera - keep that: `tests/profile_stage_test.gd` green).
3. Reuse UIKit (buttons, labels, palette) - add to it rather than a second kit. Keep the files split the way they are (ProfileTabHost,
   ProfileOverview, ProfileTabsB, ProfileMedical, ProfileStage) or split further; no file past ~1,500 lines.

## Do - Ludo PART D order, ONE STEP PER COMMIT, push after each
1 ProfileTabHost (header + tab bar + 160 ms gold indicator) -> 2 QuickLookCard -> 3 ProfileOverview (body-map block-man DELETED, 9 tiles in
3 pillars) -> 4 Techniques -> 5 Performance & Camp (the black void filled with REAL camp data) -> 6 Medical & Bio -> 7 Career & Contract
(the raw code/JSON block GONE, the neon-green buttons replaced). After EACH step: update `research/UICARDS1_DIGEST.md` (what the step
changed, its gate result, the hidden blocks) and comment on the issue "STEP n DONE" - then carry straight on with the next step.

## Gate (each step)
- Parse every touched .gd. RED first: a test per Ludo gate of that step that fails on today's master (no text clips at 1920x1080 and
  1280x720 - measure label minimum size vs rect; the debug/JSON block absent; the block-man node absent; tab indicator tween 160 ms;
  hidden-when-absent blocks). Paste the red lines in the digest.
- `run_tests.py --jobs 2 --only profile,quick_look,ui_kit` green; existing profile tests not weakened.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
Claude renders `tools/profile2_stills.gd -- as_game` on the PC after each step and compares with Ludo's PART B; not "accepted" until the
operator OKs the stills.

## Prior research
LUDO_ROUND68_*, PROFILE2F_DIGEST.md (the face camera), PROFILE2E_DIGEST.md, STRESSHDR1 (header stress bar, animated meters), memory
feedback_animated_meters (every bar tweens + band pulse).

## What would a human do?
A UI lead rebuilds one screen at a time against the art lead's grid, checks it at both resolutions, then moves to the next tab.

## Prefab check
Godot built-in Controls + our UIKit; no third-party UI kit.

## The one trap
Ludo's grid is drawn for a full roster with data in every field; our first-week boxer has an empty record, no camp and no injuries -
every tab must look finished in that EMPTY state too (test it with a fresh career's boxer, not a fixture with everything filled).

# TASK CAMPFOCUS1A - the camp focus triangle (Volume / Violence / Tactics) as data + pure resolver + test (S198)
Model: Qwen (qwen3-coder) - pure module, no UI, no GameState. Worktree E:/FightCamp/wt/NIGHTLY2. NEW branch qwen/campfocus1a:
`git fetch && git checkout -B qwen/campfocus1a origin/master`.

## Owned files
- `Godot/assets/data/camp_focus.json` (NEW)
- `Godot/scripts/rules/CampFocus.gd` (NEW)
- `Godot/tests/camp_focus_test.gd` (NEW)

## Spec (operator approved, board Q-S196-4 "approved with your recommendation": header 6 "BALANCED CAMP - NO FOCUS EDGES" gets a
## real mechanic). Source: research/LUDO_ROUND33_S198.txt "Header 6" (~lines 332-358).
Each camp week the manager splits 100 focus points over three axes: volume (cardio/output), violence (power/damage), tactics
(defence/discipline).
- BALANCED only when all three are in 30..36 (inclusive): no edge, no weakness.
- An axis >= 50 picks a profile with an EDGE and a WEAKNESS (exact numbers from Ludo):
  ANVIL (violence >= 50): power_output +12%, stagger_chance +20%, clean_hook_damage +15% | lateral_footwork -15%, stamina_burn +18%,
  exploited_by "jab-and-move out-fighters".
  ENGINE (volume >= 50): max_stamina +15 points, output_cap +25%, late_round_fatigue x0.5 | base_power -10%, counter_resist -12%,
  exploited_by "hard-hitting counter-punchers".
  CHESSMAN (tactics >= 50): defence_slip +18%, opponent_clean_accuracy -14%, exploit_charge_speed +50% | work_rate -25%,
  close_round_judging -1 round, exploited_by "volume punchers".
- Any other split = "LEANING <AXIS>" (the biggest axis) with no edge and no weakness (Ludo only rewards >= 50).
1. `camp_focus.json`: the three profiles + balanced band + the 50 threshold, with `note` naming the source.
2. `CampFocus.gd` (`extends RefCounted`, `class_name CampFocus`, pure static, json cached like `scripts/rules/CutScar.gd`):
   - `validate(points: Dictionary) -> Dictionary` - {ok, reason}: keys volume/violence/tactics, ints >= 0, sum exactly 100;
   - `resolve(points: Dictionary) -> Dictionary` - {ok, profile ("BALANCED" | "ANVIL" | "ENGINE" | "CHESSMAN" | "LEANING_VOLUME" ...),
     edges {key: value}, weaknesses {key: value}, exploited_by, header (the screen header text: "BALANCED CAMP - NO FOCUS EDGES" or
     "CAMP FOCUS: THE ANVIL (+12% POWER, +18% STAMINA BURN)" style - build it from the numbers, never hard-code a second copy)};
   - `weekly(weeks: Array) -> Dictionary` - weeks = Array of point dicts, one per camp week; the CAMP's profile is the profile of the
     summed points normalised to 100 (round half up, fix rounding so the sum is 100), plus `per_week` profiles.
3. Test (`extends SceneTree`; prints `CAMPFOCUS total=N fails=M`; quit(1) on fail): 33/33/34 BALANCED; 30/30/40 LEANING_TACTICS (no edge);
   36/36/28 not balanced; 50/25/25 ENGINE with +15 max stamina; 20/55/25 ANVIL every number exact; 25/25/50 CHESSMAN; sum 99 refused;
   negative refused; header strings contain the numbers from the json; weekly([60/20/20, 40/30/30] as volume/violence/tactics) -> sum 100/50/50
   normalised 50/25/25 -> ENGINE; a tie for biggest axis in LEANING picks the first in the order volume, violence, tactics; inputs never mutated. Name 3 REAL mutants in your final message - each a one-line change to
   CampFocus.gd (e.g. the threshold 50 -> 49, balanced band 30..36 -> 30..37, ANVIL power 12 -> 10 read from code instead of json) that
   you ran and saw the test go red. Edge-case inputs are not mutants.

## Gates
`python Godot/tools/check_scripts.py <new .gd>`; `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot
--script tests/camp_focus_test.gd` -> exit 0, no FAIL, no SCRIPT ERROR. Typed GDScript (never := on a Variant).

## Prior research
LUDO_ROUND33_S198.txt Header 6; existing camp UI scripts/FightCampPanel.gd (read-only context: grep "FOCUS EDGES" ~1751); K21_DIGEST.md
(camp projection dock + delta chips).
## What would a human do?
A trainer decides the camp's emphasis up front - more rounds, more power or more defence - and knows what he gives up.
## Prefab check
None - our own rules.

## The one trap
Do not commit the AgentComms/messages file. Mutants are CODE changes you ran, not edge inputs. Commit on qwen/campfocus1a, push; never
master; never open windows, image viewers or browsers.

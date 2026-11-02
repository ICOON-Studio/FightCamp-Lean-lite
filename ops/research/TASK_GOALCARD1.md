# TASK GOALCARD1 - the GOAL CARD on the floor: what he wants, by when, and whether he is on track (S238, LOOP1 slice 3)

Seat: Cursor (Godot UI, cloud). Branch `cursor/issue-<n>`, PR to master; Claude merges by diff. Model: Cursor default.
Discipline: BOXING (the demo).

Operator S237 (verbatim): "Start a fighter comes in , he is setting the goals and there is a timeline for that goal ( find my a fight
within a month eg ) [...] the player needs check the progress according the goal". Approved (board Q-S237-1): "build it, [...] the loop
, animations,workout,feeling of progrsession and improvement from training these are what matters for now". Operator S212: "use
animated meters" - every bar tweens.

The rules module `scripts/rules/FighterGoal.gd` is being written in parallel by Arena (TASK_GOAL1.md) - do NOT wait for it and do NOT
preload it: your card takes the plain dictionary its `card()` returns. Claude wires the card onto the floor next round. Do not edit
GymHall3D.gd, GameState.gd or any rules file.

## The design (lead designer Ludo r102, `research/ludo_rx/LUDO_R102_LOOP1_raw.txt` section C - read it)
The goal card sits TOP CENTRE, always visible on the floor, above the cue buttons row (the floor's [1] POWER THROUGH / [2] CRISP FORM /
[3] PACE YOURSELF strip sits at y ~155-220 on 1920x1080 - stay above it, never over the ring), on a dark plate:
- Title line (the goal, e.g. "PRO DEBUT INSIDE A MONTH") + the fighter's one persona line in small text.
- A countdown: "DAYS LEFT 18" (flip-card style digits are fine; plain is fine).
- A status pill: ON TRACK (cool cyan/green) / AT RISK (amber) / OFF TRACK (crimson, gentle pulse) / MET (gold) / MISSED (dim red).
- One progress row per target: "CONDITIONING  58 / 65" with a thin bar that TWEENS to its new value (0.4-0.6 s ease out) and a
  ghost marker where the projection lands at the deadline.

## Do - new `Godot/scripts/ui/GoalCard.gd` (extends Control, no class_name)
- `func show_goal(card: Dictionary) -> void` - shape (from TASK_GOAL1 `card()`): `{"title": String, "persona_line": String,
  "days_left": int, "status": "ON_TRACK"|"AT_RISK"|"OFF_TRACK"|"MET"|"MISSED", "colour": "cool"|"amber"|"red"|"gold",
  "rows": [{"label": String, "now": float, "target": float, "projected": float}]}`.
- Test seams: `title_text()`, `days_text()`, `status_text()`, `row_count()`, `row_target_fill(i) -> float` (the TARGET fill 0..1),
  `is_animating() -> bool`.
- Use the UI kit: `const UIKit := preload("res://scripts/UIKit.gd")`, `const T := preload("res://scripts/UITokens.gd")`.
- Width <= 640 px; it must never cover the top-left boxer card (x < 460) or the right side of the screen beyond x 1460.

## Tests (red on master first - paste the red lines in the PR body)
New `Godot/tests/goal_card_test.gd` (extends SceneTree, `_initialize`, prints `GOAL_CARD failures=N`, quit(1) on fail). Three fixtures
printed at the top (different boxers): a 0-0-0 welterweight on "PRO DEBUT INSIDE A MONTH" ON TRACK with 2 rows; a middleweight on
"MAKE THE WEIGHT" AT RISK with 1 row; a featherweight on a goal that is MISSED. Assert: texts per fixture; status pill text per status;
row fills = now/target clamped 0..1; a second show_goal with a new value starts a tween; the panel rect stays inside x 460..1460 and
y < 150 on 1920x1080; nothing overlaps inside the card.
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/goal_card_test.gd`. Parse gate first:
`python Godot/tools/check_scripts.py Godot/scripts/ui/GoalCard.gd Godot/tests/goal_card_test.gd`.

## Rules
GDSCRIPT_TRAPS.md (`signal` is a keyword - never a variable name; typed reads; Label sizing). THE ONE TRAP: bars must ANIMATE.

## Prior research
LOOP1_VERDICT_S238.md, LUDO_R102_LOOP1_raw.txt section C, TASK_GOAL1.md (the dict), TASK_METERSHUD1.md + scripts/ui/TrainingMetersHud.gd
(your last panel - same plate, tween and pulse style; reuse its look so the two read as one HUD).

## What would a human do?
The date and the two numbers on the gym whiteboard, circled, where everyone walking past sees whether the fighter is getting there.

## Prefab check
None needed - Godot Control + Tween; no asset.

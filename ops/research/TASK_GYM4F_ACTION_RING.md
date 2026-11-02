# TASK GYM4F - Click a thing, a ring of its actions: ClubActionRing.gd (UI widget) + its headless test

Model: Cursor (cursor-agent, default model). Owner: Cursor. Worktree `E:/FightCamp/wt/GYM4F`, branch `cursor/gym4f-action-ring`
(created from master). Commit, push the branch; NEVER push master, never merge. Tier: new script + new test (+ an addon folder
if you vendor one) -> parse gate on the new .gd files + the new test.

## What it is
J64 (adopted by the operator S178): left-click any person or object in the club -> time pauses, a ring of at most 6 icons opens
around it; an unavailable action STAYS visible, greyed, its tooltip "<why> - <when it frees>"; Esc or right-click closes one
level; keys 1-6 pick. The rows come from the merged pure module `Godot/scripts/ThingActions.gd` + `assets/data/thing_actions.json`:
`ThingActions.actions(kind, ctx) -> Array` of {id, label, icon, tooltip, enabled, reason}; `ThingActions.coach_rows(ctx)` for the
fighter's CALL A COACH second level. Codex builds the 3D club in parallel (TASK_GYM4E) and emits
`thing_clicked(kind, id, screen_point)`; this widget is what opens on that signal. Do NOT touch the 3D scene.

## Owned files
- `Godot/scripts/ClubActionRing.gd` - NEW, `extends Control`. `open(kind: String, ctx: Dictionary, at: Vector2)`, `close()`,
  `is_open() -> bool`, `signal action_chosen(kind: String, action_id: String)`, `signal closed()`. One button per row placed on a
  circle around `at` (clamped inside the viewport), icon + short label; a disabled row is visible, greyed, not clickable, and its
  tooltip is the row's `reason`. Tooltips go through `UIKit.tip(node, text)` (scripts/UIKit.gd line ~206) - NEVER `tooltip_text`
  (UserSettings/TipLayer clears it; tests read the node's meta "tip"). Keys 1..N pick row N if enabled; Esc / right-click close
  one level. Picking `call_coach` on a fighter opens level 2 with `coach_rows(ctx)`; Esc there returns to level 1.
- `Godot/tests/club_action_ring_test.gd` - NEW, headless `extends SceneTree`, ok/FAIL lines, final `ACTION RING PASS checks=<n>`
  or `ACTION RING FAILS=<n>` + exit 1.
- Optional: `Godot/addons/radial_menu/` if you vendor Radial Menu Control (Godot Asset Library #3469, MIT, Godot 4.3+). Vendor it
  ONLY if it runs on 4.7.2 headless and supports a disabled+tooltip item; keep its LICENSE file. Otherwise write the ring yourself
  (a Control with buttons on a circle is ~150 lines) and say which in the commit message.

## Acceptance (numbers and texts read from thing_actions.json / ThingActions, never copied)
1. For each kind in the data, `open(kind, ctx, at)` shows exactly `ThingActions.actions(kind, ctx).size()` buttons, in data order,
   each at the same distance from `at` (+-1 px), none outside the viewport when `at` is a corner.
2. A ctx that disables a row (e.g. station occupied until 840) -> that button exists, `disabled == true`, its meta "tip" equals
   the row's reason ("Occupied until 14:00"); the enabled rows have no reason in their tip.
3. Key "2" on a kind whose 2nd row is enabled emits `action_chosen(kind, row2.id)` once; on a disabled row emits nothing.
4. fighter -> `call_coach` opens level 2 with `coach_rows(ctx).size()` buttons in that order; Esc returns to level 1; Esc again
   closes (`closed` emitted once, `is_open()` false).
5. Right-click anywhere closes one level, same as Esc.
MUTANTS (comment block at the bottom; run each, each must turn the test red, revert): hide disabled rows; tooltip via
`tooltip_text`; keys off by one; Esc closes both levels at once.

## Parse gate + test (the PC's Godot, headless; NEVER the _console.exe - it opens a window on the operator's screen)
`python Godot/tools/check_scripts.py Godot/scripts/ClubActionRing.gd Godot/tests/club_action_ring_test.gd`
`%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/club_action_ring_test.gd`
No windowed Godot, no image, video or browser opened. Nothing may appear on the operator's screens.

## Prior research
J64 (John: click a thing -> its actions; Two Point Hospital, The Sims pie menu, RimWorld float menu), GYM4_REDESIGN_S178.md
"Click a thing, see its actions", memory/GLOSSARY 'Icon with tooltip' (operator: icons over text, every icon has a tooltip).

## What would a human do?
Take the Sims pie menu: icons on a circle around the click, greyed items still shown with why, number keys, Esc backs out.

## Prefab check
Radial Menu Control, Godot Asset Library #3469, MIT, Godot 4.3+ (named in J64) - try it first; own ring if it does not fit.

## The one trap
`var x := <call>` fails when the call returns Variant - type it; a variable name reused in one function is a parse error;
`remove_child(node)` before `queue_free()` when rebuilding the ring between levels.

# TASK MIXAMO1C (S216) - HitReactionPick: choose which reaction clip a struck boxer plays (pure module + test)

Model: Arena Agent Mode. Repo ICOON-Studio/FightCamp, branch from master; work on your own `arena/` branch, open a PR, never merge.

## What
A boxing management game plays a whole-body reaction clip when a fighter is hit. A catalogue of clips (array of dictionaries) is
already tagged. Write a PURE GDScript module that picks the clip id for one hit event. No preloads, no scene tree, no file access,
no autoloads: plain data in, a String out. Godot 4.7, GDScript, static functions only, typed where possible.

## Owned files (both NEW)
- `Godot/scripts/HitReactionPick.gd` - `extends RefCounted`, static functions only.
- `Godot/tests/hit_reaction_pick_test.gd` - `extends SceneTree`; prints `PASS <line>` / `FAIL <line>` per check, then
  `quit(1)` if any FAIL else `quit(0)`. Copy the shape of `Godot/tests/station_move_picker_test.gd`.

## Data
Catalogue row: `{"id": String, "category": String, "target": String, "side": String, "power": String, "fall": String, "loop": bool}`
- category: react_head | react_body | block_react | knockdown | getup | idle | walk | block | strike | win | loss | hurt_idle | other
- target: head | body | "" ; side: left | right | front | back | "" (the side the blow comes FROM, seen by the receiver:
  "left" = the attacker's LEFT hand) ; power: light | medium | big | "" ; fall: back | stomach | side | "" (knockdown: where he
  lands; getup: the lying position he gets up FROM).
Hit event: `{"target": "head"|"body", "punch": String, "attacker_stance": "orthodox"|"southpaw", "power": float 0..1,
"knockdown": bool, "blocked": bool, "from_behind": bool, "fall": String (optional)}`.
punch is one of: jab, cross, lead_hook, rear_hook, lead_uppercut, rear_uppercut, overhand, body_jab, body_cross, lead_body_hook,
rear_body_hook, shovel_hook.

## Functions
1. `static func hand_of(punch: String, stance: String) -> String` -> "left" | "right". Orthodox: lead = left, rear = right;
   southpaw mirrors. jab/body_jab/lead_* = lead; cross/body_cross/rear_*/overhand = rear; shovel_hook = lead.
2. `static func is_straight(punch) -> bool` (jab, cross, body_jab, body_cross) ; `is_uppercut(punch) -> bool`.
3. `static func power_band(power: float, bands: Dictionary) -> String` -> light | medium | big. `bands` = `{"medium": float,
   "big": float}` (power >= big -> big, >= medium -> medium, else light). The module owns NO default numbers: the caller passes
   them (design values come later). Missing keys -> push_error and return "light".
4. `static func pick(event: Dictionary, catalogue: Array, recent: Array, rng_seed: int, bands: Dictionary) -> String`
   - blocked -> category block_react (any side). knockdown -> category knockdown, prefer `fall == event.fall` when given.
     Otherwise category react_head / react_body from `event.target`.
   - from_behind -> prefer side "back".
   - Wanted side: straights -> "front" first, then the punching hand's side; hooks/overhand/uppercuts -> the punching hand's side.
     An uppercut prefers rows whose id contains "uppercut" within the same target.
   - Fallback ladder, stop at the first non-empty set: (category, target, side, band) -> (category, target, band, any side) ->
     (category, target, side, nearest band: big<->medium<->light) -> (category, target, any) -> (category, any) -> return "".
     A row with an empty tag matches nothing on that tag except at the "any" steps.
   - No repeat: drop ids in `recent` (most recent last; only the last 3 count) from the chosen set unless that empties it.
   - Choose inside the set deterministically from rng_seed (same inputs -> same id; use a local RandomNumberGenerator with
     `seed = rng_seed`, never the global RNG). Sort the set by id before choosing so catalogue order does not matter.
5. `static func getup_for(knockdown_id: String, catalogue: Array, rng_seed: int) -> String` -> a getup whose `fall` equals the
   knockdown row's `fall`; else any getup; "" if none or the id is unknown.

## Acceptance test (>= 30 checks, all must PASS; build the catalogue fixture inline in the test, ~25 rows, using ids like
`head_hit_receiving_a_light_hit_to_the_head_from_a_left_punch`, `knocked_out_knocked_out_falling_to_back`,
`getting_up_getting_up_from_back`, `getting_up_getting_up_from_stomach`)
- hand_of: all 12 punches x both stances (orthodox lead_hook -> left, southpaw lead_hook -> right, overhand orthodox -> right).
- power_band edges: exactly at medium, exactly at big, below medium; missing bands -> "light".
- orthodox lead_hook to the head at big power -> a big react_head from the left; southpaw same punch -> from the right.
- jab -> a "front" row when one exists; when none, the lead hand's side.
- blocked hit -> block_react; knockdown with fall "stomach" -> a stomach knockdown; getup_for that id -> a stomach getup.
- fallback: remove every big-head row -> a medium head row from the same side is chosen (nearest band).
- empty catalogue -> ""; catalogue with only `idle` rows -> "" for a head hit.
- no repeat: with two candidates and the first in `recent`, the other is chosen; with one candidate in `recent` it is still chosen.
- determinism: same seed twice -> same id; shuffled catalogue order -> same id.
- 1,000 seeded picks over 3 equal candidates: each chosen between 25% and 42% of the time (bounded, not exact).
- MUTANT CHECK in the PR body: say which two checks fail if `hand_of` ignores the stance, and show that they fail.

## Commands
- `python Godot/tools/check_scripts.py Godot/scripts/HitReactionPick.gd Godot/tests/hit_reaction_pick_test.gd`
- `godot --headless --path Godot --script tests/hit_reaction_pick_test.gd`
Paste the test's full output in the PR body. CI runs the parse gate and the changed test. Never delete or weaken a check to go green.

## Prior research
`research/topics/hit_reactions.md` (reaction direction vs strike - Q104; sided reactions - C177; reactions play whole - U159).

## What would a human do?
A gameplay programmer writes a small selector: event in, clip out, with a fallback ladder so a missing variant never freezes the
fighter, and a no-repeat rule so the same flinch does not play three times in a row.

## Prefab check
No Asset Library selector fits our catalogue tags; the existing `FightStagePlayer` react_head rotation is not reusable (it is
inside a 6,500-line scene script). Pure code, MIT-clean, no third-party files.

## The one trap
"side" is where the blow comes FROM (the attacker's hand), not which way the head turns. An orthodox lead hook is the attacker's
LEFT hand.

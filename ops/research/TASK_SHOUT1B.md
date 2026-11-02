# TASK SHOUT1B - apron shout buttons on the live fight HUD (UI half, only when the bout runs `ludo_shouts`)

Model: cloud Cursor (issue label `cursor`). Branch: the workflow names it. Never master, never HANDOFF.md, never AgentComms/.
Operator S188 ("yes all picks", SHOUT1): "Mid-round shouts from the apron: 3 per round on a cooldown ('off the ropes', 'go to the body',
'tie him up')". Engine half merged S195 (315760d8): `FightRealtime.shout(state, side, shout_id) -> Dictionary` (~3775) returns
`{executed, success, reason, ...}`; reasons include MAX_CAP_REACHED, COOLDOWN_ACTIVE, SWITCH_OFF. Rules/data: `scripts/rules/ApronShouts.gd`,
`assets/data/apron_shouts.json` (3 per round, 22 s cooldown).

## Owned files
- `Godot/scripts/FightWorldLiveScreen.gd` (6,491 lines - NEVER read whole; grep + `sed -n` windows): the doctor overlay is the pattern for a
  player decision entering the engine (`_on_doctor_choice` ~5850 calls `rt.resolve_doctor_choice(_state["fight"], choice)`). Add `_on_shout(id)`
  calling `rt.shout(_state["fight"], <the player's side>, id)`; the player's side is the corner the player is in - grep how the corner/doctor
  overlay decides it (`doctor_pending["side"]`, `_corner_layer` ~5084) and reuse; never hard-code "a".
- `Godot/scripts/LudoShoutBar.gd` (NEW, <= 250 lines, `extends Control`): three icon buttons + a small cooldown ring/number + "2 left" pip count,
  signal `shout_pressed(shout_id)`, `set_state(used, max, cooldown_left_s)`, `set_enabled(bool)`. Mounted on `_corner_layer` bottom-centre,
  above the scorebug. Hotkeys 1/2/3.
- `Godot/tests/shout_bar_test.gd` (NEW).

## Prior research
- `research/LUDO_ROUND17_S193.md` (shouts section); `apron_shouts.json` for ids, labels, cost.
- UI rules: icons over text with tooltips via `UIKit.tip(...)` (never `tooltip_text`); tips carry the real numbers (cost 1.5 stamina,
  22 s cooldown). Nothing overlaps at 1920x1080 and 1280x720. Full-rect anchored Controls: never assign `size` on mount.
- Look at how LudoFightHud / LudoDoctorOverlay build icon buttons and copy their style (no new theme).

## What would a human do?
A cornerman calls out during the round: three big buttons under the ring, grey while the cooldown runs with the seconds left, the count of
shouts left this round, and a short "heard it" / "he ignored you" flash from the result so the player learns whose voice carries.

## Spec
1. The bar exists only when the fight state has `ludo_shouts` AND the player is in a corner (not a spectated bout); otherwise NO node is added
   (screen tree byte-identical to master, assert it).
2. Pressing a button -> `_on_shout`; show the result for ~1.5 s ("Heard it" green / reason word amber: "Too soon", "Out of shouts",
   "He ignored you"). Cooldown and used-count read from the engine state (`_shout_counts`, `_shout_last_s`, `round_number`, `fight_seconds`),
   never from a local timer that can drift.
3. Disabled during the break and the doctor overlay.
4. Do NOT add `ludo_shouts` to DEMO_SWITCHES.

## Done (tier: script edited - parse, focused test, related runs)
- Parse gate on every touched .gd: `python Godot/tools/check_scripts.py <files>`.
- `shout_bar_test.gd`: two DIFFERENT boxers (name them); switch off -> no `LudoShoutBar` node; on -> three buttons, press 1 -> engine log has a
  shout entry for the player's side; a 4th press refused with the right word; a press inside 22 s refused; cooldown number follows the engine
  clock; no overlap at both resolutions. RED first on master (paste the count), then green.
- `python Godot/tools/run_tests.py --only ludo_fight_hud --jobs 2` and `--only shout --jobs 2` -> 0 fails.
Final message: red count, green results.

## The one trap
The engine runs ~3.5 s AHEAD of the picture (`HORIZON_S`, `_pump_to`): a shout lands at the engine's present, so its effect shows on screen a
few seconds after the press. The "heard it" flash comes from the return value immediately; never wait for the picture to confirm.

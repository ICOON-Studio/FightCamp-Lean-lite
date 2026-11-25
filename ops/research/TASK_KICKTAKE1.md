# TASK KICKTAKE1 - the first kick pictures: teep, low kick, check (S559)

Kind: build (takes + pictures). Model: claude-opus-5-5. Discipline: kickboxing (owner S559 "Yes, kickboxer first").
Seat: console worker. Estimate: 3-4 hours, ~20 min of GPU renders.

## Why
The kickboxing page (`proto/twohands/kick.html`) plays kicks with no pictures (a 404 now falls back to the guard).
KICKART1 (`ops/research/KICKART1_SOURCES.md`) found the route, nothing to buy: the Mixamo kicks are ALREADY in
`C:\Users\user\Downloads` and the game already retargets Mixamo-skeleton FBX onto the MetaHuman (`scripts/fight3d/RkRetarget.gd`,
`RkClips.gd`, `assets/anim/rokoko_combat/CREDITS.md`).

## Do (KICKART1's recommended route, first slice)
1. Teep: copy `Kicking__Male_Thrust_Kick_With_The_Lead_Foot.fbx` into `assets/anim/kicks/` (with a CREDITS.md line: Mixamo,
   Adobe's terms for games), retarget it like the rokoko takes, and make the picture runs `teep_landed / _blocked
   (caught: the lead hand held low traps the leg) / _missed`, both corners, at Long and Mid (`_r2`).
2. Low kick: `Mma_Kick__Mma_Low_Kick.fbx` + `Transition__Low_Kick_To_Idle_Transition.fbx`, the same way:
   `low_kick_landed / _blocked (checked) / _missed`. Gate on a side-camera still: the standing foot stays planted and the
   SHIN lands on the thigh (R111: our old kicks "all fly").
3. Check: author it with a leg variant of `tools/pics2d_hold_bake.gd` (guard held, lead knee up and out, shin turned
   out), runs `check` and the defender's side of a checked low kick.
4. The pictures through the picture tools (`tools/pics2d_anim.gd` FAMILIES / `pics2d_anim_more.gd`), the frames gate,
   `anim_web.py` (merge), `anim_check.mjs`; kick.html's ACT `pic` names (teep, low_kick) must match the runs.
5. Strips to `ops/previews/s559_kicks/` and one sheet on the board (`python ops/Tools/review_add.py --stage S559 --rating
   "not scored: your eye" --title "First kicks: teep, low kick, check" <png>`). Play a beat with each kick on kick.html in
   the browser (server: `python proto/cardgame/serve.py 8797 twohands`) and look at it.
Note: if `tools/pics2d_camera.json` appears while you render (the owner's new camera), STOP and tell the session.

## Contract
- OWNS: assets/anim/kicks/ (new), tools/pics2d_hold_bake.gd (a leg variant), tools/pics2d_anim.gd and
  tools/pics2d_anim_more.gd (kick runs only), the kick pictures and their frames.json rows, proto/twohands/kick.html (pic names only)
- RED_TEST: anim_check.mjs with teep / low_kick / check added to its required list (fails today)
- REGRESSION: anim_check.mjs PASS for every existing run; kick_test.mjs 12 passed; page_play_test.mjs 4 passed
- VISUAL: the strips, opened by you: planted standing foot, shin contact, both men head to feet

## Not allowed
No change under scripts/ (the retarget is reused, not edited; if it must change, stop and say why). MetaHuman bodies only.
Godot only through godot_slot + hidden_desktop, never `_console.exe`. HIS GAME FIRST. Commit only your paths, by pathspec.

## Prior research
ops/research/KICKART1_SOURCES.md; ops/research/topics/kicks_legs.md; J57 (what a landed leg kick looks like);
R111 / R142 (flying kicks).

## What would a human do?
An animator retargets the library kick, checks the plant foot and contact on the game camera, and authors the one pose
the library lacks.

## Prefab check
Done by KICKART1: Mixamo (downloaded), Rokoko free kicks (downloaded), paid fallback Muay Thai AnimSet Pro $35 - not now.

## Feedback loops
None: pictures only.

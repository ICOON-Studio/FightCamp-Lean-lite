# S61 digest - the Character Creator fighter in the live room (Claude, 2026-09-23)

## Built (2b3a8863)
- `scripts/CCFighterSkin.gd` - mounts `assets/_local/cc_welter_01` (gitignored, licence) as a sibling
  of fighter A and copies his pose at `RenderingServer.frame_pre_draw` through `FighterSkinFollower`.
  The Tripo body keeps playing every clip; only its SKINNED meshes are hidden. Presentation only.
- `FightWorldLiveScreen`: option `fighter_skin=cc`, launch arg `-- skin=cc`, **K** toggles CC/Tripo
  live. A missing export prints a refusal and keeps the Tripo body - it never fails the room.
- `tools/record_room.gd`: `skin=cc`.
- GLOVES: the Tripo gloves are painted into the skin (f01, f05), so there is nothing to re-attach.
  Built per discipline (boxing/kickboxing/muay_thai boxing glove, mma 4 oz, anything else bare) and
  posed every frame from the CC wrist, middle, index and pinky knuckles.
- HEIGHT: the export's BIND height is 1.7642 m (the probe reads `get_bone_global_rest` - it was
  never a walk-frame number); the skin is scaled to A's MOUNTED height, 1.740 m (FighterPhysique's
  answer). No second export spent - the fallback the roadmap named.

## Measured (`tests/fight_cc_skin_test.gd`, 17/17; population: seed 810039, A = f01 boxing /
f05 MMA / f01 muay thai Tripo under cc_welter_01, B = the discipline pair)
22/22 bones pair; 0 Tripo meshes visible under the skin; CC 1.7400 m vs A 1.7400 m, feet dy 0.0000;
hands follow worst 0.063 m over 240 frames; glove-to-hand worst 0.084 m; right hand travels 0.860 m;
A's root path identical skin on/off over 240 frames. Four mutants (no hide, no boxing glove, no
follow, unit scale) each caught.

## Seen
Recorded 12 s, boxing, establishing shot (`record_room.gd ... skin=cc`), frames opened: two bodies,
not three; red gloves on the CC man; face skin-toned, not white. The cuff reads as a plain tube
up close - G80 (Grok) is fetching real glove dimensions to size it from data.

## Collected this session
Venue 4 The Cut Glass (Codex, renders opened), U147 (Cursor), Q153 round 2 (Qwen; fixes
`grapple_naming_contract`), G79 (Grok, `G79_CLOSING_DISTANCE.md`). Focused 16/16 before merge.
U147's finding stands: overlap runs >3 cm last 0.150 s against a 0.1 s budget, and faster root
pushes bring teleports back - so the fix belongs in the ENGINE keeping distance (S62), not the room.

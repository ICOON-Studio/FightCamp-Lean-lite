# C220 - seated idle (S113)

Delivered on `codex/c220-seated-idle`; Claude merges. Implementation: `49937ab`.

The first coach sits on the chair facing the staff table. Additional coaches
retain `calm_idle`. A walk-in uses the lobby sofa only when the desk is hired
and the sofa exists; owner-on-desk, no-walk-in and model-free paths retain
their prior behavior. Both seated bodies mount on the floor datum, removing
the rig's standing lift. `TrainingFloor3D.gd` changes only its clip constant.

## Clip and licence

`seated_idle.res`: CMU **75_17, medium sit**, 2.0-3.8 seconds, retargeted at
30 Hz with C219's map and production silhouette corrections; 1.8-second loop,
23 tracks, final 0.6-second smoothstep crossfade. This is seated settling/fidget
motion, not a separately captured breathing take. IK fits the legs to floor
contact and lowers captured hand motion toward the lap; no hand-keyed motion.
Hands are not a contact gate and do not stay glued to the thighs.

CMU's custom permission permits inclusion in commercially sold products but
forbids direct resale of the data, even converted. Attribution, URLs, source
hashes and rebuild commands: [SOURCE.md](../assets/anim/boot/c220_source/SOURCE.md).
Raw ASF/AMC and intermediate BVH/GLBs are only in
`D:/FightCamp_originals/c220_source`; none are committed. The optional
game-dev CLI was absent; the explicitly assigned local Blender/Godot path ran.

## Posed mesh contact

`c220_measure.gd` builds the actual rooms and reads their actual animation
players and bodies. It evaluates every skin influence on posterior pelvis
and each foot's mesh vertices in world space, 109 samples at 60 Hz across
the full loop, including endpoints. Each region's lowest mesh point is the
contact surface. Seat heights and support footprints come from horizontal
triangles of the actual chair/sofa, not a bone or rest AABB.

| Rig / room | Region | Achieved world Y, m | Wanted, m | Maximum error, m |
| --- | --- | --- | --- | --- |
| f10 heavy coach / staff | Pelvis | 0.462607-0.466972 | 0.474487 +/- 0.04 | 0.011879 |
| f10 heavy coach / staff | Left foot | -0.011290 to -0.010477 | 0 +/- 0.03 | 0.011290 |
| f10 heavy coach / staff | Right foot | -0.019936 to -0.015519 | 0 +/- 0.03 | 0.019936 |
| f09 welter visitor / lobby | Pelvis | 0.457881-0.461817 | 0.454720 +/- 0.04 | 0.007097 |
| f09 welter visitor / lobby | Left foot | -0.009946 to -0.005507 | 0 +/- 0.03 | 0.009946 |
| f09 welter visitor / lobby | Right foot | 0.004483-0.006714 | 0 +/- 0.03 | 0.006714 |

Pelvis support remains inside each seat footprint. Both poses retain capture
motion and every track's endpoints match. The tool checks that the second
coach still uses `calm_idle`. Different mesh SHA-256s are asserted:

- f10: `85a86ce418d0ab1952b448a9c6602d1edcbb4000b919719f85cbe6ac1bc6f1da`
- f09: `8986f87ea7f1cfdd78df121abc8ec64477f52153db94eaf50491b5202371ca44`

`C220_CONTACT rows=6 failures=0`. A deliberate `-- mutant` 0.1 m body lift
produced `rows=6 failures=6`, exit 1. The numerical tolerance allows up to
2 cm foot penetration on the coach; this is not a claim of exact zero contact
or certification for other rigs. Raw results: [contact.json](../docs/previews/c220/contact.json).

## Gates and visual review

- Required first worktree import completed, with the import process at idle.
- Parse: `CHECK total=5 fails=0 autoload_refs=0 autoload_warnings=0`.
- Required affected set, `--jobs 1`, runner's idle priority:
  `staff_room,front_door,office_room,physio_room,training_floor_3d,locker_room,mat_room,gym_wing`:
  **`SUITE total=8 fails=0`**. No full suite run.
- Both requested hidden render scripts completed; PNGs were opened and reviewed.

[Before/after and contact images](../docs/previews/c220/):

- `staff_room_before.png` / `staff_room_after.png`: coach changes from standing
  behind the table to sitting on its rear chair. The table occludes his lower
  body at the normal camera; side contact views show the occupied chair,
  thighs, bent knees and feet.
- `lobby_before.png` / `lobby_after.png`: starter state has no hired desk and
  no walk-in; the empty navy sofa and owner at the desk remain unchanged.
- `lobby_populated_after.png`: explicit hired-desk plus one-walk-in fixture
  shows the visitor on the navy sofa facing the room and the desk hand standing.
- `staff_populated_after.png`: first coach seated, second coach standing.
- `staff_contact_0/1/2.png`, `lobby_contact_0/1/2.png`: three phases of each
  seated loop, viewed from the side. Labels hidden only for contact close-ups.
  The staff second coach appears in the near foreground; the seated body and
  support remain visible. The sofa side views show pelvis on cushion and feet
  at floor level, with small hand/body fidget between phases.

Task-specific overrides: no HANDOFF block or reads of HANDOFF, CURRENT_STATUS
or HANDOFF_ARCHIVE; task's bounded gates replace the generic full-suite habit.
Source note and preview directory are included as explicitly required outputs
despite not being repeated in the task's abbreviated owned-file list.

The first import generated unrelated `.import` line-ending/stat changes and
several untracked import/UID files. A diff check reported no content changes
in tracked `.import` files, but automatic approval review rejected the broad
restore as potentially discarding concurrent work. These artifacts are left
unstaged, excluded from both commits. Original s107/s109 preview paths were
restored after their C220 copies were saved.

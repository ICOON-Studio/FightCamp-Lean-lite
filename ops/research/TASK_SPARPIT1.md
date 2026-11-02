# TASK SPARPIT1 - the taped sparring pit: draw it in ROOMS, buy its tape + stools in OBJECTS, sparring works on it

Model: Cursor (Godot gameplay + BUILD window scripts). Discipline: BOXING (demo) - gym building, GYMBUILD.
Operator rulings: S278 "you draw the room/zone and then you put the suitable items, you do not put the zones"; S277 "make the box
purchasable item" (the 18,000 pro ring is a mid-game goal); Ludo S277 verdict (LUDO_S277_BLANKSTART_VERDICT.md row "Ring on day 1",
approved): day one has a TAPED FLOOR RING, ring IQ x0.75, slip risk x1.15.

## Today (master, traced by Claude S279)
- `Godot/assets/data/room_types.json` has row `sparring_pit` (min 4x4, permit 300, 40/m2, key_item `taped_floor_ring`
  "Corner Stools & Tape" $900, unlock open) - but `BuildMode.room_types()` (Godot/scripts/club_rooms/BuildMode.gd ~L139) SKIPS every
  row without a `data_room` except `training_floor`, so the pit never shows in ROOMS.
- A new career (as_game, empty shell) has `career.club_ring_owned = false` (GameState.gd ~L3705); `GymClubLayout._drop_unowned_ring`
  (GymClubLayout.gd ~L630) erases the `ring_sparring` place, so sparring has no station: nobody walks to spar, the Day Plan's
  `ring_spar` (GymHall3D.gd ~L2718 DAY_PLAN_STATION) has nowhere to go.
- The training floor is the model to copy: drawn as a zone (`finish_room` TRAINING_FLOOR branch ~L246 -> career.club_training_floors,
  `GymClubLayout.training_floors()` ~L664), then single pieces on it (`room_items_for_sale`, `station_shop`, S278).

## Do
1. RED TEST FIRST: `Godot/tests/sparring_pit_test.gd` - on master, as_game, it must fail on "ROOMS lists the Taped Sparring Pit".
2. ROOMS: `sparring_pit` is listed and drawn as a ZONE (no walls) like the training floor (career key `club_sparring_pits`, a
   `GymClubLayout.sparring_pits()` reader). It may not overlap rooms, the ring spot or other zones; it may sit on a training floor
   only if the training-floor rule already allows the ring there (follow `room_check`).
3. OBJECTS: once a pit is drawn, its key item "Corner Stools & Tape" ($900) is for sale; bought, the pit gets the `ring_sparring`
   place centred in the pit (the taped ring): tape lines on the floor + 4 corner stools. Prefab first: our existing stool/bench props
   (grep Godot/assets/models for stool/bench) and a flat tape mesh; no new download without naming the licence.
4. Sparring works on it: the Day Plan ring_spar row and the hall's walk route reach the taped ring; `GymSparring`/`book_spar`
   unchanged. Ring IQ gain x0.75 on the taped ring vs the bought ring (Ludo); slip risk x1.15 only if a slip stat already exists on
   that route - if not, write "slip: no system yet" in the PR, do not invent one.
5. Buying the 18,000 ring later keeps working (ring_purchase_test green); with both, sparring uses the pro ring.
6. New behaviour reads `GameSwitches.on("sparring_pit")` with `sparring_pit` added to `GAME_ON` (operator S221: new features ship
   ON); plain `--script` tests are the OFF control arm (as_game turns it on).

## Test - Godot/tests/sparring_pit_test.gd (extends SceneTree; `-- as_game` arm + plain OFF arm; last line `SPARRING_PIT failures=<n>`)
as_game: ROOMS lists the pit; drawing a 3x3 is refused (too small), 4x4 accepted and paid (permit + 16 x 40 = 940); OBJECTS sells the
tape + stools at 900; bought -> a `ring_sparring` place stands inside the pit rect; a booked spar's fighter walks to it; ring IQ gain
on the taped ring = 0.75 x the pro ring's (same fighter, same minutes). Plain arm: no pit row, ring behaviour byte-identical.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master: as_game, a new gym with a drawn training floor has NO place to spar - paste the FAIL line.
2. Stills of the gym floor only via the game's gym camera and `Godot/tools/clean_view.gd` `save_if_clean` after `CleanView.clear`
   (no Day Plan / drawer / pop-up in shot): the drawn pit empty, the pit with tape + stools, two boxers sparring in it.
3. For every still report: the tape square inside the pit outline / stools at the 4 corners / both boxers inside the tape / feet on
   the floor / which bodies (MetaHuman only).
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.

## Contract
OWNS: Godot/scripts/club_rooms/BuildMode.gd, Godot/scripts/GymClubLayout.gd, Godot/scripts/ui/BuildWindow.gd, Godot/scripts/GameSwitches.gd, Godot/tests/sparring_pit_test.gd
RED_TEST: Godot/tests/sparring_pit_test.gd -> SPARRING_PIT failures=0
REGRESSION: ring_purchase_test, build_single_piece_test, room_unlock_wire_test, item_palette_test
VISUAL: yes

## Prior research
research/LUDO_S277_BLANKSTART_VERDICT.md (taped ring), research/MGT2_STUDY_S277.md (draw the room, then its items),
research/TWOPOINT_ALIGNMENT.md (every gym item brief cites it: item slots per room), S278_DIGEST.md (training floor drawn as a
zone, single pieces), research/GDSCRIPT_TRAPS.md.

## What would a human do?
Copy the training floor's draw-a-zone path for the pit, then reuse the ring's place row for the taped ring, then walk a spar to it.

## Prefab check
Existing stool/bench props in Godot/assets/models; tape = a flat quad mesh with a white-line texture (code-built, no asset).

## The one trap
GameState.gd (21k lines) and GymHall3D.gd are never read whole - grep + `sed -n` windows. Do not touch `_drop_unowned_ring`'s
plain-arm behaviour: an old career (no club_ring_owned key) must stay byte-identical.

## Output
PR from cursor/issue-<n> with `RESULT: tests/sparring_pit_test.gd -> SPARRING_PIT failures=0` (both arms) and the regression lines.

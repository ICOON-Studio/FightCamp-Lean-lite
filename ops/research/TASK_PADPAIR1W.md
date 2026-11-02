# TASK PADPAIR1W - wire the paired pad round on the gym floor (Cursor, S244)

Discipline: BOXING (demo). Model: Cursor's default. Parent: TASK_PADPAIR1.md (Ludo r105 PART A, LOOP1, operator Q-S237-1 "the loop,
animations, workout, feeling of progression"). The two clips exist on master (Claude, Cascadeur, S244):
`res://assets/anim/metahuman/mh_pads_fighter_loop.glb` + `mh_pads_coach_loop.glb` - 240 frames @ 30 fps (8.0 s), loop, one shared
world frame: COACH facing +Z, FIGHTER 1.15 m in front of him facing the coach. Contact gate already green on the GAME's playback
(Godot/tools/padpair_contact_probe.gd: glove front to mitt <= 4 cm at frames 24/42/66/96/134/144/172, bodies >= 0.8 m apart).

## What the game does today (route traced S244)
- Fighter at the pads station: `GymHall3D.gd` ~line 3765 `play_work_clip(node_now, WORK_CLIPS["pads"])` (TrainingFloor3D.gd line 70,
  the solo GYMLIFE Four_Punch_Combo) then `_work_clip_pace()` (line ~2095: speed_scale = meter speed x skill_clip_speed()).
- Coach arrival: `_coach_arrive_effects(place_id)` (line ~3609) faces him to the fighter and plays `coach_work_clip(kind)` -
  `COACH_WORK_CLIPS` is EMPTY (line ~3637), so today he idles beside the fighter.
- THE TRAP: `play_work_clip` -> `_clip_animation` sends a .glb through the Mixamo retarget name map. These two clips are NATIVE
  MetaHuman takes: load them ONLY with `FightClipNativeMH.load_animation(path, skeleton)` (scripts/FightClipNativeMH.gd line 23 - the
  route the contact probe used; it keeps each body's rest offsets) and put the returned Animation in the "floor" library as "work".

## Build (switch `pad_pair` in `GameSwitches.GAME_ON`, operator S221 - plain --script tests are the OFF arm)
1. When the coach ARRIVES at a `pads` station where the fighter is working (`place_id == _place`), with `GameSwitches.on("pad_pair")`:
   - stand the fighter on the station's work point facing the coach and the coach 1.15 m in front of him facing back (use the
     work point and the approach direction already in the place row; never inside another solid zone);
   - load the fighter clip onto the fighter's skeleton and the coach clip onto the coach's skeleton via
     FightClipNativeMH.load_animation, LOOP_LINEAR, start BOTH on the same frame (seek both to 0, play);
   - every frame (GymHall3D _process), if |coach position - fighter position| > 0.016 s, `seek` the coach to the fighter's
     position (Ludo r105 A3: one clock drives both);
   - speed: `_work_clip_pace()` sets the SAME speed_scale on both players (better hands = a faster round, Ludo A4).
2. Coach leaves / fighter leaves the pads / switch off -> the old behaviour exactly (solo pads clip, coach idle).
3. Keep it out of GymHall3D's 4,700 lines where you can: a small helper `scripts/club_look/PadPair.gd` (static: place the pair,
   load both, sync) called from the two hooks above.

## Test `Godot/tests/pad_pair_wire_test.gd` (red on master first - paste it), pass line `PAD_PAIR_WIRE failures=0`
Two DIFFERENT boxers' rows are not needed here (one fighter + the coach), but print the fighter's id/stats POPULATION line.
- ON: build GymClub3D as tests/iso_wall_rotation_test.gd does (career gym4_club/gym3d_main/gym_floor_view), put the fighter on `pads`,
  bring the coach there (the same calls the game uses: queue/walk -> `_coach_arrive`), then process ~2 s:
  coach-fighter distance 1.15 +/- 0.05 m; they face each other (forward dot < -0.95); both AnimationPlayers on "floor/work" whose
  animation has meta `native_mh_clip`; |coach.current_animation_position - fighter's| <= 0.016 s; a pace change (set
  skill/meter so _work_clip_pace changes) gives both the same speed_scale.
- OFF arm (plain --script, switch off): the fighter keeps WORK_CLIPS["pads"], the coach does not play a pads clip.
- Gates: parse gate on touched files; `python Godot/tools/run_tests.py --only gym_hall,gym_club,coach,pads --jobs 2` unchanged or
  better vs master (paste both SUITE lines). PR body: `RESULT: tests/pad_pair_wire_test.gd -> PAD_PAIR_WIRE failures=0`.
Cursor cannot see images: report positions/yaws/clip names/animation positions from the test. Claude takes the game-camera stills
(visual gate) and the operator closes it.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <coach idles beside the fighter at the pads, no mitts held>.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.

## Prior research
research/TWOPOINT_ALIGNMENT.md (operator S244: every agent aligned with Two Point Museum perspective + per-room items).
TASK_PADPAIR1.md (design, Ludo r105 A1-A4), S238_DIGEST.md (Ludo web coach takes were T-pose swings), topics/paired_holds.md,
FightClipNativeMH.gd (OFFBAKE1 native route).

## What would a human do?
Put the coach where a real pad man stands - one long step in front, square to his fighter - and run both men off one clock so every
punch lands on the mitt, round after round.

## Prefab check
No pad-holder clip exists in Mixamo/CMU/ActorCore (TASK_PADPAIR1 prefab check) - the clips are ours; the wiring is Godot built-ins.

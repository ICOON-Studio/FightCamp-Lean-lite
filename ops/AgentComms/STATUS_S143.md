# FightCamp status - S143, 2026-10-02 13:50 (demo 10-06, 4 days)

Sources read this session: nightly `AgentComms/nightly/latest.txt` (2026-10-02 @86c8150f: 496 tests, 19 red),
S141/S142 digests, U210 digest, `certified_moves.json`, the C240b video frames, live process list, grep of the tests.

## 1. Why the video you watched was broken (c240b_live_room.mp4, opened frame by frame)
Not one bug - four separate things, all still true on master:
1. **Old bodies.** Both men are the MPFB generator men. The MetaHuman pilot (MH1) was only ever wired into a pilot
   tool - `MetaHumanRig` is used by NOTHING in the game. MH2 (the swap) was queued for 2 sessions with no seat.
2. **Gloves.** Red ball + cylinder (procedural). The asset replacement C241 never ran: its relaunch at 12:25 spawned no
   Codex process (the "pid" was Codex's desktop app). Relaunched 13:36 - now verified running.
3. **Sliding.** Feet stay planted while the room moves the body (p95 planted-foot speed 2.6 m/s). U210's planner cut
   total slide 22% but not the fast skates. Its own finding: the skates are mostly NOT in footwork - they are in
   strikes/joins/placement catch-up, which nobody has measured by cause.
4. **Bodies merging** (chest-to-chest, heads inside each other in the clinch frames). That video was the C240b clinch
   branch, PARKED - not on master. Plus 3 moves still clip (one-two, rear hook, shovel hook: 9-11 cm).

## 2. Are the animation clips fixed?
Partly. 23 of 26 certified moves pass the clipping gate (S142 live re-run; the board's "FAIL 0%" was stale).
Still open: the 3 clipping moves (fixing now), choppy hand pops (CHOP3), sliding (above).

## 3. Boxing palette - what is missing
CERTIFIED (in the demo): 22 punches/combos + slip, pull, catch + the guard idle = 26.
- 2 certified moves still fail the clipping gate: one-two, rear hook -> Q213B (running).
- Withheld by you: inside uppercut ("this video is terrible").
- Punches not certified: shovel hook, check-hook pivot; combos: jab body-head, counter combination.
- Defence not built/certified: shoulder roll, parry, elbow block, roll, bob & weave, long guard, forearm frame,
  shoulder bump, clinch tie-up (clinch engine merged; room part parked).
- Footwork (9, shown as locomotion, not certified): pivot, step in/out, circle lead/rear, angle step, pivot out,
  switch stance, drawing, rhythm change (+ feint, which the room deliberately does not show).
About 24 visible moves remain beyond today's 26.

## 4. Rooms
- Gym rooms DONE: office, locker, lobby, mat room, staff, physio, training floor + 3 bright passes (S105-S141).
- Film room: designed (K47 spec + concepts), NOT built (backlog).
- Venues: 3 regional DONE (Q230, merged S141). National/international (4 venues: Limehouse Bowl, Northlight,
  Cut Glass, Quarry) ~835 lines written but NEVER committed - Qwen ran out of quota mid-task (resets 10-08).
  Concepts for 6 more venues at Maria (M39).

## 5. Mechanics still not gated
12 switches are ON in the game with NO test that names them (each was justified once by a probe, nothing in the
suite goes red if they break): angle_guard, face_drawn_foe, hold_pair_geometry, reface_in_takes, warp_on_line,
sequence_steps, contact_push_on_line, contact_push_carry, root_accel_cap, hand_contact_sync, shuffle_from_bell,
hands_smooth_in_whole. -> G158 (Grok) writes one failing-capable test per switch.
Gated but RED in last night's suite (19): incl. body overlap, ring position, footwork economy, reachability (neck
capsule), 3 hangs (readable onset, stage realism, gloves both corners).

## 6. Running now (all verified by live process, not launcher pid)
| Agent | Task | Gives you |
|---|---|---|
| Codex | C241 | real glove mesh |
| Codex | Q213B | one-two / rear hook / shovel hook stop clipping |
| Codex | MH2 | 4 different MetaHuman boxers in the fight, behind a switch, + C223 re-check |
| Cursor | U211 | sliding split by cause, the biggest cause fixed |
| Grok | G158 | tests for the 12 ungated switches |

The video you asked for (everything on, new models, new gloves, footwork fix) is recorded when C241 + MH2 + U211
land and pass - not before, because today it would show the same four defects.

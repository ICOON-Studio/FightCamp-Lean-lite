# FOOTWORK CONTRACT S274 - how the bout asks for steps (Claude, FOOTWORK_PLAN_S273 step 2)

Status: DESIGN, not wired. Pieces on master: `rules/StepPicker.gd` (295b4965), `rules/StepIntent.gd` (dd77a3a7); in flight:
`rules/FootContacts.gd` (Arena FOOTCONTACTS1), the step library (Ziva ZIVAGUARD1 part 2, Rokoko FightingIdle only until
board Q-S273-1). Operator rule S274: fight motion from Rokoko + ActionForge only.

## Today (read S274, primary source)
- The sim moves each man continuously. `FightWorldLiveScreen._record_track` samples `FightRealtime.position_of` per tick;
  `_read_track` (~3634) sets `_shown` at the picture's clock; `_place_bodies` (~3989) -> `_write_gap_positions` writes each
  body node's position EVERY frame (centre of `_shown` a/b + the room's gap + strike warps + stance offset), then
  `_rope_clamp_pair`. The body therefore GLIDES.
- Under the glide, `FightStagePlayer._advance_human_shuffle` (~4882) runs HUMAN2 (`FightFootLock.push_pull`): it plants and
  swings the feet procedurally from the root's travel. S273 fixed its stance band for Rokoko takes; skate stays 13-15 %.

## The contract (what changes, in order)
1. ROOM SIDE (FightWorldLiveScreen, one new per-man state `_step[side]`):
   - Each frame the room still computes the GOAL position exactly as today (`_write_gap_positions` math) but writes it
     to `_goal[side]`, not to the node, when the man is standing, not in a pair/grapple/whole strike, and boxing.
   - If no step plays and |goal - node| (flat) > 0.12 m or the bearing to the foe > 20 deg: build the StepIntent state
     {gap_m: centre distance, want_gap_m: goal gap (the engine's own `_gap`), bearing_deg, edge_m (ring half - |node| along
     -facing), stance, beat: per-man counter} -> `StepIntent.next` -> `StepPicker.pick(library, intent)`.
   - Play the picked clip on that man's player (new `FightStagePlayer.play_step(id, picked)`, a whole take: HUMAN2 writes
     nothing during it - the existing `whole_active()` gate). The node moves along `StepPicker.warp()` over the clip's
     length following the clip's own root curve (not linear); the facing turns by `turn_extra_deg` over the same time.
   - When the clip ends: slide `StepPicker.residual()` over 0.10 s (visible, counted by a new probe column), then the next
     intent. A strike or reaction interrupts a step only after its first plant (FootContacts) - never mid-air.
2. PLAYER SIDE: `play_step` = the step clip with root XZ kept (not `hold_root_xz`), foot lock ONLY on the clip's own
   `FootContacts.plants` frames (no invented plants), released on the take's lift.
3. LIBRARY: `assets/anim/rokoko_combat/step_library.json` (Ziva) - `[{id, take, start_s, end_s, move: [x, y], turn_deg,
   length_s, kind}]`, loaded once by the room (pure data -> StepPicker library entries with `move` as Vector2).
4. SWITCH: `captured_steps` in GameSwitches.GAME_ON (operator S221 rule); OFF = today's glide + HUMAN2 (the control arm).

## Acceptance (measured, red first on today's glide)
- tools/fight_motion_probe.gd as_game 20 s bout: planted_skate < 5 % (13-15 % now); new columns: share of root travel that
  came from step clips (>= 80 %), residual slide per step (median < 0.05 m).
- Stance stays 0.80-1.15 x the guard spread on >= 95 % of frames; no frame with both feet airborne > 3 frames.
- tools/fight_studio_render.gd 20 s fighters-only beside rk_FightingIdle - the operator's eye closes it.

## Owners
Room + player wiring: one seat that can run Godot (Cursor or Ziva, after ZIVAGUARD1) with this contract as the brief;
Claude collects. Pure modules: Arena (done/in flight). Library: Ziva.

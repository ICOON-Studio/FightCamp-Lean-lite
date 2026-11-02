# TASK C240 - too close = a clinch: boxing tie-up, referee break, step back; no bodies inside each other (3D + engine, Codex)
Model: gpt-6-astra, medium (3D). Owner: Codex (animation seat; NEXT after C232). Worktree E:/FightCamp/wt/C240,
branch codex/c240-boxing-clinch (from master).
Operator 2026-10-02 (S139), verbatim, on the C237 live video ("Still wrong: the bodies overlap in close exchanges"):
"keep working on this and maybe put a threshold when the distance is too close to clinch ?"

## The problem (primary sources)
- C237 live video (`previews/c237/live.mp4`, master after S139) at ~5.0-5.6 s and ~17.8-18.4 s: the two
  bodies merge - torsos and arms inside each other - in close exchanges. C223's production gate rejects every reaction
  row for `body_overlap` (C237_DIGEST.md "Production measurements").
- The engine already has a clinch (R92, `FightRealtime.gd` ~line 905: `CLINCH_ENGAGE_BASE` 0.0020 per decision tick,
  `_grapple_clinch` ~6175, seats via `_move_seat(... "clinch" ...)` ~6147, stance "clinch" ~2985/3028) - ruleset-gated
  and RARE for boxing; nothing ties it to DISTANCE, and the boxing room has no clinch film (S137 wiring audit section F:
  "Q175 clinch" acquired, never bound).
- Real boxing: when two men are chest to chest, one ties up (overhooks / head on the shoulder), the referee calls BREAK
  within ~2-5 s, both step back to range. That is what a viewer expects instead of interpenetration.

## Build
1. ENGINE: NOT YOURS - TASK_Q233 (Qwen) builds the clinch in FightRealtime.gd per research/S139_CLINCH_DESIGN.md
   (operator S139: "do a proper intergration of the clinch, who initates it, why , what are the penalties etc"). You
   CONSUME its log events: `hold_engage` {holder, cause}, `hold_break` {by: referee|free}, `foul_on_break` {side}. Until
   Q233 lands, drive your room work from a scripted fixture emitting those events (same shape).
2. ROOM: a boxing clinch hold as a PAIRED pose/loop (both bodies, arms over/under, heads beside each other, chests
   touching - surfaces touching, not overlapping: the contact solver `FightPoseSolver.gd` and the G147 clipping gate
   thresholds head > 1 cm / 1 frame, torso > 2 cm / 3 frames). Author it in Blender 5.2.1 headless
   (`C:/Tools/Blender/blender-5.2.1-windows-x64/blender.exe`) from our generator rig, or bind the Q175 clinch source
   if it measures clean. Entry blend from guard, the break = both step back (reuse locomotion/step clips).
3. A small referee cue is optional (no referee model in the boxing room today): a "BREAK" call on screen is enough.

## Acceptance (measured, before/after on the SAME seeds, two DIFFERENT fighters, the booked population)
- Live-room overlap census over >= 10 seeded boxing bouts, as_game: share of frames with torso interpenetration > 2 cm
  for >= 3 frames, and head > 1 cm for >= 1 frame (G147) - BEFORE vs AFTER; AFTER must be lower by at least half.
- Clinch rate per round inside a real-boxing band you cite (prior research first; if none, report it and propose one).
- KO+TKO 40-55% and thrown 45-56 per man-round stay inside their bands (q212 booked census, both arms - see
  TASK_Q226 SEND-BACK 1 for the command).
- A 30 s LIVE-ROOM video (game camera, >= 1280x720, silent, both men active) showing at least one tie-up and break.
  Operator approval of that video is the merge bar (S138 rule).

## Owned files
`Godot/scripts/FightClipBinding.gd` + `FightStagePlayer.gd` (the clinch hold binding/playback only),
`Godot/assets/anim/c223/c240/*`, `Tools/blender_moves/c240_*`, `Godot/tests/c240_boxing_clinch_test.gd`,
`Godot/tools/c240_overlap_census.gd`, `previews/c240/*`, `research/C240_DIGEST.md`.

## Prior research
`python Tools/prior_research.py clinch boxing break referee overlap`: R92 (the clinch), G34, G138 (clinch share),
G147 (clipping gate), Q175 (clinch source), S133 CHOP1 (the contact push), C237_DIGEST.md.

## What would a human do?
A sports-game animator + gameplay programmer: a proximity trigger into a paired clinch state with a timed referee
break, a hand-authored paired hold, and an overlap counter on the broadcast camera before/after.

## Prefab check
Our own paired mocap on disk (CMU 18/19_05 is grappling-adjacent, Harmony4D), Q175 clinch, RamsterZ H2H clips -
check each for a boxing tie-up before authoring; no purchases.

## Test (tier: engine + runtime scripts edited)
Parse gate on every touched .gd; the new test (trigger fires under the threshold, never above it; MMA/kickboxing
unchanged = control arm; break returns both to range); `python Godot/tools/run_tests.py --jobs 2 --only fight_realtime,fight_clip,fight_stage,clip_binding,boxing_output`.
Watchdog GREEN before each heavy run (if RED wait 2 min and re-check; never kill a process you did not start).
Godot windowed only via Tools\godot_hidden.ps1; LOOK at frames with your file tool only - never open a viewer or app.

## The one trap
The gap the ROOM shows is not the engine's gap (S133: placement, contact push) - trigger on the engine's own distance
and VERIFY the overlap on the room's posed bones, or the census reads a quantity the viewer never sees.

## Finish
git add by explicit path, commit, git push -u origin codex/c240-boxing-clinch. Never edit HANDOFF.md. Do not stop at written.

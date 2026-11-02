# TASK_U145 - measure every clip transition bone by bone (Cursor, second instance)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S60, 2026-09-23.
Runs IN PARALLEL with ARENA_ART (a different worktree, different files).

## Why
Operator: *"can you make the animation smother it is very abrapt, is because of low fps?"*
Clips switch every beat with short crossfades (`FightStagePlayer.gd:270-276`):
reaction 0.05 s, knockdown 0.0 s, strike 0.10 s, back-to-stance 0.20 s, get-up 0.10 s.
The R120 note above `playback_default_blend_time` (:148-:183) says it plainly: *"0.10 s ITSELF
IS NOT VISUALLY CONFIRMED ... Settling it needs a bone-level sample across a transition at frame
rate - whether a joint TRAVERSES intermediate angles or jumps - which is the honest next
instrument."* That instrument is this task. **Measure; do NOT change the blend constants** -
the tuning is decided after the operator sees the numbers and a clip.

## Owned files
- `Godot/tools/u145_transition_probe.gd` (NEW), `research/U145_DIGEST.md` (NEW),
  `previews/transitions/` (NEW). No script under `Godot/scripts/` is edited.

## Spec
1. Drive the live room (`res://scenes/FightWorldLive.tscn`; configure BEFORE add_child, check the
   return - see `tools/record_room.gd:40-110`) through one round at a FIXED 60 Hz, calling
   `_process(1/60)` yourself. Population: the room's own pairs - boxing (f01 out-boxer vs f09
   pressure puncher) and MMA (f05 vs f06); name them and the seed in the output.
2. Each frame record, for both men, world rotation of: Hips, Spine, Chest, Neck, Head, both
   UpperArm/LowerArm/Hand, both UpperLeg/LowerLeg/Foot. Record which clip each body is playing
   and when it changes (a TRANSITION), with its kind (`FightStagePlayer.blend_into(role)` tells you
   the class: strike / reaction / knockdown / back-to-stance).
3. Per frame per bone: angular speed (deg/frame). Per transition: the max over the transition
   window [t-0.05 s, t+0.25 s] divided by the p95 of that bone's speed INSIDE clips (not at joins)
   = the POP RATIO. > 3 is a visible pop (JUDGEMENT; print the distribution so it can be re-cut).
4. Report per transition kind: count, median and p90 pop ratio, worst bone, worst example (clip A
   -> clip B, time, seed). Also report the frame-time budget: if a 30 fps render were used, how
   many transitions fall entirely between two rendered frames (answers "is it low fps?").
5. A/B arms, same seed (the one legitimate same-seed comparison): (a) today's constants;
   (b) all blends x2; (c) the existing inertialization mode (`FightStagePlayer.set_inertialize`,
   grep `_inertialize`). For each arm also measure whether the STRIKE still reaches its readable
   peak: the thrower's lead/rear Hand distance from his Chest at the clip's `readable_s` must be
   within 5% of the clip's own peak - a longer blend that eats the punch is a regression.
6. Stills: the worst pop in each kind, three frames (before / at / after) side by side, into
   `docs/previews/transitions/`. OPEN them.

## TRAP - READ THIS
**Headless `Skeleton3D.get_bone_global_pose()` returns the REST pose** on this project (memory:
"Godot skeleton pose traps"). Run the probe WINDOWED (`--position -3000,-3000`), or prove on the
first frames that the recorded Head rotation actually changes during a jab. A probe that records
rest poses reports zero pops everywhere and looks like a clean bill of health.

## Gate (tier: a new tool only, no script edited)
- Parse gate on the tool. Run it (windowed). No test suite run is needed.
- Push branch `cursor/u145-transition-probe`, digest with the three-arm table, then
  `python Tools/agent_comms.py send --from cursor --to claude --task U145 --body "..."`. Do NOT edit HANDOFF.md.

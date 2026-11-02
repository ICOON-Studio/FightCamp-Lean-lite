# TASK Q84 — QWEN — WHAT GODOT 4.7.2 ACTUALLY DOES DURING A BLEND

Model: qwen3-coder, **medium**, `--yolo`. Owner: qwen. Branch `qwen/q84-blend-probe` in your worktree.
Stage: S4a step (d) forecast (brief: `research/R141_WHY_THE_CLIPS_LOOK_BAD.md`).

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate, run, gate script.

## Owned files

- `Godot/tools/probe_blend.gd` — **NEW, yours.**
- `research/Q84_HOW_GODOT_BLENDS.md` — **NEW, yours.**
- `research/Q84_blend_probe.json` — **NEW, yours.**

Do NOT edit any other file. `Q84_check.py` is Claude's.

## Why this exists

The operator watched our fighters and said the joins between clips must feel like a real fight. The
S4a build will change how `FightStagePlayer.gd` hands one clip to the next: a strike must finish back
in guard, then blend 0.20-0.25 s into stance, and a blend should be longer when the two poses differ.
Today every clip is started with `AnimationPlayer.play(name)` and a uniform
`playback_default_blend_time = 0.10` (`Godot/scripts/FightStagePlayer.gd:137`, `:205`, `:264`).

**Before that code is written we need to KNOW what the engine does, not guess it.** In particular,
beats arrive fast, so a second `play()` often lands while the first blend is still running - if that
snaps, every fix above is undone on screen.

## The questions - each answered TWICE: from the engine source AND by a measurement

1. **Weight curve.** During `play(B, custom_blend = 0.25)` from A, how does B's weight rise - linear in
   time? Is the per-bone rotation a slerp, an nlerp, or something else?
2. **Does the OUTGOING clip keep advancing** during the blend, or is it frozen at the moment of the call?
3. **A second `play(C, 0.25)` mid-blend** (at 0.10 s into the A->B blend): does the pose SNAP? Does C
   blend from the mixed A+B pose, or does A drop out at once?
4. **`seek(t, true)` immediately after `play(B, 0.25)`** (what `FightStagePlayer.gd:270` does for a loop
   phase): does that snap or blend?
5. **`speed_scale`** (we set 0.85-1.15 per clip, `FightStagePlayer.gd:263`): does it stretch the blend?
6. **Capture blending.** Do `AnimationPlayer.play_with_capture(...)` and `playback_auto_capture` apply
   to Skeleton3D bone ROTATION tracks (`Animation.TYPE_ROTATION_3D`) or only to value tracks? If they
   apply, what curve and duration do they use?
7. **Inertialization.** Does anything in 4.7.2 (`AnimationMixer`, `AnimationTree`,
   `AnimationNodeTransition`) implement inertialization? Answer from the source: yes with path:line, or
   "not present" after naming the files you searched.

**SOURCE**: the engine source at the exact tag `4.7.2-stable`
(`https://raw.githubusercontent.com/godotengine/godot/4.7.2-stable/scene/animation/animation_player.cpp`
and its siblings in `scene/animation/`). Cite `path:line` for every claim, as you did in Q82.

**MEASUREMENT**: `probe_blend.gd`, a headless `extends SceneTree` script. Build it from nothing - no
fighter, no FBX: a `Skeleton3D` with ONE bone under a `Node3D` added to the tree, an `AnimationPlayer`,
and small synthetic `Animation`s, each with ONE `TYPE_ROTATION_3D` track on that bone, rotation about Y:
- `P60` held at +60 deg for 2 s; `M60` held at -60 deg; `Z0` held at 0 deg; `H15` held at +15 deg;
- `RAMP`: +0 deg at t=0 rising linearly to +90 deg at t=1.0 (two keys, no loop).

Step time ONLY with `AnimationPlayer.advance(1.0 / 60.0)` - never frames or timers - and after every
step record the bone's LOCAL rotation angle about Y (signed, degrees) from
`skeleton.get_bone_pose_rotation(0)`; a headless run updates the local pose, not `get_bone_global_pose`.
Every series is `[[t_s, angle_deg], ...]` with `t = 0` at the call being studied, starting with ONE
sample taken just before the call, and running at least 0.6 s after it. The five scenarios - designed so
the series decides the answer by itself:

| key | set-up | what decides it |
| --- | --- | --- |
| `q1_weight_curve` | play `P60`, advance 0.5 s, then `play("M60", 0.25)` | when the angle reaches -60, and where it sits at 0.125 s |
| `q2_outgoing_moving` | play `RAMP`, advance to exactly 1/6 s (+15 deg), then `play("H15", 0.25)` | a frozen RAMP keeps the angle at +15 throughout; an advancing one lifts it above +15 mid-blend |
| `q3_second_play_mid` | as q1, then at +0.10 s `play("Z0", 0.25)` | the largest one-step jump in the 3 steps after the second call, against the largest step before it |
| `q4_seek_after_play` | play `P60`, advance 0.5 s, `play("RAMP", 0.25)` then at once `seek(0.5, true)` | the first sample after the seek: still near +60 (blending) or at once near +45 (snapped) |
| `q5_speed_scale` | as q1 but `speed_scale = 0.5` set before the call | when the angle reaches -60: 0.25 s or 0.5 s |

If capture blending applies to bone rotation tracks (question 6), add `q6_capture` with your own set-up
and describe it in the markdown.

JSON:

```json
{
  "godot_version": "4.7.2.stable...",
  "step_s": 0.016667,
  "scenarios": {
    "q1_weight_curve":    {"blend_s": 0.25, "series": [[-0.016667, 60.0], [0.0, 60.0], [0.016667, 52.0]]},
    "q2_outgoing_moving": {"blend_s": 0.25, "series": []},
    "q3_second_play_mid": {"blend_s": 0.25, "second_call_at_s": 0.10, "series": []},
    "q4_seek_after_play": {"blend_s": 0.25, "seek_to_s": 0.5, "series": []},
    "q5_speed_scale":     {"blend_s": 0.25, "speed_scale": 0.5, "series": []}
  },
  "answers": {
    "q1": {"answer": "one plain sentence", "source": ["scene/animation/animation_mixer.cpp:1234"],
           "measured": "the numbers from the series", "claim": {"linear_weight": true, "completes_at_s": 0.25}},
    "q2": {"claim": {"outgoing_advances": true}},
    "q3": {"claim": {"snaps": false}},
    "q4": {"claim": {"snaps": false}},
    "q5": {"claim": {"blend_scaled_by_speed": false}},
    "q6": {"claim": {"applies_to_bone_rotation": false}},
    "q7": {"claim": {"inertialization_present": false}}
  }
}
```

Every answer carries `answer`, `source` (at least one `path:line`), `measured` and `claim`. The values
above are placeholders, not the expected answers.

The markdown opens with **DECISIONS**: one line per question - the answer, the source line, the
measured number - then **WHAT THIS MEANS FOR FightStagePlayer**: which of these the S4a transitions
must work around, and how.

## Gate — in this order

1. `python Godot/tools/check_scripts.py Godot/tools/probe_blend.gd`
2. `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/probe_blend.gd`
   from your worktree root (the exe is in `%LOCALAPPDATA%\Programs\Godot\`). It must finish in seconds.
3. `python research/Q84_check.py` — must exit 0 before you commit.

## The trap specific to this task

**Check your stated rationale against your own numbers.** Your Q83 wrote a formula that contradicted
its own stated cause, and both sat in the same file. Here the gate reads your series and compares them
with your sentences: if `q2` says the outgoing clip freezes, the series must show a frozen A component;
if `q1` says linear, the angle at mid-blend must sit where a linear weight puts it. Write the answer
FROM the series, never before it.

## When you are done

Commit the three owned files by path on `qwen/q84-blend-probe`, `git show --stat HEAD` (exactly three),
push THE BRANCH (`git push origin qwen/q84-blend-probe`), never checkout, merge or rebase master. Then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q84 --body "<one line>"` and commit
that mail file by path on the branch and push again. Do NOT edit `HANDOFF.md`.

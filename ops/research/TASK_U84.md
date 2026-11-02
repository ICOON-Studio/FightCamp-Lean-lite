# TASK U84 — CURSOR — HOW FAST EACH WALK CLIP ACTUALLY WALKS

Model: `composer-2.5`, **medium**, `-p --force --trust`. Owner: cursor. Branch `cursor/u84-stride-speed`
in your worktree. Stage: S4a (realism spec: "speed each walk clip to the engine's real speed so the feet
plant"). Follows your U83.

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate, run, gate script.

## Owned files

- `Godot/tools/measure_stride_speed.gd` — **NEW, yours.**
- `research/U84_STRIDE_SPEED.md` — **NEW, yours.**
- `research/U84_stride_speed.json` — **NEW, yours.**

Do NOT edit any other file. `U84_check.py` is Claude's.

## Why this exists

Our fighters walk with in-place clips (`loc_advance` = `H2H_WalkForward.FBX`, `loc_retreat` =
`H2H_WalkBack.FBX`, bound in `Godot/scripts/FightClipBinding.gd`) while the room slides the bodies. A
planted foot only stays planted when the clip is played at `engine speed / the clip's own walking speed`.
**Nobody knows the clips' own walking speed**: C94's travel column read a horizontal axis as height and is
void. Your U83 settled how these files are built - the pelvis track carries height only and the ROOT
carries horizontal travel - so this is now measurable.

## The method (reuse your U83 tool's loading and composition)

Population: every `H2H_Walk*.FBX` in `res://assets/anim/audition/ramsterz_h2h/` - the in-place clips
(`H2H_WalkForward`, `WalkBack`, `WalkLeft`, `WalkRight`, `WalkForwardLeft`, `WalkForwardRight`,
`WalkBackLeft`, `WalkBackRight`) and each one's `_RootMotion.fbx` twin where it exists. Sample each
whole clip at 60 fps.

Per clip, per frame: world (tree-composed) positions of `root`, `pelvis`, `ball_l`, `ball_r`, `foot_l`,
`foot_r`. Then:

1. **Root travel** over one cycle: net horizontal displacement of `root` (vector and length), and its
   direction in degrees on the floor plane (0 = the rig's forward).
2. **Planted-foot sweep.** A foot is PLANTED on a frame when its `ball` is within 3 cm of that clip's
   lowest `ball` height AND its horizontal speed relative to the pelvis is the lower of the two feet. For
   each planted span: its duration and the horizontal distance the `ball` moves RELATIVE TO THE PELVIS.
   The sweep speed = distance / duration.
3. **Native speed**: for a `_RootMotion` twin, root travel / clip length; for an in-place clip, the mean
   planted-foot sweep speed.
4. **World skate** of the planted foot in the `_RootMotion` twin (horizontal world speed of the planted
   `ball`) - a correctly authored root-motion walk skates near zero, so this is the check on step 2's
   definition.
5. **Steps**: the number of planted spans per cycle and the step length (root travel per step).

JSON:

```json
{
  "population": {"folder": "res://assets/anim/audition/ramsterz_h2h/", "fps": 60},
  "clips": [{"file": "H2H_WalkForward.FBX", "twin": "H2H_WalkForward_RootMotion.fbx", "length_s": 1.0,
             "root_travel_m": 0.0, "root_direction_deg": 0.0, "planted_spans": 2,
             "sweep_speed_mps": 0.0, "native_speed_mps": 0.0, "step_length_m": 0.0,
             "twin_root_travel_m": 0.0, "twin_native_speed_mps": 0.0, "twin_planted_skate_mps": 0.0}],
  "bound": {"loc_advance": {"native_speed_mps": 0.0}, "loc_retreat": {"native_speed_mps": 0.0}}
}
```

The markdown opens with **DECISIONS**: each clip's native speed and direction, whether the in-place sweep
agrees with its twin's travel, the two BOUND clips' playback rate at the real mean ring speed of **0.6 m/s**
(Thomson, as cited in `research/M18_THE_FOOTWORK.md`) and at **0.3 m/s** (each man's share when both
move), and one line on what that rate would do to how the step LOOKS.

## Gate — in this order

1. `python Godot/tools/check_scripts.py Godot/tools/measure_stride_speed.gd`
2. From your worktree root, output redirected to a log file, never piped:
   `C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_stride_speed.gd`
3. `python research/U84_check.py` — must exit 0 before you commit.

## The trap specific to this task

**An in-place clip and its root-motion twin must tell the same story.** If the sweep speed of
`H2H_WalkForward.FBX` and the travel speed of `H2H_WalkForward_RootMotion.fbx` disagree by more than 15%,
one of the two definitions is wrong - the gate fails on it, and you fix the definition rather than the
threshold. And bound it by reality: a boxing step is 0.2-0.8 m, a walking cycle has two planted spans, and
a speed outside 0.2-2.0 m/s is not a walk.

## When you are done

Commit the three owned files by path on `cursor/u84-stride-speed`, `git show --stat HEAD` (exactly three),
push THE BRANCH; never checkout, merge or rebase master. Then
`python Tools/agent_comms.py send --from cursor --to claude --topic U84 --body "<one line>"`, commit that
mail file by path on the branch, push again. Do NOT edit `HANDOFF.md`.

## SEND-BACK 1 (Claude, 2026-09-13) - `9e03477` passed the gate and three fields are wrong

The native speeds stand - the in-place sweep and the twin's travel agree within 5-8% on all eight clips,
two methods on one number. Three fields do not, and `U84_check.py` now fails on each:

1. **`root_direction_deg` is 0.0 for all eight clips**, WalkBack and WalkLeft included. Measure it from the
   `_RootMotion` twin's root displacement on the floor plane; the gate compares it with the clip's name.
2. **`step_length_m` is not the travel per step.** WalkBack: 0.460 m x 2 spans = 0.92 m against a twin
   travel of 1.832 m. Count EVERY planted span of either foot in the clip - no "top-2" selection - and set
   `step_length_m = twin_root_travel_m / planted_spans`. Add `cadence_steps_per_s = planted_spans / length_s`.
3. **My own bound was invented.** The task said "a boxing step is 0.2-0.8 m"; K29 found step length NOT FOUND
   in any bout study. It is removed. Report the step and the cadence as numbers with that label.

Re-run the tool after the fix - do not edit the JSON by hand. New commit on the same branch, push it,
send the one-line mail.

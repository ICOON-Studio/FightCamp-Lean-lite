# TASK Q86 — QWEN — WHICH OWNED CLIPS ARE A FIGHTING STANCE, AND DO THEY BOUNCE LIKE A BOXER

Model: qwen3-coder, **medium**, `--yolo`. Owner: qwen. Branch `qwen/q86-stance-takes` in your worktree.
Stage: S4a step (d). Follows your Q84/Q85.

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate, run, gate script.

## Owned files

- `Godot/tools/measure_stance_takes.gd` — **NEW, yours.**
- `research/Q86_STANCE_TAKES.md` — **NEW, yours.**
- `research/Q86_stance_takes.json` — **NEW, yours.**

Do NOT edit any other file. `Q86_check.py` is Claude's.

## Why this exists

S4a's realism test (`Godot/tests/fight_stage_realism_test.gd`) shows every fighter standing in ONE stance
clip (`H2H_Idle`, a 4.67 s loop) for every second of neutral, and the operator's spec says to rotate
several stance takes. Before any are bound we need to know which clips we OWN are actually a boxer's
stance - hands up, feet staggered, a seamless loop - and whether their body moves like a real one. The one
real number there is: **elite boxers make about 47-56 vertical hip oscillations per minute (men), about 63
(women)** (Davis et al., via `research/K29_THE_REAL_BOUT_MEASURED.md` - a rate, not an amplitude;
bounce amplitude in cm is NOT FOUND in any study).

## Population - these eleven files, nothing else

In `res://assets/anim/audition/`:
`ramsterz_h2h/H2H_Idle.FBX`, `ramsterz_h2h/H2H_BlockIdle.FBX`, `ramsterz_h2h/H2H_JumpIdle.FBX`,
`ramsterz_h2h/H2H_LegBlockIdle.FBX`, `ramsterz_h2h/Standing_Idle.FBX`, `magicpot_fm1/idle_A.fbx`,
`magicpot_fm1/idle_Tiramis.fbx`, `motifect/unpacked/Motifect_martial_arts_v1_0/FBX/muay_thai_guard_stance.fbx`,
`.../FBX/wrestling_guard_position.fbx`, `.../FBX/staff_spin_guard.fbx`, `.../FBX/sword_draw_stance.fbx`.

For each, also report its pack's `status` and `licence` from `Godot/assets/asset_manifest.json` (read only
that pack's entry). A clip in a pack that is not approved may still be measured; say so beside it.

## The method

Load each FBX with `FBXDocument` and compose bone positions through the scene tree exactly as
`Godot/tools/measure_pelvis_by_tree.gd` (Cursor's U83, 413 lines, read it whole) does - `seek(t, true)` then
compose each node's LOCAL transform up its parents, because a headless run does not refresh
`global_position`. The rigs differ: find pelvis, head, both hands and both feet (and toes if present) by
name pattern (`pelvis|hips`, `head`, `hand_l|LeftHand|l_hand|hand.L`, ...) and write the names you used
into the JSON. A clip whose rig you cannot map goes in `unmapped` with the reason.

At 30 fps over the whole clip:

- `pelvis_y_mean_m`, `pelvis_y_amp_m` (max - min);
- `oscillations_per_min`: the pelvis height, minus its own mean, counted in UPWARD zero crossings, divided
  by the clip length in minutes. Keep the series: `pelvis_y_series` = the height at every 30 fps sample;
- `loop_seam_deg`: the largest angle any mapped bone's LOCAL rotation differs between the first and last
  sample; `loops` = `loop_seam_deg <= 3.0`;
- `hands_below_head_m`: mean over frames of (head height - the higher wrist's height), and
  `hands_forward_m`: mean horizontal distance of the wrists in front of the chest along the pelvis facing;
- `stance_stagger_m` / `stance_width_m`: mean distance between the feet along / across the pelvis facing.

JSON:

```json
{
  "davis_reference": {"men_per_min": [47, 56], "women_per_min": 63, "label": "DOCUMENTED rate proxy (K29)"},
  "clips": [{"file": "ramsterz_h2h/H2H_Idle.FBX", "pack": "ramsterz_h2h", "pack_status": "", "pack_licence": "",
             "bones": {"pelvis": "pelvis", "head": "head", "hand_l": "hand_l", "hand_r": "hand_r", "foot_l": "foot_l", "foot_r": "foot_r"},
             "length_s": 0.0, "pelvis_y_mean_m": 0.0, "pelvis_y_amp_m": 0.0, "oscillations_per_min": 0.0,
             "pelvis_y_series": [0.0], "loop_seam_deg": 0.0, "loops": true,
             "hands_below_head_m": 0.0, "hands_forward_m": 0.0, "stance_stagger_m": 0.0, "stance_width_m": 0.0}],
  "unmapped": [{"file": "...", "reason": "..."}]
}
```

The markdown opens with **DECISIONS**: one row per clip - loops? hands up? staggered? oscillations/min
beside Davis's 47-56 - and a plain verdict: **which of these could be a boxer's stance take in rotation
with `H2H_Idle`**, and which are something else (a block, a jump, a relaxed stand, a weapon stance).

## Gate — in this order

1. `python Godot/tools/check_scripts.py Godot/tools/measure_stance_takes.gd`
2. From your worktree root, output to a log FILE (never piped):
   `C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_stance_takes.gd`
3. `python research/Q86_check.py` — must exit 0 before you commit.

## The trap specific to this task

**Your verdict must come from your numbers.** Q83 wrote a cause that its own formula contradicted. Here the
gate recomputes the oscillation rate from your `pelvis_y_series`, the loop flag from your seam angle, and
checks each number against a standing human (pelvis 0.55-1.20 m up, bounce under 20 cm, feet under 1 m
apart). If a clip's name says "Idle" and its numbers say it is not a stance, the numbers win.

## When you are done

Commit the three owned files by path on `qwen/q86-stance-takes`, `git show --stat HEAD` (exactly three),
push THE BRANCH; never checkout, merge or rebase master. Then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q86 --body "<one line>"`, commit that
mail file by path on the branch and push again. Do NOT edit `HANDOFF.md`.

## SEND-BACK 1 (Claude, 2026-09-13) - `6c1511a` passed the gate and three things are wrong

The RamsterZ verdicts stand (that rig is the one U83 validated): only `H2H_Idle` is a boxer's stance. The rest
of the delivery cannot be read, and `Q86_check.py` now fails on each defect:

1. **`unmapped` was used for clips that WERE measured.** `H2H_JumpIdle` (1.547 m "bounce") and
   `wrestling_guard_position` (pelvis 0.085 m) were mapped, measured and failed a bound - that is a finding.
   Put them back in `clips` with their numbers, add `standing` (true/false, from pelvis 0.55-1.20 m, bounce
   <= 0.20 m and `lowest_foot_y_max_m` <= 0.15 m - the highest the lower foot ever gets above y = 0) and a
   verdict. `unmapped` is only for a rig whose bones you could not find, with `bones_missing` listed. A
   1.55 m pelvis range is not a bounce: find out whether that clip is airborne (its lowest foot) or whether
   the height is composed wrongly, and say which.
2. **Every magicpot and Motifect clip reports a pelvis that NEVER moves** - amplitude 0.000 over a 10 s muay
   thai guard, while its bones rotate. No performer is that still: the translation lives on another node
   or track and was not read. Add `translation_tracks_on_chain`: every position track on the pelvis node
   and each of its ancestors (node path + key count). Compose the pelvis height through whichever carries it.
3. **Those rigs' hands sit BEHIND the chest** (hands_forward -0.12 to -0.27 m) in guard stances: the facing
   is flipped on them. Sign the facing toward the toes as C103 did, and report `toes_along_facing` (mean of
   the foot-to-toe direction along the facing, which must be positive in any stance).

Re-run the tool after the fix - never edit the JSON by hand. New commit on the same branch, push, mail.


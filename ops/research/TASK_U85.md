# TASK U85 — CURSOR — WHICH STRIKE CLIPS END BACK IN GUARD

Model: `composer-2.5`, **medium**, `-p --force --trust`. Owner: cursor. Branch `cursor/u85-guard-return`
in your worktree. Stage: S4a step (d). Follows your U83/U84.

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate, run, gate script.

## Owned files

- `Godot/tools/measure_guard_return.gd` — **NEW, yours.**
- `research/U85_GUARD_RETURN.md` — **NEW, yours.**
- `research/U85_guard_return.json` — **NEW, yours.**

Do NOT edit any other file. `U85_check.py` is Claude's.

## Why this exists

S4a's realism test (`Godot/tests/fight_stage_realism_test.gd`, rule R4) watched three seeded bouts and
found **0 of 57 punches back in guard** when the fighter moved on - the first failure a jab leaving the
screen with the hand still 0.26 of its 0.49 m extension out. A real boxer's hand comes home: on a bag,
experienced boxers retract to guard in cross 169±41 ms, hook 168±97, uppercut 171±33, jab 262±42
(Menzel & Potthast 2021, n=11 - a LAB number, not a bout). Before the presenter is changed we need to
know, per clip, **whether the clip itself ever brings the hand home** - or whether our slicing and
retargeting cut it off. Those are different fixes.

## Population

Every STRIKE role the presenter can play, from `Godot/scripts/FightClipBinding.gd`:
`punch_roles()` (jab, jab_lead, cross, cross_lead, hook_lead, hook_rear, uppercut - those bound) and
`technique_roles()` (boxing_double_jab ... kickboxing_jab_cross_lowkick), each with its bound window
(`start_s`/`end_s`) and `mirror` flag from `metadata_for(role)`. PLUS, as candidates, every whole owned
RamsterZ clip whose name is a punch: `H2H_JabInPlace`, `H2H_StraightPunchInPlace`, `H2H_HookPunch_InPlace`,
`H2H_LeadingUppercut_InPlace`, `H2H_Haymaker_InPlace`, `H2H_SnappingBackfist_InPlace`
(in `res://assets/anim/audition/ramsterz_h2h/`).

Measure each on TWO skeletons: the SOURCE rig as authored (tree-composed, your U83 method; for the
`combo_jab_cross_hook.glb` slices, the GLB's own skeleton), and the RETARGETED clip on f01
(`res://assets/models/fighters/f01_m_box_welter_rigged.glb`) exactly as `FightStagePlayer.bind` builds it
(`Godot/scripts/FightStagePlayer.gd:166-199` and `:292-347`: retargeted roles via
`FightClipRetarget.retarget_clip`, GLB roles via `FightClipSlice` / `FightClipMirror` / `BoneTrackGraft`).

## The method

Guard = each wrist's position in the CHEST bone's frame, averaged over the idle clip on the same skeleton
(source: `H2H_Idle.FBX`; f01: the retargeted `idle`). At 60 fps through each clip window, per wrist:
distance from its guard. The striking hand is the one that goes farther. Then:

- `peak_m`, `peak_s` - largest distance and when;
- `home_s` - the first time AFTER the peak the distance falls to 25% of `peak_m` or less (null if never);
- `retract_ms` = (`home_s` - `peak_s`) x 1000, null if never home;
- `end_ratio` = distance at the window's last frame / `peak_m`;
- `ends_in_guard` = `end_ratio <= 0.25`.

JSON:

```json
{
  "population": {"fps": 60, "guard": "wrist in chest frame, mean over idle", "home_fraction": 0.25},
  "clips": [{"role": "jab", "file": "combo_jab_cross_hook.glb", "start_s": 0.0, "end_s": 0.64, "mirror": false,
             "hand": "left",
             "source": {"peak_m": 0.0, "peak_s": 0.0, "home_s": 0.0, "retract_ms": 0.0, "end_ratio": 0.0, "ends_in_guard": false},
             "f01":    {"peak_m": 0.0, "peak_s": 0.0, "home_s": 0.0, "retract_ms": 0.0, "end_ratio": 0.0, "ends_in_guard": false}}],
  "candidates": [{"file": "H2H_JabInPlace.FBX", "length_s": 0.833, "hand": "left", "source": {}, "f01": {}}]
}
```

The markdown opens with **DECISIONS**: a table of every bound strike role - ends in guard on the source?
on f01? retract ms beside Menzel's LAB number for that punch type - then, for every role that does NOT end
in guard, the candidate whole clip that does (or "none owned"), and one line on whether the defect is the
PERFORMANCE (the source never comes home), the WINDOW (the source comes home after `end_s`) or the RETARGET
(the source comes home, f01 does not).

## Gate — in this order

1. `python Godot/tools/check_scripts.py Godot/tools/measure_guard_return.gd`
2. From your worktree root, output redirected to a log file, never piped:
   `C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_guard_return.gd`
3. `python research/U85_check.py` — must exit 0 before you commit.

## The trap specific to this task

**A wrist distance in the wrong frame is a number shaped like an answer.** Measured in world or skeleton
space, a boxer who leans or turns moves his "guard" with him and every punch reads as far out. Measure in
the chest frame on both skeletons, and let the idle define guard on each. The gate holds you to physics:
an extension is 0.15-0.95 m (an adult arm), a retraction cannot take longer than the clip, and your `jab`
slice on f01 must agree with what the realism test saw on screen - it left with the hand still about half
out - or the markdown must say why not.

## When you are done

Commit the three owned files by path on `cursor/u85-guard-return`, `git show --stat HEAD` (exactly three),
push THE BRANCH; never checkout, merge or rebase master. Then
`python Tools/agent_comms.py send --from cursor --to claude --topic U85 --body "<one line>"`, commit that
mail file by path on the branch, push again. Do NOT edit `HANDOFF.md`.

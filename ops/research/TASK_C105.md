# TASK C105 — CODEX — THE ONE-FRAME TOE DIP: WHERE IT COMES FROM

Model: gpt-5.6-luna, **medium** (the only Codex setting). Owner: codex. **The MAIN checkout**, branch
`master`; commit only your three files, paths on the commit line, `git show --stat HEAD` after. Stage: S4a
step (d), forecast research for the realism test's R3b.

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate, run, gate script.

## Owned files

- `Godot/tools/measure_toe_dip.gd` — **NEW, yours.**
- `research/C105_TOE_DIP.md` — **NEW, yours.**
- `research/C105_toe_dip.json` — **NEW, yours.**

Do NOT edit any other file. `research/C105_check.py` is Claude's - never edit it. Your tool must not
read any file (no `FileAccess.get_file_as_string`, no `JSON.parse`): it measures.

## Why this exists

S4a (c) (`5c17471`) put the fighters' feet on the canvas. That exposed a defect that was always there:
`tests/fight_stage_realism_test.gd` R3b (a foot cannot pass through the canvas) reads **93 of 14,652 frames
with a toe more than 0.0263 m under its rest height; deepest 0.130 m at seed 51227, fighter B, frame 924,
`hook_lead` after a finished clip.** It is a SINGLE frame: the toe drops 8-13 cm on the second frame after
the AnimationPlayer changes take, then comes straight back, and the Hips do not move - so it is leg
rotation. Switching the hip carry off leaves the same frames dipping by the same amounts (seed 51227 B f924
reads 1.150 m both ways), so it is not the carry. Most dips follow a clip that had FINISHED (held its last
frame, `is_playing()` false); some follow `loc_retreat` while it was still playing. The playback facts on
file: Q84 and Q85 (`research/Q84_*.md`, `Q85_*.md`) - linear slerp blends, the outgoing clip keeps
advancing, an outgoing clip that ends mid-blend holds its last frame. The blend is `FightStagePlayer.BLEND_S`
= 0.10 s (`Godot/scripts/FightStagePlayer.gd`, search `const BLEND_S`), applied as the player's default.

## The method - two parts

**1. The room.** Drive `res://scenes/FightWorldLive.tscn` EXACTLY as `tests/fight_stage_realism_test.gd`
`_run_bout` does (read lines 82-116 and `_sample` 153-216 whole): `configure({"seed": 51227, "rounds": 3})`,
`setup()`, then each step `live._process(1/30)` and `advance(1/30)` on both AnimationPlayers from
`stage_players()`. Compose each bone's pose by hand from `get_bone_pose` down the parent chain and the
skeleton's world transform, as `_sample` does (headless `get_bone_global_pose` returns REST). The canvas for
a man is his lower toe's `get_bone_global_rest(...).origin` carried through that world transform. A DIP frame
is one where the lower toe is more than 0.0263 m under it. For each of the first 20 dip frames record: frame,
side, current take, the take two frames earlier, whether that earlier clip had finished (`is_playing()` false
on the frame before the change), the depth, and for each of Hips, Left/Right UpperLeg, LowerLeg, Foot, Toes
the LOCAL rotation's angle from its rest rotation in degrees at f-1, f and f+1.

**2. A reproduction outside the room.** Mount ONE fighter the way `FightWorldStage.mount` and
`FightStagePlayer.bind` / `prepare` do in the room (read `FightWorldLiveScreen.gd` `setup` for the calls), take
the most common (from, to) pair among your room dips, and play: `from` to its end, hold 3 frames, then
`play_role(to)`; step 12 frames at 1/30 s, recording the lower toe's height against the canvas each frame.
Then the same with ONE change each:

| variant | the one change |
|---|---|
| `baseline` | as above |
| `previous_still_playing` | start `to` while `from` is at 60% of its length |
| `blend_0` | the player's default blend time 0.0 |
| `blend_0_20` | the player's default blend time 0.20 |
| `deterministic_true` | `AnimationMixer.deterministic = true` on that player |
| `deterministic_false` | `AnimationMixer.deterministic = false` on that player |

Report each variant's lowest toe (negative = under the canvas) and its 12 per-frame heights.

JSON:

```json
{
  "room": {"seed": 51227, "frames": 2442, "dips": [{"frame": 924, "side": "b", "take": "hook_lead",
    "previous_take": "", "previous_finished": true, "toe_below_rest_m": -0.13,
    "bones": {"Hips": {"f_minus_1_deg": 0.0, "f_deg": 0.0, "f_plus_1_deg": 0.0}}}]},
  "reproduction": {"fighter": "f09_m_bare_welter", "clip_from": "", "clip_to": "", "fps": 30,
    "default_deterministic": true,
    "variants": {"baseline": {"lowest_toe_below_rest_m": 0.0, "frames": 12, "heights_m": []}}}
}
```

`C105_TOE_DIP.md` opens with `## DECISIONS`: whether the baseline reproduces the dip (if it does not, say
**NOT REPRODUCED** and what differed from the room); which variant(s) keep the toe above -0.0263 m, named
exactly as in the table (if none, say **NO VARIANT**); which bones carry the dip in the room rows (the ones
whose `f_deg` jumps away from both neighbours); and one sentence on the mechanism that fits those rows. Say
INFERENCE where a sentence is not a measurement.

## Gate — in this order, from the repo root

1. `python Godot/tools/check_scripts.py Godot/tools/measure_toe_dip.gd`
2. Run through the wrapper, which writes a log file and kills the process tree on timeout:
   `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tools/measure_toe_dip.gd --timeout 600`
   **A GDScript runtime error HANGS a headless run until its timeout** (C104 waited out 3600 s this way).
   Open the log after the first minute; a `SCRIPT ERROR` line means kill the run and fix the script.
3. `python research/C105_check.py` — must exit 0 before you commit.
4. `git add -- <your three files>`, `git commit -m "..." -- <your three files>`, `git show --stat HEAD`,
   `git push origin master`, then
   `python Tools/agent_comms.py send --from codex --to claude --topic "C105 ready" --body "<commit>"`
   and commit that mail file by its path the same way.

## The trap specific to this task

Other agents work in their own worktrees, not here, but the room reads `FightStagePlayer.gd` and the bindings
from THIS checkout: if `git status -s` shows either file modified before you start, stop and say so in the
mail instead of measuring someone's half-finished edit.

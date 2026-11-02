# TASK Q85 — QWEN — THE FIVE PLAYBACK MECHANICS THE S4a TRANSITIONS WILL STAND ON

Model: qwen3-coder, **medium**, `--yolo`. Owner: qwen. Branch `qwen/q85-playback-mechanics` in your
worktree. Stage: S4a step (d). Follows your Q84.

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate, run, gate script.

## Owned files

- `Godot/tools/probe_playback.gd` — **NEW, yours.**
- `research/Q85_PLAYBACK_MECHANICS.md` — **NEW, yours.**
- `research/Q85_playback_probe.json` — **NEW, yours.**

Do NOT edit any other file, including your Q84 files. `Q85_check.py` is Claude's.

## Why this exists

Your Q84 measured that `AnimationPlayer.speed_scale` stretches a blend (a 0.50 s blend took 1.00 s at 0.5).
That matters at once: U84 measured that our walk clips must play at about **0.17x** for a planted foot to
stay planted, and `speed_scale` is player-wide - so slowing the walk that way would make every blend into
or out of it six times longer. And the realism test (`Godot/tests/fight_stage_realism_test.gd`) found
fighters FROZEN on 26-29% of frames: a non-looping clip ends and the body holds its last frame until the
next beat. Before the presenter is rebuilt we need five more mechanics MEASURED, not guessed.

**Use EXACTLY these blend lengths: 0.25 s wherever a blend is named.** Your Q84 ran 0.50 s where the
task said 0.25; the answers held, but a second deviation will be sent back.

## The questions - each answered from the 4.7.2-stable source AND by a measurement

8. **`play(name, custom_blend, custom_speed)`** - `custom_speed = 0.5`, `speed_scale = 1.0`: does a
   0.25 s blend still take 0.25 s, or 0.50 s? And does the clip itself play at half speed?
9. **`queue(name)`** - `P60_SHORT` (a non-looping 0.30 s clip held at +60) is playing and `Z0_LOOP`
   (looping, 0 deg) is queued, `playback_default_blend_time = 0.25`. When P60_SHORT ends: is there ANY
   frame on which the bone holds +60 after the clip's end (a freeze), and does Z0_LOOP arrive with a
   0.25 s blend or a cut?
10. **`set_blend_time(from, to, sec)`** - with `playback_default_blend_time = 0.10` and
    `set_blend_time("P60", "M60", 0.40)`: does `play("M60")` with NO custom blend take 0.40 s?
11. **An outgoing clip that ENDS mid-blend** - `P60_SHORT` (0.30 s, non-looping) started at t=0 and at
    t=0.20 `play("M60", 0.25)`: during the last 0.15 s of the blend, when P60_SHORT has run out, does
    its contribution hold its last frame, or drop out (a jump toward M60)?
12. **`animation_finished` under manual `advance()`** - with only `advance(1/60)` stepping, does the
    signal fire, and on which step relative to the clip's length?

**SOURCE**: `https://raw.githubusercontent.com/godotengine/godot/4.7.2-stable/scene/animation/...`,
cite `path:line`. **MEASUREMENT**: extend your Q84 probe's set-up (a one-bone `Skeleton3D`, synthetic
`TYPE_ROTATION_3D` animations about Y, `advance(1/60)` only, the LOCAL pose read each step). Same
series shape as Q84: `[[t_s, angle_deg], ...]`, one sample just before the call, `t = 0` at the call,
at least 0.6 s after it.

| key | set-up | what decides it |
| --- | --- | --- |
| `q8_custom_speed` | play `P60`, advance 0.5 s, `play("M60", 0.25, 0.5)` | when the angle settles at -60 |
| `q9_queue` | play `P60_SHORT` (0.30 s), `queue("Z0_LOOP")`, default blend 0.25; `t = 0` at the play | any sample at +60 after t = 0.30 + one step; when it reaches 0 |
| `q10_pair_blend` | default 0.10, `set_blend_time("P60","M60",0.40)`, play `P60`, advance 0.5 s, `play("M60")` | when the angle settles at -60 |
| `q11_outgoing_ends` | play `P60_SHORT` at t = 0, at t = 0.20 `play("M60", 0.25)` (`t = 0` at THIS call) | the largest one-step jump between t = 0.10 and 0.25 against the steps before 0.10 |
| `q12_finished_signal` | play `P60_SHORT`, connect `animation_finished`, step | the step index and time it fires (`fired_at_s`, null if never) |

JSON:

```json
{
  "godot_version": "4.7.2...", "step_s": 0.016667,
  "scenarios": {
    "q8_custom_speed":    {"blend_s": 0.25, "custom_speed": 0.5, "series": []},
    "q9_queue":           {"blend_s": 0.25, "short_len_s": 0.30, "series": []},
    "q10_pair_blend":     {"default_blend_s": 0.10, "pair_blend_s": 0.40, "series": []},
    "q11_outgoing_ends":  {"blend_s": 0.25, "outgoing_left_s": 0.10, "series": []},
    "q12_finished_signal":{"short_len_s": 0.30, "fired_at_s": 0.3}
  },
  "answers": {
    "q8":  {"answer": "", "source": ["scene/animation/animation_player.cpp:1"], "measured": "", "claim": {"blend_scaled_by_custom_speed": false, "completes_at_s": 0.25}},
    "q9":  {"claim": {"freeze_frames": 0, "blends_in": true}},
    "q10": {"claim": {"completes_at_s": 0.40}},
    "q11": {"claim": {"jumps_when_outgoing_ends": false}},
    "q12": {"claim": {"fires": true}}
  }
}
```

The values above are placeholders, not expected answers. The markdown opens with **DECISIONS** (one line
per question: answer, source line, measured number) and then **WHAT THIS MEANS FOR FightStagePlayer**:
how to slow a walk without stretching blends, how to return a finished clip to stance with no frozen
frame, and whether per-pair blend times can carry "blend longer when the poses differ".

## Gate — in this order

1. `python Godot/tools/check_scripts.py Godot/tools/probe_playback.gd`
2. From your worktree root, output to a log FILE (never piped):
   `C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/probe_playback.gd`
3. `python research/Q85_check.py` — must exit 0 before you commit.

## The trap specific to this task

**The contract's numbers are the experiment.** A probe run at a different blend length answers a
different question, and the gate now checks every scenario's blend field against this task. Write each
answer from the series you measured, never from what the source seems to say.

## When you are done

Commit the three owned files by path on `qwen/q85-playback-mechanics`, `git show --stat HEAD` (exactly
three), push THE BRANCH; never checkout, merge or rebase master. Then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q85 --body "<one line>"`, commit that
mail file by path on the branch and push again. Do NOT edit `HANDOFF.md`.

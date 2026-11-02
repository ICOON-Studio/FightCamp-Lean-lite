# TASK Q60 — QWEN — A FAST MAN'S JAB LOOKS FAST, AND A TIRED MAN'S DOES NOT

Model: your default, **medium effort**. Owner: qwen.
**A BUILD, not a study.** Q57 already did the research; every number you need is
measured. Nothing here is open.

Test tier: **ONE SCRIPT EDITED + ITS TEST.**

```
python Godot/tools/check_scripts.py Godot/scripts/FightStagePlayer.gd Godot/tests/fight_stage_speed_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_stage_speed_test.gd
python Godot/tools/run_tests.py --only fight_stage
python Godot/tools/run_tests.py --only paired
```

**Do NOT run the full suite** — twenty minutes, and it is Claude's at integration.
**ONLY ONE GODOT AT A TIME in this checkout.** Never start a second alongside
your own.

## Owned files

- `Godot/scripts/FightStagePlayer.gd` — yours for this task (489 lines).
- `Godot/tests/fight_stage_speed_test.gd` — **NEW. Yours alone.**

Nothing else. Do not edit `PairedStagePlayer.gd`, `FightClipBinding.gd`,
`FightBeatAdapter.gd`, `FightStageDirector.gd`, `GameState.gd`, `HANDOFF.md`, or
any existing test. **`GameState.gd` is 12,938 lines — you do not need it, never
open it.**

## Why this exists

The operator's words for this whole stage were *"i want to see as many animations
as possible make the fighters inteliggent with many skills avaiable to them"*, and
asked where the intelligence should show, they said: **"In what you can SEE."**

Q57 ranked five ways to buy variety without buying art. **This is number one, and
it is the only one that is pure code with zero art:**

> `AnimationPlayer.speed_scale` is a single float. Before `play()`, set it from
> the fighter's `speed` stat and current fatigue. A fast fighter's jab at 1.15x
> looks snappier. A tired fighter at 0.9x looks sluggish.

**It buys ~3-5x apparent variety per clip family for about twenty lines**, and it
makes two systems the player currently cannot see — the speed stat and the fatigue
model — visible without a single new decision rule. That is the operator's
"intelligence you can SEE", for free.

## THE NUMBERS, ALREADY MEASURED — DO NOT RE-DERIVE THEM

From `research/Q57_VARIETY_WITHOUT_BUYING.md` §Q3 (**read that section, it
is short**):

- **±15% is the recommended safe range.** So `speed_scale` lives in
  **[0.85, 1.15]** and is CLAMPED there. Q57 is explicit that ±15% is INFERENCE
  rather than a published tolerance — respect the range, do not widen it.
- A fast man's punch at **1.15x**; a tired man's at **0.9x**.

Q57 also names the trap that kills this feature (see Traps below).

## WHAT TO BUILD

### 1. `FightStagePlayer.gd`

`play_role()` is at `:122` and the actual `_ap.play(anim_name)` is at `:146`.
**Set `speed_scale` on the AnimationPlayer immediately before that `play()` call**
and nowhere else.

Add a small, explicit API rather than reaching into the fighter yourself — this
module must not learn what a fighter dictionary looks like:

```gdscript
## The playback rate for the next `play_role`. Clamped to [0.85, 1.15]; Q57 §Q3
## measured +/-15% as the honest safe range and calls it INFERENCE, not a
## published tolerance. 1.0 is the neutral default and MUST remain the default,
## so a caller that never sets it sees exactly today's behaviour.
func set_tempo(scale: float) -> float

## The rate currently in force.
func tempo() -> float

## Derive a tempo from the two things the fighter already carries. Pure and
## static so it is testable without a scene.
static func tempo_for(speed_stat: int, fatigue_01: float) -> float
```

**`tempo_for` is the whole design decision and it must be DETERMINISTIC and
MONOTONIC:**

- a higher `speed` stat gives a higher tempo,
- higher fatigue gives a lower tempo,
- the result is always inside [0.85, 1.15],
- **a mid stat (50) with zero fatigue returns EXACTLY 1.0** — so an average,
  fresh fighter looks precisely as he does today and the feature is invisible
  until it should be visible.

Document the curve you pick in a comment, in one sentence, with its two anchors.

### 2. `Godot/tests/fight_stage_speed_test.gd`

`extends SceneTree`, the idiom of `Godot/tests/fight_beat_timing_test.gd` —
`_check(cond, label)`, `checks`/`failures`, a `PASS (%d checks)` or `FAILS=%d`
line, `quit(0 if failures == 0 else 1)`.

**It must prove, at minimum:**

1. **The default did not move.** A player that never calls `set_tempo` plays at
   exactly 1.0. **This is the most important check in the file** — every existing
   `fight_stage_*` test depends on it.
2. **`tempo_for(50, 0.0) == 1.0` exactly.** Not "about" 1.0.
3. **Monotonic in both arguments.** Walk the speed stat 1..99 at fixed fatigue and
   assert the tempo never decreases; walk fatigue 0.0..1.0 at a fixed stat and
   assert it never increases. **Assert the whole walk, not three sample points.**
4. **Clamped.** The extremes — stat 1 and stat 99, fatigue 0.0 and 1.0, and the
   four corners — all land inside [0.85, 1.15].
5. **It reaches the AnimationPlayer.** After `set_tempo(1.15)` and a `play_role`,
   assert the AnimationPlayer's `speed_scale` IS 1.15. **Assert the quantity that
   actually drives the picture, never just the getter you wrote** — R103 shipped a
   presenter reporting `strike_head` while the player held `jab`, and a green
   suite agreed with itself throughout.
6. **Deterministic.** The same inputs give the same tempo twice, in one process.

## Definition of done

- Both files exist, the focused test reports `failures=0`, and `--only fight_stage`
  and `--only paired` are no worse than they are now.
- **`failures=0` is a CEILING, not an exact count.** If you find something else
  already failing and fix it, say so and push the better result.
- Commit, push to master, **write your own short HANDOFF digest block** (append
  only — never rewrite another agent's block; Q59's digest had to be written for
  you and that is worth not repeating).
- One line back:
  `python Tools/agent_comms.py send --from qwen --to claude --subject Q60-done --body "<sha> checks=N failures=M neutral_exact=yes|no range=[min,max]"`

## The traps specific to Q60

1. **DETERMINISM IS A HARD GATE, AND Q57 NAMES THE ONE THING THAT BREAKS IT.**
   `AnimationNodeOneShot.autorestart_random_delay > 0.0` is NOT deterministic.
   Do not reach for randomness to get variety — the variety here comes from the
   fighter's own stats, which are deterministic game state. `FightStagePlayer`
   already cycles takes round-robin rather than randomly for exactly this reason;
   match it.
2. **NO SEEDED FIGHT MAY MOVE.** This changes how fast a clip is drawn and nothing
   else. It must not touch a tick, a draw, or a verdict.
3. **`speed_scale` IS A PROPERTY OF THE AnimationPlayer, NOT OF THE ANIMATION.**
   It persists across `play()` calls, so a tempo set for one beat will still be in
   force for the next one unless it is set every time. Set it on every
   `play_role`, and make the default path set it back to 1.0 rather than leaving
   the last value in place — a fighter who throws one tired punch must not then
   be permanently slow.
4. **`var x := <call>` fails when the call returns Variant** (`.size()` or `.get()`
   on an untyped value, a static on a `load()`ed script). Write the type:
   `var n: int = ...`. And you cannot reuse a variable name inside one function
   even across separate `if`/`for` blocks — that is a parse error, and **a parse
   error does not fail a headless test, it HANGS it until the timeout.**
5. **Scene scripts compile before the autoloads.** Use
   `get_node_or_null("/root/GameState")` plus `has_method`, never the bare
   `GameState` identifier — and this module should not need GameState at all.

# TASK U25 — CURSOR — THE LIVE FIGHT READ: A HEART RATE AND A CUT, NOT TWO BARS

Model: Composer, high effort, Fast off. Owner: Cursor. Base: `c885c5f`,
`SUITE total=204 fails=0`.

You own `Godot/scripts/FightHudPanel.gd` (new),
`Godot/tests/fight_hud_panel_test.gd` (new) and a capture tool, the same shape as
your U24 `CaptureU24Scorecard.gd`.

---

## Why this screen exists

You built the POST-fight scorecard in U24. This is the LIVE read — what a
broadcast shows while the fight is happening. It exists because
`R85R_UNDISPUTED_HUD.md` drove Undisputed first-hand and produced two findings
we could not express at the time, and now can:

1. **Cardio is a HEART RATE, not a stamina bar.** A tank at 60 is a number; 178
   bpm in the twelfth is a fighter in trouble. `Cardio.gd` shipped for this.
2. **Damage is CONTINUOUS for attrition and DISCRETE for trauma.** Head and body
   are bars because they accumulate; cuts and swelling are four-step pips
   because a cut is an EVENT. `FightTrauma.gd` shipped for this.

Both modules are currently **INERT** — nothing calls either. This screen and
R87's engine wiring are what change that. **Do not render trauma as a bar or
cardio as a tank**; that is the one thing this task is for.

## What to build

A `Control` built from the kit (`UIKit.gd` + `UITokens.gd`), rendering
`FightHudRead.fold(state)` **and nothing else** — no scoring, no judging, no
engine calls, exactly the discipline your U24 panel already keeps.

Per fighter: name, **heart rate in bpm with its zone**, a continuous bar per body
region, and **discrete pips** for each trauma site — four steps, and the site
labelled. Plus the round, the clock, whether the corner minute is running, and
the running score. `worst_trauma.words` is the broadcast phrase for the worst
mark; use it rather than inventing your own wording.

## THE READ CONTRACT — copied verbatim from TASK_Q18

Qwen owns `FightHudRead.gd` and is building it in parallel. **You do not wait for
it.** Build against this contract and, if the module has not landed when you are
ready to test, stub the fold inside your own test file — never inside the panel.

```
static func fold(state: Dictionary) -> Dictionary
```

```
{
  "round": int, "rounds_total": int,
  "seconds_elapsed": float, "resting": bool, "over": bool,
  "a": <side read>, "b": <side read>,
  "score": {"a": int, "b": int, "rounds_scored": int},
}
```

`<side read>`:

```
{
  "id": String, "name": String,
  "heart_rate": int,        # already an int
  "zone": String,
  "stamina": float,
  "condition": {"head_neck": float, "torso_core": float,
                "left_arm": float, "right_arm": float,
                "left_leg": float, "right_leg": float},   # each 0..100
  "trauma": {<site>: {"cut": int, "swelling": int}},        # each 0..4
  "worst_trauma": {"site": String, "kind": String, "pips": int, "words": String},
  "total_pips": int,
  "knockdowns_round": int, "knockdowns_total": int,
}
```

Trauma sites are `left_brow, right_brow, left_eye, right_eye, nose, lip` —
`FightTrauma.SITES`, and note there is deliberately **no `head_neck`** among
them: that region is the continuous bar, which is the whole distinction.

## Owned files

| File | Lines | How to read it |
| --- | --- | --- |
| `Godot/scripts/FightHudPanel.gd` | new | Yours. |
| `Godot/tests/fight_hud_panel_test.gd` | new | Yours. Feed synthetic read dictionaries; do not boot `FightRealtime`. |
| `Godot/tools/CaptureU25FightHud.gd` | new | Yours. Same shape as the U24 capture tool. |

## Pattern (read only, not owned)

Read for the pattern — **your own U24 work is the best reference**:
`Godot/scripts/ScorecardPanel.gd` on `cursor/u24-scorecard-panel-80cb` (408
lines; `apply_route_args` `:50`, and its `const T` / `const UIKit` preload
header). Read whole (both small): `Godot/scripts/FightTrauma.gd` (158 — `SITES`
`:16`, `words` `:88`), `Godot/scripts/Cardio.gd` (122 — `zone` `:106`).
**Never open `GameState.gd` (12,900+ lines) and never read `FightRealtime.gd`
whole (940).**

## Gates

1. Trauma renders as **discrete pips**, four steps, per site — assert the pip
   count rendered equals the pip count in the read, for 0, 1, 4 and an
   out-of-range value.
2. Cardio renders as **bpm plus zone text**, never as a proportion bar.
3. The panel reads only the contract keys. A read with a missing optional key
   must not crash the panel.
4. A rebuild is stable: build twice from the same read and get the same tree.
   Remember `remove_child(node)` before `queue_free()`, or new nodes get renamed.
5. **Merge conflict warning:** U24 is finished on your branch but **not yet
   merged** — Claude merges it as R87's first step. Branch U25 off `master` and
   do not depend on `ScorecardPanel.gd` existing.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/FightHudPanel.gd Godot/tests/fight_hud_panel_test.gd Godot/tools/CaptureU25FightHud.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_hud_panel_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0`, `total` at least 205. A sibling task
(C66) is expected to be RED by design while it waits for R87, so if the suite
reads `fails=1` and the only failure is `fight_reaches_its_modules_test.gd`, that
is not yours — say so and push.

## The trap specific to this task

**R31, twice over, and it costs a fix cycle every time.** A Control with
full-rect anchors must never have `size` assigned when it is mounted: with
anchors at 0..1 that writes the OFFSETS and the node ends up twice the parent.
And a `TextureRect` keeps the TEXTURE's size as its minimum until `expand_mode`
is set — so set `expand_mode` and `stretch_mode` BEFORE `texture`/`size`, or the
size you assign is clamped straight back up. Also: a `Label` outside a Container
does not autowrap reliably; break lines with `\n`.

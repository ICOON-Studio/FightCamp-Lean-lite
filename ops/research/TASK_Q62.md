# TASK Q62 — QWEN — THE BEAT LEARNS THE RANGE

Model: qwen3-coder, **medium effort**. Owner: qwen.
Test tier: **ONE SCRIPT EDITED plus ONE NEW TEST.** Parse gate, your own test,
then the two named subsets. **Do NOT run the full suite** — it is Claude's, once,
at integration. **Only one Godot at a time in this checkout.**

```
python Godot/tools/check_scripts.py Godot/scripts/FightBeatAdapter.gd Godot/tests/fight_beat_range_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_beat_range_test.gd
python Godot/tools/run_tests.py --only fight_beat
python Godot/tools/run_tests.py --only fight_stage
```

## Owned files

- `Godot/scripts/FightBeatAdapter.gd` — **1,000+ lines. DO NOT READ IT WHOLE.**
  Yours for this task, and only the beat-building functions the anchors below
  name.
- `Godot/tests/fight_beat_range_test.gd` — **NEW. Yours alone.**

Nothing else. Do **NOT** edit `FightRealtime.gd`, `FightStagePlayer.gd`,
`FightClipBinding.gd`, `FightWorldLiveScreen.gd`, any other test, or
`HANDOFF.md`. `GameState.gd` is 12,938 lines — you do not need it, never open it.

## Why this exists

**The two fighters never move.** They are placed once, facing each other, and
trade from a fixed distance for three rounds. Every clip we bound is an
`_InPlace` variant and Q61 measured `travel_m = 0.00` on all of them. That is
correct by design — **G42 is standing: the ENGINE owns translation, the clips are
in-place, and the clip is rate-matched to the sim.**

So the bodies cannot move until **the engine tells the presenter where they
are** — and today it does not. The stage has no idea how far apart the two men
are supposed to be.

**THE ENGINE ALREADY KNOWS.** Every fighter carries `preferred_range` (default
`1.2`), and `FightBeatAdapter` already holds `RANGE_DELTA := 0.35`,
`PREFERRED_RANGE_MIN := 0.4`, `PREFERRED_RANGE_MAX := 2.0`. The corner
instruction writes onto that axis (`FightBeatAdapter.gd:394-412`, the
`_apply_corner` / range_call path — read that window, it is short). **The number
exists and never reaches the beat.**

**THIS TASK IS EXACTLY RUNG 1 AGAIN, FOR RANGE INSTEAD OF THE GRAPPLE.** Rung 1
(`bb2d75c`) put the grapple on the beat in the ENGINE'S OWN WORDS and changed
nothing about what the engine decided. Do that, for range. **You are not moving
any body. You are not touching the stage. You put a number the engine already
computed onto the beat, honestly, and stop.**

## The contract — exact names, this is what an unseen consumer will call

Add to every beat the adapter builds (both the action path and the grapple
path — the anchors are `beat["clip_role"]` assignments around
`FightBeatAdapter.gd:694-700` and `:903-910`; read `sed -n '680,710p'` and
`sed -n '895,915p'` windows, nothing else):

```
beat["range_m"]           float  the engine's own separation for this beat
beat["range_source"]      String "preferred" | "clamped" | "unknown"
beat["actor_range_m"]     float  the ACTOR's preferred_range at this beat
beat["target_range_m"]    float  the TARGET's preferred_range at this beat
```

**`range_m` IS DERIVED, AND HOW YOU DERIVE IT IS THE JUDGEMENT IN THIS TASK.**
Two men want different distances; the one who is closing gets his way only if the
other cannot keep him off. **Do not invent a fight model for that.** Take the
honest, stated-in-a-comment reading: the smaller of the two preferred ranges is
what the exchange actually happened at, because a blow landed means somebody got
inside. Clamp the result to `[PREFERRED_RANGE_MIN, PREFERRED_RANGE_MAX]` and set
`range_source` to `"clamped"` when the clamp bit, `"preferred"` when it did not.

**`range_source = "unknown"` when a fighter carries no `preferred_range` at all**
(an older or hand-built fixture). **Return `0.0` for `range_m` in that case and
say so — never substitute the 1.2 default silently.** A beat that claims a
measured range it does not have is the M19 lie wearing a number.

## THE THREE RULES THAT CANNOT BREAK

1. **NOTHING HERE MAY DRAW AN RNG OR CONSUME A TICK.** Read the values off the
   fighter dicts after the window has already been pumped, exactly where the
   grapple events are already read. A seeded fight's verdict, scorecards and
   stoppage must be byte-identical before and after this change.
2. **DO NOT WRITE TO `preferred_range`.** You read it. The corner instruction
   owns writing it and that path already exists.
3. **THE BEAT GAINS KEYS AND LOSES NONE.** Every existing key keeps its name,
   type and meaning.

## The test

`fight_beat_range_test.gd`:

- Over a seeded bout, **every action beat carries `range_m` and a `range_source`
  from the three allowed strings** — no beat is missing the key.
- `range_m` is inside `[0.4, 2.0]` whenever `range_source != "unknown"`.
- **A fighter built WITHOUT `preferred_range` yields `range_source == "unknown"`
  and `range_m == 0.0`** — assert the honest branch is reached, not merely
  reachable.
- **A corner instruction that says `get_inside` lowers a later beat's `range_m`,
  and `stay_long` raises it.** That is the assertion that proves the number is
  the ENGINE'S and not a constant you wrote. `CORNER_OPTIONS` at
  `FightBeatAdapter.gd:149-156` carries both labels.
- **THE ONE THAT MATTERS: run the same seed twice, once reading the new keys and
  once ignoring them, and assert the VERDICT, the scorecards and the stoppage
  tick are identical.** That is rung 1's own discipline and it is what proves you
  did not start driving the fight.

**ASSERT THE QUANTITY THAT DRAWS THE PICTURE, NEVER THE GETTER YOU WROTE.** This
repo has had that finding three times running — most recently your own Q60, whose
test proved a reset by reading the getter it had just written and passed while
shipping a bug. `range_m` on the beat is the quantity; a helper that returns it
is not.

## AND THE Q61 LESSON, WHICH IS YOURS AND IS NOW A RULE

Q61 was told that if its CONTROL clips disagreed with their known answer, the
instrument was wrong and every other row was worthless — report it and stop. The
roundhouse control came back near-balanced instead of lateral, you found and
named the root cause correctly, **and then drew a teep verdict from the broken
instrument anyway.** That verdict could not be used.

**A failed control voids the report. It does not caveat it.** If the
verdict-stability check in the test above moves a single seeded verdict, this
task has failed and the answer is to say so — not to note it and continue.

## Done means

- `check_scripts.py` clean on both files; your own test green; `--only
  fight_beat` and `--only fight_stage` both `fails=0`. **`fails=0` is a CEILING,
  not an exact target** — if a pre-existing failure disappears, say so and push.
- `git status -s` FIRST, then `git add --` your two explicit paths only.
- Commit ending `Co-Authored-By: Qwen <noreply@qwen.ai>`, then
  `git push origin master`.
- One line of mail:
  `python Tools/agent_comms.py send --from qwen --to claude --subject Q62-done --body "<hash> beats=<n> range_source_unknown=<n> verdicts_moved=<n> checks=<n> failures=<n>"`
- Do NOT edit `HANDOFF.md` — Claude writes your block.

## GDScript traps

- `var x := <call>` fails when the call returns Variant (`.get()` on an untyped
  dict is the usual one here) — write the type: `var r: float = float(...)`.
- A `%` inside a format string must be `%%`.
- Reusing a variable name inside one function is a parse error even across
  separate `if`/`for` blocks.
- **Parse gate BEFORE any test.** A parse error does not fail a headless test,
  it HANGS it for 600 seconds.
- Use only
  `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe`.

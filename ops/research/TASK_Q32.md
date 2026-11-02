# TASK Q32 — QWEN — MEASURE THE BEAT STREAM SO THE CLIP LIST IS SIZED BY EVIDENCE

Model: qwen (its CLI in this checkout), effort MEDIUM, `--yolo`.
Owner: qwen. Task id: Q32.

## Why this exists, in one sentence

We are about to buy animation clips, and **the shopping list must be sized by
what the engine actually emits, not guessed** — R94 measured the price per clip
(0.2 credits) but nobody has ever measured how many of each KIND of thing a real
bout contains.

You did exactly this shape of work in Q31 (300 bouts, the stoppage read) and it
came back with the number that killed a threshold design. Same discipline here.

## Owned files

- `Godot/tools/measure_beats.gd` — **NEW.** The measuring harness.
- `research/Q32_BEAT_STREAM.md` — **the deliverable. This is the point of
  the task.**
- `research/Q32_DIGEST.md` — short.

Do NOT edit `FightBeatAdapter.gd`, `FightRealtime.gd`, `FightStageDirector.gd`
(Claude is writing it in parallel), any existing test, `HANDOFF.md` or
`CURRENT_STATUS.md`. **You are measuring, not changing.** If the measurement
needs the engine to expose something it does not, that is a FINDING to report,
not a change to make.

## The measurement

**Over at least 200 seeded BOXING bouts** (more if it is cheap; say how many you
ran). Drive them exactly the way `Godot/tests/fight_beat_adapter_test.gd` does —
copy its setup, do not re-derive it:

`FightBeatAdapter.begin(a, b, options)` → loop `advance_beat(state)` until
`is_fight_over(state)` → `result(state)`.

Vary the seed per bout. Use two ordinary welterweights; say which fighters and
which options you used, so the numbers can be reproduced.

### What to report, per question

**1. Action beats per fight.**
Total beats, and how many were `type == "action"` versus `"no_action"`.
Min / median / mean / max across the 200. **A `no_action` beat is a body standing
there**, so this number is directly how much idle/stance footage the stage needs
relative to strikes.

**2. Region distribution of the presented strike.**
Across every `action` beat, count `target_region`: `head_neck`, `torso_core`,
`left_leg`, `right_leg`, `left_arm`, `right_arm`. Report as counts AND as a
percentage of action beats. **Report a region that reads zero as zero** — do not
omit it. R84 set the arm probability to 0.00 deliberately, so arms reading 0 is
the expected confirmation of a ruling, and a leg reading 0 under boxing is a
fact about boxing.

**3. Contact distribution of the presented strike.**
`clean` / `glancing` / `absorbed` / `blocked` / `slipped` / `missed`, counts and
percentages. This one sizes block and slip footage against react footage, and
nobody has ever looked at it.

**4. How often knockdown and shocked fire.**
Per fight and in total: how many action beats carried `knockdown` true, how many
`flash_knockdown` true, how many `shocked` true. Report **the share of FIGHTS
that contain at least one** of each, as well as the raw counts — "a knockdown
happens in 31% of bouts" is the number that decides whether knockdown footage is
bought first or last, and a mean per fight hides it.

**5. The drop rate, confirmed or corrected.**
R97 measured **896 impacts, 66 shown, 830 dropped (92.6%)** on one bout. Report
the same three numbers across your 200 — `state["shown"]`, `state["dropped"]`,
and their sum — as a distribution, not one figure. **If your rate disagrees with
92.6%, say so plainly and do not reconcile it away**; R97 measured one bout and
you are measuring two hundred.

**6. Beat span.**
`beat["span"]` in seconds — is it always 14.0 (280 ticks at 20 Hz), or does the
last beat of a round or of the fight come up short? A clip has to fit inside a
beat, so a short beat is the case that decides whether clips get cut.

**7. Separation at the moment of the strike.**
`beat["distance"]` on action beats: min / median / max. **This sizes how far
apart two bodies stand when a punch lands**, which is what the 3D stage has to
place them at, and it is the number that says whether a fixed stance distance is
defensible or the bodies must slide.

## The rule that outranks everything else here

**REPORT WHAT YOU MEASURED.** If a number is surprising, surprising is the
finding. Do not tune, do not filter outliers, do not round a zero away, and do
not explain a result by reading the engine source and asserting what it "must"
be. Q31's value was that it reported an overlap that killed a design.

If something cannot be measured from the beat stream at all, **say which field is
missing** — that is the most valuable line in the document, because a value the
engine keeps only on `fight_state` is a value the presentation cannot have.

## Test tier — NO `.gd` UNDER `Godot/tests/` IS EDITED

You are adding a tool, not a test. So:

```
python Godot/tools/check_scripts.py Godot/tools/measure_beats.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_beats.gd
```

**No focused suite. No full suite.** The full suite is Claude's once, at
integration, and a concurrent Godot run corrupts everyone's `user://` fixtures.
**NEVER pass `--godot` to `run_tests.py`.**

## Traps

- **A parse error HANGS a headless run** until the timeout instead of failing.
  Run `check_scripts.py` before every Godot invocation, every time.
- `var x := <call>` fails when the call returns Variant (`.size()` or `.get()` on
  an untyped value, a static on a `load()`ed script). Write the type:
  `var n: int = ...`.
- **`beat["wear"]` is a DICTIONARY of region→amount**, not a number. `float(wear)`
  throws `Nonexistent 'float' constructor`. Sum its numeric values if you want a
  scalar.
- `%` inside a format string must be `%%`. You will be printing percentages.
- Reusing a variable name inside one function is a parse error in GDScript, even
  across separate `if`/`for` blocks. You will be writing several counting loops
  in one function — give each its own names, or split the function.
- 200 bouts is a lot of output. Print a SUMMARY, not a line per bout; write the
  full table into the research file.

## Close-out

Commit and push to **master** — `git rev-parse --abbrev-ref HEAD` first. Then:

```
python Tools/agent_comms.py send --from qwen --to claude --subject Q32-done --body "<sha> bouts=N action-beats med=X regions=head%/torso%/leg% contacts=clean%/blocked%/slipped%/missed% kd-share=X%% shocked-share=X%% drop=X%% span=<always 14 or not> distance med=Xm missing-fields=<none|what>"
```

Do NOT edit `HANDOFF.md`.

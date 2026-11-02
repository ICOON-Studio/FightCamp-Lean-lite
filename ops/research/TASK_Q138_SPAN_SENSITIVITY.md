# TASK_Q138 — QWEN — IF WE FIX THE SPANS, WHICH CAPSULES LEAVE THE NEEDLE BAND?

**Owner:** qwen. **Model:** `qwen3-coder`, MEDIUM. `--yolo` (never `auto` —
`auto` leaves you with no shell tool at all).
**Worktree:** `C:\Users\user\AppData\Local\Temp\FightCamp-Q114`. **Cut a FRESH
branch off `origin/master` first.**
**Test tier:** parse gate on every touched `.gd`, then your own tool. **NO SUITE
RUN** — it is Claude's, once, at integration, and it costs forty minutes.

## WHAT YOUR OWN Q137 FOUND, AND THE QUESTION IT LEFT

Your census is merged and it is the reason this task exists. Across twelve rigs:
`head` **BALL on 10/12**, `pelvis` **NEEDLE on all 12**, `neck` NEEDLE 8 / BALL
4, `thorax` straddling at median 0.49 — and **every limb from femur outward
fine**. The capsule abstraction fails on the **trunk**, which is where every
grapple happens.

Then John's J42 landed, blind to your census, with the anthropometry:

- A real male neck is **ANSUR Neck Link `L = 107.8 mm`, soft `r = 63.3 mm`** →
  `r/L = 0.59`, **already a NEEDLE**.
- **Our neck span is 59–77 mm** — short against that ~108 mm C7–tragion length.
- Head as a capsule is `r/L ≈ 1.00` → it should be a **sphere**, not a capsule.

**So we know our spans are wrong AND we know a correct span does not save the
neck.** What nobody knows is **how much of the trunk a span correction WOULD
fix**, and that decides whether the span fix is worth doing on its own terms.

## THE QUESTION

**For each trunk capsule, sweep its span and find the length at which it leaves
the NEEDLE band — then say whether that length is anatomically plausible.**

## WHAT TO BUILD

`Godot/tools/q138_span_sensitivity.gd`, a headless SceneTree script.

For all twelve rigs (read the roster the same way `q137_slenderness_census.gd`
does — **do not list them again**), and for each of `neck`, `head`, `thorax`,
`pelvis`, `foot_l`, `foot_r`:

1. Read the capsule's built `r` and its measured `L` from
   `FighterCapsules.build_report` — **and its `authored_m` from the report's
   `extents` block, which is the bone-to-bone distance.** Do not recompute
   either.
2. **Sweep `L`** from the measured value up to `3x` it, in steps of 1 mm,
   holding `r` fixed. At each step compute `r/L` and its band, using the same
   table Q137 used: `<0.25 SEGMENT`, `0.25–0.50 STOUT`, `0.50–1.00 NEEDLE`,
   `>=1.00 BALL` — **inclusive at the number named**.
3. Report, per capsule per rig: the measured `L`, the **`L_exit_needle`** (the
   smallest `L` in the sweep whose band is `STOUT` or better), the **ratio
   `L_exit_needle / L_measured`**, and whether the sweep ever exits at all
   within `3x`.

## THE OUTPUT

**(1) Per-rig table**, one row per capsule.

**(2) The roll-up**, per capsule name across twelve rigs: median `L_measured`,
median `L_exit_needle`, median ratio, and **how many rigs never exit within
3x**.

**(3) THE ANATOMY COLUMN, which is the point.** For `neck` only, put
`L_exit_needle` beside **J42's 107.8 mm Neck Link**. State plainly whether the
exit length is below it (the span fix alone would clear the neck), at it, or
above it (**it would not — you would need a neck longer than a human's**).
**Read the 107.8 mm from `research/CLAUDE_LAND_NOTE_J42.md` rather than
from this file**, and say in the output which file you took it from.

**(4) The honest verdict**, one paragraph: is a span correction worth doing? Say
so either way. **"No" is a result** and it saves the next session a day.

End with `SUITE total=1 fails=N`.

## Owned files

- `Godot/tools/q138_span_sensitivity.gd`
- `research/Q138_SPAN_SENSITIVITY.md`
- `research/Q138_DIGEST.md`

**Do not edit `FighterCapsules.gd`, `CapsulePresence.gd` or any test.** This is a
measurement. If it wants a module changed, that is a finding to report, not a
change to make.

## Gate

```
python Godot/tools/check_scripts.py Godot/tools/q138_span_sensitivity.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q138_span_sensitivity.gd
```

The exe is in `%LOCALAPPDATA%\Programs\Godot\`.

## Traps

1. **`var x := <call>` fails when the call returns Variant.** Write the type.
   A parse error does not fail a headless run, it **HANGS** it to the timeout.
2. **`%` in a format string must be `%%`.** You print percentages on every row.
3. **Reusing a variable name inside one function is a parse error in GDScript**,
   even across separate `if`/`for` blocks. This tool has three nested loops.
4. **A sweep that never exits must say so explicitly** rather than reporting the
   last value it tried. `NOT REACHED WITHIN 3x` is the honest cell, and for
   `head` — where `r` exceeds `L` outright — it may be the common one.

## Rules

- Never `git stash`, `git reset --hard`, `git checkout .`, `git clean` or
  `git add -A`. Stage explicit paths only.
- Commit, push your branch, write the digest, send one line with
  `python Tools/agent_comms.py send`. **Do NOT edit `HANDOFF.md`.**
- Your API content filter killed a run today and the retry passed. **Retry once
  before rewording anything.**
